import '../models/expense_models.dart';
import '../models/paginated_response.dart';
import '../offline/local_database.dart';
import '../offline/sync_queue_item.dart';
import 'expense_repository.dart';

class OfflineExpenseRepository {
  OfflineExpenseRepository({
    required ExpenseRepository remote,
    required LocalDatabase db,
    required bool Function() isOnline,
  })  : _remote = remote,
        _db = db,
        _isOnline = isOnline;

  final ExpenseRepository _remote;
  final LocalDatabase _db;
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
        await _db.cacheEntitiesBatch(
          entityType: 'expense',
          entities: result.items
              .map(
                (expense) => (
                  entityId: expense.id,
                  data: {...expense.toJson(), 'id': expense.id, '_pending_sync': false},
                ),
              )
              .toList(),
        );
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
    final cached = await _db.getCachedEntities('expense');
    final items = cached.map((e) => ExpenseModel.fromJson(e)).toList();
    return PaginatedResponse(items: items, currentPage: 1, lastPage: 1, total: items.length);
  }

  Future<List<ExpenseModel>> _pendingExpenses() async {
    final cached = await _db.getCachedEntities('expense');
    return cached
        .where((e) => e['_pending_sync'] == true)
        .map((e) => ExpenseModel.fromJson(e))
        .toList();
  }

  Future<ExpenseModel> create(Map<String, dynamic> body) async {
    if (_isOnline()) {
      final expense = await _remote.create(body);
      await _db.cacheEntity(
        entityType: 'expense',
        entityId: expense.id,
        data: {...expense.toJson(), 'id': expense.id, '_pending_sync': false},
      );
      return expense;
    }

    final localId = await _db.nextLocalId();
    final pending = {
      ...body,
      'id': localId,
      'status': body['status'] ?? 'draft',
      'currency': body['currency'] ?? 'SAR',
      '_pending_sync': true,
    };
    await _db.cacheEntity(entityType: 'expense', entityId: localId, data: pending);
    await _db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'expense',
      operation: 'create',
      localId: localId,
      payload: body,
    ));
    return ExpenseModel.fromJson(pending);
  }

  Future<ExpenseModel> update(int id, Map<String, dynamic> body) async {
    if (_isOnline()) {
      final expense = await _remote.update(id, body);
      await _db.cacheEntity(
        entityType: 'expense',
        entityId: expense.id,
        data: {...expense.toJson(), 'id': expense.id, '_pending_sync': false},
      );
      return expense;
    }

    final cached = await _db.getCachedEntity('expense', id);
    final updated = {...?cached, ...body, 'id': id, '_pending_sync': true};
    await _db.cacheEntity(entityType: 'expense', entityId: id, data: updated);

    if (id > 0) {
      await _db.enqueue(SyncQueueItem(
        id: 0,
        entityType: 'expense',
        operation: 'update',
        serverId: id,
        payload: body,
      ));
    }
    return ExpenseModel.fromJson(updated);
  }

  Future<int> pendingSyncCount() => _db.pendingCount();
}
