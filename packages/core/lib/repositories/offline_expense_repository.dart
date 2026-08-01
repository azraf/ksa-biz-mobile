import '../models/expense_models.dart';
import '../models/paginated_response.dart';
import '../offline/offline_sync_trigger.dart';
import '../utils/client_request_id.dart';
import '../offline/stores/expense_local_store.dart';
import '../offline/stores/sync_outbox_store.dart';
import '../offline/sync_queue_item.dart';
import 'expense_repository.dart';

class OfflineExpenseRepository {
  OfflineExpenseRepository({
    required ExpenseRepository remote,
    required ExpenseLocalStore expenses,
    required SyncOutboxStore outbox,
    required bool Function() isOnline,
  })  : _remote = remote,
        _expenses = expenses,
        _outbox = outbox,
        _isOnline = isOnline;

  final ExpenseRepository _remote;
  final ExpenseLocalStore _expenses;
  final SyncOutboxStore _outbox;
  final bool Function() _isOnline;

  Future<PaginatedResponse<ExpenseModel>> list({
    int? categoryId,
    String? status,
    String? fromDate,
    String? toDate,
    int page = 1,
  }) async {
    if (_isOnline()) {
      try {
        final result = await _remote.list(
          categoryId: categoryId,
          status: status,
          fromDate: fromDate,
          toDate: toDate,
          page: page,
        );
        for (final expense in result.items) {
          await _expenses.upsertJson(expense.id, {...expense.toJson(), 'id': expense.id});
        }
        if (page == 1) {
          final pending = await _pendingExpenses();
          if (pending.isNotEmpty) {
            return PaginatedResponse(
              items: [...pending, ...result.items],
              currentPage: result.currentPage,
              lastPage: result.lastPage,
              total: result.total + pending.length,
            );
          }
        }
        return result;
      } catch (_) {
        return _cachedList();
      }
    }
    return _cachedList();
  }

  Future<PaginatedResponse<ExpenseModel>> _cachedList() async {
    final cached = await _expenses.listAll();
    final items = cached.map((e) => ExpenseModel.fromJson(e)).toList();
    return PaginatedResponse(items: items, currentPage: 1, lastPage: 1, total: items.length);
  }

  Future<List<ExpenseModel>> _pendingExpenses() async {
    final cached = await _expenses.listAll();
    return cached
        .where((e) => e['_pending_sync'] == true)
        .map((e) => ExpenseModel.fromJson(e))
        .toList();
  }

  Future<ExpenseModel> create(Map<String, dynamic> body) async {
    if (_isOnline()) {
      final expense = await _remote.create(body);
      await _expenses.upsertJson(expense.id, {...expense.toJson(), 'id': expense.id});
      return expense;
    }

    final payload = withClientRequestId(body);
    final localId = await _expenses.nextLocalId();
    final pending = {
      ...payload,
      'id': localId,
      'status': body['status'] ?? 'draft',
      'currency': body['currency'] ?? 'SAR',
      '_pending_sync': true,
    };
    await _expenses.upsertJson(localId, pending, pendingSync: true);
    await _outbox.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'expense',
      operation: 'create',
      localId: localId,
      payload: payload,
    ));
    OfflineSyncTrigger.requestSync();
    return ExpenseModel.fromJson(pending);
  }

  Future<ExpenseModel> update(int id, Map<String, dynamic> body) async {
    if (_isOnline()) {
      final expense = await _remote.update(id, body);
      await _expenses.upsertJson(expense.id, {...expense.toJson(), 'id': expense.id});
      return expense;
    }

    final cached = await _expenses.getJson(id);
    final updated = {...?cached, ...body, 'id': id, '_pending_sync': true};
    await _expenses.upsertJson(id, updated, pendingSync: true);

    if (id > 0) {
      await _outbox.enqueue(SyncQueueItem(
        id: 0,
        entityType: 'expense',
        operation: 'update',
        serverId: id,
        payload: body,
      ));
    }
    OfflineSyncTrigger.requestSync();
    return ExpenseModel.fromJson(updated);
  }

  Future<int> pendingSyncCount() => _outbox.pendingCount();
}
