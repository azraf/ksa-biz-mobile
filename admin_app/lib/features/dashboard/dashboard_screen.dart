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
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_pendingSync > 0)
            Card(
              color: Colors.orange.shade50,
              child: ListTile(
                leading: const Icon(Icons.sync_problem),
                title: Text('$_pendingSync pending sync'),
                subtitle: const Text('Orders/expenses waiting to upload'),
                trailing: TextButton(
                  onPressed: () {
                    ref.read(syncServiceProvider).syncIfOnline();
                    _load();
                  },
                  child: const Text('Sync'),
                ),
              ),
            ),
          if ((_salesFromCache && _salesIsStale && _salesCachedAt != null) ||
              (_expenseFromCache && _expenseIsStale && _expenseCachedAt != null))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MaterialBanner(
                content: Text(
                  'Showing cached data from ${(_salesCachedAt ?? _expenseCachedAt)!.substring(0, 16)}',
                ),
                leading: const Icon(Icons.cloud_off_outlined),
                actions: [
                  TextButton(onPressed: _refresh, child: const Text('Retry')),
                ],
              ),
            ),
          _kpiCard(
            'Sales (this month)',
            '${_sales?.ordersCount ?? 0} orders',
            'SAR ${(_sales?.totalBill ?? 0).toStringAsFixed(2)}',
            Icons.receipt_long,
            cachedAt: _salesFromCache ? _salesCachedAt : null,
            onTap: () => context.go('/reports/sales'),
          ),
          _kpiCard(
            'Expenses (YTD)',
            'SAR ${(_expenseSummary?.grandTotal ?? 0).toStringAsFixed(2)}',
            '${_expenseSummary?.byPeriod.length ?? 0} periods',
            Icons.payments,
            cachedAt: _expenseFromCache ? _expenseCachedAt : null,
            onTap: () => context.go('/reports/expense-summary'),
          ),
          _kpiCard(
            'Pending manual orders',
            '$_pendingOrders',
            'Awaiting review',
            Icons.phone_in_talk,
            onTap: () => context.go('/sales/manual-orders'),
          ),
          const SizedBox(height: 16),
          Text('Quick links', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
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

  Widget _kpiCard(
    String title,
    String value,
    String subtitle,
    IconData icon, {
    String? cachedAt,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(subtitle),
            if (cachedAt != null)
              Text('Updated: ${cachedAt.substring(0, 16)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
