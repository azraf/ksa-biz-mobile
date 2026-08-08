import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import '../../widgets/first_run_tips.dart';
import '../watchlist/watchlist_screens.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _loading = true;
  String? _error;
  bool? _needsSalesPersonSelection;
  double _totalDue = 0;
  int _unpaidOrders = 0;
  int _openManualOrders = 0;
  int _vanProducts = 0;
  int _lowStock = 0;
  bool _forceRefresh = false;
  bool _duesFromCache = false;
  bool _duesIsStale = false;
  String? _duesCachedAt;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final auth = ref.read(authProvider);
    final salesPersonId = requireSalesPersonId(auth);
    if (salesPersonId == null) {
      setState(() {
        _loading = false;
        _needsSalesPersonSelection = auth.canPickSalesPerson;
        _error = '';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _needsSalesPersonSelection = null;
    });

    try {
      final reportRepo = ref.read(reportRepositoryProvider);
      final manualRepo = ref.read(manualOrderRepositoryProvider);
      final inventoryRepo = ref.read(inventoryRepositoryProvider);
      final force = _forceRefresh;

      final due = await reportRepo.salesPersonDue(
        salesPersonId,
        forceRefresh: force,
        onRevalidate: _applyDuesRevalidate,
      );
      final results = await Future.wait([
        manualRepo.list(openPool: true),
        manualRepo.list(assignedSalesPersonId: salesPersonId, status: 'assigned'),
        manualRepo.list(assignedSalesPersonId: salesPersonId, status: 'in_review'),
        inventoryRepo.vanStock(salesPersonId),
      ]);
      final openPool = results[0] as PaginatedResponse<ManualOrderRequestModel>;
      final assigned = results[1] as PaginatedResponse<ManualOrderRequestModel>;
      final inReview = results[2] as PaginatedResponse<ManualOrderRequestModel>;
      final vanStock = results[3] as List<InventoryStockModel>;

      setState(() {
        _totalDue = due.data.totalDue;
        _unpaidOrders = due.data.orders.length;
        _duesFromCache = due.isCached;
        _duesIsStale = due.isStale;
        _duesCachedAt = due.fetchedAt;
        _openManualOrders = openPool.total + assigned.total + inReview.total;
        _vanProducts = vanStock.length;
        _lowStock = vanStock.where((s) {
          final alert = s.product?.alertQuantity ?? 0;
          return alert > 0 && s.balance <= alert;
        }).length;
        _forceRefresh = false;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _refresh() async {
    _forceRefresh = true;
    await _load();
  }

  void _applyDuesRevalidate(ReportResult<SalesPersonDueReport> result) {
    if (!mounted) return;
    setState(() {
      _totalDue = result.data.totalDue;
      _unpaidOrders = result.data.orders.length;
      _duesFromCache = result.isCached;
      _duesIsStale = result.isStale;
      _duesCachedAt = result.fetchedAt;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider);
    final currency = NumberFormat.currency(symbol: 'SAR ');

    if (_loading) return const SkeletonDashboard();
    if (_needsSalesPersonSelection != null) {
      final message = _needsSalesPersonSelection!
          ? l10n.salesDashboardSelectSp
          : l10n.salesDashboardNoProfile;
      return ErrorView(
        message: message,
        onRetry: _needsSalesPersonSelection! ? () => context.go('/select-salesperson') : _load,
      );
    }
    if (_error != null && _error!.isNotEmpty) {
      return ErrorView(
        message: _error!,
        onRetry: auth.canPickSalesPerson ? () => context.go('/select-salesperson') : _load,
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_duesFromCache && _duesIsStale && _duesCachedAt != null)
            NoticeCard(
              kind: NoticeKind.info,
              icon: Icons.cloud_off_outlined,
              title: l10n.salesDashboardCachedDues(_duesCachedAt!.substring(0, 16)),
              actionLabel: l10n.commonRetry,
              onAction: _refresh,
            ),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.salesHello(auth.user?.name ?? l10n.salesDefaultSalesperson),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.push('/notifications'),
              ),
            ],
          ),
          if (auth.activeSalesPerson != null)
            Text(l10n.salesActingAsName(auth.activeSalesPerson!.name), style: Theme.of(context).textTheme.bodyMedium)
          else if (auth.salesPerson != null)
            Text(auth.salesPerson!.name, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          KpiCard(
            title: l10n.salesCardOutstandingDues,
            value: currency.format(_totalDue),
            subtitle: l10n.salesCardUnpaidOrders(_unpaidOrders),
            icon: Icons.payments,
            onTap: () => context.go('/dues'),
          ),
          const SizedBox(height: AppSpacing.md),
          KpiCard(
            title: l10n.salesCardManualOrders,
            value: '$_openManualOrders',
            subtitle: l10n.salesCardManualSubtitle,
            icon: Icons.phone_in_talk,
            onTap: () => context.go('/manual-orders'),
          ),
          const SizedBox(height: AppSpacing.md),
          KpiCard(
            title: l10n.salesCardVanStock,
            value: l10n.salesCardVanProducts(_vanProducts),
            subtitle: _lowStock > 0
                ? l10n.salesCardLowStockAlerts(_lowStock)
                : l10n.salesCardTapManageStock,
            icon: Icons.local_shipping,
            onTap: () => context.go('/van-stock'),
          ),
          const SizedBox(height: AppSpacing.md),
          KpiCard(
            title: l10n.salesCardMyOrders,
            value: l10n.salesCardViewAll,
            subtitle: l10n.salesCardOrdersSubtitle,
            icon: Icons.receipt_long,
            onTap: () => context.go('/orders'),
          ),
          const SizedBox(height: AppSpacing.md),
          KpiCard(
            title: l10n.salesCardCustomers,
            value: l10n.salesCardCustomersValue,
            subtitle: l10n.salesCardCustomersSubtitle,
            icon: Icons.people_outline,
            onTap: () => context.push('/customers'),
          ),
          const SizedBox(height: AppSpacing.md),
          KpiCard(
            title: l10n.salesCardWatchlist,
            value: l10n.salesCardWatchlistValue,
            subtitle: l10n.salesCardWatchlistSubtitle,
            icon: Icons.bookmark_add_outlined,
            onTap: () => context.push('/watchlist'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => quickSaveWatchlistLocation(context, ref),
            icon: const Icon(Icons.add_location_alt),
            label: Text(l10n.salesQuickSaveLocation),
          ),
        ],
      ),
        ),
        FirstRunTips(prefs: ref.watch(sharedPreferencesProvider)),
      ],
    );
  }
}
