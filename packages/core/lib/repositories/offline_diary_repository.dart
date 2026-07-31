import '../models/customer_diary_note.dart';
import '../offline/local_database.dart';
import '../offline/sync_queue_item.dart';
import 'customer_diary_repository.dart';

class OfflineDiaryRepository {
  OfflineDiaryRepository({
    required CustomerDiaryRepository remote,
    required LocalDatabase db,
    required bool Function() isOnline,
  })  : _remote = remote,
        _db = db,
        _isOnline = isOnline;

  final CustomerDiaryRepository _remote;
  final LocalDatabase _db;
  final bool Function() _isOnline;

  Future<List<CustomerDiaryNoteModel>> list({
    required String customerType,
    required int customerId,
    int page = 1,
  }) async {
    if (_isOnline()) {
      try {
        final result = await _remote.list(customerType: customerType, customerId: customerId, page: page);
        return result.items;
      } catch (_) {}
    }
    final key = '${customerType}_$customerId';
    final cached = await _db.getCachedEntities('diary_$key');
    return cached.map((e) => CustomerDiaryNoteModel.fromJson(e)).toList();
  }

  Future<CustomerDiaryNoteModel> createText({
    required String customerType,
    required int customerId,
    required String body,
    int? salesPersonId,
  }) async {
    if (_isOnline()) {
      final note = await _remote.create(
        customerType: customerType,
        customerId: customerId,
        noteType: 'text',
        body: body,
        salesPersonId: salesPersonId,
      );
      await _cacheNote(customerType, customerId, note);
      return note;
    }

    final localId = -DateTime.now().millisecondsSinceEpoch;
    final note = CustomerDiaryNoteModel(
      id: localId,
      customerType: customerType,
      noteType: 'text',
      body: body,
      customerShopId: customerType == 'customer_shop' ? customerId : null,
      customerVanId: customerType == 'customer_van' ? customerId : null,
      customerImporterId: customerType == 'customer_importer' ? customerId : null,
      isLocalOnly: true,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _cacheNote(customerType, customerId, note, pending: true);
    await _db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'diary',
      operation: 'create',
      localId: localId,
      payload: {
        ...note.toCreateJson(),
        'customer_id': customerId,
      },
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    ));
    return note;
  }

  Future<void> _cacheNote(
    String customerType,
    int customerId,
    CustomerDiaryNoteModel note, {
    bool pending = false,
  }) async {
    final key = 'diary_${customerType}_$customerId';
    final data = {
      'id': note.id,
      'customer_type': note.customerType,
      'note_type': note.noteType,
      'body': note.body,
      'customer_shop_id': note.customerShopId,
      'customer_van_id': note.customerVanId,
      'customer_importer_id': note.customerImporterId,
      'created_at': note.createdAt,
      if (pending) '_pending_sync': true,
    };
    await _db.cacheEntity(entityType: key, entityId: note.id, data: data);
  }
}
