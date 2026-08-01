import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'connectivity_provider.dart';
import 'repositories.dart';

class AdminDashboardData {
  const AdminDashboardData({
    required this.sales,
    required this.expenseSummary,
    required this.pendingManualOrders,
    this.salesCachedAt,
    this.expenseCachedAt,
    this.salesFromCache = false,
    this.expenseFromCache = false,
    this.salesIsStale = false,
    this.expenseIsStale = false,
  });

  final SalesReport sales;
  final ExpenseSummaryReport expenseSummary;
  final int pendingManualOrders;
  final String? salesCachedAt;
  final String? expenseCachedAt;
  final bool salesFromCache;
  final bool expenseFromCache;
  final bool salesIsStale;
  final bool expenseIsStale;

  AdminDashboardData copyWith({
    SalesReport? sales,
    ExpenseSummaryReport? expenseSummary,
    int? pendingManualOrders,
    String? salesCachedAt,
    String? expenseCachedAt,
    bool? salesFromCache,
    bool? expenseFromCache,
    bool? salesIsStale,
    bool? expenseIsStale,
  }) {
    return AdminDashboardData(
      sales: sales ?? this.sales,
      expenseSummary: expenseSummary ?? this.expenseSummary,
      pendingManualOrders: pendingManualOrders ?? this.pendingManualOrders,
      salesCachedAt: salesCachedAt ?? this.salesCachedAt,
      expenseCachedAt: expenseCachedAt ?? this.expenseCachedAt,
      salesFromCache: salesFromCache ?? this.salesFromCache,
      expenseFromCache: expenseFromCache ?? this.expenseFromCache,
      salesIsStale: salesIsStale ?? this.salesIsStale,
      expenseIsStale: expenseIsStale ?? this.expenseIsStale,
    );
  }
}

final dashboardProvider = AsyncNotifierProvider<AdminDashboardNotifier, AdminDashboardData>(
  AdminDashboardNotifier.new,
);

class AdminDashboardNotifier extends AsyncNotifier<AdminDashboardData> {
  var _forceRefresh = false;

  @override
  Future<AdminDashboardData> build() async => _load();

  Future<void> refresh() async {
    _forceRefresh = true;
    state = const AsyncLoading();
    state = AsyncData(await _load());
    _forceRefresh = false;
  }

  Future<AdminDashboardData> _load() async {
    final reports = ref.read(reportRepositoryProvider);
    final now = DateTime.now();
    final from = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    final to = DateFormat('yyyy-MM-dd').format(now);
    final force = _forceRefresh;

    final reportResults = await Future.wait([
      reports.sales(
        fromDate: from,
        toDate: to,
        forceRefresh: force,
        onRevalidate: (result) => _applySalesRevalidate(result),
      ),
      reports.expenseSummary(
        fromDate: '${now.year}-01-01',
        toDate: to,
        forceRefresh: force,
        onRevalidate: (result) => _applyExpenseRevalidate(result),
      ),
    ]);

    final salesResult = reportResults[0] as ReportResult<SalesReport>;
    final expenseResult = reportResults[1] as ReportResult<ExpenseSummaryReport>;

    var pendingManualOrders = 0;
    try {
      final manualOrders = await ref.read(manualOrderRepositoryProvider).list(status: 'pending');
      pendingManualOrders = manualOrders.total;
    } catch (_) {}

    return AdminDashboardData(
      sales: salesResult.data,
      expenseSummary: expenseResult.data,
      pendingManualOrders: pendingManualOrders,
      salesCachedAt: salesResult.fetchedAt,
      expenseCachedAt: expenseResult.fetchedAt,
      salesFromCache: salesResult.isCached,
      expenseFromCache: expenseResult.isCached,
      salesIsStale: salesResult.isStale,
      expenseIsStale: expenseResult.isStale,
    );
  }

  void _applySalesRevalidate(ReportResult<SalesReport> result) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        sales: result.data,
        salesCachedAt: result.fetchedAt,
        salesFromCache: result.isCached,
        salesIsStale: result.isStale,
      ),
    );
  }

  void _applyExpenseRevalidate(ReportResult<ExpenseSummaryReport> result) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        expenseSummary: result.data,
        expenseCachedAt: result.fetchedAt,
        expenseFromCache: result.isCached,
        expenseIsStale: result.isStale,
      ),
    );
  }
}

class AdminOrderListState {
  const AdminOrderListState({
    required this.orders,
    required this.currentPage,
    required this.lastPage,
    this.loadingMore = false,
  });

  final List<OrderModel> orders;
  final int currentPage;
  final int lastPage;
  final bool loadingMore;

  bool get hasMore => currentPage < lastPage;

  AdminOrderListState copyWith({
    List<OrderModel>? orders,
    int? currentPage,
    int? lastPage,
    bool? loadingMore,
  }) {
    return AdminOrderListState(
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }
}

final adminOrdersProvider = AsyncNotifierProvider<AdminOrdersNotifier, AdminOrderListState>(
  AdminOrdersNotifier.new,
);

class AdminOrdersNotifier extends AsyncNotifier<AdminOrderListState> {
  static const _perPage = 25;

  @override
  Future<AdminOrderListState> build() async => _loadPage(1);

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadPage(1));
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      state = AsyncData(await _loadPage(current.currentPage + 1, append: current.orders));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }

  Future<AdminOrderListState> _loadPage(int page, {List<OrderModel>? append}) async {
    if (page == 1 && ref.read(onlineStatusProvider)) {
      unawaited(
        ref.read(syncServiceProvider).syncIfOnline().timeout(
          const Duration(seconds: 30),
          onTimeout: () {},
        ),
      );
    }
    final result = await ref.read(offlineOrderRepositoryProvider).list(page: page, perPage: _perPage);
    final orders = page == 1 ? result.items : [...?append, ...result.items];
    return AdminOrderListState(
      orders: orders,
      currentPage: result.currentPage,
      lastPage: result.lastPage,
    );
  }
}

final expensesListProvider = AsyncNotifierProvider<ExpensesListNotifier, List<ExpenseModel>>(
  ExpensesListNotifier.new,
);

class ExpensesListNotifier extends AsyncNotifier<List<ExpenseModel>> {
  @override
  Future<List<ExpenseModel>> build() async => _load();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _load());
  }

  Future<List<ExpenseModel>> _load() async {
    final result = await ref.read(offlineExpenseRepositoryProvider).list();
    return result.items;
  }
}

class SalesReportParams {
  const SalesReportParams({required this.from, required this.to});
  final String from;
  final String to;
}

class ExpenseSummaryParams {
  const ExpenseSummaryParams({required this.from, required this.to});
  final String from;
  final String to;
}

final salesReportProvider = FutureProvider.family<ReportResult<SalesReport>, SalesReportParams>((ref, params) {
  return ref.read(reportRepositoryProvider).sales(fromDate: params.from, toDate: params.to);
});

final expenseSummaryReportProvider =
    FutureProvider.family<ReportResult<ExpenseSummaryReport>, ExpenseSummaryParams>((ref, params) {
  return ref.read(reportRepositoryProvider).expenseSummary(fromDate: params.from, toDate: params.to);
});

void invalidateAdminScreenProviders(WidgetRef ref) {
  ref.invalidate(dashboardProvider);
  ref.invalidate(adminOrdersProvider);
  ref.invalidate(expensesListProvider);
}
