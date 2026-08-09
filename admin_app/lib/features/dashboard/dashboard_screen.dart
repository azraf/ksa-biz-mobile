import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  SalesReport? _sales;
  ExpenseSummaryReport? _expenseSummary;
  int _pendingOrders = 0;
  int _pendingSync = 0;
  bool _loading = true;
  bool _forceRefresh = false;
  String? _salesCachedAt;
  String? _expenseCachedAt;
  bool _salesFromCache = false;
  bool _salesIsStale = false;
  bool _expenseFromCache = false;
  bool _expenseIsStale = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
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
          onRevalidate: _applySalesRevalidate,
        ),
        reports.expenseSummary(
          fromDate: '${now.year}-01-01',
          toDate: to,
          forceRefresh: force,
          onRevalidate: _applyExpenseRevalidate,
        ),
      ]);

      final salesResult = reportResults[0] as ReportResult<SalesReport>;
      final expenseResult = reportResults[1] as ReportResult<ExpenseSummaryReport>;

      var pendingManualOrders = 0;
      try {
        final manualOrders = await ref.read(manualOrderRepositoryProvider).list(status: 'pending');
        pendingManualOrders = manualOrders.total;
      } catch (_) {}

      final pendingSync = await ref.read(localDatabaseProvider).pendingCount();

      if (!mounted) return;
      setState(() {
        _sales = salesResult.data;
        _salesCachedAt = salesResult.fetchedAt;
        _salesFromCache = salesResult.isCached;
        _salesIsStale = salesResult.isStale;
        _expenseSummary = expenseResult.data;
        _expenseCachedAt = expenseResult.fetchedAt;
        _expenseFromCache = expenseResult.isCached;
        _expenseIsStale = expenseResult.isStale;
        _pendingOrders = pendingManualOrders;
        _pendingSync = pendingSync;
        _forceRefresh = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dashboard: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refresh() async {
    _forceRefresh = true;
    await _load();
  }

  void _applySalesRevalidate(ReportResult<SalesReport> result) {
    if (!mounted) return;
    setState(() {
      _sales = result.data;
      _salesCachedAt = result.fetchedAt;
      _salesFromCache = result.isCached;
      _salesIsStale = result.isStale;
    });
  }

  void _applyExpenseRevalidate(ReportResult<ExpenseSummaryReport> result) {
    if (!mounted) return;
    setState(() {
      _expenseSummary = result.data;
      _expenseCachedAt = result.fetchedAt;
      _expenseFromCache = result.isCached;
      _expenseIsStale = result.isStale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SkeletonDashboard();
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppUpdateNotice(api: ref.read(apiClientProvider)),
          if (_pendingSync > 0)
            NoticeCard(
              kind: NoticeKind.warning,
              icon: Icons.sync_problem,
              title: '$_pendingSync pending sync',
              subtitle: 'Orders/expenses waiting to upload',
              actionLabel: 'Sync',
              onAction: () {
                ref.read(syncServiceProvider).syncIfOnline();
                _load();
              },
            ),
          if ((_salesFromCache && _salesIsStale && _salesCachedAt != null) ||
              (_expenseFromCache && _expenseIsStale && _expenseCachedAt != null))
            NoticeCard(
              kind: NoticeKind.info,
              icon: Icons.cloud_off_outlined,
              title:
                  'Showing cached data from ${(_salesCachedAt ?? _expenseCachedAt)!.substring(0, 16)}',
              actionLabel: 'Retry',
              onAction: _refresh,
            ),
          KpiCard(
            title: 'Sales (this month)',
            value: '${_sales?.ordersCount ?? 0} orders',
            subtitle: 'SAR ${(_sales?.totalBill ?? 0).toStringAsFixed(2)}',
            icon: Icons.receipt_long,
            caption: _salesFromCache && _salesCachedAt != null
                ? 'Updated: ${_salesCachedAt!.substring(0, 16)}'
                : null,
            onTap: () => context.go('/reports/sales'),
          ),
          const SizedBox(height: AppSpacing.md),
          KpiCard(
            title: 'Expenses (YTD)',
            value: 'SAR ${(_expenseSummary?.grandTotal ?? 0).toStringAsFixed(2)}',
            subtitle: '${_expenseSummary?.byPeriod.length ?? 0} periods',
            icon: Icons.payments,
            caption: _expenseFromCache && _expenseCachedAt != null
                ? 'Updated: ${_expenseCachedAt!.substring(0, 16)}'
                : null,
            onTap: () => context.go('/reports/expense-summary'),
          ),
          const SizedBox(height: AppSpacing.md),
          KpiCard(
            title: 'Pending manual orders',
            value: '$_pendingOrders',
            subtitle: 'Awaiting review',
            icon: Icons.phone_in_talk,
            onTap: () => context.go('/sales/manual-orders'),
          ),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Quick links'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(label: const Text('New Order'), onPressed: () => context.go('/sales/orders/create')),
              ActionChip(label: const Text('New Expense'), onPressed: () => context.go('/expenses/list/create')),
              ActionChip(label: const Text('Products'), onPressed: () => context.go('/catalog/products')),
              ActionChip(label: const Text('Warehouse'), onPressed: () => context.go('/inventory/warehouse')),
            ],
          ),
        ],
      ),
    );
  }
}
