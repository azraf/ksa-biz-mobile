import '../models/order.dart';
import '../models/paginated_response.dart';
import '../offline/local_database.dart';
import '../offline/sync_queue_item.dart';
import '../offline/sync_service.dart';
import '../utils/client_request_id.dart';
import 'order_repository.dart';

class OfflineOrderRepository {
  OfflineOrderRepository({
    required OrderRepository remote,
    required LocalDatabase db,
    required bool Function() isOnline,
  })  : _remote = remote,
        _db = db,
        _isOnline = isOnline;

  final OrderRepository _remote;
  final LocalDatabase _db;
  final bool Function() _isOnline;

  Future<PaginatedResponse<OrderModel>> list({
    int? salesPersonId,
    String? status,
    String? paymentStatus,
    String sort = 'created_at',
    int page = 1,
  }) async {
    if (_isOnline()) {
      try {
        final result = await _remote.list(
          salesPersonId: salesPersonId,
          status: status,
          paymentStatus: paymentStatus,
          sort: sort,
          page: page,
        );
        await _db.cacheEntitiesBatch(
          entityType: 'order',
          entities: result.items
              .map((order) => (entityId: order.id, data: _toCache(order)))
              .toList(),
        );
        final pending = await _pendingOrders();
        if (page == 1 && pending.isNotEmpty) {
          return PaginatedResponse(
            items: [...pending, ...result.items],
            currentPage: result.currentPage,
            lastPage: result.lastPage,
            total: result.total + pending.length,
          );
        }
        return result;
      } catch (_) {
        return _cachedList();
      }
    }
    return _cachedList();
  }

  Future<PaginatedResponse<OrderModel>> _cachedList() async {
    final cached = await _db.getCachedEntities('order');
    final orders = cached.map((e) => OrderModel.fromJson(e)).toList();
    return PaginatedResponse(
      items: orders,
      currentPage: 1,
      lastPage: 1,
      total: orders.length,
    );
  }

  Future<List<OrderModel>> _pendingOrders() async {
    final cached = await _db.getCachedEntities('order');
    return cached
        .where((e) => e['_pending_sync'] == true)
        .map((e) => OrderModel.fromJson(e))
        .toList();
  }

  Future<OrderModel> get(int id) async {
    if (id < 0) {
      final cached = await _db.getCachedEntity('order', id);
      if (cached != null) return OrderModel.fromJson(cached);
    }
    if (_isOnline()) {
      try {
        final order = await _remote.get(id);
        await _db.cacheEntity(entityType: 'order', entityId: order.id, data: _toCache(order));
        return order;
      } catch (_) {}
    }
    final cached = await _db.getCachedEntity('order', id);
    if (cached != null) return OrderModel.fromJson(cached);
    throw Exception('Order not available offline');
  }

