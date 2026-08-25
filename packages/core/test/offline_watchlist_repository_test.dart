import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:core/api/api_client.dart';
import 'package:core/offline/local_database.dart';
import 'package:core/repositories/offline_watchlist_repository.dart';
import 'package:core/repositories/watchlist_repository.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  OfflineWatchlistRepository offlineRepo() => OfflineWatchlistRepository(
        // Never reached: isOnline is false throughout.
        remote: WatchlistRepository(ApiClient()),
        db: LocalDatabase.instance,
        isOnline: () => false,
      );

  test('offline create queues a payload carrying a client_request_id', () async {
    final repo = offlineRepo();
    final created = await repo.create(
      gps: '24.7136,46.6753',
      salesPersonId: 990001,
      placeName: 'zzz-wl-create-marker',
    );

    expect(created.id, lessThan(0));
    expect(created.isLocalOnly, isTrue);

    final queue = await LocalDatabase.instance.pendingQueueByLocalId(created.id);
    final creates =
        queue.where((q) => q.entityType == 'watchlist' && q.operation == 'create').toList();
    expect(creates, hasLength(1));
    expect(creates.first.payload['place_name'], 'zzz-wl-create-marker');
    expect(creates.first.payload['client_request_id'], isNotNull);
  });

  test('offline edit to a local-only item replaces the queued create with the merged payload',
      () async {
    final repo = offlineRepo();
    final created = await repo.create(
      gps: '24.0000,46.0000',
      salesPersonId: 990002,
      placeName: 'zzz-wl-edit-original',
      noteText: 'original note',
    );
    final originalQueue =
        await LocalDatabase.instance.pendingQueueByLocalId(created.id);
    final originalRequestId = originalQueue
        .firstWhere((q) => q.entityType == 'watchlist' && q.operation == 'create')
        .payload['client_request_id'];

    final merged = await repo.update(created.id, {
      'place_name': 'zzz-wl-edit-renamed',
      'phone': '0555000111',
    });

    expect(merged.placeName, 'zzz-wl-edit-renamed');
    expect(merged.phone, '0555000111');
    expect(merged.noteText, 'original note', reason: 'untouched fields survive the merge');

    // Exactly one queued create remains, and it carries the edited fields —
    // not the stale original payload.
    final queue = await LocalDatabase.instance.pendingQueueByLocalId(created.id);
    final creates =
        queue.where((q) => q.entityType == 'watchlist' && q.operation == 'create').toList();
    expect(creates, hasLength(1));
    expect(creates.first.payload['place_name'], 'zzz-wl-edit-renamed');
    expect(creates.first.payload['phone'], '0555000111');
    expect(creates.first.payload['note_text'], 'original note');
    expect(creates.first.payload['client_request_id'], originalRequestId,
        reason: 'reusing the id lets the server dedupe a mid-sync race');

    final cached =
        await LocalDatabase.instance.getCachedEntity('watchlist', created.id);
    expect(cached?['place_name'], 'zzz-wl-edit-renamed');
  });

  test('deleting an unsynced item cancels its queued create and queued media', () async {
    final repo = offlineRepo();
    final created = await repo.create(
      gps: '25.0000,47.0000',
      salesPersonId: 990003,
      placeName: 'zzz-wl-delete-marker',
    );
    await LocalDatabase.instance.insertMediaBlob(
      localPath: '/nonexistent/zzz-wl-delete-blob.jpg',
      mimeType: 'image/jpeg',
      mediaKind: 'image',
      parentEntityType: 'watchlist',
      parentLocalId: created.id,
      uploadEndpoint: '/watchlist-items/{parent_id}/attachments',
    );

    await repo.delete(created.id);

    final queue = await LocalDatabase.instance.pendingQueueByLocalId(created.id);
    expect(queue.where((q) => q.entityType == 'watchlist'), isEmpty,
        reason: 'a surviving queued create would resurrect the deleted prospect');

    final blobs = await LocalDatabase.instance.pendingMediaBlobs();
    expect(
      blobs.where((b) => b.parentEntityType == 'watchlist' && b.parentLocalId == created.id),
      isEmpty,
    );

    final cached =
        await LocalDatabase.instance.getCachedEntity('watchlist', created.id);
    expect(cached, isNull);
  });

  test('offline edit to a synced item queues an update op and persists the merge', () async {
    const serverId = 990101;
    await LocalDatabase.instance.cacheEntity(
      entityType: 'watchlist',
      entityId: serverId,
      data: {
        'id': serverId,
        'sales_person_id': 990004,
        'gps': '26.0000,48.0000',
        'place_name': 'zzz-wl-server-edit',
        'status': 'active',
      },
    );

    final merged = await offlineRepo().update(serverId, {
      'status': 'archived',
      'archived_reason': 'visited',
    });
    expect(merged.status, 'archived');

    final queue = await LocalDatabase.instance.pendingQueue();
    final update = queue.lastWhere(
        (q) => q.entityType == 'watchlist' && q.operation == 'update' && q.serverId == serverId);
    expect(update.payload['status'], 'archived');
    expect(update.payload['archived_reason'], 'visited');

    // The merge must be written back, not just returned — otherwise the edit
    // vanishes on the next reload from cache.
    final cached =
        await LocalDatabase.instance.getCachedEntity('watchlist', serverId);
    expect(cached?['status'], 'archived');
    expect(cached?['archived_reason'], 'visited');
  });
}
