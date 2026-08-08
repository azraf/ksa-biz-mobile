import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';

class SalesReportScreen extends ConsumerStatefulWidget {
  const SalesReportScreen({super.key});

  @override
  ConsumerState<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends ConsumerState<SalesReportScreen> {
  ReportResult<SalesReport>? _result;
  bool _loading = true;
  late String _from;
  late String _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    _to = DateFormat('yyyy-MM-dd').format(now);
    _load();
  }

  Future<void> _load({bool force = false}) async {
    setState(() => _loading = true);
    try {
      _result = await ref.read(reportRepositoryProvider).sales(
            fromDate: _from,
            toDate: _to,
            forceRefresh: force,
          );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();

    return RefreshIndicator(
      onRefresh: () => _load(force: true),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_result?.isCached == true)
            const NoticeCard(
              kind: NoticeKind.info,
              icon: Icons.offline_pin,
              title: 'Showing cached data',
              subtitle: 'Connect to refresh from server',
            ),
          Text('Orders: ${_result?.data.ordersCount ?? 0}'),
          Text('Total: SAR ${(_result?.data.totalBill ?? 0).toStringAsFixed(2)}'),
          if (_result?.fetchedAt != null)
            Text(
              'Updated: ${_result!.fetchedAt!.substring(0, 16)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          const Divider(),
          const Text('By product', style: TextStyle(fontWeight: FontWeight.bold)),
          ...(_result?.data.byProduct ?? []).map(
            (p) => ListTile(
              title: Text('Product #${p.productId}'),
              trailing: Text('${p.qty} — SAR ${p.revenue.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfitReportScreen extends ConsumerStatefulWidget {
  const ProfitReportScreen({super.key});

  @override
  ConsumerState<ProfitReportScreen> createState() => _ProfitReportScreenState();
}

class _ProfitReportScreenState extends ConsumerState<ProfitReportScreen> {
  ReportResult<ProfitReport>? _result;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool force = false}) async {
    setState(() => _loading = true);
    _result = await ref.read(reportRepositoryProvider).profit(forceRefresh: force);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();

    final r = _result?.data;
    return RefreshIndicator(
      onRefresh: () => _load(force: true),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_result?.isCached == true)
            Text('Cached data', style: Theme.of(context).textTheme.bodySmall),
          Text('Revenue: SAR ${(r?.revenue ?? 0).toStringAsFixed(2)}'),
          Text('Cost: SAR ${(r?.cost ?? 0).toStringAsFixed(2)}'),
          Text(
            'Profit: SAR ${(r?.profit ?? 0).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ExpenseReportScreen extends ConsumerStatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  ConsumerState<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends ConsumerState<ExpenseReportScreen> {
  ReportResult<ExpenseReport>? _result;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool force = false}) async {
    setState(() => _loading = true);
    _result = await ref.read(reportRepositoryProvider).expenses(forceRefresh: force);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();

    return RefreshIndicator(
      onRefresh: () => _load(force: true),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_result?.isCached == true)
            Text('Cached data', style: Theme.of(context).textTheme.bodySmall),
          Text('Total: SAR ${(_result?.data.totalAmount ?? 0).toStringAsFixed(2)}'),
          ...(_result?.data.byCategory ?? []).map(
            (c) => ListTile(
              title: Text(c.categoryName ?? 'Category'),
              trailing: Text('SAR ${c.total.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseSummaryReportScreen extends ConsumerStatefulWidget {
  const ExpenseSummaryReportScreen({super.key});

  @override
  ConsumerState<ExpenseSummaryReportScreen> createState() => _ExpenseSummaryReportScreenState();
}

class _ExpenseSummaryReportScreenState extends ConsumerState<ExpenseSummaryReportScreen> {
  ReportResult<ExpenseSummaryReport>? _result;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool force = false}) async {
    setState(() => _loading = true);
    final now = DateTime.now();
    _result = await ref.read(reportRepositoryProvider).expenseSummary(
          fromDate: '${now.year}-01-01',
          toDate: DateFormat('yyyy-MM-dd').format(now),
          forceRefresh: force,
        );
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();

    return RefreshIndicator(
      onRefresh: () => _load(force: true),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_result?.isCached == true)
            Text('Cached data', style: Theme.of(context).textTheme.bodySmall),
          Text(
            'Grand total: SAR ${(_result?.data.grandTotal ?? 0).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...(_result?.data.byPeriod ?? []).map(
            (p) => ListTile(
              title: Text(p.periodKey ?? ''),
              trailing: Text('SAR ${p.total.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }
}
