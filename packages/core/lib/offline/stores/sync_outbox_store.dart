import 'dart:async';
import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../utils/client_request_id.dart';
import '../isar/enums.dart';
import '../isar/sync_outbox_entry.dart';
import '../isar_service.dart';
import '../sync_queue_item.dart';

class SyncOutboxStore {
  SyncOutboxStore(this._isar);

  final IsarService _isar;
  static const maxRetries = 5;

  Isar get _db => _isar.isar;

  SyncEntityType _entityType(String value) {
    return SyncEntityType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SyncEntityType.order,
    );
  }

  SyncOperation _operation(String value) {
    return SyncOperation.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SyncOperation.create,
    );
  }

  SyncStatus _status(String value) {
    return SyncStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SyncStatus.pending,
    );
  }

  /// Upgrades outbox rows written by older app versions so they keep syncing safely.
  Future<void> migrateLegacyEntries({bool softenCappedRetries = false}) async {
    await _isar.writeTxn(() async {
      final rows = await _db.syncOutboxEntrys
          .filter()
          .group((q) {
            return q
                .statusEqualTo(SyncStatus.pending)
                .or()
                .statusEqualTo(SyncStatus.failed)
                .or()
                .statusEqualTo(SyncStatus.syncing);
          })
          .findAll();

      for (final entry in rows) {
        var changed = false;
        final payload = Map<String, dynamic>.from(
          jsonDecode(entry.payloadJson) as Map<String, dynamic>,
        );

        final payloadId = payload['client_request_id'] as String?;
        if (entry.operation == SyncOperation.create &&
            (payloadId == null || payloadId.isEmpty)) {
          final id = newClientRequestId();
          payload['client_request_id'] = id;
          entry.clientRequestId = id;
          entry.payloadJson = jsonEncode(payload);
          changed = true;
        } else if (entry.clientRequestId == null && payloadId != null && payloadId.isNotEmpty) {
          entry.clientRequestId = payloadId;
          changed = true;
        }

        if (softenCappedRetries &&
            entry.status == SyncStatus.failed &&
            entry.retryCount >= maxRetries) {
          entry.retryCount = maxRetries - 1;
          entry.nextRetryAt = null;
          changed = true;
        }

        if (changed) {
          await _db.syncOutboxEntrys.put(entry);
        }
      }
    });
  }

  Future<int> enqueue(SyncQueueItem item) async {
    final clientRequestId = item.clientRequestId ??
        item.payload['client_request_id'] as String?;
    final entry = SyncOutboxEntry()
      ..entityType = _entityType(item.entityType)
      ..operation = _operation(item.operation)
      ..localEntityId = item.localId
      ..serverEntityId = item.serverId
      ..status = _status(item.status)
      ..payloadJson = jsonEncode(item.payload)
      ..createdAt = DateTime.now()
      ..retryCount = item.retryCount
      ..errorMessage = item.errorMessage
      ..clientRequestId = clientRequestId
      ..nextRetryAt = item.nextRetryAt;
    return _isar.writeTxn(() => _db.syncOutboxEntrys.put(entry));
  }

  Future<List<SyncQueueItem>> pendingQueue() async {
    final now = DateTime.now();
    final rows = await _db.syncOutboxEntrys
        .filter()
        .group((q) => q.statusEqualTo(SyncStatus.pending).or().statusEqualTo(SyncStatus.failed))
        .sortByCreatedAt()
        .findAll();
    return rows
        .where((entry) {
          if (entry.status == SyncStatus.pending) return true;
          if (entry.nextRetryAt == null) return true;
          return !entry.nextRetryAt!.isAfter(now);
        })
        .map(_toQueueItem)
        .toList();
  }

  Future<List<SyncQueueItem>> actionableItems() async {
    final rows = await _db.syncOutboxEntrys
        .filter()
        .group((q) {
          return q
              .statusEqualTo(SyncStatus.failed)
              .or()
              .statusEqualTo(SyncStatus.dead);
        })
        .sortByCreatedAtDesc()
        .findAll();
    return rows.map(_toQueueItem).toList();
  }

  Future<int> pendingCount() async {
    return _db.syncOutboxEntrys
        .filter()
        .group((q) {
          return q
              .statusEqualTo(SyncStatus.pending)
              .or()
              .statusEqualTo(SyncStatus.failed)
              .or()
              .statusEqualTo(SyncStatus.dead);
        })
        .count();
  }

  Future<int> deadCount() async {
    return _db.syncOutboxEntrys.filter().statusEqualTo(SyncStatus.dead).count();
  }

  Stream<int> watchPendingCount() async* {
    yield await pendingCount();
    await for (final _ in _db.syncOutboxEntrys.watchLazy(fireImmediately: true)) {
      yield await pendingCount();
    }
  }

  Future<void> updateStatus(
    int id, {
    required String status,
    int? serverId,
    String? errorMessage,
    int? retryCount,
    DateTime? nextRetryAt,
    bool clearNextRetryAt = false,
  }) async {
    await _isar.writeTxn(() async {
      final entry = await _db.syncOutboxEntrys.get(id);
      if (entry == null) return;
      entry.status = _status(status);
      if (serverId != null) entry.serverEntityId = serverId;
      if (errorMessage != null) entry.errorMessage = errorMessage;
      if (retryCount != null) entry.retryCount = retryCount;
      if (nextRetryAt != null) entry.nextRetryAt = nextRetryAt;
      if (clearNextRetryAt) entry.nextRetryAt = null;
      await _db.syncOutboxEntrys.put(entry);
    });
  }

  Future<void> updatePayloadForLocalId(int localId, Map<String, dynamic> payload) async {
    await _isar.writeTxn(() async {
      final rows = await _db.syncOutboxEntrys
          .filter()
          .localEntityIdEqualTo(localId)
          .group((q) => q.statusEqualTo(SyncStatus.pending).or().statusEqualTo(SyncStatus.failed))
          .findAll();
      for (final entry in rows) {
        entry.payloadJson = jsonEncode(payload);
        if (payload['client_request_id'] is String) {
          entry.clientRequestId = payload['client_request_id'] as String;
        }
        await _db.syncOutboxEntrys.put(entry);
      }
    });
  }

  Future<SyncQueueItem?> findPendingCreateForLocalId(int localId) async {
    final row = await _db.syncOutboxEntrys
        .filter()
        .localEntityIdEqualTo(localId)
        .operationEqualTo(SyncOperation.create)
        .group((q) => q.statusEqualTo(SyncStatus.pending).or().statusEqualTo(SyncStatus.failed))
        .findFirst();
    return row == null ? null : _toQueueItem(row);
  }

  Future<void> retryItem(int id) async {
    await updateStatus(
      id,
      status: 'pending',
      retryCount: 0,
      clearNextRetryAt: true,
      errorMessage: '',
    );
  }

  Future<void> dismissDead(int id) async {
    await _isar.writeTxn(() => _db.syncOutboxEntrys.delete(id));
  }

  Future<void> retryAllFailed() async {
    final items = await actionableItems();
    for (final item in items) {
      await retryItem(item.id);
    }
  }

  Future<void> purgeDone({Duration olderThan = const Duration(days: 7)}) async {
    final cutoff = DateTime.now().subtract(olderThan);
    await _isar.writeTxn(() async {
      final rows = await _db.syncOutboxEntrys
          .filter()
          .statusEqualTo(SyncStatus.done)
          .createdAtLessThan(cutoff)
          .findAll();
      for (final row in rows) {
        await _db.syncOutboxEntrys.delete(row.id);
      }
    });
  }

  Future<void> cancelPendingByLocalId(int localId) async {
    await _isar.writeTxn(() async {
      final rows = await _db.syncOutboxEntrys
          .filter()
          .localEntityIdEqualTo(localId)
          .group(
            (q) => q.statusEqualTo(SyncStatus.pending).or().statusEqualTo(SyncStatus.failed),
          )
          .findAll();
      for (final row in rows) {
        await _db.syncOutboxEntrys.delete(row.id);
      }
    });
  }

  SyncQueueItem _toQueueItem(SyncOutboxEntry entry) {
    return SyncQueueItem(
      id: entry.id,
      entityType: entry.entityType.name,
      operation: entry.operation.name,
      localId: entry.localEntityId,
      serverId: entry.serverEntityId,
      payload: jsonDecode(entry.payloadJson) as Map<String, dynamic>,
      status: entry.status.name,
      retryCount: entry.retryCount,
      errorMessage: entry.errorMessage,
      createdAt: entry.createdAt.toIso8601String(),
      clientRequestId: entry.clientRequestId,
      nextRetryAt: entry.nextRetryAt,
    );
  }
}
