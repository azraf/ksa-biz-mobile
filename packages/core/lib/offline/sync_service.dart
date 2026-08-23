import 'dart:async';
import 'dart:math' as math;

import '../api/api_exception.dart';
import '../api/api_reachability_service.dart';
import '../models/order.dart';
import '../repositories/customer_diary_repository.dart';
import '../repositories/expense_repository.dart';
import '../repositories/manual_order_repository.dart';
import '../repositories/media_upload_repository.dart';
import '../repositories/order_repository.dart';
import '../repositories/sync_repository.dart';
import '../repositories/visit_schedule_repository.dart';
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
    this.manualOrderRepository,
    this.visitRepository,
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
  final ManualOrderRepository? manualOrderRepository;
  final VisitScheduleRepository? visitRepository;
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
        final wholeBatch = queue.skip(offset).take(bulkBatchSize).toList();

        // Claim every row first — a 0 count means wipeUserData() deleted it
        // (a different user logged in mid-sync); drop it from this batch so
        // it's never pushed under the new user's token.
        final batch = <SyncQueueItem>[];
        for (final item in wholeBatch) {
          final claimed = await db.updateQueueStatus(item.id, status: 'syncing', clearNextRetryAt: true);
          if (claimed > 0) batch.add(item);
        }
        if (batch.isEmpty) continue;

        final operations = batch.map(_operationPayload).toList();
        try {
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
        } on ApiException {
          // Claimed as 'syncing' but the push itself failed — put them back
          // so the per-item fallback path (which also claims before
          // sending) picks them up instead of leaving them stuck.
          for (final item in batch) {
            await db.updateQueueStatus(item.id, status: 'pending');
          }
          rethrow;
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
        if (item.operation == 'create' && item.localId != null && serverId != null) {
          // Must mirror _syncDiary: without the remap the note's photo/voice
          // blob keeps parent_server_id = NULL, uploadPendingBlobs skips it
          // forever, and the recording is silently never delivered.
          await db.resolveMediaBlobParents(
            parentEntityType: 'diary',
            parentLocalId: item.localId!,
            parentServerId: serverId,
          );
          final payload = item.payload;
          final customerType = payload['customer_type'] as String?;
          final customerId = payload['customer_id'] as int?;
          final orderId = payload['order_id'] as int?;
          // Order-scoped notes cache under a different key than customer ones.
          final key = orderId != null
              ? 'diary_order_$orderId'
              : (customerType != null && customerId != null
                    ? 'diary_${customerType}_$customerId'
                    : null);
          if (key != null) {
            await db.removeCachedEntity(key, item.localId!);
          }
        }
      case 'manual_order':
        if (item.operation == 'create' && item.localId != null && serverId != null) {
          await db.resolveMediaBlobParents(
            parentEntityType: 'manual_order',
            parentLocalId: item.localId!,
            parentServerId: serverId,
          );
          await db.removeCachedEntity('manual_order', item.localId!);
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

    // Claim the row — a 0 count means it was deleted by wipeUserData() (a
    // different user logged in while this sync was in flight); stop rather
    // than push it to the server under the new user's token.
    final claimed = await db.updateQueueStatus(item.id, status: 'syncing', clearNextRetryAt: true);
    if (claimed == 0) return;
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
        case 'manual_order':
          await _syncManualOrder(item);
        case 'visit':
          await _syncVisit(item);
        default:
          await db.updateQueueStatus(item.id, status: 'failed', errorMessage: 'Unknown entity');
      }
      // Handlers early-return when their repository is absent or the operation
      // is unsupported, leaving the row claimed. Hand it back so the next pass
      // retries it instead of waiting for an app restart.
      await db.releaseUnfinishedClaim(item.id);
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
        phone: payload['phone'] as String?,
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
            'phone': created.phone,
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

  Future<void> _syncVisit(SyncQueueItem item) async {
    final repo = visitRepository;
    if (repo == null) return;

    if (item.operation == 'create') {
      final payload = Map<String, dynamic>.from(item.payload);
      payload.putIfAbsent('client_request_id', generateClientRequestId);
      final created = await repo.create(payload);
      if (item.localId != null) {
        await db.removeCachedEntity('visit', item.localId!);
      }
      await db.cacheEntity(entityType: 'visit', entityId: created.id, data: created.toCacheJson());
      await db.updateQueueStatus(item.id, status: 'done', serverId: created.id, clearNextRetryAt: true);
      return;
    }

    final serverId = item.serverId;
    if (serverId == null) {
      await db.updateQueueStatus(item.id, status: 'failed', errorMessage: 'Missing server id');
      return;
    }

    final outcome = item.payload['outcome_note'] as String?;
    final updated = switch (item.operation) {
      'update' => await repo.update(serverId, item.payload),
      'complete' => await repo.complete(serverId, outcomeNote: outcome),
      'miss' => await repo.miss(serverId, outcomeNote: outcome),
      'cancel' => await repo.cancel(serverId, reason: outcome),
      _ => null,
    };

    if (updated == null) {
      await db.updateQueueStatus(item.id, status: 'failed', errorMessage: 'Unknown visit operation');
      return;
    }

    await db.cacheEntity(entityType: 'visit', entityId: updated.id, data: updated.toCacheJson());
    await db.updateQueueStatus(item.id, status: 'done', serverId: updated.id, clearNextRetryAt: true);
  }

  Future<void> _syncDiary(SyncQueueItem item) async {
    final repo = diaryRepository;
    if (repo == null || item.operation != 'create') return;

    final payload = Map<String, dynamic>.from(item.payload);
    payload.putIfAbsent('client_request_id', generateClientRequestId);
    final customerType = payload['customer_type'] as String;
    final customerId = payload['customer_id'] as int;
    final orderId = payload['order_id'] as int?;
    final note = await repo.create(
      customerType: customerType,
      customerId: customerId,
      noteType: payload['note_type'] as String? ?? 'text',
      body: payload['body'] as String?,
      orderId: orderId,
      salesPersonId: payload['sales_person_id'] as int?,
      clientRequestId: payload['client_request_id'] as String?,
    );
    if (item.localId != null) {
      await db.resolveMediaBlobParents(
        parentEntityType: 'diary',
        parentLocalId: item.localId!,
        parentServerId: note.id,
      );
      final key = orderId != null ? 'diary_order_$orderId' : 'diary_${customerType}_$customerId';
      await db.removeCachedEntity(key, item.localId!);
    }
    await db.updateQueueStatus(item.id, status: 'done', serverId: note.id, clearNextRetryAt: true);
  }

  Future<void> _syncManualOrder(SyncQueueItem item) async {
    final repo = manualOrderRepository;
    if (repo == null || item.operation != 'create') return;

    final payload = Map<String, dynamic>.from(item.payload);
    payload.putIfAbsent('client_request_id', generateClientRequestId);
    final request = await repo.create(
      customerType: payload['customer_type'] as String?,
      customerId: payload['customer_id'] as int?,
      notes: payload['notes'] as String? ?? '',
      clientRequestId: payload['client_request_id'] as String?,
    );
    if (item.localId != null) {
      await db.resolveMediaBlobParents(
        parentEntityType: 'manual_order',
        parentLocalId: item.localId!,
        parentServerId: request.id,
      );
      await db.removeCachedEntity('manual_order', item.localId!);
    }
    await db.updateQueueStatus(item.id, status: 'done', serverId: request.id, clearNextRetryAt: true);
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
