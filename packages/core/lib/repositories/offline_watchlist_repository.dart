import '../models/watchlist_item.dart';
import '../offline/offline_sync_trigger.dart';
import '../utils/client_request_id.dart';
import '../offline/stores/sync_outbox_store.dart';
import '../offline/stores/watchlist_local_store.dart';
import '../offline/sync_queue_item.dart';
import 'watchlist_repository.dart';

class OfflineWatchlistRepository {
  OfflineWatchlistRepository({
    required WatchlistRepository remote,
    required WatchlistLocalStore watchlist,
    required SyncOutboxStore outbox,
    required bool Function() isOnline,
  })  : _remote = remote,
        _watchlist = watchlist,
        _outbox = outbox,
        _isOnline = isOnline;

  final WatchlistRepository _remote;
  final WatchlistLocalStore _watchlist;
  final SyncOutboxStore _outbox;
  final bool Function() _isOnline;

  Future<List<WatchlistItemModel>> listLocalAndRemote({
    required int salesPersonId,
    String status = 'active',
  }) async {
    final local = await _watchlist.list(salesPersonId: salesPersonId, status: status);
    if (!_isOnline()) return local;

    try {
      final remote = await _remote.list(salesPersonId: salesPersonId, status: status);
      for (final item in remote.items) {
        await _watchlist.upsert(item);
      }
      final pending = local.where((e) => e.isLocalOnly).toList();
      return [...pending, ...remote.items];
    } catch (_) {
      return local;
    }
  }

  Future<WatchlistItemModel> create({
    required String gps,
    required int salesPersonId,
    String? placeName,
    String? noteText,
  }) async {
    if (_isOnline()) {
      final item = await _remote.create(
        gps: gps,
        salesPersonId: salesPersonId,
        placeName: placeName,
        noteText: noteText,
      );
      await _watchlist.upsert(item);
      return item;
    }

    final localId = -DateTime.now().millisecondsSinceEpoch;
    final item = WatchlistItemModel(
      id: localId,
      localId: localId,
      salesPersonId: salesPersonId,
      gps: gps,
      placeName: placeName,
      noteText: noteText,
      isLocalOnly: true,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _watchlist.upsert(item, pendingSync: true);
    final payload = withClientRequestId(item.toCreateJson());
    await _outbox.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'watchlist',
      operation: 'create',
      localId: localId,
      payload: payload,
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    ));
    OfflineSyncTrigger.requestSync();
    return item;
  }

  Future<WatchlistItemModel> update(int id, Map<String, dynamic> body) async {
    if (id < 0 && !_isOnline()) {
      final cached = await _watchlist.get(id);
      if (cached != null) {
        final updated = WatchlistItemModel.fromJson({..._toJson(cached), ...body});
        await _watchlist.upsert(updated, pendingSync: true);
        final pendingCreate = await _outbox.findPendingCreateForLocalId(id);
        if (pendingCreate != null) {
          final mergedPayload = {...pendingCreate.payload, ...body};
          await _outbox.updatePayloadForLocalId(id, mergedPayload);
        } else {
          await _outbox.enqueue(SyncQueueItem(
            id: 0,
            entityType: 'watchlist',
            operation: 'update',
            serverId: id,
            payload: body,
            status: 'pending',
            retryCount: 0,
            createdAt: DateTime.now().toIso8601String(),
          ));
        }
        OfflineSyncTrigger.requestSync();
        return updated;
      }
      throw Exception('Watch-list item not found offline');
    }
    if (id < 0 || !_isOnline()) {
      if (_isOnline()) return _remote.update(id, body);
      await _outbox.enqueue(SyncQueueItem(
        id: 0,
        entityType: 'watchlist',
        operation: 'update',
        serverId: id,
        payload: body,
        status: 'pending',
        retryCount: 0,
        createdAt: DateTime.now().toIso8601String(),
      ));
      OfflineSyncTrigger.requestSync();
      final cached = await _watchlist.get(id);
      if (cached != null) {
        return WatchlistItemModel.fromJson({..._toJson(cached), ...body});
      }
      throw Exception('Watch-list item not found offline');
    }
    final item = await _remote.update(id, body);
    await _watchlist.upsert(item);
    return item;
  }

  Future<WatchlistItemModel?> get(int id) async {
    final local = await _watchlist.get(id);
    if (local != null) return local;
    if (_isOnline()) {
      final item = await _remote.get(id);
      await _watchlist.upsert(item);
      return item;
    }
    return null;
  }

  Future<void> delete(int id) async {
    if (id < 0) {
      await _watchlist.remove(id);
      return;
    }
    if (_isOnline()) {
      await _remote.delete(id);
      await _watchlist.remove(id);
      return;
    }
    await _outbox.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'watchlist',
      operation: 'delete',
      serverId: id,
      payload: {},
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    ));
    OfflineSyncTrigger.requestSync();
  }

  Map<String, dynamic> _toJson(WatchlistItemModel item) => {
        'id': item.id,
        'sales_person_id': item.salesPersonId,
        'gps': item.gps,
        'place_name': item.placeName,
        'note_text': item.noteText,
        'status': item.status,
        'archived_reason': item.archivedReason,
        'customer_shop_id': item.customerShopId,
        'created_at': item.createdAt,
      };
}
