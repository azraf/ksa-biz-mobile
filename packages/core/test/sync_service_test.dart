import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:core/api/api_client.dart';
import 'package:core/models/order.dart';
import 'package:core/offline/local_database.dart';
import 'package:core/offline/sync_queue_item.dart';
import 'package:core/offline/sync_service.dart';
import 'package:core/repositories/expense_repository.dart';
import 'package:core/repositories/order_repository.dart';
import 'package:core/repositories/sync_repository.dart';

class _FakeSyncRepository extends SyncRepository {
  _FakeSyncRepository(this._handler) : super(ApiClient());

  final Future<List<Map<String, dynamic>>> Function(List<Map<String, dynamic>> operations)
      _handler;
  int pushCalls = 0;

  @override
  Future<List<Map<String, dynamic>>> push(List<Map<String, dynamic>> operations) {
    pushCalls++;
    return _handler(operations);
  }
}

/// Records create() payloads instead of hitting the network.
class _RecordingOrderRepository extends OrderRepository {
  _RecordingOrderRepository() : super(ApiClient());

  final createdPayloads = <Map<String, dynamic>>[];

  @override
  Future<OrderModel> create(Map<String, dynamic> body) async {
    createdPayloads.add(body);
    return OrderModel.fromJson({
      'id': 7000 + createdPayloads.length,
      'customer_type_id': 1,
      'total_bill': 10.0,
      'items': <dynamic>[],
    });
  }

  @override
  Future<OrderModel> get(int id) async => OrderModel.fromJson({
        'id': id,
        'customer_type_id': 1,
        'items': <dynamic>[],
      });
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  final db = LocalDatabase.instance;

  /// These tests drive syncIfOnline over the whole queue, so leftovers from
  /// other files (the DB file is shared) must not leak in.
  Future<void> clearQueue() async {
    final database = await db.database;
    await database.delete('sync_queue');
  }

  SyncService buildService({
    required _FakeSyncRepository syncRepository,
    _RecordingOrderRepository? orderRepository,
    int bulkBatchSize = 20,
  }) =>
      SyncService(
        db: db,
        connectivity: ConnectivityService(), // defaults to online; init() never called
        orderRepository: orderRepository ?? _RecordingOrderRepository(),
        expenseRepository: ExpenseRepository(ApiClient()),
        syncRepository: syncRepository,
        bulkBatchSize: bulkBatchSize,
      );

  Future<int> enqueue({
    required String entityType,
    required int localId,
    Map<String, dynamic> payload = const {},
  }) =>
      db.enqueue(SyncQueueItem(
        id: 0,
        entityType: entityType,
        operation: 'create',
        localId: localId,
        payload: payload,
        status: 'pending',
        retryCount: 0,
        createdAt: DateTime.now().toIso8601String(),
      ));

  test('partial bulk failure does not re-send rows already done', () async {
    await clearQueue();
    final idA = await enqueue(
      entityType: 'order',
      localId: -101,
      payload: {'client_request_id': 'bulk-a', 'customer_type_id': 1, 'items': <dynamic>[]},
    );
    final idB = await enqueue(
      entityType: 'order',
      localId: -102,
      payload: {'client_request_id': 'bulk-b', 'customer_type_id': 1, 'items': <dynamic>[]},
    );

    // Batch size 1: batch A succeeds, batch B dies on a transport error.
    final syncRepo = _FakeSyncRepository((ops) async {
      if (ops.single['client_request_id'] == 'bulk-a') {
        return [
          {'status': 'done', 'data': {'server_id': 9101}},
        ];
      }
      throw const SocketException('network dropped mid-sync');
    });
    final orders = _RecordingOrderRepository();
    final service = buildService(
      syncRepository: syncRepo,
      orderRepository: orders,
      bulkBatchSize: 1,
    );

    await service.syncIfOnline();

    // The per-item fallback must only have re-sent B — A was already done.
    expect(
      orders.createdPayloads.map((p) => p['client_request_id']).toList(),
      ['bulk-b'],
    );

    final rows = await db.allQueueItems();
    expect(rows.firstWhere((q) => q.id == idA).status, 'done');
    expect(rows.firstWhere((q) => q.id == idA).serverId, 9101);
    expect(rows.firstWhere((q) => q.id == idB).status, 'done');

    await db.deleteQueueItem(idA);
    await db.deleteQueueItem(idB);
    await db.removeCachedEntity('order', 9101);
    await db.removeCachedEntity('order', 7001);
    service.dispose();
  });

  test('done rows cannot be re-claimed even from a stale queue snapshot', () async {
    await clearQueue();
    final id = await enqueue(entityType: 'order', localId: -103);
    await db.updateQueueStatus(id, status: 'syncing');
    await db.updateQueueStatus(id, status: 'done', serverId: 9102);

    // A stale snapshot (taken before the row finished) tries to claim it.
    final claimed = await db.updateQueueStatus(id, status: 'syncing');
    expect(claimed, 0);
    expect((await db.allQueueItems()).firstWhere((q) => q.id == id).status, 'done');

    await db.deleteQueueItem(id);
  });

  test('transport-failed bulk push leaves rows pending, never stuck syncing', () async {
    await clearQueue();
    // watchlist with no watchlistRepository: the per-item fallback no-ops and
    // releases its claim, isolating what the bulk failure path left behind.
    final idA = await enqueue(entityType: 'watchlist', localId: -111);
    final idB = await enqueue(entityType: 'watchlist', localId: -112);

    final syncRepo = _FakeSyncRepository(
      (ops) async => throw http.ClientException('Connection closed'),
    );
    final service = buildService(syncRepository: syncRepo);

    // Must not throw despite the raw transport error.
    await service.syncIfOnline();

    final rows = await db.allQueueItems();
    expect(rows.firstWhere((q) => q.id == idA).status, 'pending');
    expect(rows.firstWhere((q) => q.id == idB).status, 'pending');
    expect(await db.pendingCount(), 2);
    expect(await service.isFullySynced(), isFalse);

    await db.deleteQueueItem(idA);
    await db.deleteQueueItem(idB);
    service.dispose();
  });

  test('bulk visit create clears the pending-sync cached ghost', () async {
    await clearQueue();
    await db.cacheEntity(
      entityType: 'visit',
      entityId: -201,
      data: {'id': -201, '_pending_sync': true},
    );
    final id = await enqueue(
      entityType: 'visit',
      localId: -201,
      payload: {'client_request_id': 'visit-a'},
    );

    final syncRepo = _FakeSyncRepository((ops) async => [
          {'status': 'done', 'data': {'server_id': 9301}},
        ]);
    final service = buildService(syncRepository: syncRepo);

    await service.syncIfOnline();

    expect(await db.getCachedEntity('visit', -201), isNull,
        reason: 'the local ghost must be removed once the visit exists server-side');
    final row = (await db.allQueueItems()).firstWhere((q) => q.id == id);
    expect(row.status, 'done');
    expect(row.serverId, 9301);

    await db.deleteQueueItem(id);
    service.dispose();
  });
}
