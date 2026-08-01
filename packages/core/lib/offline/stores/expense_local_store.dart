import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../isar/local_expense.dart';
import '../isar_service.dart';

class ExpenseLocalStore {
  ExpenseLocalStore(this._isar);

  final IsarService _isar;

  Isar get _db => _isar.isar;

  Future<void> upsertJson(int serverId, Map<String, dynamic> data, {bool pendingSync = false}) async {
    await _isar.writeTxn(() async {
      final existing = await _db.localExpenses.filter().serverIdEqualTo(serverId).findFirst();
      final row = LocalExpense()
        ..serverId = serverId
        ..dataJson = jsonEncode(data)
        ..pendingSync = pendingSync || serverId < 0
        ..updatedAt = DateTime.now();
      if (existing != null) row.isarId = existing.isarId;
      await _db.localExpenses.put(row);
    });
  }

  Future<Map<String, dynamic>?> getJson(int serverId) async {
    final row = await _db.localExpenses.filter().serverIdEqualTo(serverId).findFirst();
    if (row == null) return null;
    return jsonDecode(row.dataJson) as Map<String, dynamic>;
  }

  Future<void> remove(int serverId) async {
    await _isar.writeTxn(() async {
      await _db.localExpenses.filter().serverIdEqualTo(serverId).deleteAll();
    });
  }

  Future<List<Map<String, dynamic>>> listAll() async {
    final rows = await _db.localExpenses.where().sortByUpdatedAtDesc().findAll();
    return rows.map((r) => jsonDecode(r.dataJson) as Map<String, dynamic>).toList();
  }

  Future<int> nextLocalId() async {
    final rows = await _db.localExpenses.filter().serverIdLessThan(0).findAll();
    var minId = 0;
    for (final row in rows) {
      if (row.serverId < minId) minId = row.serverId;
    }
    return minId - 1;
  }
}
