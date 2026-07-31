import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/media_target.dart';
import 'sync_queue_item.dart';

class LocalDatabase {
  LocalDatabase._();
  static final LocalDatabase instance = LocalDatabase._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'ksa_biz_offline.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _createSchema(db);
        await _createMediaBlobsTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (var v = oldVersion + 1; v <= newVersion; v++) {
          await _migrate(db, v);
        }
      },
    );
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
      default:
        break;
    }
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
    return db.insert('sync_queue', {
      'entity_type': item.entityType,
      'operation': item.operation,
      'local_id': item.localId,
      'server_id': item.serverId,
      'payload': jsonEncode(item.payload),
      'status': item.status,
      'retry_count': item.retryCount,
      'error_message': item.errorMessage,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<SyncQueueItem>> pendingQueue() async {
    final db = await database;
    final rows = await db.query(
      'sync_queue',
      where: "status IN ('pending', 'failed')",
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

  Future<void> updateQueueStatus(
    int id, {
    required String status,
    int? serverId,
    String? errorMessage,
    int? retryCount,
  }) async {
    final db = await database;
    await db.update(
      'sync_queue',
      {
        'status': status,
        if (serverId != null) 'server_id': serverId,
        if (errorMessage != null) 'error_message': errorMessage,
        if (retryCount != null) 'retry_count': retryCount,
      },
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

  Future<int> pendingMediaCount() async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as c FROM media_blobs WHERE status IN ('pending', 'failed', 'uploading')",
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
