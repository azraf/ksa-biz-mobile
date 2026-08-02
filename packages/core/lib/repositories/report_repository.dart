import 'dart:async';

import '../api/api_client.dart';
import '../models/customer.dart';
import '../models/report_models.dart';
import '../offline/local_database.dart';

typedef ReportRevalidateCallback<T> = void Function(ReportResult<T> result);

class ReportRepository {
  ReportRepository(this._api, {LocalDatabase? db}) : _db = db ?? LocalDatabase.instance;

  static const cacheTtl = Duration(minutes: 15);

  final ApiClient _api;
  final LocalDatabase _db;

  String _cacheKey(String type, Map<String, String>? query) {
    final sorted = (query ?? {}).entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return '$type:${sorted.map((e) => '${e.key}=${e.value}').join('&')}';
  }

  bool _isStale(String? fetchedAt) {
    if (fetchedAt == null) return true;
    final at = DateTime.tryParse(fetchedAt);
    if (at == null) return true;
    return DateTime.now().difference(at) > cacheTtl;
  }

  Future<ReportResult<SalesReport>> sales({
    String? fromDate,
    String? toDate,
    int? salesPersonId,
    bool forceRefresh = false,
    ReportRevalidateCallback<SalesReport>? onRevalidate,
  }) async {
    final query = <String, String>{};
    if (fromDate != null) query['from_date'] = fromDate;
    if (toDate != null) query['to_date'] = toDate;
    if (salesPersonId != null) query['sales_person_id'] = '$salesPersonId';

    return _fetch(
      'sales',
      query,
      () async {
        final response = await _api.get('/reports/sales', query: query.isEmpty ? null : query);
        return SalesReport.fromJson(response);
      },
      forceRefresh: forceRefresh,
      onRevalidate: onRevalidate,
    );
  }

  Future<ReportResult<SalesPersonDueReport>> salesPersonDue(
    int salesPersonId, {
    bool forceRefresh = false,
    ReportRevalidateCallback<SalesPersonDueReport>? onRevalidate,
  }) async {
    final query = {'sales_person_id': '$salesPersonId'};
    return _fetch(
      'sales-person-due',
      query,
      () async {
        final response = await _api.get('/reports/sales-person-due', query: query);
        return SalesPersonDueReport.fromJson(response);
      },
      forceRefresh: forceRefresh,
      onRevalidate: onRevalidate,
    );
  }

  Future<ReportResult<ProfitReport>> profit({
    String? fromDate,
    String? toDate,
    bool forceRefresh = false,
  }) async {
    final query = <String, String>{};
    if (fromDate != null) query['from_date'] = fromDate;
    if (toDate != null) query['to_date'] = toDate;

    return _fetch(
      'profit',
      query,
      () async {
        final response = await _api.get('/reports/profit', query: query.isEmpty ? null : query);
        return ProfitReport.fromJson(response);
      },
      forceRefresh: forceRefresh,
    );
  }

  Future<ReportResult<ExpenseReport>> expenses({
    String? fromDate,
    String? toDate,
    int? expenseCategoryId,
    bool forceRefresh = false,
  }) async {
    final query = <String, String>{};
    if (fromDate != null) query['from_date'] = fromDate;
    if (toDate != null) query['to_date'] = toDate;
    if (expenseCategoryId != null) query['expense_category_id'] = '$expenseCategoryId';

    return _fetch(
      'expenses',
      query,
      () async {
        final response = await _api.get('/reports/expenses', query: query.isEmpty ? null : query);
        return ExpenseReport.fromJson(response);
      },
      forceRefresh: forceRefresh,
    );
  }

  Future<ReportResult<ExpenseSummaryReport>> expenseSummary({
    String period = 'monthly',
    String? fromDate,
    String? toDate,
    bool forceRefresh = false,
    ReportRevalidateCallback<ExpenseSummaryReport>? onRevalidate,
  }) async {
    final query = <String, String>{'period': period};
    if (fromDate != null) query['from_date'] = fromDate;
    if (toDate != null) query['to_date'] = toDate;

    return _fetch(
      'expense-summary',
      query,
      () async {
        final response = await _api.get('/reports/expense-summary', query: query);
        return ExpenseSummaryReport.fromJson(response);
      },
      forceRefresh: forceRefresh,
      onRevalidate: onRevalidate,
    );
  }

  Future<ReportResult<Map<String, dynamic>>> purchases({
    String? fromDate,
    String? toDate,
    bool forceRefresh = false,
  }) async {
    final query = <String, String>{};
    if (fromDate != null) query['from_date'] = fromDate;
    if (toDate != null) query['to_date'] = toDate;

    return _fetchRaw(
      'purchases',
      query,
      () => _api.get('/reports/purchases', query: query.isEmpty ? null : query),
      forceRefresh: forceRefresh,
    );
  }

