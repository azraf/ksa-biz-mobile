import '../models/customer_diary_note.dart';
import '../offline/offline_sync_trigger.dart';
import '../utils/client_request_id.dart';
import '../offline/stores/diary_local_store.dart';
import '../offline/stores/sync_outbox_store.dart';
import '../offline/sync_queue_item.dart';
import 'customer_diary_repository.dart';

class OfflineDiaryRepository {
  OfflineDiaryRepository({
    required CustomerDiaryRepository remote,
    required DiaryLocalStore diary,
    required SyncOutboxStore outbox,
    required bool Function() isOnline,
  })  : _remote = remote,
        _diary = diary,
        _outbox = outbox,
        _isOnline = isOnline;

  final CustomerDiaryRepository _remote;
  final DiaryLocalStore _diary;
  final SyncOutboxStore _outbox;
  final bool Function() _isOnline;

  Future<List<CustomerDiaryNoteModel>> list({
    required String customerType,
    required int customerId,
    int page = 1,
  }) async {
    if (_isOnline()) {
      try {
        final result = await _remote.list(customerType: customerType, customerId: customerId, page: page);
        for (final note in result.items) {
          await _diary.upsert(note, customerId: customerId);
        }
        return result.items;
      } catch (_) {}
    }
    return _diary.list(customerType: customerType, customerId: customerId);
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
      await _diary.upsert(note, customerId: customerId);
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
    await _diary.upsert(note, customerId: customerId, pendingSync: true);
    final payload = withClientRequestId({
      ...note.toCreateJson(),
      'customer_id': customerId,
    });
    await _outbox.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'diary',
      operation: 'create',
      localId: localId,
      payload: payload,
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    ));
    OfflineSyncTrigger.requestSync();
    return note;
  }
}
