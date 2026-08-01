import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../isar/local_admin_list_cache.dart';
import '../isar_service.dart';

class AdminListCacheStore {
  AdminListCacheStore(this._isar);

  final IsarService _isar;

  Isar get _db => _isar.isar;

  Future<void> put(String cacheKey, List<Map<String, dynamic>> items) async {
    final entry = LocalAdminListCache()
      ..cacheKey = cacheKey
      ..payloadJson = jsonEncode(items)
      ..fetchedAt = DateTime.now();
    await _isar.writeTxn(() => _db.localAdminListCaches.put(entry));
  }

  Future<({List<Map<String, dynamic>> items, DateTime fetchedAt})?> get(String cacheKey) async {
    final row = await _db.localAdminListCaches.filter().cacheKeyEqualTo(cacheKey).findFirst();
    if (row == null) return null;
    final decoded = jsonDecode(row.payloadJson) as List<dynamic>;
    return (
      items: decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
      fetchedAt: row.fetchedAt,
    );
  }
}
