import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/media_target.dart';
import 'offline_sync_trigger.dart';
import 'sync_queue_item.dart';

class LocalDatabase {
  LocalDatabase._();
  static final LocalDatabase instance = LocalDatabase._();

  static const maxRetries = 5;
  static const entityCacheTtlDays = 30;
  static const maxEntityCacheRows = 15000;
  static const purgeDoneOlderThanDays = 7;

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'ksa_biz_offline.db');
    final db = await openDatabase(
      path,
      version: 3,
      onConfigure: _configureDatabase,
      onCreate: (db, version) async {
        await _createSchema(db);
        await _createMediaBlobsTable(db);
        await _createAppConfigTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (var v = oldVersion + 1; v <= newVersion; v++) {
          await _migrate(db, v);
        }
      },
    );
    await _resetStuckStatuses(db);
    return db;
  }

  /// PRAGMA returns result rows — use rawQuery (Android rejects execute() for these).
  Future<void> _configureDatabase(Database db) async {
    try {
      await db.rawQuery('PRAGMA journal_mode=WAL');
      await db.rawQuery('PRAGMA synchronous=NORMAL');
    } catch (_) {
      // WAL is a performance optimization; default journal mode is fine.
    }
  }

  Future<void> _createSchema(Database db) async {
        await db.execute('''
          CREATE TABLE entity_cache (
            cache_key TEXT PRIMARY KEY,
            entity_type TEXT NOT NULL,
            entity_id INTEGER,
            data TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE sync_queue (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            entity_type TEXT NOT NULL,
            operation TEXT NOT NULL,
            local_id INTEGER,
            server_id INTEGER,
            payload TEXT NOT NULL,
            status TEXT NOT NULL DEFAULT 'pending',
            retry_count INTEGER NOT NULL DEFAULT 0,
            error_message TEXT,
            next_retry_at TEXT,
            created_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE report_cache (
            cache_key TEXT PRIMARY KEY,
            report_type TEXT NOT NULL,
            data TEXT NOT NULL,
            fetched_at TEXT NOT NULL
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_sync_queue_status ON sync_queue(status)',
        );
        await db.execute(
          'CREATE INDEX idx_entity_cache_type ON entity_cache(entity_type)',
        );
  }

  /// Additive migrations only — never drop entity_cache or sync_queue data.
  Future<void> _migrate(Database db, int version) async {
    switch (version) {
      case 2:
        await _createMediaBlobsTable(db);
        await db.update('sync_queue', {'status': 'pending'}, where: "status = 'syncing'");
        await db.update('media_blobs', {'status': 'pending'}, where: "status = 'uploading'");
        break;
      case 3:
        await _createAppConfigTable(db);
        try {
          await db.execute('ALTER TABLE sync_queue ADD COLUMN next_retry_at TEXT');
        } catch (_) {}
        break;
      default:
        break;
    }
  }

  Future<void> _createAppConfigTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_config (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  Future<void> _resetStuckStatuses(Database db) async {
    await db.update('sync_queue', {'status': 'pending'}, where: "status = 'syncing'");
    await db.update('media_blobs', {'status': 'pending'}, where: "status = 'uploading'");
  }

  Future<void> _createMediaBlobsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS media_blobs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        local_path TEXT NOT NULL,
        mime_type TEXT NOT NULL,
        original_name TEXT,
        size_bytes INTEGER NOT NULL DEFAULT 0,
        media_kind TEXT NOT NULL,
        parent_entity_type TEXT NOT NULL,
        parent_local_id INTEGER,
        parent_server_id INTEGER,
        upload_endpoint TEXT NOT NULL,
        upload_field TEXT NOT NULL DEFAULT 'file',
        extra_fields TEXT,
        status TEXT NOT NULL DEFAULT 'pending',
        native_task_id TEXT,
        retry_count INTEGER NOT NULL DEFAULT 0,
        error_message TEXT,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_media_blobs_status ON media_blobs(status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_media_blobs_parent ON media_blobs(parent_entity_type, parent_local_id)',
    );
  }

  Future<void> cacheEntity({
    required String entityType,
    required int entityId,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;
    final key = '${entityType}_$entityId';
    await db.insert(
      'entity_cache',
      {
        'cache_key': key,
        'entity_type': entityType,
        'entity_id': entityId,
        'data': jsonEncode(data),
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> cacheEntitiesBatch({
    required String entityType,
    required List<({int entityId, Map<String, dynamic> data})> entities,
  }) async {
    if (entities.isEmpty) return;

    final db = await database;
    final batch = db.batch();
    final updatedAt = DateTime.now().toIso8601String();

    for (final entity in entities) {
      final key = '${entityType}_${entity.entityId}';
      batch.insert(
        'entity_cache',
        {
          'cache_key': key,
          'entity_type': entityType,
          'entity_id': entity.entityId,
          'data': jsonEncode(entity.data),
          'updated_at': updatedAt,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getCachedEntities(String entityType) async {
    final db = await database;
    final rows = await db.query(
      'entity_cache',
      where: 'entity_type = ?',
      whereArgs: [entityType],
      orderBy: 'updated_at DESC',
    );
    return rows
        .map((r) => jsonDecode(r['data'] as String) as Map<String, dynamic>)
        .toList();
  }

  Future<Map<String, dynamic>?> getCachedEntity(
    String entityType,
    int entityId,
  ) async {
    final db = await database;
    final rows = await db.query(
      'entity_cache',
      where: 'cache_key = ?',
      whereArgs: ['${entityType}_$entityId'],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return jsonDecode(rows.first['data'] as String) as Map<String, dynamic>;
  }

  Future<void> removeCachedEntity(String entityType, int entityId) async {
    final db = await database;
    await db.delete(
      'entity_cache',
      where: 'cache_key = ?',
      whereArgs: ['${entityType}_$entityId'],
    );
  }

  Future<void> cancelPendingByLocalId(int localId) async {
    final db = await database;
    await db.delete(
      'sync_queue',
      where: "local_id = ? AND status IN ('pending', 'failed')",
      whereArgs: [localId],
    );
  }

  Future<int> enqueue(SyncQueueItem item) async {
    final db = await database;
    final id = await db.insert('sync_queue', {
      'entity_type': item.entityType,
      'operation': item.operation,
      'local_id': item.localId,
      'server_id': item.serverId,
      'payload': jsonEncode(item.payload),
      'status': item.status,
      'retry_count': item.retryCount,
      'error_message': item.errorMessage,
      'next_retry_at': item.nextRetryAt?.toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
    });
    OfflineSyncTrigger.requestSync();
    return id;
  }

  Future<List<SyncQueueItem>> allQueueItems() async {
    final db = await database;
    final rows = await db.query('sync_queue', orderBy: 'id ASC');
    return rows.map(_rowToQueueItem).toList();
  }

  Future<void> retryFailedItems() async {
    final db = await database;
    await db.update(
      'sync_queue',
      {
        'status': 'pending',
        'retry_count': 0,
        'error_message': null,
        'next_retry_at': null,
      },
      where: "status = 'failed'",
    );
    await db.update(
      'media_blobs',
      {
        'status': 'pending',
        'retry_count': 0,
        'error_message': null,
      },
      where: "status = 'failed'",
    );
  }

  Future<void> retryQueueItem(int id) async {
    final db = await database;
    await db.update(
      'sync_queue',
      {
        'status': 'pending',
        'retry_count': 0,
        'error_message': null,
        'next_retry_at': null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> purgeDoneQueue({Duration olderThan = const Duration(days: 7)}) async {
    final db = await database;
    final cutoff = DateTime.now().subtract(olderThan).toIso8601String();
    await db.delete(
      'sync_queue',
      where: "status = 'done' AND created_at < ?",
      whereArgs: [cutoff],
    );
  }

  Future<void> purgeDoneMedia({Duration olderThan = const Duration(days: 7)}) async {
    final db = await database;
    final cutoff = DateTime.now().subtract(olderThan).toIso8601String();
    await db.delete(
      'media_blobs',
      where: "status = 'done' AND created_at < ?",
      whereArgs: [cutoff],
    );
  }

  Future<void> evictStaleEntityCache() async {
    final db = await database;
    final cutoff = DateTime.now()
        .subtract(const Duration(days: entityCacheTtlDays))
        .toIso8601String();
    await db.delete('entity_cache', where: 'updated_at < ?', whereArgs: [cutoff]);

    final countResult = await db.rawQuery('SELECT COUNT(*) as c FROM entity_cache');
    final count = Sqflite.firstIntValue(countResult) ?? 0;
    if (count > maxEntityCacheRows) {
      final excess = count - maxEntityCacheRows;
      await db.rawDelete(
        'DELETE FROM entity_cache WHERE cache_key IN ('
        'SELECT cache_key FROM entity_cache ORDER BY updated_at ASC LIMIT ?)',
        [excess],
      );
    }
  }

  Future<String?> getConfig(String key) async {
    final db = await database;
    final rows = await db.query('app_config', where: 'key = ?', whereArgs: [key], limit: 1);
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  Future<void> setConfig(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_config',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DateTime?> getLastSyncAt() async {
    final raw = await getConfig('last_sync_at');
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> setLastSyncAt(DateTime at) async {
    await setConfig('last_sync_at', at.toIso8601String());
  }

  static const _lastUserIdKey = 'last_user_id';

  Future<int?> getLastUserId() async {
    final raw = await getConfig(_lastUserIdKey);
    return raw == null ? null : int.tryParse(raw);
  }

  Future<void> setLastUserId(int userId) => setConfig(_lastUserIdKey, '$userId');

  /// Deletes all per-user offline data: cached entities/reports, the sync
  /// outbox, and downloaded media files. Called when a different user logs
  /// in on this device (see AuthRepository) so one user's data is never
  /// shown to, or synced under, another. Does not touch `last_user_id`
  /// itself — the caller re-stamps it after wiping.
  Future<void> wipeUserData() async {
    final db = await database;

    final mediaRows = await db.query('media_blobs', columns: ['local_path']);
    for (final row in mediaRows) {
      try {
        final path = row['local_path'] as String?;
        if (path != null) await File(path).delete();
      } catch (_) {
        // Best-effort — a missing/unreadable file must not block the wipe.
      }
    }

    final batch = db.batch();
    batch.delete('entity_cache');
    batch.delete('sync_queue');
    batch.delete('report_cache');
    batch.delete('media_blobs');
    batch.delete('app_config', where: 'key = ?', whereArgs: ['last_sync_at']);
    await batch.commit(noResult: true);
  }

  Future<Map<String, dynamic>> exportRecoveryData() async {
    final queue = await allQueueItems();
    final media = await pendingMediaBlobs();
    return {
      'exported_at': DateTime.now().toIso8601String(),
      'sync_queue': queue.map((q) => {
            'id': q.id,
            'entity_type': q.entityType,
            'operation': q.operation,
            'local_id': q.localId,
            'server_id': q.serverId,
            'payload': q.payload,
            'status': q.status,
            'retry_count': q.retryCount,
            'error_message': q.errorMessage,
          }).toList(),
      'media_blobs': media.map((m) => {
            'id': m.id,
            'local_path': m.localPath,
            'parent_entity_type': m.parentEntityType,
            'parent_local_id': m.parentLocalId,
            'parent_server_id': m.parentServerId,
            'status': m.status,
            'error_message': m.errorMessage,
          }).toList(),
    };
  }

  Future<List<SyncQueueItem>> pendingQueue() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final rows = await db.query(
      'sync_queue',
      where: "status IN ('pending', 'failed') AND retry_count < ? AND (next_retry_at IS NULL OR next_retry_at <= ?)",
      whereArgs: [maxRetries, now],
      orderBy: 'id ASC',
    );
    return rows.map(_rowToQueueItem).toList();
  }

  /// Pending, failed, and exhausted-retry items for Sync issues UI.
  Future<List<SyncQueueItem>> actionableSyncItems() async {
    final db = await database;
    final rows = await db.query(
      'sync_queue',
      where: "status IN ('pending', 'failed', 'syncing')",
      orderBy: 'id ASC',
    );
    return rows.map(_rowToQueueItem).toList();
  }

  Future<int> pendingCount() async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as c FROM sync_queue WHERE status IN ('pending', 'failed')",
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Returns the number of rows updated (0 or 1) — a sync in flight when a
  /// different user logs in and wipes the queue can use this to notice its
  /// row is gone and stop, rather than pushing it under the new user's token.
  Future<int> updateQueueStatus(
    int id, {
    required String status,
    int? serverId,
    String? errorMessage,
    int? retryCount,
    DateTime? nextRetryAt,
    bool clearNextRetryAt = false,
  }) async {
    final db = await database;
    final updates = <String, Object?>{
      'status': status,
      if (serverId != null) 'server_id': serverId,
      if (errorMessage != null) 'error_message': errorMessage,
      if (retryCount != null) 'retry_count': retryCount,
    };
    if (clearNextRetryAt) {
      updates['next_retry_at'] = null;
    } else if (nextRetryAt != null) {
      updates['next_retry_at'] = nextRetryAt.toIso8601String();
    }
    return db.update(
      'sync_queue',
      updates,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> cacheReport({
    required String cacheKey,
    required String reportType,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;
    await db.insert(
      'report_cache',
      {
        'cache_key': cacheKey,
        'report_type': reportType,
        'data': jsonEncode(data),
        'fetched_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<({Map<String, dynamic> data, String fetchedAt})?> getCachedReport(
    String cacheKey,
  ) async {
    final db = await database;
    final rows = await db.query(
      'report_cache',
      where: 'cache_key = ?',
      whereArgs: [cacheKey],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    return (
      data: jsonDecode(row['data'] as String) as Map<String, dynamic>,
      fetchedAt: row['fetched_at'] as String,
    );
  }

  Future<int> nextLocalId() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT MIN(local_id) as min_id FROM sync_queue WHERE local_id < 0',
    );
    final minId = Sqflite.firstIntValue(result);
    return (minId ?? 0) - 1;
  }

  Future<int> insertMediaBlob({
    required String localPath,
    required String mimeType,
    required String mediaKind,
    required String parentEntityType,
    required String uploadEndpoint,
    String uploadField = 'file',
    String? originalName,
    int sizeBytes = 0,
    int? parentLocalId,
    int? parentServerId,
    Map<String, String> extraFields = const {},
  }) async {
    final db = await database;
    return db.insert('media_blobs', {
      'local_path': localPath,
      'mime_type': mimeType,
      'original_name': originalName,
      'size_bytes': sizeBytes,
      'media_kind': mediaKind,
      'parent_entity_type': parentEntityType,
      'parent_local_id': parentLocalId,
      'parent_server_id': parentServerId,
      'upload_endpoint': uploadEndpoint,
      'upload_field': uploadField,
      'extra_fields': jsonEncode(extraFields),
      'status': 'pending',
      'retry_count': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<MediaBlobRecord>> pendingMediaBlobs() async {
    final db = await database;
    final rows = await db.query(
      'media_blobs',
      where: "status IN ('pending', 'failed')",
      orderBy: 'id ASC',
    );
    return rows.map((r) => MediaBlobRecord.fromMap(r)).toList();
  }

  Future<void> deleteQueueItem(int id) async {
    final db = await database;
    await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> pendingMediaCount() async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as c FROM media_blobs WHERE status IN ('pending', 'failed', 'uploading')",
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> failedMediaCount() async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as c FROM media_blobs WHERE status = 'failed'",
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> updateMediaBlobStatus(
    int id, {
    required String status,
    String? nativeTaskId,
    String? errorMessage,
    int? retryCount,
    int? parentServerId,
  }) async {
    final db = await database;
    await db.update(
      'media_blobs',
      {
        'status': status,
        if (nativeTaskId != null) 'native_task_id': nativeTaskId,
        if (errorMessage != null) 'error_message': errorMessage,
        if (retryCount != null) 'retry_count': retryCount,
        if (parentServerId != null) 'parent_server_id': parentServerId,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> resolveMediaBlobParents({
    required String parentEntityType,
    required int parentLocalId,
    required int parentServerId,
  }) async {
    final db = await database;
    await db.update(
      'media_blobs',
      {'parent_server_id': parentServerId},
      where: 'parent_entity_type = ? AND parent_local_id = ? AND parent_server_id IS NULL',
      whereArgs: [parentEntityType, parentLocalId],
    );
  }

  Future<void> deleteMediaBlob(int id) async {
    final db = await database;
    await db.delete('media_blobs', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> patchCachedEntityData(
    String entityType,
    int entityId,
    Map<String, dynamic> patch,
  ) async {
    final existing = await getCachedEntity(entityType, entityId);
    if (existing == null) return;
    await cacheEntity(
      entityType: entityType,
      entityId: entityId,
      data: {...existing, ...patch},
    );
  }

  SyncQueueItem _rowToQueueItem(Map<String, dynamic> row) {
    return SyncQueueItem(
      id: row['id'] as int,
      entityType: row['entity_type'] as String,
      operation: row['operation'] as String,
      localId: row['local_id'] as int?,
      serverId: row['server_id'] as int?,
      payload: jsonDecode(row['payload'] as String) as Map<String, dynamic>,
      status: row['status'] as String? ?? 'pending',
      retryCount: row['retry_count'] as int? ?? 0,
      errorMessage: row['error_message'] as String?,
      createdAt: row['created_at'] as String?,
      nextRetryAt: row['next_retry_at'] != null
          ? DateTime.tryParse(row['next_retry_at'] as String)
          : null,
    );
  }
}

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final _controller = StreamController<bool>.broadcast();
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  Stream<bool> get onConnectivityChanged => _controller.stream;

  Future<void> init() async {
    final results = await _connectivity.checkConnectivity();
    _isOnline = _hasConnection(results);
    _controller.add(_isOnline);
    _connectivity.onConnectivityChanged.listen((results) {
      final online = _hasConnection(results);
      if (online != _isOnline) {
        _isOnline = online;
        _controller.add(online);
      }
    });
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  void dispose() => _controller.close();
}
