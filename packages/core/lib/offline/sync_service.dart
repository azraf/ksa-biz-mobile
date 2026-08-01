import 'dart:async';
import 'dart:math' as math;

import '../api/api_exception.dart';
import '../models/order.dart';
import '../offline/offline_stores.dart';
import '../offline/offline_sync_trigger.dart';
import '../offline/stores/sync_outbox_store.dart';
import '../offline/sync_queue_item.dart';
import '../repositories/customer_diary_repository.dart';
import '../repositories/expense_repository.dart';
import '../repositories/media_upload_repository.dart';
import '../repositories/order_repository.dart';
import '../repositories/watchlist_repository.dart';
import 'connectivity_service.dart';
import '../api/api_reachability_service.dart';

class SyncProgress {
  const SyncProgress({required this.completed, required this.total});

  final int completed;
  final int total;
}

class SyncService {
  SyncService({
    required OfflineStores stores,
    required ConnectivityService connectivity,
    required OrderRepository orderRepository,
    required ExpenseRepository expenseRepository,
    this.watchlistRepository,
    this.diaryRepository,
    this.mediaUploadRepository,
    this.apiReachability,
    this.apiBaseUrl,
  })  : _stores = stores,
        connectivity = connectivity,
        orderRepository = orderRepository,
        expenseRepository = expenseRepository;

