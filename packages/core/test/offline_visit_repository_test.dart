import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:core/api/api_client.dart';
import 'package:core/models/visit_schedule.dart';
import 'package:core/offline/local_database.dart';
import 'package:core/repositories/offline_visit_repository.dart';
import 'package:core/repositories/visit_schedule_repository.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  OfflineVisitRepository offlineRepo() => OfflineVisitRepository(
        // Never reached: isOnline is false throughout.
        remote: VisitScheduleRepository(ApiClient()),
        db: LocalDatabase.instance,
        isOnline: () => false,
      );

  test('offline create returns a negative id and queues the payload', () async {
    final repo = offlineRepo();
    final created = await repo.create(const VisitScheduleModel(
      id: 0,
      salesPersonId: 4,
      customerType: 'customer_shop',
      customerShopId: 12,
      customerName: 'Corner Store',
      scheduledAt: '2026-08-12T09:00:00',
      purpose: 'due_collection',
      notes: 'Collect the balance',
    ));

    expect(created.id, lessThan(0));
    expect(created.isLocalOnly, isTrue);

    final queue = await LocalDatabase.instance.pendingQueue();
    final item = queue.lastWhere((e) => e.entityType == 'visit');
    expect(item.operation, 'create');
    expect(item.localId, created.id);
    expect(item.payload['purpose'], 'due_collection');
    expect(item.payload['customer_shop_id'], 12);
    expect(item.payload['client_request_id'], isNotNull);

    final listed = await repo.list(
      from: DateTime(2026, 8, 1),
      to: DateTime(2026, 8, 31),
    );
    expect(listed.any((v) => v.id == created.id), isTrue);
  });

  test('offline transition on a synced row enqueues the operation and patches the cache', () async {
    const synced = VisitScheduleModel(
      id: 501,
      salesPersonId: 4,
      customerType: 'customer_shop',
      customerShopId: 12,
      scheduledAt: '2026-08-13T09:00:00',
      purpose: 'regular_visit',
    );
    await LocalDatabase.instance.cacheEntity(
      entityType: 'visit',
      entityId: synced.id,
      data: synced.toCacheJson(),
    );

    final updated = await offlineRepo().transition(synced, 'complete', outcomeNote: 'Paid');
    expect(updated.status, 'done');

    final queue = await LocalDatabase.instance.pendingQueue();
    final item = queue.lastWhere((e) => e.entityType == 'visit' && e.operation == 'complete');
    expect(item.serverId, 501);
    expect(item.payload['outcome_note'], 'Paid');
  });
}
