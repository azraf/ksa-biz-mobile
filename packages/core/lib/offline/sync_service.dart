import 'dart:async';
import 'dart:math' as math;

import '../api/api_exception.dart';
import '../api/api_reachability_service.dart';
import '../models/order.dart';
import '../repositories/customer_diary_repository.dart';
import '../repositories/expense_repository.dart';
import '../repositories/media_upload_repository.dart';
import '../repositories/order_repository.dart';
import '../repositories/sync_repository.dart';
import '../repositories/watchlist_repository.dart';
import '../utils/client_request_id.dart';
import 'local_database.dart';
import 'offline_sync_trigger.dart';
import 'sync_queue_item.dart';

class SyncProgress {
  const SyncProgress({required this.completed, required this.total});

  final int completed;
  final int total;
}

class SyncService {
  SyncService({
    required this.db,
    required this.connectivity,
    required this.orderRepository,
    required this.expenseRepository,
    this.syncRepository,
    this.watchlistRepository,
    this.diaryRepository,
    this.mediaUploadRepository,
    this.apiReachability,
    this.apiBaseUrl,
    this.maxConcurrentSync = 3,
    this.bulkBatchSize = 20,
  });

  final LocalDatabase db;
  final ConnectivityService connectivity;
  final OrderRepository orderRepository;
  final ExpenseRepository expenseRepository;
  final SyncRepository? syncRepository;
  final WatchlistRepository? watchlistRepository;
  final CustomerDiaryRepository? diaryRepository;
  final MediaUploadRepository? mediaUploadRepository;
  final ApiReachabilityService? apiReachability;
  final String? apiBaseUrl;
  final int maxConcurrentSync;
  final int bulkBatchSize;

  final _syncController = StreamController<void>.broadcast();
  final _progressController = StreamController<SyncProgress>.broadcast();

  Stream<void> get onSyncComplete => _syncController.stream;
  Stream<SyncProgress> get progressStream => _progressController.stream;

  bool _syncing = false;

  Future<void> syncIfOnline() async {
    if (!connectivity.isOnline || _syncing) return;
    final reachability = apiReachability;
    if (reachability != null) {
      final ok = await reachability.check(baseUrl: apiBaseUrl);
      if (!ok) return;
    }
    _syncing = true;
    try {
      final queue = await db.pendingQueue();
      var completed = 0;
      _progressController.add(SyncProgress(completed: 0, total: queue.length));
      if (queue.isNotEmpty) {
        final bulkHandled = await _tryBulkSync(queue);
        if (!bulkHandled) {
          await _processQueueInParallel(
            queue,
            onItemComplete: () {
              completed++;
              _progressController.add(SyncProgress(completed: completed, total: queue.length));
            },
          );
        } else {
          completed = queue.length;
          _progressController.add(SyncProgress(completed: completed, total: queue.length));
        }
      }
      await mediaUploadRepository?.uploadPendingBlobs();
      await db.purgeDoneQueue(olderThan: const Duration(days: LocalDatabase.purgeDoneOlderThanDays));
      await db.purgeDoneMedia(olderThan: const Duration(days: LocalDatabase.purgeDoneOlderThanDays));
      await db.evictStaleEntityCache();
      await db.setLastSyncAt(DateTime.now());
      _syncController.add(null);
    } finally {
      _syncing = false;
    }
  }

  Future<void> retryFailedItems() async {
    await db.retryFailedItems();
    await syncIfOnline();
  }

  Future<void> retryItem(int id) async {
    await db.retryQueueItem(id);
    await syncIfOnline();
  }

  Future<List<SyncQueueItem>> actionableItems() => db.actionableSyncItems();

  Future<bool> isFullySynced() async {
    final queue = await db.pendingCount();
    final media = await db.pendingMediaCount();
    return queue == 0 && media == 0;
  }

  Future<bool> _tryBulkSync(List<SyncQueueItem> queue) async {
    final repo = syncRepository;
    if (repo == null) return false;

    try {
      for (var offset = 0; offset < queue.length; offset += bulkBatchSize) {
        final batch = queue.skip(offset).take(bulkBatchSize).toList();
        final operations = batch.map(_operationPayload).toList();
        final results = await repo.push(operations);

        for (var i = 0; i < batch.length; i++) {
          final item = batch[i];
          final result = i < results.length ? results[i] : null;
          if (result == null || result['status'] != 'done') {
            await _markFailed(item, result?['error']?.toString() ?? 'Bulk sync failed');
            continue;
          }

          await _applyBulkResult(item, result);
          await db.updateQueueStatus(
            item.id,
            status: 'done',
            serverId: _readServerId(result),
            clearNextRetryAt: true,
          );
        }
      }
      return true;
    } on ApiException {
      return false;
    }
  }

