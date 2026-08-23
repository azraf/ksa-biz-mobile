import 'dart:io';

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
        payload: const {'client_request_id': 'test-uuid'},
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

  test('lastUserId round-trips through app_config', () async {
    final db = LocalDatabase.instance;
    await db.setLastUserId(42);
    expect(await db.getLastUserId(), 42);
    await db.setLastUserId(7);
    expect(await db.getLastUserId(), 7);
  });

  test('updateQueueStatus returns 0 for a missing row', () async {
    final db = LocalDatabase.instance;
    final claimed = await db.updateQueueStatus(999999999, status: 'syncing');
    expect(claimed, 0);
  });

  test('updateQueueStatus returns 1 for a claimed row', () async {
    final db = LocalDatabase.instance;
    final id = await db.enqueue(
      SyncQueueItem(
        id: 0,
        entityType: 'order',
        operation: 'create',
        localId: -2,
        payload: const {},
        status: 'pending',
        retryCount: 0,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    final claimed = await db.updateQueueStatus(id, status: 'syncing');
    expect(claimed, 1);
  });

  // Runs last in this file: wipeUserData() clears every table unconditionally,
  // which would break the assumptions of earlier tests if it ran before them.
  test('wipeUserData clears every table and deletes media files', () async {
    final db = LocalDatabase.instance;

    await db.cacheEntity(entityType: 'wipe_test', entityId: 1, data: {'id': 1});
    await db.enqueue(
      SyncQueueItem(
        id: 0,
        entityType: 'order',
        operation: 'create',
        localId: -3,
        payload: const {},
        status: 'pending',
        retryCount: 0,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    await db.cacheReport(cacheKey: 'wipe_test_report', reportType: 'sales', data: {'total': 1});
    await db.setLastSyncAt(DateTime.now());

    final tempFile = File('${Directory.systemTemp.path}/wipe_test_${DateTime.now().microsecondsSinceEpoch}.jpg')
      ..writeAsBytesSync([0]);
    await db.insertMediaBlob(
      localPath: tempFile.path,
      mimeType: 'image/jpeg',
      mediaKind: 'image',
      parentEntityType: 'watchlist',
      uploadEndpoint: '/watchlist-items/{parent_id}/attachments',
    );
    expect(tempFile.existsSync(), isTrue);

    await db.wipeUserData();

    expect(await db.getCachedEntities('wipe_test'), isEmpty);
    expect(await db.pendingCount(), 0);
    expect(await db.getCachedReport('wipe_test_report'), isNull);
    expect(await db.pendingMediaCount(), 0);
    expect(await db.getLastSyncAt(), isNull);
    expect(tempFile.existsSync(), isFalse);
  });

  test('repairOrphanedMediaParents recovers blobs from their done queue row', () async {
    final db = LocalDatabase.instance;
    final database = await db.database;
    final now = DateTime.now().toIso8601String();

    // A diary note that synced before the bulk path remapped media parents.
    await database.insert('sync_queue', {
      'entity_type': 'diary',
      'operation': 'create',
      'local_id': -999,
      'server_id': 4242,
      'payload': '{}',
      'status': 'done',
      'created_at': now,
    });

    Future<int> blob(int parentLocalId) => database.insert('media_blobs', {
      'local_path': '/tmp/voice-$parentLocalId.m4a',
      'mime_type': 'audio/mp4',
      'media_kind': 'recording_audio',
      'parent_entity_type': 'diary',
      'parent_local_id': parentLocalId,
      'upload_endpoint': '/customer-diary-notes/{parent_id}/recording',
      'upload_field': 'file',
      'status': 'pending',
      'created_at': now,
    });

    final recoverable = await blob(-999);
    final orphan = await blob(-888); // no queue row: must be left alone

    expect(await db.repairOrphanedMediaParents(), 1);

    Future<Object?> parentOf(int id) async => (await database.query(
      'media_blobs',
      columns: ['parent_server_id'],
      where: 'id = ?',
      whereArgs: [id],
    )).first['parent_server_id'];

    expect(await parentOf(recoverable), 4242);
    expect(await parentOf(orphan), isNull);
  });
}
