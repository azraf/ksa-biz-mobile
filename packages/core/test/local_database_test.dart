import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:core/offline/local_database.dart';
import 'package:core/offline/sync_queue_item.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('enqueue and pendingQueue round-trip', () async {
    final db = LocalDatabase.instance;
    final id = await db.enqueue(
      SyncQueueItem(
        id: 0,
        entityType: 'order',
        operation: 'create',
        localId: -1,
        payload: {'client_request_id': 'test-uuid'},
        status: 'pending',
        retryCount: 0,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    expect(id, greaterThan(0));
    final pending = await db.pendingQueue();
    expect(pending.any((e) => e.id == id), isTrue);
  });

  test('pendingQueue skips exhausted retries', () async {
    final db = LocalDatabase.instance;
    final database = await db.database;
    await database.insert('sync_queue', {
      'entity_type': 'order',
      'operation': 'create',
      'payload': '{}',
      'status': 'pending',
      'retry_count': LocalDatabase.maxRetries,
      'created_at': DateTime.now().toIso8601String(),
    });
    final pending = await db.pendingQueue();
    expect(pending.where((e) => e.retryCount >= LocalDatabase.maxRetries), isEmpty);
  });

  test('media extra_fields json decode', () async {
    final db = LocalDatabase.instance;
    final blobId = await db.insertMediaBlob(
      localPath: '/tmp/test.jpg',
      mimeType: 'image/jpeg',
      mediaKind: 'image',
      parentEntityType: 'watchlist',
      uploadEndpoint: '/watchlist-items/{parent_id}/attachments',
      extraFields: {'type': 'gallery'},
    );
    final blobs = await db.pendingMediaBlobs();
    final blob = blobs.firstWhere((b) => b.id == blobId);
    expect(blob.extraFields['type'], 'gallery');
  });
}
