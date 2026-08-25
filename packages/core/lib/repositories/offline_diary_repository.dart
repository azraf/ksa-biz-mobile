import '../models/customer_diary_note.dart';
import '../offline/local_database.dart';
import '../offline/sync_queue_item.dart';
import '../utils/client_request_id.dart';
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

  /// Order-scoped notes cache separately from the customer feed so both lists
  /// stay correct offline.
  static String _cacheKey(String customerType, int customerId, int? orderId) =>
      orderId != null ? 'diary_order_$orderId' : 'diary_${customerType}_$customerId';

  Future<List<CustomerDiaryNoteModel>> list({
    required String customerType,
    required int customerId,
    int? orderId,
    int page = 1,
  }) async {
    if (_isOnline()) {
      try {
        final result = await _remote.list(
          customerType: customerType,
          customerId: customerId,
          orderId: orderId,
          page: page,
        );
        for (final note in result.items) {
          await _cacheNote(customerType, customerId, note, orderId: orderId);
        }
        return result.items;
      } catch (_) {}
    }
    final cached = await _db.getCachedEntities(_cacheKey(customerType, customerId, orderId));
    return cached.map((e) => CustomerDiaryNoteModel.fromJson(e)).toList();
  }

  Future<CustomerDiaryNoteModel> createText({
    required String customerType,
    required int customerId,
    required String body,
    int? salesPersonId,
  }) {
    return createNote(
      customerType: customerType,
      customerId: customerId,
      noteType: 'text',
      body: body,
      salesPersonId: salesPersonId,
    );
  }

  /// Creates a note of any type, online or queued. Media (photo/voice/video)
  /// attaches afterwards through MediaCaptureFacade, keyed to the note's
  /// (possibly negative) id.
  Future<CustomerDiaryNoteModel> createNote({
    required String customerType,
    required int customerId,
    required String noteType,
    String? body,
    int? orderId,
    int? salesPersonId,
  }) async {
    // Generated once per note and persisted with the queued payload, so a
    // retried sync (or an online request replayed after a dropped response)
    // dedupes server-side instead of creating a duplicate note.
    final clientRequestId = generateClientRequestId();

    if (_isOnline()) {
      final note = await _remote.create(
        customerType: customerType,
        customerId: customerId,
        noteType: noteType,
        body: body,
        orderId: orderId,
        salesPersonId: salesPersonId,
        clientRequestId: clientRequestId,
      );
      await _cacheNote(customerType, customerId, note, orderId: orderId);
      return note;
    }

    final localId = -DateTime.now().millisecondsSinceEpoch;
    final note = CustomerDiaryNoteModel(
      id: localId,
      customerType: customerType,
      noteType: noteType,
      body: body,
      customerShopId: customerType == 'customer_shop' ? customerId : null,
      customerVanId: customerType == 'customer_van' ? customerId : null,
      customerImporterId: customerType == 'customer_importer' ? customerId : null,
      orderId: orderId,
      isLocalOnly: true,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _cacheNote(customerType, customerId, note, orderId: orderId, pending: true);
    await _db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'diary',
      operation: 'create',
      localId: localId,
      payload: {
        ...note.toCreateJson(),
        'customer_id': customerId,
        'client_request_id': clientRequestId,
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
    int? orderId,
    bool pending = false,
  }) async {
    final data = {
      'id': note.id,
      'customer_type': note.customerType,
      'note_type': note.noteType,
      'body': note.body,
      'customer_shop_id': note.customerShopId,
      'customer_van_id': note.customerVanId,
      'customer_importer_id': note.customerImporterId,
      'order_id': note.orderId,
      'created_at': note.createdAt,
      if (pending) '_pending_sync': true,
    };
    await _db.cacheEntity(
      entityType: _cacheKey(customerType, customerId, orderId ?? note.orderId),
      entityId: note.id,
      data: data,
    );
  }
}
