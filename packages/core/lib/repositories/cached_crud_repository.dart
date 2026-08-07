import '../errors/offline_write_exception.dart';
import '../offline/local_database.dart';
import 'crud_repository.dart';

class CachedListResult<T> {
  const CachedListResult({
    required this.items,
    this.fetchedAt,
    this.isCached = false,
  });

  final List<T> items;
  final DateTime? fetchedAt;
  final bool isCached;
}

/// SQLite-backed list cache for admin CRUD screens (offline read).
class CachedCrudRepository<T> {
  CachedCrudRepository({
    required CrudRepository<T> remote,
    required LocalDatabase db,
    required String cacheKey,
    required Map<String, dynamic> Function(T) toJson,
    required bool Function() isOnline,
  })  : _remote = remote,
        _db = db,
        _cacheKey = cacheKey,
        _toJson = toJson,
        _isOnline = isOnline;

  final CrudRepository<T> _remote;
  final LocalDatabase _db;
  final String _cacheKey;
  final Map<String, dynamic> Function(T) _toJson;
  final bool Function() _isOnline;

  static const _entityType = 'admin_list';

  String _key([Map<String, String>? query]) {
    if (query == null || query.isEmpty) return _cacheKey;
    final q = query.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '$_cacheKey?$q';
  }

  int _entityId(String key) => key.hashCode;

  Future<void> _putList(String key, List<Map<String, dynamic>> items) async {
    await _db.cacheEntity(
      entityType: _entityType,
      entityId: _entityId(key),
      data: {
        'list_key': key,
        'items': items,
        'fetched_at': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<CachedListResult<T>> listParsed({
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? query,
  }) async {
    final key = _key(query);
    if (_isOnline()) {
      try {
        final items = await _remote.list(query: query);
        await _putList(key, items.map(_toJson).toList());
        return CachedListResult(items: items);
      } catch (_) {
        return _fromCacheParsed(key, fromJson);
      }
    }
    return _fromCacheParsed(key, fromJson);
  }

  Future<CachedListResult<T>> _fromCacheParsed(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final cached = await _db.getCachedEntity(_entityType, _entityId(key));
    if (cached == null) return const CachedListResult(items: []);
    final rawItems = cached['items'] as List<dynamic>? ?? [];
    final fetchedAt = DateTime.tryParse(cached['fetched_at'] as String? ?? '');
    final items = rawItems
        .map((e) => fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return CachedListResult(items: items, fetchedAt: fetchedAt, isCached: true);
  }

  Future<T> get(int id) async {
    if (!_isOnline()) throw OfflineWriteException();
    return _remote.get(id);
  }

  Future<T> create(Map<String, dynamic> body) async {
    if (!_isOnline()) throw OfflineWriteException();
    return _remote.create(body);
  }

  Future<T> update(int id, Map<String, dynamic> body) async {
    if (!_isOnline()) throw OfflineWriteException();
    return _remote.update(id, body);
  }

  Future<void> delete(int id) async {
    if (!_isOnline()) throw OfflineWriteException();
    return _remote.delete(id);
  }
}
