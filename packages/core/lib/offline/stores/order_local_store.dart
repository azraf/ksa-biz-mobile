import 'package:isar_community/isar.dart';

import '../../models/order.dart';
import '../isar/local_order.dart';
import '../isar/sync_outbox_entry.dart';
import '../isar/mappers/entity_mappers.dart';
import '../isar_service.dart';

class OrderLocalStore {
  OrderLocalStore(this._isar);

  final IsarService _isar;

  Isar get _db => _isar.isar;

  Future<void> upsert(OrderModel order, {bool pendingSync = false}) async {
    final local = OrderMapper.fromModel(order, pendingSync: pendingSync || order.id < 0);
    await _isar.writeTxn(() async {
      final existing = await _db.localOrders.filter().serverIdEqualTo(order.id).findFirst();
      if (existing != null) local.isarId = existing.isarId;
      await _db.localOrders.put(local);
    });
  }

  Future<void> upsertAll(Iterable<OrderModel> orders) async {
    await _isar.writeTxn(() async {
      for (final order in orders) {
        final local = OrderMapper.fromModel(order, pendingSync: order.id < 0);
        final existing = await _db.localOrders.filter().serverIdEqualTo(order.id).findFirst();
        if (existing != null) local.isarId = existing.isarId;
        await _db.localOrders.put(local);
      }
    });
  }

  Future<OrderModel?> getByServerId(int serverId) async {
    final local = await _db.localOrders.filter().serverIdEqualTo(serverId).findFirst();
    return local == null ? null : OrderMapper.toModel(local);
  }

  Future<List<OrderModel>> list({
    int offset = 0,
    int limit = 100,
    bool pendingOnly = false,
  }) async {
    final q = _db.localOrders.where();
    List<LocalOrder> rows;
    if (pendingOnly) {
      rows = await q
          .filter()
          .pendingSyncEqualTo(true)
          .sortByUpdatedAtDesc()
          .offset(offset)
          .limit(limit)
          .findAll();
    } else {
      rows = await q.sortByUpdatedAtDesc().offset(offset).limit(limit).findAll();
    }
    return rows.map(OrderMapper.toModel).toList();
  }

  Future<List<OrderModel>> pendingOrders() async {
    final rows = await _db.localOrders
        .filter()
        .pendingSyncEqualTo(true)
        .sortByUpdatedAtDesc()
        .findAll();
    return rows.map(OrderMapper.toModel).toList();
  }

  Future<int> count() => _db.localOrders.count();

  Future<void> remove(int serverId) async {
    await _isar.writeTxn(() async {
      await _db.localOrders.filter().serverIdEqualTo(serverId).deleteAll();
    });
  }

  Future<void> replaceLocalId(int localId, OrderModel serverOrder) async {
    await _isar.writeTxn(() async {
      await _db.localOrders.filter().serverIdEqualTo(localId).deleteAll();
      final local = OrderMapper.fromModel(serverOrder);
      await _db.localOrders.put(local);
    });
  }

  Future<int> nextLocalId() async {
    final rows = await _db.syncOutboxEntrys
        .filter()
        .localEntityIdIsNotNull()
        .localEntityIdLessThan(0)
        .findAll();
    var minId = 0;
    for (final row in rows) {
      final id = row.localEntityId!;
      if (id < minId) minId = id;
    }
    final orders = await _db.localOrders.filter().serverIdLessThan(0).findAll();
    for (final order in orders) {
      if (order.serverId < minId) minId = order.serverId;
    }
    return minId - 1;
  }

  Stream<void> watchChanges() => _db.localOrders.watchLazy(fireImmediately: true);
}