  Future<ReportResult<Map<String, dynamic>>> containers({
    String? fromDate,
    String? toDate,
    bool forceRefresh = false,
  }) async {
    final query = <String, String>{};
    if (fromDate != null) query['from_date'] = fromDate;
    if (toDate != null) query['to_date'] = toDate;

    return _fetchRaw(
      'containers',
      query,
      () => _api.get('/reports/containers', query: query.isEmpty ? null : query),
      forceRefresh: forceRefresh,
    );
  }

  Future<ReportResult<T>> _fetch<T>(
    String type,
    Map<String, String> query,
    Future<T> Function() fetcher, {
    bool forceRefresh = false,
    ReportRevalidateCallback<T>? onRevalidate,
  }) async {
    final key = _cacheKey(type, query);
    if (!forceRefresh) {
      final cached = await _db.getCachedReport(key);
      if (cached != null) {
        final stale = _isStale(cached.fetchedAt);
        final result = ReportResult(
          data: _deserialize(type, cached.data) as T,
          fetchedAt: cached.fetchedAt,
          isCached: true,
          isStale: stale,
        );
        if (stale) {
          unawaited(_revalidateInBackground(type, query, key, fetcher, onRevalidate));
        }
        return result;
      }
    }

    try {
      final data = await fetcher();
      await _db.cacheReport(
        cacheKey: key,
        reportType: type,
        data: _serialize(data),
      );
      return ReportResult(data: data, fetchedAt: DateTime.now().toIso8601String());
    } catch (e) {
      final cached = await _db.getCachedReport(key);
      if (cached != null) {
        return ReportResult(
          data: _deserialize(type, cached.data) as T,
          fetchedAt: cached.fetchedAt,
          isCached: true,
          isStale: true,
        );
      }
      rethrow;
    }
  }

  Future<void> _revalidateInBackground<T>(
    String type,
    Map<String, String> query,
    String key,
    Future<T> Function() fetcher,
    ReportRevalidateCallback<T>? onRevalidate,
  ) async {
    try {
      final data = await fetcher();
      await _db.cacheReport(
        cacheKey: key,
        reportType: type,
        data: _serialize(data),
      );
      onRevalidate?.call(
        ReportResult(data: data, fetchedAt: DateTime.now().toIso8601String()),
      );
    } catch (_) {}
  }

  Future<ReportResult<Map<String, dynamic>>> _fetchRaw(
    String type,
    Map<String, String> query,
    Future<Map<String, dynamic>> Function() fetcher, {
    bool forceRefresh = false,
  }) async {
    final key = _cacheKey(type, query);
    if (!forceRefresh) {
      final cached = await _db.getCachedReport(key);
      if (cached != null) {
        final stale = _isStale(cached.fetchedAt);
        return ReportResult(
          data: cached.data,
          fetchedAt: cached.fetchedAt,
          isCached: true,
          isStale: stale,
        );
      }
    }

    try {
      final data = await fetcher();
      await _db.cacheReport(cacheKey: key, reportType: type, data: data);
      return ReportResult(data: data, fetchedAt: DateTime.now().toIso8601String());
    } catch (e) {
      final cached = await _db.getCachedReport(key);
      if (cached != null) {
        return ReportResult(
          data: cached.data,
          fetchedAt: cached.fetchedAt,
          isCached: true,
          isStale: true,
        );
      }
      rethrow;
    }
  }

  Map<String, dynamic> _serialize(dynamic data) {
    if (data is SalesReport) {
      return {
        'from_date': data.fromDate,
        'to_date': data.toDate,
        'orders_count': data.ordersCount,
        'total_bill': data.totalBill,
        'by_product': data.byProduct
            .map((p) => {'product_id': p.productId, 'qty': p.qty, 'revenue': p.revenue})
            .toList(),
      };
    }
    if (data is ProfitReport) {
      return {'revenue': data.revenue, 'cost': data.cost, 'profit': data.profit};
    }
    if (data is ExpenseReport) {
      return {
        'from_date': data.fromDate,
        'to_date': data.toDate,
        'total_amount': data.totalAmount,
        'by_category': data.byCategory
            .map((c) => {
                  'expense_category_id': c.expenseCategoryId,
                  'category_name': c.categoryName,
                  'total': c.total,
                  'count': c.count,
                })
            .toList(),
      };
    }
    if (data is ExpenseSummaryReport) {
      return {
        'period': data.period,
        'from_date': data.fromDate,
        'to_date': data.toDate,
        'grand_total': data.grandTotal,
        'by_period': data.byPeriod.map((p) => {'period_key': p.periodKey, 'total': p.total}).toList(),
      };
    }
    if (data is SalesPersonDueReport) {
      return {
        'sales_person_id': data.salesPersonId,
        'total_due': data.totalDue,
        'orders': data.orders,
      };
    }
    return {};
  }

  dynamic _deserialize(String type, Map<String, dynamic> json) {
    return switch (type) {
      'sales' => SalesReport.fromJson(json),
      'profit' => ProfitReport.fromJson(json),
      'expenses' => ExpenseReport.fromJson(json),
      'expense-summary' => ExpenseSummaryReport.fromJson(json),
      'sales-person-due' => SalesPersonDueReport.fromJson(json),
      _ => json,
    };
  }
}
