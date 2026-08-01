import 'package:isar_community/isar.dart';

import '../../models/customer_diary_note.dart';
import '../isar/local_diary.dart';
import '../isar/mappers/entity_mappers.dart';
import '../isar_service.dart';

class DiaryLocalStore {
  DiaryLocalStore(this._isar);

  final IsarService _isar;

  Isar get _db => _isar.isar;

  Future<void> upsert(
    CustomerDiaryNoteModel note, {
    required int customerId,
    bool pendingSync = false,
  }) async {
    final local = DiaryMapper.fromModel(note, customerId: customerId, pendingSync: pendingSync);
    await _isar.writeTxn(() async {
      final existing = await _db.localDiaryNotes.filter().serverIdEqualTo(note.id).findFirst();
      if (existing != null) local.isarId = existing.isarId;
      await _db.localDiaryNotes.put(local);
    });
  }

  Future<List<CustomerDiaryNoteModel>> list({
    required String customerType,
    required int customerId,
  }) async {
    final key = '${customerType}_$customerId';
    final rows = await _db.localDiaryNotes
        .filter()
        .customerKeyEqualTo(key)
        .sortByUpdatedAtDesc()
        .findAll();
    return rows.map(DiaryMapper.toModel).toList();
  }

  Future<void> remove(int serverId) async {
    await _isar.writeTxn(() async {
      await _db.localDiaryNotes.filter().serverIdEqualTo(serverId).deleteAll();
    });
  }
}