  Future<void> _processQueueInParallel(
    List<SyncQueueItem> queue, {
    void Function()? onItemComplete,
  }) async {
    for (var offset = 0; offset < queue.length; offset += maxConcurrentSync) {
      final batch = queue.skip(offset).take(maxConcurrentSync).toList();
      await Future.wait(batch.map((item) async {
        await _processItem(item);
        onItemComplete?.call();
      }));
    }
  }

  Map<String, dynamic> _operationPayload(SyncQueueItem item) {
    final payload = Map<String, dynamic>.from(item.payload);
    payload.putIfAbsent('client_request_id', generateClientRequestId);

    return {
      'entity_type': item.entityType,
      'operation': item.operation,
      'client_request_id': payload['client_request_id'],
      'payload': payload,
      if (item.localId != null) 'local_id': item.localId,
      if (item.serverId != null) 'server_id': item.serverId,
    };
  }

  int? _readServerId(Map<String, dynamic> result) {
    final data = result['data'];
    if (data is Map && data['server_id'] != null) {
      return data['server_id'] as int;
    }
    return null;
  }

  Future<void> _applyBulkResult(SyncQueueItem item, Map<String, dynamic> result) async {
    final serverId = _readServerId(result);
    switch (item.entityType) {
      case 'order':
        if (item.operation == 'create' && item.localId != null && serverId != null) {
          await db.removeCachedEntity('order', item.localId!);
          try {
            final order = await orderRepository.get(serverId);
            await db.cacheEntity(
              entityType: 'order',
              entityId: serverId,
              data: _orderToJson(order),
            );
          } catch (_) {
            await db.cacheEntity(
              entityType: 'order',
              entityId: serverId,
              data: {'id': serverId, '_pending_sync': false},
            );
          }
        }
      case 'expense':
        if (item.operation == 'create' && item.localId != null && serverId != null) {
          await db.removeCachedEntity('expense', item.localId!);
        }
      case 'watchlist':
        if (item.operation == 'create' && item.localId != null && serverId != null) {
          await db.resolveMediaBlobParents(
            parentEntityType: 'watchlist',
            parentLocalId: item.localId!,
            parentServerId: serverId,
          );
          await db.removeCachedEntity('watchlist', item.localId!);
        }
      case 'diary':
        if (item.operation == 'create' && item.localId != null) {
          final payload = item.payload;
          final customerType = payload['customer_type'] as String?;
          final customerId = payload['customer_id'] as int?;
          if (customerType != null && customerId != null && serverId != null) {
            final key = 'diary_${customerType}_$customerId';
            await db.removeCachedEntity(key, item.localId!);
          }
        }
    }
  }

