import 'dart:io';

import '../models/watchlist_item.dart';
import '../support/search_match.dart';
import '../offline/local_database.dart';
import '../offline/sync_queue_item.dart';
import '../utils/client_request_id.dart';
import 'watchlist_repository.dart';

class OfflineWatchlistRepository {
  OfflineWatchlistRepository({
    required WatchlistRepository remote,
    required LocalDatabase db,
    required bool Function() isOnline,
  })  : _remote = remote,
        _db = db,
        _isOnline = isOnline;

  final WatchlistRepository _remote;
  final LocalDatabase _db;
  final bool Function() _isOnline;

  Future<List<WatchlistItemModel>> listLocalAndRemote({
    required int salesPersonId,
    String status = 'active',
    String sort = 'created_at',
    String? search,
  }) async => (await searchLocalAndRemote(salesPersonId: salesPersonId, status: status, sort: sort, search: search)).items;

  /// Like [listLocalAndRemote] but also reports whether the result is a
  /// "most likely" (fuzzy) match. Offline, the cached items are filtered with
  /// the same matcher the server uses; [status] 'all' returns both statuses.
  Future<({List<WatchlistItemModel> items, bool isFuzzy})> searchLocalAndRemote({
    required int salesPersonId,
    String status = 'active',
    String sort = 'created_at',
    String? search,
  }) async {
    final local = await _localItems(salesPersonId, status, search);
    if (!_isOnline()) return local;

    try {
      final remote = await _remote.list(salesPersonId: salesPersonId, status: status, sort: sort, search: search);
      for (final item in remote.items) {
        await _db.cacheEntity(
          entityType: 'watchlist',
          entityId: item.id,
          data: _toCache(item),
        );
      }
      final pending = local.items.where((e) => e.isLocalOnly).toList();
      return (items: [...pending, ...remote.items], isFuzzy: remote.isFuzzy);
    } catch (_) {
      return local;
    }
  }

  Future<({List<WatchlistItemModel> items, bool isFuzzy})> _localItems(
    int salesPersonId,
    String status,
    String? search,
  ) async {
    final cached = await _db.getCachedEntities('watchlist');
    final items = cached
        .where((e) =>
            e['sales_person_id'] == salesPersonId &&
            (status == 'all' || (e['status'] as String? ?? 'active') == status))
        .map((e) {
          final item = WatchlistItemModel.fromJson(e);
          // Cache rows don't round-trip isLocalOnly; the negative id is the
          // reliable local-only marker.
          return item.id < 0 ? item.copyWith(isLocalOnly: true) : item;
        })
        .toList();
    if (search == null || search.trim().isEmpty) return (items: items, isFuzzy: false);
    // Active first so the screen can section, same as the server.
    items.sort((a, b) => (a.isActive ? 0 : 1).compareTo(b.isActive ? 0 : 1));
    return SearchMatch.filterOrFuzzy(items, search, (i) => [i.placeName, i.noteText, i.gps, i.phone]);
  }

