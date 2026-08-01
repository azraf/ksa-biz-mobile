import '../errors/offline_write_exception.dart';
import '../offline/stores/admin_list_cache_store.dart';
import '../repositories/crud_repository.dart';

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

/// Wraps [CrudRepository] with Isar list cache for offline read.
class CachedCrudRepository<T> {
  CachedCrudRepository({
    required CrudRepository<T> remote,
    required AdminListCacheStore cache,
    required String cacheKey,
    required Map<String, dynamic> Function(T) toJson,
    required bool Function() isOnline,
  })  : _remote = remote,
        _cache = cache,
        _cacheKey = cacheKey,
        _toJson = toJson,
        _isOnline = isOnline;

  final CrudRepository<T> _remote;
  final AdminListCacheStore _cache;
  final String _cacheKey;
  final Map<String, dynamic> Function(T) _toJson;
  final bool Function() _isOnline;

  String _key([Map<String, String>? query]) {
    if (query == null || query.isEmpty) return _cacheKey;
    final q = query.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '$_cacheKey?$q';
  }

  Future<CachedListResult<T>> list({Map<String, String>? query}) async {
    final key = _key(query);
    if (_isOnline()) {
      try {
        final items = await _remote.list(query: query);
        await _cache.put(key, items.map(_toJson).toList());
        return CachedListResult(items: items);
      } catch (_) {
        return _fromCache(key);
      }
    }
    return _fromCache(key);
  }

  Future<CachedListResult<T>> _fromCache(String key) async {
    final cached = await _cache.get(key);
    if (cached == null) return const CachedListResult(items: []);
    // Items re-fetched via remote's internal mapper on next online call only.
    // For offline we store JSON and rely on caller-provided fromJson via listParsed.
    return CachedListResult(
      items: const [],
      fetchedAt: cached.fetchedAt,
      isCached: true,
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
        await _cache.put(key, items.map(_toJson).toList());
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
    final cached = await _cache.get(key);
    if (cached == null) return const CachedListResult(items: []);
    final items = cached.items.map(fromJson).toList();
    return CachedListResult(items: items, fetchedAt: cached.fetchedAt, isCached: true);
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