  Future<void> _processItem(SyncQueueItem item) async {
    if (item.retryCount >= LocalDatabase.maxRetries) {
      await db.updateQueueStatus(
        item.id,
        status: 'failed',
        errorMessage: item.errorMessage ?? 'Maximum retry attempts exceeded',
      );
      return;
    }

    await db.updateQueueStatus(item.id, status: 'syncing', clearNextRetryAt: true);
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
      await _markFailed(item, e.message);
    } catch (e) {
      await _markFailed(item, e.toString());
    }
  }

  Future<void> _markFailed(SyncQueueItem item, String message) async {
    final nextRetry = item.retryCount + 1;
    if (nextRetry >= LocalDatabase.maxRetries) {
      await db.updateQueueStatus(
        item.id,
        status: 'failed',
        errorMessage: message,
        retryCount: nextRetry,
      );
      return;
    }
    final delaySeconds = math.min(60, math.pow(2, nextRetry).toInt());
    await db.updateQueueStatus(
      item.id,
      status: 'failed',
      errorMessage: message,
      retryCount: nextRetry,
      nextRetryAt: DateTime.now().add(Duration(seconds: delaySeconds)),
    );
  }

  Future<void> _syncOrder(SyncQueueItem item) async {
    final payload = Map<String, dynamic>.from(item.payload);
    payload.putIfAbsent('client_request_id', generateClientRequestId);

    if (item.operation == 'create') {
      final order = await orderRepository.create(payload);
      if (item.localId != null) {
        await db.removeCachedEntity('order', item.localId!);
        await db.cacheEntity(
          entityType: 'order',
          entityId: order.id,
          data: _orderToJson(order),
        );
      }
      await db.updateQueueStatus(
        item.id,
        status: 'done',
        serverId: order.id,
        clearNextRetryAt: true,
      );
    } else if (item.operation == 'payment' && item.serverId != null && item.serverId! > 0) {
      final order = await orderRepository.recordPayment(
        item.serverId!,
        amount: (payload['amount'] as num).toDouble(),
        paymentMethod: payload['payment_method'] as String?,
        notes: payload['notes'] as String?,
      );
      await db.cacheEntity(
        entityType: 'order',
        entityId: order.id,
        data: _orderToJson(order),
      );
      await db.updateQueueStatus(item.id, status: 'done', clearNextRetryAt: true);
    } else if (item.operation == 'cancel' && item.serverId != null && item.serverId! > 0) {
      final order = await orderRepository.cancel(
        item.serverId!,
        payload['reason'] as String? ?? '',
      );
      await db.cacheEntity(
        entityType: 'order',
        entityId: order.id,
        data: _orderToJson(order),
      );
      await db.updateQueueStatus(item.id, status: 'done', clearNextRetryAt: true);
    } else {
      await db.updateQueueStatus(
        item.id,
        status: 'failed',
        errorMessage: 'Invalid order sync state',
      );
    }
  }

  Future<void> _syncExpense(SyncQueueItem item) async {
    final payload = Map<String, dynamic>.from(item.payload);
    payload.putIfAbsent('client_request_id', generateClientRequestId);

    if (item.operation == 'create') {
      final expense = await expenseRepository.create(payload);
      if (item.localId != null) {
        await db.removeCachedEntity('expense', item.localId!);
        await db.cacheEntity(
          entityType: 'expense',
          entityId: expense.id,
          data: expense.toJson(),
        );
      }
      await db.updateQueueStatus(item.id, status: 'done', serverId: expense.id, clearNextRetryAt: true);
    } else if (item.operation == 'update' && item.serverId != null) {
      final expense = await expenseRepository.update(item.serverId!, payload);
      await db.cacheEntity(
        entityType: 'expense',
        entityId: expense.id,
        data: expense.toJson(),
      );
      await db.updateQueueStatus(item.id, status: 'done', clearNextRetryAt: true);
    }
  }

  Future<void> _syncWatchlist(SyncQueueItem item) async {
    final repo = watchlistRepository;
    if (repo == null) return;

    final payload = Map<String, dynamic>.from(item.payload);
    payload.putIfAbsent('client_request_id', generateClientRequestId);

    if (item.operation == 'create') {
      final created = await repo.create(
        gps: payload['gps'] as String,
        salesPersonId: payload['sales_person_id'] as int,
        placeName: payload['place_name'] as String?,
        noteText: payload['note_text'] as String?,
        clientRequestId: payload['client_request_id'] as String?,
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
      await db.updateQueueStatus(item.id, status: 'done', serverId: created.id, clearNextRetryAt: true);
    } else if (item.operation == 'update' && item.serverId != null) {
      await repo.update(item.serverId!, payload);
      await db.updateQueueStatus(item.id, status: 'done', clearNextRetryAt: true);
    } else if (item.operation == 'delete' && item.serverId != null) {
      await repo.delete(item.serverId!);
      await db.removeCachedEntity('watchlist', item.serverId!);
      await db.updateQueueStatus(item.id, status: 'done', clearNextRetryAt: true);
    }
  }

  Future<void> _syncDiary(SyncQueueItem item) async {
    final repo = diaryRepository;
    if (repo == null || item.operation != 'create') return;

    final payload = Map<String, dynamic>.from(item.payload);
    payload.putIfAbsent('client_request_id', generateClientRequestId);
    final customerType = payload['customer_type'] as String;
    final customerId = payload['customer_id'] as int;
    final note = await repo.create(
      customerType: customerType,
      customerId: customerId,
      noteType: payload['note_type'] as String? ?? 'text',
      body: payload['body'] as String?,
      salesPersonId: payload['sales_person_id'] as int?,
      clientRequestId: payload['client_request_id'] as String?,
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
    await db.updateQueueStatus(item.id, status: 'done', serverId: note.id, clearNextRetryAt: true);
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

  Future<void> dismissDeadItem(int id) async {
    await db.deleteQueueItem(id);
  }

  void dispose() {
    _syncController.close();
    _progressController.close();
  }
}

/// After enqueue, request foreground sync.
void notifyOfflineEnqueue() => OfflineSyncTrigger.requestSync();
