import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/format_providers.dart';
import '../../providers/repositories.dart';
import '../../services/visit_reminder_service.dart';
import '../../widgets/first_run_tips.dart';
import '../watchlist/watchlist_screens.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _loading = true;
  bool? _needsSalesPersonSelection;
  double _totalDue = 0;
  int _unpaidOrders = 0;
  int _openManualOrders = 0;
  int _vanProducts = 0;
  int _lowStock = 0;
  int _todayVisits = 0;
  bool _forceRefresh = false;
  bool _duesFromCache = false;
  bool _duesIsStale = false;
  String? _duesCachedAt;
  // Per-section failure flags: each section fails independently so an
  // offline fetch never blanks out sections that did load (or have cache).
  bool _duesFailed = false;
  bool _manualFailed = false;
  bool _vanFailed = false;
  bool _duesEverLoaded = false;
  bool _manualEverLoaded = false;
  bool _vanEverLoaded = false;
  DateTime? _lastLoadedAt;
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // KPIs go stale after actions on other tabs; listen to navigation so
    // returning to the dashboard branch refetches (throttled in _onRouteChanged).
    final router = GoRouter.of(context);
    if (!identical(router, _router)) {
      _router?.routerDelegate.removeListener(_onRouteChanged);
      _router = router;
      router.routerDelegate.addListener(_onRouteChanged);
    }
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    if (!mounted || _loading) return;
    final uri = _router?.routerDelegate.currentConfiguration.uri;
    if (uri?.path != '/') return;
    final last = _lastLoadedAt;
    if (last == null ||
        DateTime.now().difference(last) < const Duration(seconds: 30)) {
      return;
    }
    _load();
  }

  Future<void> _load() async {
    final auth = ref.read(authProvider);
    final salesPersonId = requireSalesPersonId(auth);
    if (salesPersonId == null) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _needsSalesPersonSelection = auth.canPickSalesPerson;
      });
      return;
    }

    setState(() {
      _loading = true;
      _needsSalesPersonSelection = null;
    });

    final force = _forceRefresh;
    await Future.wait([
      _loadVisits(),
      _loadDues(salesPersonId, force),
      _loadManualOrders(salesPersonId),
      _loadVanStock(salesPersonId),
    ]);

    if (!mounted) return;
    setState(() {
      _forceRefresh = false;
      _loading = false;
    });
    _lastLoadedAt = DateTime.now();
  }

  // Cached and offline-safe; hidden as 0 on any failure.
  Future<void> _loadVisits() async {
    try {
      final now = DateTime.now();
      final visits = await ref
          .read(offlineVisitRepositoryProvider)
          .list(from: now, to: now);
      // Pending-sync rows can carry any date; count only today's schedule.
      _todayVisits = visits.plannedOn(DateTime(now.year, now.month, now.day));
    } catch (_) {}
  }

  Future<void> _loadDues(int salesPersonId, bool force) async {
    try {
      final due = await ref.read(reportRepositoryProvider).salesPersonDue(
            salesPersonId,
            forceRefresh: force,
            onRevalidate: _applyDuesRevalidate,
          );
      _totalDue = due.data.totalDue;
      _unpaidOrders = due.data.orders.length;
      _duesFromCache = due.isCached;
      _duesIsStale = due.isStale;
      _duesCachedAt = due.fetchedAt;
      _duesFailed = false;
      _duesEverLoaded = true;
    } catch (_) {
      _duesFailed = true;
    }
  }

  Future<void> _loadManualOrders(int salesPersonId) async {
    try {
      final manualRepo = ref.read(manualOrderRepositoryProvider);
      final results = await Future.wait([
        manualRepo.list(openPool: true),
        manualRepo.list(
          assignedSalesPersonId: salesPersonId,
          status: 'assigned',
        ),
        manualRepo.list(
          assignedSalesPersonId: salesPersonId,
          status: 'in_review',
        ),
      ]);
      _openManualOrders = results[0].total + results[1].total + results[2].total;
      _manualFailed = false;
      _manualEverLoaded = true;
    } catch (_) {
      _manualFailed = true;
    }
  }

  Future<void> _loadVanStock(int salesPersonId) async {
    try {
      final vanStock =
          await ref.read(inventoryRepositoryProvider).vanStock(salesPersonId);
      _vanProducts = vanStock.length;
      _lowStock = vanStock.where((s) {
        final alert = s.product?.alertQuantity ?? 0;
        return alert > 0 && s.balance <= alert;
      }).length;
      _vanFailed = false;
      _vanEverLoaded = true;
    } catch (_) {
      _vanFailed = true;
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
    final currency = ref.watch(currencyFormatProvider);

    // Cold start restores the session after this screen mounts: re-run the
    // load once auth finishes restoring (or the acting salesperson changes).
    ref.listen<AuthState>(authProvider, (previous, next) {
      final finishedLoading = (previous?.isLoading ?? false) && !next.isLoading;
      final salesPersonChanged =
          previous?.effectiveSalesPersonId != next.effectiveSalesPersonId;
      if (finishedLoading || salesPersonChanged) _load();
    });

    if (_loading) return const SkeletonDashboard();
    if (_needsSalesPersonSelection != null) {
      final message = _needsSalesPersonSelection!
          ? l10n.salesDashboardSelectSp
          : l10n.salesDashboardNoProfile;
      return ErrorView(
        message: message,
        onRetry: _needsSalesPersonSelection!
            ? () => context.go('/select-salesperson')
            : _load,
      );
    }
    final sectionsFailed = _duesFailed || _manualFailed || _vanFailed;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppUpdateNotice(api: ref.read(apiClientProvider)),
              if (sectionsFailed)
                NoticeCard(
                  kind: NoticeKind.info,
                  icon: Icons.cloud_off_outlined,
                  title: l10n.salesDashboardPartialLoadTitle,
                  subtitle: l10n.salesDashboardPartialLoadSubtitle,
                  actionLabel: l10n.commonRetry,
                  onAction: _refresh,
                ),
              if (_duesFromCache && _duesIsStale && _duesCachedAt != null)
                NoticeCard(
                  kind: NoticeKind.info,
                  icon: Icons.cloud_off_outlined,
                  title: l10n.salesDashboardCachedDues(
                    _duesCachedAt!.substring(0, 16),
                  ),
                  actionLabel: l10n.commonRetry,
                  onAction: _refresh,
                ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.salesHello(
                        auth.user?.name ?? l10n.salesDefaultSalesperson,
                      ),
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
                Text(
                  l10n.salesActingAsName(auth.activeSalesPerson!.name),
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              else if (auth.salesPerson != null)
                Text(
                  auth.salesPerson!.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              const SizedBox(height: 16),
              KpiCard(
                title: l10n.salesTitlePlan,
                value: l10n.planTodayVisits(_todayVisits),
                subtitle: l10n.planTabVisits,
                icon: Icons.event_available,
                onTap: () => context.go('/plan'),
              ),
              const SizedBox(height: AppSpacing.md),
              KpiCard(
                title: l10n.salesCardOutstandingDues,
                value: _duesFailed && !_duesEverLoaded
                    ? '—'
                    : currency.format(_totalDue),
                subtitle: _duesFailed && !_duesEverLoaded
                    ? '—'
                    : l10n.salesCardUnpaidOrders(_unpaidOrders),
                icon: Icons.payments,
                onTap: () => context.go('/plan?tab=dues'),
              ),
              const SizedBox(height: AppSpacing.md),
              KpiCard(
                title: l10n.salesCardManualOrders,
                value: _manualFailed && !_manualEverLoaded
                    ? '—'
                    : '$_openManualOrders',
                subtitle: l10n.salesCardManualSubtitle,
                icon: Icons.phone_in_talk,
                onTap: () => context.go('/manual-orders'),
              ),
              const SizedBox(height: AppSpacing.md),
              KpiCard(
                title: l10n.salesCardVanStock,
                value: _vanFailed && !_vanEverLoaded
                    ? '—'
                    : l10n.salesCardVanProducts(_vanProducts),
                subtitle: _lowStock > 0 && !(_vanFailed && !_vanEverLoaded)
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
              const SizedBox(height: AppSpacing.md),
              KpiCard(
                title: 'Field map',
                value: 'View',
                subtitle: 'Filterable map of your assigned customers',
                icon: Icons.map_outlined,
                onTap: () => context.push('/field-map'),
              ),
              const SizedBox(height: AppSpacing.md),
              KpiCard(
                title: 'Performance Review',
                value: 'View',
                subtitle: 'Your sales, cartons, and dues this month',
                icon: Icons.insights_outlined,
                onTap: () => context.push('/performance'),
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
