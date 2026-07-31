import 'dart:async';

import '../api/api_exception.dart';
import '../models/order.dart';
import '../repositories/customer_diary_repository.dart';
import '../repositories/expense_repository.dart';
import '../repositories/media_upload_repository.dart';
import '../repositories/order_repository.dart';
import '../repositories/watchlist_repository.dart';
import 'local_database.dart';
import 'sync_queue_item.dart';

class SyncService {
  SyncService({
    required this.db,
    required this.connectivity,
    required this.orderRepository,
    required this.expenseRepository,
    this.watchlistRepository,
    this.diaryRepository,
    this.mediaUploadRepository,
  });

  final LocalDatabase db;
  final ConnectivityService connectivity;
  final OrderRepository orderRepository;
  final ExpenseRepository expenseRepository;
  final WatchlistRepository? watchlistRepository;
  final CustomerDiaryRepository? diaryRepository;
  final MediaUploadRepository? mediaUploadRepository;

  final _syncController = StreamController<void>.broadcast();
  Stream<void> get onSyncComplete => _syncController.stream;

  bool _syncing = false;

  Future<void> syncIfOnline() async {
    if (!connectivity.isOnline || _syncing) return;
    _syncing = true;
    try {
      final queue = await db.pendingQueue();
      for (final item in queue) {
        await _processItem(item);
      }
      await mediaUploadRepository?.uploadPendingBlobs();
      _syncController.add(null);
    } finally {
      _syncing = false;
    }
  }

  Future<void> _processItem(SyncQueueItem item) async {
    await db.updateQueueStatus(item.id, status: 'syncing');
    try {
      switch (item.entityType) {
        case 'order':
          await _syncOrder(item);
        case 'expense':
          await _syncExpense(item);
        case 'watchlist':
          await _syncWatchlist(item);
        case 'diary':
          await _syncDiary(item);
        default:
          await db.updateQueueStatus(item.id, status: 'failed', errorMessage: 'Unknown entity');
      }
    } on ApiException catch (e) {
      await db.updateQueueStatus(
        item.id,
        status: 'failed',
        errorMessage: e.message,
        retryCount: item.retryCount + 1,
      );
    } catch (e) {
      await db.updateQueueStatus(
        item.id,
        status: 'failed',
        errorMessage: e.toString(),
        retryCount: item.retryCount + 1,
      );
    }
  }

  Future<void> _syncOrder(SyncQueueItem item) async {
    if (item.operation == 'create') {
      final order = await orderRepository.create(item.payload);
      if (item.localId != null) {
        await db.removeCachedEntity('order', item.localId!);
        await db.cacheEntity(
          entityType: 'order',
          entityId: order.id,
          data: _orderToJson(order),
        );
      }
      await db.updateQueueStatus(item.id, status: 'done', serverId: order.id);
    } else if (item.operation == 'payment' && item.serverId != null) {
      final order = await orderRepository.recordPayment(
        item.serverId!,
        amount: (item.payload['amount'] as num).toDouble(),
        paymentMethod: item.payload['payment_method'] as String?,
        notes: item.payload['notes'] as String?,
      );
      await db.cacheEntity(
        entityType: 'order',
        entityId: order.id,
        data: _orderToJson(order),
      );
      await db.updateQueueStatus(item.id, status: 'done');
    } else if (item.operation == 'cancel' && item.serverId != null) {
      final order = await orderRepository.cancel(
        item.serverId!,
        item.payload['reason'] as String? ?? '',
      );
      await db.cacheEntity(
        entityType: 'order',
        entityId: order.id,
        data: _orderToJson(order),
      );
      await db.updateQueueStatus(item.id, status: 'done');
    }
  }

  Future<void> _syncExpense(SyncQueueItem item) async {
    if (item.operation == 'create') {
      final expense = await expenseRepository.create(item.payload);
      if (item.localId != null) {
        await db.removeCachedEntity('expense', item.localId!);
        await db.cacheEntity(
          entityType: 'expense',
          entityId: expense.id,
          data: expense.toJson(),
        );
      }
      await db.updateQueueStatus(item.id, status: 'done', serverId: expense.id);
    } else if (item.operation == 'update' && item.serverId != null) {
      final expense = await expenseRepository.update(item.serverId!, item.payload);
      await db.cacheEntity(
        entityType: 'expense',
        entityId: expense.id,
        data: expense.toJson(),
      );
      await db.updateQueueStatus(item.id, status: 'done');
    }
  }

  Future<void> _syncWatchlist(SyncQueueItem item) async {
    final repo = watchlistRepository;
    if (repo == null) return;

    if (item.operation == 'create') {
      final payload = item.payload;
      final created = await repo.create(
        gps: payload['gps'] as String,
        salesPersonId: payload['sales_person_id'] as int,
        placeName: payload['place_name'] as String?,
        noteText: payload['note_text'] as String?,
      );
      if (item.localId != null) {
        await db.resolveMediaBlobParents(
          parentEntityType: 'watchlist',
          parentLocalId: item.localId!,
          parentServerId: created.id,
        );
        await db.removeCachedEntity('watchlist', item.localId!);
        await db.cacheEntity(
          entityType: 'watchlist',
          entityId: created.id,
          data: {
            'id': created.id,
            'sales_person_id': created.salesPersonId,
            'gps': created.gps,
            'place_name': created.placeName,
            'note_text': created.noteText,
            'status': created.status,
          },
        );
      }
      await db.updateQueueStatus(item.id, status: 'done', serverId: created.id);
    } else if (item.operation == 'update' && item.serverId != null) {
      await repo.update(item.serverId!, item.payload);
      await db.updateQueueStatus(item.id, status: 'done');
    } else if (item.operation == 'delete' && item.serverId != null) {
      await repo.delete(item.serverId!);
      await db.removeCachedEntity('watchlist', item.serverId!);
      await db.updateQueueStatus(item.id, status: 'done');
    }
  }

  Future<void> _syncDiary(SyncQueueItem item) async {
    final repo = diaryRepository;
    if (repo == null || item.operation != 'create') return;

    final payload = item.payload;
    final customerType = payload['customer_type'] as String;
    final customerId = payload['customer_id'] as int;
    final note = await repo.create(
      customerType: customerType,
      customerId: customerId,
      noteType: payload['note_type'] as String? ?? 'text',
      body: payload['body'] as String?,
      salesPersonId: payload['sales_person_id'] as int?,
    );
    if (item.localId != null) {
      await db.resolveMediaBlobParents(
        parentEntityType: 'diary',
        parentLocalId: item.localId!,
        parentServerId: note.id,
      );
      final key = 'diary_${customerType}_$customerId';
      await db.removeCachedEntity(key, item.localId!);
    }
    await db.updateQueueStatus(item.id, status: 'done', serverId: note.id);
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
        'items': order.items.map((i) => {
              'product_id': i.productId,
              'quantity': i.quantity,
              'product_price': i.productPrice,
            }).toList(),
        'created_at': order.createdAt,
        '_pending_sync': false,
      };
}
