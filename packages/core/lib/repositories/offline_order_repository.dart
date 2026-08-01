import '../models/order.dart';
import '../models/paginated_response.dart';
import '../offline/offline_sync_trigger.dart';
import '../utils/client_request_id.dart';
import '../offline/stores/order_local_store.dart';
import '../offline/stores/sync_outbox_store.dart';
import '../offline/sync_queue_item.dart';
import 'order_repository.dart';

class OfflineOrderRepository {
  OfflineOrderRepository({
    required OrderRepository remote,
    required OrderLocalStore orders,
    required SyncOutboxStore outbox,
    required bool Function() isOnline,
  })  : _remote = remote,
        _orders = orders,
        _outbox = outbox,
        _isOnline = isOnline;

  final OrderRepository _remote;
  final OrderLocalStore _orders;
  final SyncOutboxStore _outbox;
  final bool Function() _isOnline;

  Future<PaginatedResponse<OrderModel>> list({
    int? salesPersonId,
    String? status,
    String? paymentStatus,
    int page = 1,
    int perPage = 25,
  }) async {
    if (_isOnline()) {
      try {
        final result = await _remote.list(
          salesPersonId: salesPersonId,
          status: status,
          paymentStatus: paymentStatus,
          page: page,
        );
        await _orders.upsertAll(result.items);
        final pending = await _orders.pendingOrders();
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
        return _cachedList(page: page, perPage: perPage);
      }
    }
    return _cachedList(page: page, perPage: perPage);
  }

  Future<PaginatedResponse<OrderModel>> _cachedList({
    int page = 1,
    int perPage = 25,
  }) async {
    final offset = (page - 1) * perPage;
    final orders = await _orders.list(offset: offset, limit: perPage);
    final total = await _orders.count();
    final lastPage = total == 0 ? 1 : (total / perPage).ceil();
    return PaginatedResponse(
      items: orders,
      currentPage: page,
      lastPage: lastPage,
      total: total,
    );
  }

  Future<OrderModel> get(int id) async {
    if (id < 0) {
      final cached = await _orders.getByServerId(id);
      if (cached != null) return cached;
    }
    if (_isOnline()) {
      try {
        final order = await _remote.get(id);
        await _orders.upsert(order);
        return order;
      } catch (_) {}
    }
    final cached = await _orders.getByServerId(id);
    if (cached != null) return cached;
    throw Exception('Order not available offline');
  }

  Future<OrderModel> create(Map<String, dynamic> body) async {
    if (_isOnline()) {
      final order = await _remote.create(body);
      await _orders.upsert(order);
      return order;
    }

    final payload = withClientRequestId(body);
    final localId = await _orders.nextLocalId();
    final normalizedItems = _normalizeCreateItems(payload['items'] as List<dynamic>? ?? []);
    final totalBill = normalizedItems.fold<double>(
      0,
      (sum, item) => sum + (item['bill'] as num).toDouble(),
    );
    final pending = {
      ...payload,
      'id': localId,
      'status': 'confirmed',
      'payment_status': body['payment_status'] ?? 'pending',
      'total_bill': totalBill,
      'items': normalizedItems,
      '_pending_sync': true,
      'created_at': DateTime.now().toIso8601String(),
    };
    final order = OrderModel.fromJson(pending);
    await _orders.upsert(order, pendingSync: true);
    await _outbox.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'order',
      operation: 'create',
      localId: localId,
      payload: payload,
    ));
    OfflineSyncTrigger.requestSync();
    return order;
  }

  Future<OrderModel> cancel(int orderId, String reason) async {
    if (_isOnline()) {
      final order = await _remote.cancel(orderId, reason);
      await _orders.upsert(order);
      return order;
    }

    if (orderId < 0) {
      final cached = await _orders.getByServerId(orderId);
      if (cached != null) {
        final updated = OrderModel.fromJson({
          ..._orderToJson(cached),
          'status': 'cancelled',
          'cancellation_reason': reason,
        });
        await _orders.upsert(updated, pendingSync: true);
        await _outbox.cancelPendingByLocalId(orderId);
        return updated;
      }
    }

    await _outbox.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'order',
      operation: 'cancel',
      serverId: orderId,
      payload: {'reason': reason},
    ));
    OfflineSyncTrigger.requestSync();
    final cached = await _orders.getByServerId(orderId);
    if (cached != null) {
      final updated = OrderModel.fromJson({
        ..._orderToJson(cached),
        'status': 'cancelled',
        'cancellation_reason': reason,
      });
      await _orders.upsert(updated);
      return updated;
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
      await _orders.upsert(order);
      return order;
    }

    await _outbox.enqueue(SyncQueueItem(
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
    OfflineSyncTrigger.requestSync();
    final cached = await _orders.getByServerId(orderId);
    if (cached != null) {
      final paid = cached.amountPaid + amount;
      final due = (cached.totalBill - paid).clamp(0, double.infinity);
      final updated = OrderModel.fromJson({
        ..._orderToJson(cached),
        'amount_paid': paid,
        'amount_due': due,
        'payment_status': due <= 0 ? 'paid' : 'partial',
      });
      await _orders.upsert(updated);
      return updated;
    }
    throw Exception('Order not available offline');
  }

  Map<String, dynamic> _orderToJson(OrderModel order) => {
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

  Future<int> pendingSyncCount() => _outbox.pendingCount();
}
