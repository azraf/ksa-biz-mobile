import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:core/api/api_client.dart';
import 'package:core/offline/local_database.dart';
import 'package:core/repositories/customer_diary_repository.dart';
import 'package:core/repositories/offline_diary_repository.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('offline diary create persists a client_request_id in the queued payload', () async {
    final db = LocalDatabase.instance;
    final repo = OfflineDiaryRepository(
      remote: CustomerDiaryRepository(ApiClient()), // never reached offline
      db: db,
      isOnline: () => false,
    );

    // Delta-based: the queue DB file is shared with other test files.
    final before = (await db.pendingQueue()).map((q) => q.id).toSet();
    final note = await repo.createNote(
      customerType: 'customer_shop',
      customerId: 12,
      noteType: 'text',
      body: 'Offline note',
    );
    expect(note.id, isNegative);

    final queued = (await db.pendingQueue()).singleWhere((q) => !before.contains(q.id));
    expect(queued.entityType, 'diary');
    expect(queued.operation, 'create');
    expect(queued.payload['customer_id'], 12);

    // Persisted at enqueue time so every retry replays the SAME id and the
    // server can dedupe, instead of a fresh one being minted per attempt.
    final id = queued.payload['client_request_id'] as String?;
    expect(id, isNotNull);
    expect(id, isNotEmpty);
    expect(id!.length, lessThanOrEqualTo(36)); // server validates max:36

    await db.deleteQueueItem(queued.id);
    await db.removeCachedEntity('diary_customer_shop_12', note.id);
  });
}
