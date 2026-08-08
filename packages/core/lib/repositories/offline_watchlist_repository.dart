import '../models/watchlist_item.dart';
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
  }) async {
    final local = await _localItems(salesPersonId, status);
    if (!_isOnline()) return local;

    try {
      final remote = await _remote.list(salesPersonId: salesPersonId, status: status, sort: sort);
      for (final item in remote.items) {
        await _db.cacheEntity(
          entityType: 'watchlist',
          entityId: item.id,
          data: _toCache(item),
        );
      }
      final pending = local.where((e) => e.isLocalOnly).toList();
      return [...pending, ...remote.items];
    } catch (_) {
      return local;
    }
  }

  Future<List<WatchlistItemModel>> _localItems(int salesPersonId, String status) async {
    final cached = await _db.getCachedEntities('watchlist');
    return cached
        .where((e) => e['sales_person_id'] == salesPersonId && (e['status'] as String? ?? 'active') == status)
        .map((e) => WatchlistItemModel.fromJson(e))
        .toList();
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
      payload: {},
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
        'status': item.status,
        'archived_reason': item.archivedReason,
        'customer_shop_id': item.customerShopId,
        'created_at': item.createdAt,
        if (pending) '_pending_sync': true,
      };
}
