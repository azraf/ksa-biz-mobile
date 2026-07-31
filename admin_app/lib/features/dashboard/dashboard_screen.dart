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
  String? _salesCachedAt;
  String? _expenseCachedAt;

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

      final salesResult = await reports.sales(fromDate: from, toDate: to);
      final expenseResult = await reports.expenseSummary(fromDate: '${now.year}-01-01', toDate: to);
      final manualOrders = await ref.read(manualOrderRepositoryProvider).list(status: 'pending');
      final pendingSync = await ref.read(localDatabaseProvider).pendingCount();

      setState(() {
        _sales = salesResult.data;
        _salesCachedAt = salesResult.fetchedAt;
        _expenseSummary = expenseResult.data;
        _expenseCachedAt = expenseResult.fetchedAt;
        _pendingOrders = manualOrders.total;
        _pendingSync = pendingSync;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dashboard: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
              onRefresh: _load,
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
                  _kpiCard(
                    'Sales (this month)',
                    '${_sales?.ordersCount ?? 0} orders',
                    'SAR ${(_sales?.totalBill ?? 0).toStringAsFixed(2)}',
                    Icons.receipt_long,
                    cachedAt: _salesCachedAt,
                    onTap: () => context.go('/reports/sales'),
                  ),
                  _kpiCard(
                    'Expenses (YTD)',
                    'SAR ${(_expenseSummary?.grandTotal ?? 0).toStringAsFixed(2)}',
                    '${_expenseSummary?.byPeriod.length ?? 0} periods',
                    Icons.payments,
                    cachedAt: _expenseCachedAt,
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
