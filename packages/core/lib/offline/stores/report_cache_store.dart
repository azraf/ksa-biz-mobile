import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../isar/local_report_cache.dart';
import '../isar_service.dart';

class ReportCacheStore {
  ReportCacheStore(this._isar);

  final IsarService _isar;

  Isar get _db => _isar.isar;

  Future<void> cache({
    required String cacheKey,
    required String reportType,
    required Map<String, dynamic> data,
  }) async {
    await _isar.writeTxn(() async {
      final existing = await _db.localReportCaches.filter().cacheKeyEqualTo(cacheKey).findFirst();
      final row = LocalReportCache()
        ..cacheKey = cacheKey
        ..reportType = reportType
        ..dataJson = jsonEncode(data)
        ..fetchedAt = DateTime.now();
      if (existing != null) row.isarId = existing.isarId;
      await _db.localReportCaches.put(row);
    });
  }

  Future<({Map<String, dynamic> data, String fetchedAt})?> get(String cacheKey) async {
    final row = await _db.localReportCaches.filter().cacheKeyEqualTo(cacheKey).findFirst();
    if (row == null) return null;
    return (
      data: jsonDecode(row.dataJson) as Map<String, dynamic>,
      fetchedAt: row.fetchedAt.toIso8601String(),
    );
  }

  Future<void> invalidateAll() async {
    await _isar.writeTxn(() async {
      await _db.localReportCaches.clear();
    });
  }
}
