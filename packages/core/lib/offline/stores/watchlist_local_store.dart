import 'package:isar_community/isar.dart';

import '../../models/watchlist_item.dart';
import '../isar/local_watchlist.dart';
import '../isar/mappers/entity_mappers.dart';
import '../isar_service.dart';

class WatchlistLocalStore {
  WatchlistLocalStore(this._isar);

  final IsarService _isar;

  Isar get _db => _isar.isar;

  Future<void> upsert(WatchlistItemModel item, {bool pendingSync = false}) async {
    final local = WatchlistMapper.fromModel(item, pendingSync: pendingSync || item.isLocalOnly);
    await _isar.writeTxn(() async {
      final existing = await _db.localWatchlistItems.filter().serverIdEqualTo(item.id).findFirst();
      if (existing != null) local.isarId = existing.isarId;
      await _db.localWatchlistItems.put(local);
    });
  }

  Future<List<WatchlistItemModel>> list({
    required int salesPersonId,
    String status = 'active',
  }) async {
    final rows = await _db.localWatchlistItems
        .filter()
        .salesPersonIdEqualTo(salesPersonId)
        .statusEqualTo(status)
        .sortByUpdatedAtDesc()
        .findAll();
    return rows.map(WatchlistMapper.toModel).toList();
  }

  Future<WatchlistItemModel?> get(int serverId) async {
    final row = await _db.localWatchlistItems.filter().serverIdEqualTo(serverId).findFirst();
    return row == null ? null : WatchlistMapper.toModel(row);
  }

  Future<void> remove(int serverId) async {
    await _isar.writeTxn(() async {
      await _db.localWatchlistItems.filter().serverIdEqualTo(serverId).deleteAll();
    });
  }

  Future<void> replaceLocalId(int localId, WatchlistItemModel serverItem) async {
    await _isar.writeTxn(() async {
      await _db.localWatchlistItems.filter().serverIdEqualTo(localId).deleteAll();
      await _db.localWatchlistItems.put(WatchlistMapper.fromModel(serverItem));
    });
  }
}