  Future<WatchlistItemModel> create({
    required String gps,
    required int salesPersonId,
    String? placeName,
    String? noteText,
    String? phone,
  }) async {
    // Generated once and sent on both paths so server-side dedupe catches
    // replays (mirrors OfflineOrderRepository).
    final clientRequestId = generateClientRequestId();

    if (_isOnline()) {
      final item = await _remote.create(
        gps: gps,
        salesPersonId: salesPersonId,
        placeName: placeName,
        noteText: noteText,
        phone: phone,
        clientRequestId: clientRequestId,
      );
      await _db.cacheEntity(entityType: 'watchlist', entityId: item.id, data: _toCache(item));
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
      phone: phone,
      isLocalOnly: true,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _db.cacheEntity(entityType: 'watchlist', entityId: localId, data: _toCache(item, pending: true));
    await _db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'watchlist',
      operation: 'create',
      localId: localId,
      payload: {
        ...item.toCreateJson(),
        'client_request_id': clientRequestId,
      },
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    ));
    return item;
  }

  Future<WatchlistItemModel> update(int id, Map<String, dynamic> body) async {
    if (id < 0) {
      // Local-only row: merge into the cache AND replace the queued create —
      // otherwise the stale original payload is what syncs (the house
      // cancel-and-requeue pattern, see OfflineVisitRepository.update).
      final cached = await _db.getCachedEntity('watchlist', id);
      if (cached == null) throw Exception('Watch-list item not found offline');
      cached.addAll(body);
      await _db.cacheEntity(entityType: 'watchlist', entityId: id, data: cached);
      final merged = WatchlistItemModel.fromJson(cached);

      // Reuse the original client_request_id: if the old create slipped into
      // 'syncing' before the cancel, the server dedupes the re-enqueued one
      // instead of creating a duplicate prospect.
      final pending = await _db.pendingQueueByLocalId(id);
      final priorCreates =
          pending.where((q) => q.entityType == 'watchlist' && q.operation == 'create');
      final clientRequestId = (priorCreates.isEmpty
              ? null
              : priorCreates.first.payload['client_request_id'] as String?) ??
          generateClientRequestId();
      await _db.cancelPendingByLocalId(id);
      await _db.enqueue(SyncQueueItem(
        id: 0,
        entityType: 'watchlist',
        operation: 'create',
        localId: id,
        payload: {
          ...merged.toCreateJson(),
          // The server's sync create currently forces status active; carried
          // anyway so the intent isn't lost if that ever changes.
          if (!merged.isActive) 'status': merged.status,
          if (merged.archivedReason != null) 'archived_reason': merged.archivedReason,
          'client_request_id': clientRequestId,
        },
        status: 'pending',
        retryCount: 0,
        createdAt: DateTime.now().toIso8601String(),
      ));
      return merged;
    }

    if (_isOnline()) {
      final item = await _remote.update(id, body);
      await _db.cacheEntity(entityType: 'watchlist', entityId: item.id, data: _toCache(item));
      return item;
    }

    // Offline edit to a synced row: queue an update op (both the bulk sync
    // endpoint and the per-item fallback support watchlist 'update') and
    // persist the merge so the change survives a reload.
    await _db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'watchlist',
      operation: 'update',
      serverId: id,
      payload: body,
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    ));
    final cached = await _db.getCachedEntity('watchlist', id);
    if (cached != null) {
      cached.addAll(body);
      await _db.cacheEntity(entityType: 'watchlist', entityId: id, data: cached);
      return WatchlistItemModel.fromJson(cached);
    }
    throw Exception('Watch-list item not found offline');
  }

  Future<void> delete(int id) async {
    if (id < 0) {
      // Unsynced row: cancel the queued create (or the deleted prospect
      // resurrects on the server) and drop its queued media blobs too.
      await _db.cancelPendingByLocalId(id);
      await _dropQueuedMediaFor(id);
      await _db.removeCachedEntity('watchlist', id);
      return;
    }
    if (_isOnline()) {
      await _remote.delete(id);
      await _db.removeCachedEntity('watchlist', id);
      return;
    }
    await _db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'watchlist',
      operation: 'delete',
      serverId: id,
      payload: const {},
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    ));
    // Optimistic: hide it locally now; the queued op deletes it server-side.
    await _db.removeCachedEntity('watchlist', id);
  }

  /// Not-yet-uploaded media queued against a local-only watchlist row.
  /// LocalDatabase has no fetch-blobs-by-parent helper, so the pending set is
  /// filtered here; the blob row is removed and its staged file best-effort
  /// deleted (mirrors wipeUserData).
  Future<void> _dropQueuedMediaFor(int localId) async {
    final blobs = await _db.pendingMediaBlobs();
    for (final blob in blobs) {
      if (blob.parentEntityType != 'watchlist' ||
          blob.parentLocalId != localId ||
          blob.parentServerId != null) {
        continue;
      }
      try {
        await File(blob.localPath).delete();
      } catch (_) {
        // Best-effort — a missing file must not block the delete.
      }
      await _db.deleteMediaBlob(blob.id);
    }
  }

  Map<String, dynamic> _toCache(WatchlistItemModel item, {bool pending = false}) => {
        'id': item.id,
        'sales_person_id': item.salesPersonId,
        'gps': item.gps,
        'place_name': item.placeName,
        'note_text': item.noteText,
        'phone': item.phone,
        'status': item.status,
        'archived_reason': item.archivedReason,
        'customer_shop_id': item.customerShopId,
        'created_at': item.createdAt,
        if (pending) '_pending_sync': true,
      };
}
