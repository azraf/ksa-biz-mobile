import '../models/watchlist_item.dart';
import '../support/search_match.dart';
import '../offline/local_database.dart';
import '../offline/sync_queue_item.dart';
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
        .map((e) => WatchlistItemModel.fromJson(e))
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
    if (_isOnline()) {
      final item = await _remote.create(
        gps: gps,
        salesPersonId: salesPersonId,
        placeName: placeName,
        noteText: noteText,
        phone: phone,
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
      payload: item.toCreateJson(),
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    ));
    return item;
  }

  Future<WatchlistItemModel> update(int id, Map<String, dynamic> body) async {
    if (id < 0 || !_isOnline()) {
      if (id < 0) {
        final cached = await _db.getCachedEntity('watchlist', id);
        if (cached != null) {
          cached.addAll(body);
          await _db.cacheEntity(entityType: 'watchlist', entityId: id, data: cached);
          return WatchlistItemModel.fromJson(cached);
        }
      }
      if (_isOnline()) return _remote.update(id, body);
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
        return WatchlistItemModel.fromJson(cached);
      }
      throw Exception('Watch-list item not found offline');
    }
    final item = await _remote.update(id, body);
    await _db.cacheEntity(entityType: 'watchlist', entityId: item.id, data: _toCache(item));
    return item;
  }

  Future<void> delete(int id) async {
    if (id < 0) {
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