  final OfflineStores _stores;
  final ConnectivityService connectivity;
  final OrderRepository orderRepository;
  final ExpenseRepository expenseRepository;
  final WatchlistRepository? watchlistRepository;
  final CustomerDiaryRepository? diaryRepository;
  final MediaUploadRepository? mediaUploadRepository;
  final ApiReachabilityService? apiReachability;
  final String? apiBaseUrl;

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
      final queue = await _stores.outbox.pendingQueue();
      var completed = 0;
      _progressController.add(SyncProgress(completed: 0, total: queue.length));
      for (final item in queue) {
        await _processItem(item);
        completed++;
        _progressController.add(SyncProgress(completed: completed, total: queue.length));
      }
      await mediaUploadRepository?.uploadPendingBlobs();
      await _stores.outbox.purgeDone();
      await _stores.reports.invalidateAll();
      _syncController.add(null);
    } finally {
      _syncing = false;
    }
  }

  Future<void> retryFailedItems() async {
    await _stores.outbox.retryAllFailed();
    await syncIfOnline();
  }

  Future<void> retryItem(int id) async {
    await _stores.outbox.retryItem(id);
    await syncIfOnline();
  }

  Future<void> dismissDeadItem(int id) async {
    await _stores.outbox.dismissDead(id);
  }

  Future<List<SyncQueueItem>> actionableItems() => _stores.outbox.actionableItems();

  Future<void> _processItem(SyncQueueItem item) async {
    if (item.retryCount >= SyncOutboxStore.maxRetries) {
      await _stores.outbox.updateStatus(
        item.id,
        status: 'dead',
        errorMessage: item.errorMessage ?? 'Maximum retry attempts exceeded',
      );
      return;
    }

    await _stores.outbox.updateStatus(item.id, status: 'syncing');
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
          await _stores.outbox.updateStatus(item.id, status: 'failed', errorMessage: 'Unknown entity');
      }
    } on ApiException catch (e) {
      await _markFailed(item, e.message);
    } catch (e) {
      await _markFailed(item, e.toString());
    }
  }

  Future<void> _markFailed(SyncQueueItem item, String message) async {
    final nextRetry = item.retryCount + 1;
    if (nextRetry >= SyncOutboxStore.maxRetries) {
      await _stores.outbox.updateStatus(
        item.id,
        status: 'dead',
        errorMessage: message,
        retryCount: nextRetry,
      );
      return;
    }
    final delaySeconds = math.min(60, math.pow(2, nextRetry).toInt());
    await _stores.outbox.updateStatus(
      item.id,
      status: 'failed',
      errorMessage: message,
      retryCount: nextRetry,
      nextRetryAt: DateTime.now().add(Duration(seconds: delaySeconds)),
    );
  }

  Future<void> _markDone(SyncQueueItem item, {int? serverId, Future<void> Function()? afterLocalUpdate}) async {
    if (afterLocalUpdate != null) {
      await afterLocalUpdate();
    }
    await _stores.outbox.updateStatus(
      item.id,
      status: 'done',
      serverId: serverId,
      clearNextRetryAt: true,
    );
  }

  Future<OrderModel?> _fetchServerOrder(int orderId) async {
    try {
      return await orderRepository.get(orderId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _syncOrder(SyncQueueItem item) async {
    if (item.operation == 'create') {
      final order = await orderRepository.create(item.payload);
      await _markDone(
        item,
        serverId: order.id,
        afterLocalUpdate: () async {
          if (item.localId != null) {
            await _stores.orders.replaceLocalId(item.localId!, order);
          }
        },
      );
    } else if (item.operation == 'payment' && item.serverId != null) {
      final current = await _fetchServerOrder(item.serverId!);
      if (current == null) {
        await _markFailed(item, 'Order not found on server');
        return;
      }
      if (current.status == 'cancelled') {
        await _markFailed(item, 'Cannot record payment on a cancelled order');
        return;
      }
      if (current.paymentStatus == 'paid') {
        await _markDone(
          item,
          afterLocalUpdate: () async => _stores.orders.upsert(current),
        );
        return;
      }
      final order = await orderRepository.recordPayment(
        item.serverId!,
        amount: (item.payload['amount'] as num).toDouble(),
        paymentMethod: item.payload['payment_method'] as String?,
        notes: item.payload['notes'] as String?,
      );
      await _markDone(
        item,
        afterLocalUpdate: () async => _stores.orders.upsert(order),
      );
    } else if (item.operation == 'cancel' && item.serverId != null) {
      final current = await _fetchServerOrder(item.serverId!);
      if (current == null) {
        await _markFailed(item, 'Order not found on server');
        return;
      }
      if (current.status == 'cancelled') {
        await _markDone(
          item,
          afterLocalUpdate: () async => _stores.orders.upsert(current),
        );
        return;
      }
      final order = await orderRepository.cancel(
        item.serverId!,
        item.payload['reason'] as String? ?? '',
      );
      await _markDone(
        item,
        afterLocalUpdate: () async => _stores.orders.upsert(order),
      );
    }
  }

  Future<void> _syncExpense(SyncQueueItem item) async {
    if (item.operation == 'create') {
      final expense = await expenseRepository.create(item.payload);
      await _markDone(
        item,
        serverId: expense.id,
        afterLocalUpdate: () async {
          if (item.localId != null) {
            await _stores.expenses.remove(item.localId!);
            await _stores.expenses.upsertJson(expense.id, {...expense.toJson(), 'id': expense.id});
          }
        },
      );
    } else if (item.operation == 'update' && item.serverId != null) {
      final expense = await expenseRepository.update(item.serverId!, item.payload);
      await _markDone(
        item,
        afterLocalUpdate: () async {
          await _stores.expenses.upsertJson(expense.id, {...expense.toJson(), 'id': expense.id});
        },
      );
    }
  }

  Future<void> _syncWatchlist(SyncQueueItem item) async {
    final repo = watchlistRepository;
    if (repo == null) return;

    if (item.operation == 'create') {
      final created = await repo.createFromPayload(item.payload);
      await _markDone(
        item,
        serverId: created.id,
        afterLocalUpdate: () async {
          if (item.localId != null) {
            await _stores.media.resolveParents(
              parentEntityType: 'watchlist',
              parentLocalId: item.localId!,
              parentServerId: created.id,
            );
            await _stores.watchlist.replaceLocalId(item.localId!, created);
          }
        },
      );
    } else if (item.operation == 'update' && item.serverId != null) {
      await repo.update(item.serverId!, item.payload);
      await _markDone(item);
    } else if (item.operation == 'delete' && item.serverId != null) {
      await repo.delete(item.serverId!);
      await _markDone(
        item,
        afterLocalUpdate: () async => _stores.watchlist.remove(item.serverId!),
      );
    }
  }

  Future<void> _syncDiary(SyncQueueItem item) async {
    final repo = diaryRepository;
    if (repo == null || item.operation != 'create') return;

    final payload = item.payload;
    final note = await repo.createFromPayload(payload);
    await _markDone(
      item,
      serverId: note.id,
      afterLocalUpdate: () async {
        if (item.localId != null) {
          await _stores.media.resolveParents(
            parentEntityType: 'diary',
            parentLocalId: item.localId!,
            parentServerId: note.id,
          );
          await _stores.diary.remove(item.localId!);
        }
      },
    );
  }
}
