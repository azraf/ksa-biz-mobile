import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'connectivity_provider.dart';
import 'repositories.dart';

class DashboardData {
  const DashboardData({
    required this.totalDue,
    required this.unpaidOrders,
    required this.openManualOrders,
    required this.vanProducts,
    required this.lowStock,
    this.duesCachedAt,
    this.fromCache = false,
    this.isStale = false,
  });

  final double totalDue;
  final int unpaidOrders;
  final int openManualOrders;
  final int vanProducts;
  final int lowStock;
  final String? duesCachedAt;
  final bool fromCache;
  final bool isStale;

  DashboardData copyWith({
    double? totalDue,
    int? unpaidOrders,
    int? openManualOrders,
    int? vanProducts,
    int? lowStock,
    String? duesCachedAt,
    bool? fromCache,
    bool? isStale,
  }) {
    return DashboardData(
      totalDue: totalDue ?? this.totalDue,
      unpaidOrders: unpaidOrders ?? this.unpaidOrders,
      openManualOrders: openManualOrders ?? this.openManualOrders,
      vanProducts: vanProducts ?? this.vanProducts,
      lowStock: lowStock ?? this.lowStock,
      duesCachedAt: duesCachedAt ?? this.duesCachedAt,
      fromCache: fromCache ?? this.fromCache,
      isStale: isStale ?? this.isStale,
    );
  }
}

final dashboardProvider = AsyncNotifierProvider<DashboardNotifier, DashboardData>(DashboardNotifier.new);

class DashboardNotifier extends AsyncNotifier<DashboardData> {
  var _forceRefresh = false;

  @override
  Future<DashboardData> build() async => _load();

  Future<void> refresh() async {
    _forceRefresh = true;
    state = const AsyncLoading();
    state = AsyncData(await _load());
    _forceRefresh = false;
  }

  Future<DashboardData> _load() async {
    final auth = ref.read(authProvider);
    final salesPersonId = requireSalesPersonId(auth);
    if (salesPersonId == null) {
      throw Exception(auth.canPickSalesPerson ? 'select_sp' : 'no_profile');
    }

    final reportRepo = ref.read(reportRepositoryProvider);
    final manualRepo = ref.read(manualOrderRepositoryProvider);
    final inventoryRepo = ref.read(inventoryRepositoryProvider);

    final results = await Future.wait([
      reportRepo.salesPersonDue(
        salesPersonId,
        forceRefresh: _forceRefresh,
        onRevalidate: (result) => _applyDueRevalidate(result),
      ),
      manualRepo.list(openPool: true),
      manualRepo.list(assignedSalesPersonId: salesPersonId, status: 'assigned'),
      manualRepo.list(assignedSalesPersonId: salesPersonId, status: 'in_review'),
      inventoryRepo.vanStock(salesPersonId),
    ]);

    final due = results[0] as ReportResult<SalesPersonDueReport>;
    final openPool = results[1] as PaginatedResponse<ManualOrderRequestModel>;
    final assigned = results[2] as PaginatedResponse<ManualOrderRequestModel>;
    final inReview = results[3] as PaginatedResponse<ManualOrderRequestModel>;
    final vanStock = results[4] as List<InventoryStockModel>;

    final lowStock = vanStock.where((s) {
      final alert = s.product?.alertQuantity ?? 0;
      return alert > 0 && s.balance <= alert;
    }).length;

    return DashboardData(
      totalDue: due.data.totalDue,
      unpaidOrders: due.data.orders.length,
      openManualOrders: openPool.total + assigned.total + inReview.total,
      vanProducts: vanStock.length,
      lowStock: lowStock,
      duesCachedAt: due.isCached ? due.fetchedAt : null,
      fromCache: due.isCached,
      isStale: due.isStale,
    );
  }

  void _applyDueRevalidate(ReportResult<SalesPersonDueReport> result) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        totalDue: result.data.totalDue,
        unpaidOrders: result.data.orders.length,
        duesCachedAt: result.fetchedAt,
        fromCache: result.isCached,
        isStale: result.isStale,
      ),
    );
  }
}

class DuesData {
  const DuesData({
    required this.report,
    this.fetchedAt,
    this.fromCache = false,
    this.isStale = false,
  });

  final SalesPersonDueReport report;
  final String? fetchedAt;
  final bool fromCache;
  final bool isStale;

  DuesData copyWith({
    SalesPersonDueReport? report,
    String? fetchedAt,
    bool? fromCache,
    bool? isStale,
  }) {
    return DuesData(
      report: report ?? this.report,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      fromCache: fromCache ?? this.fromCache,
      isStale: isStale ?? this.isStale,
    );
  }
}

final duesProvider = AsyncNotifierProvider<DuesNotifier, DuesData>(DuesNotifier.new);

class DuesNotifier extends AsyncNotifier<DuesData> {
  var _forceRefresh = false;

  @override
  Future<DuesData> build() async => _load();

  Future<void> refresh() async {
    _forceRefresh = true;
    state = const AsyncLoading();
    state = AsyncData(await _load());
    _forceRefresh = false;
  }

  Future<DuesData> _load() async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null) throw Exception('no_profile');

    final result = await ref.read(reportRepositoryProvider).salesPersonDue(
          salesPersonId,
          forceRefresh: _forceRefresh,
          onRevalidate: (revalidated) {
            final current = state.asData?.value;
            if (current == null) return;
            state = AsyncData(
              current.copyWith(
                report: revalidated.data,
                fetchedAt: revalidated.fetchedAt,
                fromCache: revalidated.isCached,
                isStale: revalidated.isStale,
              ),
            );
          },
        );
    return DuesData(
      report: result.data,
      fetchedAt: result.fetchedAt,
      fromCache: result.isCached,
      isStale: result.isStale,
    );
  }
}

class OrderListState {
  const OrderListState({
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

  OrderListState copyWith({
    List<OrderModel>? orders,
    int? currentPage,
    int? lastPage,
    bool? loadingMore,
  }) {
    return OrderListState(
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }
}

final orderListProvider = AsyncNotifierProvider<OrderListNotifier, OrderListState>(OrderListNotifier.new);

class OrderListNotifier extends AsyncNotifier<OrderListState> {
  static const _perPage = 25;

  @override
  Future<OrderListState> build() async => _loadPage(1);

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadPage(1));
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await _loadPage(current.currentPage + 1, append: current.orders);
      state = AsyncData(next);
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }

  Future<OrderListState> _loadPage(int page, {List<OrderModel>? append}) async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (page == 1 && ref.read(onlineStatusProvider)) {
      unawaited(
        ref.read(syncServiceProvider).syncIfOnline().timeout(
          const Duration(seconds: 30),
          onTimeout: () {},
        ),
      );
    }
    final result = await ref.read(offlineOrderRepositoryProvider).list(
          salesPersonId: salesPersonId,
          page: page,
          perPage: _perPage,
        );
    final orders = page == 1 ? result.items : [...?append, ...result.items];
    return OrderListState(
      orders: orders,
      currentPage: result.currentPage,
      lastPage: result.lastPage,
    );
  }
}

void invalidateSalesScreenProviders(WidgetRef ref) {
  ref.invalidate(dashboardProvider);
  ref.invalidate(orderListProvider);
  ref.invalidate(duesProvider);
}
