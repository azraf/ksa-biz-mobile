import '../models/visit_schedule.dart';
import '../offline/local_database.dart';
import '../offline/sync_queue_item.dart';
import '../utils/client_request_id.dart';
import 'visit_schedule_repository.dart';

/// Offline-first visit planner store, mirroring OfflineWatchlistRepository:
/// negative ids for local-only rows, sync_queue for pending operations,
/// entity_cache('visit') for the calendar's offline view.
class OfflineVisitRepository {
  OfflineVisitRepository({
    required VisitScheduleRepository remote,
    required LocalDatabase db,
    required bool Function() isOnline,
  })  : _remote = remote,
        _db = db,
        _isOnline = isOnline;

  final VisitScheduleRepository _remote;
  final LocalDatabase _db;
  final bool Function() _isOnline;

  /// Visits between [from] and [to] inclusive, cached for offline. Filters run
  /// in Dart over the cache — fine at field-sales volumes.
  /// ponytail: whole-cache scan; index by month if it ever hurts.
  Future<List<VisitScheduleModel>> list({
    required DateTime from,
    required DateTime to,
    String? purpose,
    String? status,
  }) async {
    if (_isOnline()) {
      try {
        final fetched = <VisitScheduleModel>[];
        var page = 1;
        while (true) {
          final result = await _remote.list(
            from: _dateOnly(from),
            to: _dateOnly(to),
            page: page,
          );
          fetched.addAll(result.items);
          if (!result.hasMore) break;
          page++;
        }
        for (final visit in fetched) {
          await _db.cacheEntity(
            entityType: 'visit',
            entityId: visit.id,
            data: visit.toCacheJson(),
          );
        }
      } catch (_) {}
    }

    final cached = await _db.getCachedEntities('visit');
    final visits = cached.map(VisitScheduleModel.fromJson).where((v) {
      final when = v.scheduledDate;
      if (when == null) return v.isLocalOnly;
      final inRange = !when.isBefore(DateTime(from.year, from.month, from.day)) &&
          when.isBefore(DateTime(to.year, to.month, to.day).add(const Duration(days: 1)));
      return inRange || v.isLocalOnly;
    }).toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    return visits.where((v) {
      if (purpose != null && v.purpose != purpose) return false;
      if (status != null && v.status != status) return false;
      return true;
    }).toList();
  }

  Future<VisitScheduleModel> create(VisitScheduleModel draft) async {
    if (_isOnline()) {
      final created = await _remote.create({
        ...draft.toCreateJson(),
        'client_request_id': generateClientRequestId(),
      });
      await _db.cacheEntity(entityType: 'visit', entityId: created.id, data: created.toCacheJson());
      return created;
    }

    final localId = -DateTime.now().millisecondsSinceEpoch;
    final local = VisitScheduleModel(
      id: localId,
      salesPersonId: draft.salesPersonId,
      customerType: draft.customerType,
      customerShopId: draft.customerShopId,
      customerVanId: draft.customerVanId,
      customerImporterId: draft.customerImporterId,
      watchlistItemId: draft.watchlistItemId,
      customerName: draft.customerName,
      gps: draft.gps,
      scheduledAt: draft.scheduledAt,
      durationMinutes: draft.durationMinutes,
      purpose: draft.purpose,
      notes: draft.notes,
      isLocalOnly: true,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _db.cacheEntity(
      entityType: 'visit',
      entityId: localId,
      data: local.toCacheJson(pending: true),
    );
    await _db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'visit',
      operation: 'create',
      localId: localId,
      payload: {
        ...local.toCreateJson(),
        'client_request_id': generateClientRequestId(),
      },
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    ));
    return local;
  }

  /// Reschedule/notes. Local-only rows are edited in the cache and their
  /// queued payload replaced (delete-and-recreate, the house pattern).
  Future<VisitScheduleModel> update(
    VisitScheduleModel visit, {
    required String scheduledAt,
    int? durationMinutes,
    String? notes,
  }) async {
    if (visit.id < 0) {
      await _db.cancelPendingByLocalId(visit.id);
      await _db.removeCachedEntity('visit', visit.id);
      return create(VisitScheduleModel(
        id: 0,
        salesPersonId: visit.salesPersonId,
        customerType: visit.customerType,
        customerShopId: visit.customerShopId,
        customerVanId: visit.customerVanId,
        customerImporterId: visit.customerImporterId,
        watchlistItemId: visit.watchlistItemId,
        customerName: visit.customerName,
        gps: visit.gps,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes ?? visit.durationMinutes,
        purpose: visit.purpose,
        notes: notes ?? visit.notes,
      ));
    }

    final payload = {
      'scheduled_at': scheduledAt,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (notes != null) 'notes': notes,
    };

    if (_isOnline()) {
      final updated = await _remote.update(visit.id, payload);
      await _db.cacheEntity(entityType: 'visit', entityId: updated.id, data: updated.toCacheJson());
      return updated;
    }

    await _db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'visit',
      operation: 'update',
      serverId: visit.id,
      payload: payload,
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    ));
    final cached = await _db.getCachedEntity('visit', visit.id);
    if (cached != null) {
      cached.addAll(payload);
      cached['_pending_sync'] = true;
      await _db.cacheEntity(entityType: 'visit', entityId: visit.id, data: cached);
      return VisitScheduleModel.fromJson(cached);
    }
    return visit;
  }

  /// Status transitions apply to synced rows only; the UI blocks them for
  /// local-only visits ("sync first"), matching the watchlist pattern.
  Future<VisitScheduleModel> transition(
    VisitScheduleModel visit,
    String operation, {
    String? outcomeNote,
  }) async {
    assert(operation == 'complete' || operation == 'miss' || operation == 'cancel');

    if (_isOnline()) {
      final updated = switch (operation) {
        'complete' => await _remote.complete(visit.id, outcomeNote: outcomeNote),
        'miss' => await _remote.miss(visit.id, outcomeNote: outcomeNote),
        _ => await _remote.cancel(visit.id, reason: outcomeNote),
      };
      await _db.cacheEntity(entityType: 'visit', entityId: updated.id, data: updated.toCacheJson());
      return updated;
    }

    await _db.enqueue(SyncQueueItem(
      id: 0,
      entityType: 'visit',
      operation: operation,
      serverId: visit.id,
      payload: {if (outcomeNote != null) 'outcome_note': outcomeNote},
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now().toIso8601String(),
    ));

    final newStatus = switch (operation) {
      'complete' => 'done',
      'miss' => 'missed',
      _ => 'cancelled',
    };
    final optimistic = visit.copyWith(status: newStatus, outcomeNote: outcomeNote);
    await _db.cacheEntity(
      entityType: 'visit',
      entityId: visit.id,
      data: optimistic.toCacheJson(pending: true),
    );
    return optimistic;
  }

  /// Deleting a local-only visit just drops the queue row and cache entry.
  Future<void> deleteLocal(VisitScheduleModel visit) async {
    if (visit.id >= 0) return;
    await _db.cancelPendingByLocalId(visit.id);
    await _db.removeCachedEntity('visit', visit.id);
  }

  static String _dateOnly(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
