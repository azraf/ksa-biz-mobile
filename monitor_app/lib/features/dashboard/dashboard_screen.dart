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
  ProfitReport? _profit;
  ExpenseSummaryReport? _expenseSummary;
  int _pendingOrders = 0;
  int _orderCount = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final reports = ref.read(reportRepositoryProvider);
      final now = DateTime.now();
      final from = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
      final to = DateFormat('yyyy-MM-dd').format(now);

      final salesResult = await reports.sales(fromDate: from, toDate: to);
      final profitResult = await reports.profit();
      final expenseResult = await reports.expenseSummary(fromDate: '${now.year}-01-01', toDate: to);
      final manualOrders = await ref.read(manualOrderRepositoryProvider).list(status: 'pending');
      final orders = await ref.read(orderRepositoryProvider).list();

      setState(() {
        _sales = salesResult.data;
        _profit = profitResult.data;
        _expenseSummary = expenseResult.data;
        _pendingOrders = manualOrders.total;
        _orderCount = orders.total;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'SAR ');

    if (_loading) return const SkeletonDashboard();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(title: 'Business overview'),
          KpiCard(
            title: 'Sales (this month)',
            value: currency.format(_sales?.totalBill ?? 0),
            subtitle: '${_sales?.ordersCount ?? 0} orders',
            icon: Icons.receipt_long,
            onTap: () => context.go('/reports/sales'),
          ),
          const SizedBox(height: AppSpacing.md),
          KpiCard(
            title: 'Profit',
            value: currency.format(_profit?.profit ?? 0),
            subtitle: 'Revenue ${currency.format(_profit?.revenue ?? 0)}',
            icon: Icons.trending_up,
            onTap: () => context.go('/reports/profit'),
          ),
          const SizedBox(height: AppSpacing.md),
          KpiCard(
            title: 'Expenses (YTD)',
            value: currency.format(_expenseSummary?.grandTotal ?? 0),
            subtitle: '${_expenseSummary?.byPeriod.length ?? 0} periods',
            icon: Icons.payments,
            onTap: () => context.go('/reports/expense-summary'),
          ),
          const SizedBox(height: AppSpacing.md),
          KpiCard(
            title: 'Orders',
            value: '$_orderCount',
            subtitle: 'All orders',
            icon: Icons.shopping_cart_outlined,
            onTap: () => context.go('/sales'),
          ),
          const SizedBox(height: AppSpacing.md),
          KpiCard(
            title: 'Pending manual orders',
            value: '$_pendingOrders',
            subtitle: 'Awaiting review',
            icon: Icons.phone_in_talk,
            onTap: () => context.go('/sales'),
          ),
        ],
      ),
    );
  }
}