  Future<OrderModel> create(Map<String, dynamic> body) async {
    final payload = Map<String, dynamic>.from(body);
    payload.putIfAbsent('client_request_id', generateClientRequestId);

    if (_isOnline()) {
      final order = await _remote.create(payload);
      await _db.cacheEntity(entityType: 'order', entityId: order.id, data: _toCache(order));
      return order;
    }

    final localId = await _db.nextLocalId();
    final normalizedItems = _normalizeCreateItems(payload['items'] as List<dynamic>? ?? []);
    final totalBill = normalizedItems.fold<double>(
      0,
      (sum, item) => sum + (item['bill'] as num).toDouble(),
    );
    final pending = {
      ...payload,
      'id': localId,
      'status': payload['as_draft'] == true ? 'draft' : 'confirmed',
      'payment_status': payload['payment_status'] ?? 'pending',
      'total_bill': totalBill,
      'items': normalizedItems,
      '_pending_sync': true,
      'created_at': DateTime.now().toIso8601String(),
    };
    await _db.cacheEntity(entityType: 'order', entityId: localId, data: pending);
    await _db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'order',
      operation: 'create',
      localId: localId,
      payload: payload,
    ));
    notifyOfflineEnqueue();
    return OrderModel.fromJson(pending);
  }

  Future<OrderModel> cancel(int orderId, String reason) async {
    if (_isOnline()) {
      final order = await _remote.cancel(orderId, reason);
      await _db.cacheEntity(entityType: 'order', entityId: order.id, data: _toCache(order));
      return order;
    }

    if (orderId < 0) {
      final cached = await _db.getCachedEntity('order', orderId);
      if (cached != null) {
        final updated = {...cached, 'status': 'cancelled', 'cancellation_reason': reason};
        await _db.cacheEntity(entityType: 'order', entityId: orderId, data: updated);
        await _db.cancelPendingByLocalId(orderId);
        return OrderModel.fromJson(updated);
      }
    }

    await _db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'order',
      operation: 'cancel',
      serverId: orderId,
      payload: {'reason': reason},
    ));
    notifyOfflineEnqueue();
    final cached = await _db.getCachedEntity('order', orderId);
    if (cached != null) {
      final updated = {...cached, 'status': 'cancelled', 'cancellation_reason': reason};
      await _db.cacheEntity(entityType: 'order', entityId: orderId, data: updated);
      return OrderModel.fromJson(updated);
    }
    throw Exception('Order not found');
  }

  Future<OrderModel> recordPayment(
    int orderId, {
    required double amount,
    String? paymentMethod,
    String? notes,
  }) async {
    if (_isOnline()) {
      final order = await _remote.recordPayment(
        orderId,
        amount: amount,
        paymentMethod: paymentMethod,
        notes: notes,
      );
      await _db.cacheEntity(entityType: 'order', entityId: order.id, data: _toCache(order));
      return order;
    }

    if (orderId < 0) {
      throw Exception('Payment cannot be recorded until the order is synced to the server');
    }

    await _db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'order',
      operation: 'payment',
      serverId: orderId,
      payload: {
        'amount': amount,
        if (paymentMethod != null) 'payment_method': paymentMethod,
        if (notes != null) 'notes': notes,
      },
    ));
    notifyOfflineEnqueue();
    final cached = await _db.getCachedEntity('order', orderId);
    if (cached != null) {
      final paid = _toDouble(cached['amount_paid']) + amount;
      final total = _toDouble(cached['total_bill']);
      final due = (total - paid).clamp(0, double.infinity);
      final updated = {
        ...cached,
        'amount_paid': paid,
        'amount_due': due,
        'payment_status': due <= 0 ? 'paid' : 'partial',
      };
      await _db.cacheEntity(entityType: 'order', entityId: orderId, data: updated);
      return OrderModel.fromJson(updated);
    }
    throw Exception('Order not available offline');
  }

  Map<String, dynamic> _toCache(OrderModel order) => {
        'id': order.id,
        'sales_person_id': order.salesPersonId,
        'customer_type_id': order.customerTypeId,
        'customer_van_id': order.customerVanId,
        'customer_importer_id': order.customerImporterId,
        'customer_shop_id': order.customerShopId,
        'total_bill': order.totalBill,
        'grand_discount': order.grandDiscount,
        'amount_paid': order.amountPaid,
        'amount_due': order.amountDue,
        'payment_status': order.paymentStatus,
        'status': order.status,
        'items': order.items
            .map((i) => {
                  'product_id': i.productId,
                  'quantity': i.quantity,
                  'product_price': i.productPrice,
                })
            .toList(),
        'created_at': order.createdAt,
        '_pending_sync': order.id < 0,
      };

  List<Map<String, dynamic>> _normalizeCreateItems(List<dynamic> rawItems) {
    return rawItems.asMap().entries.map((entry) {
      final item = Map<String, dynamic>.from(entry.value as Map);
      final quantity = item['quantity'] as int? ?? 0;
      final price = _toDouble(item['product_price']);
      final discount = _toDouble(item['product_discount']);
      final vat = _toDouble(item['product_vat']);
      return {
        'id': -(entry.key + 1),
        'product_id': item['product_id'],
        'quantity': quantity,
        'product_price': price,
        'product_discount': discount,
        'product_vat': vat,
        'bill': (price * quantity) - discount + vat,
        'is_preorder': item['is_preorder'] as bool? ?? false,
      };
    }).toList();
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  Future<int> pendingSyncCount() => _db.pendingCount();
}
