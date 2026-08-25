import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:core/api/api_client.dart';
import 'package:core/offline/local_database.dart';
import 'package:core/offline/sync_queue_item.dart';
import 'package:core/repositories/offline_order_repository.dart';
import 'package:core/repositories/order_repository.dart';

/// Remote that must never be reached — these tests run the offline path.
class _OfflineOrderRemote extends OrderRepository {
  _OfflineOrderRemote() : super(ApiClient());
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  OfflineOrderRepository repo() => OfflineOrderRepository(
        remote: _OfflineOrderRemote(),
        db: LocalDatabase.instance,
        isOnline: () => false,
      );

  test('cached list skips a poisoned row instead of erroring the whole list', () async {
    await LocalDatabase.instance.cacheEntity(
      entityType: 'order',
      entityId: 11,
      data: {
        'id': 11,
        'customer_type_id': 1,
        'total_bill': 100.0,
        'items': [
          // Written offline: no item id — must still parse.
          {'product_id': 5, 'quantity': 2, 'unit_id': 3, 'product_price': 50.0, 'bill': 100.0},
        ],
      },
    );
    // Row written by an older build with a shape the current parser rejects.
    await LocalDatabase.instance.cacheEntity(
      entityType: 'order',
      entityId: 12,
      data: {'id': 12},
    );

    final result = await repo().list();
    expect(result.items.map((o) => o.id), contains(11));
    expect(result.items.map((o) => o.id), isNot(contains(12)));

    final good = result.items.firstWhere((o) => o.id == 11);
    expect(good.items.single.id, 0);
    expect(good.items.single.unitId, 3);
    expect(good.items.single.bill, 100.0);
  });

  test('single-order cache fallback degrades to "not available" on a poisoned row', () async {
    await LocalDatabase.instance.cacheEntity(
      entityType: 'order',
      entityId: 13,
      data: {'id': 13},
    );

    await expectLater(
      () => repo().get(13),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        contains('not available offline'),
      )),
    );
  });

  test('offline recordPayment queues a stable client_request_id', () async {
    await LocalDatabase.instance.cacheEntity(
      entityType: 'order',
      entityId: 42,
      data: {
        'id': 42,
        'customer_type_id': 1,
        'total_bill': 100.0,
        'amount_paid': 0.0,
      },
    );

    // Delta-based: the queue DB file is shared and may hold rows from other
    // runs — only the row this call enqueues is under test.
    final before = (await LocalDatabase.instance.pendingQueue()).map((q) => q.id).toSet();
    await repo().recordPayment(42, amount: 60, paymentMethod: 'cash');
    final payment = (await LocalDatabase.instance.pendingQueue()).singleWhere(
      (q) => !before.contains(q.id),
    );

    expect(payment.entityType, 'order');
    expect(payment.operation, 'payment');
    expect(payment.serverId, 42);
    final id = payment.payload['client_request_id'] as String?;
    expect(id, isNotNull);
    expect(id!.length, lessThanOrEqualTo(36)); // server cap
    expect(payment.payload['amount'], 60);
    expect(payment.payload['payment_method'], 'cash');

    await LocalDatabase.instance.deleteQueueItem(payment.id);
  });

  test('cancelling an unsynced offline order removes the cached row entirely', () async {
    final db = LocalDatabase.instance;
    await db.cacheEntity(
      entityType: 'order',
      entityId: -50,
      data: {
        'id': -50,
        'customer_type_id': 1,
        'total_bill': 40.0,
        'status': 'confirmed',
        '_pending_sync': true,
        'items': <dynamic>[],
      },
    );
    await db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'order',
      operation: 'create',
      localId: -50,
      payload: const {'client_request_id': 'cancel-ghost-test'},
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    ));

    final cancelled = await repo().cancel(-50, 'ordered by mistake');
    expect(cancelled.status, 'cancelled');

    // No phantom cancelled '_pending_sync' row may linger in the cache, and
    // the queued create must be gone too.
    expect(await db.getCachedEntity('order', -50), isNull);
    expect(await db.pendingQueueByLocalId(-50), isEmpty);
  });

  test('offline cached list honors the active-salesperson filter', () async {
    final db = LocalDatabase.instance;
    await db.cacheEntity(
      entityType: 'order',
      entityId: 21,
      data: {'id': 21, 'customer_type_id': 1, 'sales_person_id': 5, 'items': <dynamic>[]},
    );
    await db.cacheEntity(
      entityType: 'order',
      entityId: 22,
      data: {'id': 22, 'customer_type_id': 1, 'sales_person_id': 6, 'items': <dynamic>[]},
    );

    final filtered = await repo().list(salesPersonId: 5);
    expect(filtered.items.map((o) => o.id), contains(21));
    expect(filtered.items.map((o) => o.id), isNot(contains(22)));

    final multi = await repo().list(salesPersonIds: {6});
    expect(multi.items.map((o) => o.id), contains(22));
    expect(multi.items.map((o) => o.id), isNot(contains(21)));

    final unfiltered = await repo().list();
    expect(unfiltered.items.map((o) => o.id), containsAll([21, 22]));

    await db.removeCachedEntity('order', 21);
    await db.removeCachedEntity('order', 22);
  });

  tearDownAll(() async {
    for (final id in [11, 12, 13, 42]) {
      await LocalDatabase.instance.removeCachedEntity('order', id);
    }
  });
}
