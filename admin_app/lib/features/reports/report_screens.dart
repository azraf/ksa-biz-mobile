import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/repositories.dart';
import '../../providers/screen_providers.dart';

class SalesReportScreen extends ConsumerStatefulWidget {
  const SalesReportScreen({super.key});
  @override
  ConsumerState<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends ConsumerState<SalesReportScreen> {
  late String _from;
  late String _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    _to = DateFormat('yyyy-MM-dd').format(now);
  }

  void _refresh() {
    ref.invalidate(salesReportProvider(SalesReportParams(from: _from, to: _to)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final params = SalesReportParams(from: _from, to: _to);
    final reportAsync = ref.watch(salesReportProvider(params));

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
            ],
          ),
          Expanded(
            child: reportAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorView(
                message: AppErrorMapper.localize(context, e),
                error: e,
                onRetry: _refresh,
              ),
              data: (result) => ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (result.isCached) _cachedBanner(context, l10n, result.fetchedAt),
                  Text('Orders: ${result.data.ordersCount}'),
                  Text('Total: SAR ${result.data.totalBill.toStringAsFixed(2)}'),
                  if (result.fetchedAt != null)
                    Text(
                      'Updated: ${result.fetchedAt!.substring(0, 16)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  const Divider(),
                  const Text('By Product', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...result.data.byProduct.map(
                    (p) => ListTile(
                      title: Text('Product #${p.productId}'),
                      trailing: Text('${p.qty} — SAR ${p.revenue.toStringAsFixed(2)}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cachedBanner(BuildContext context, AppLocalizations l10n, String? fetchedAt) {
    final label = fetchedAt != null ? fetchedAt.substring(0, 16) : '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MaterialBanner(
        content: Text(l10n.adminShowingCachedList(label)),
        leading: const Icon(Icons.cloud_off_outlined),
        actions: [TextButton(onPressed: _refresh, child: Text(l10n.commonRetry))],
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
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool force = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _result = await ref.read(reportRepositoryProvider).profit(forceRefresh: force);
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: LoadingView());
    if (_error != null) {
      return Scaffold(
        body: ErrorView(
          message: AppErrorMapper.localize(context, _error!),
          error: _error,
          onRetry: () => _load(force: true),
        ),
      );
    }

    final r = _result!.data;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_result!.isCached) const Text('Cached data', style: TextStyle(color: Colors.grey)),
            Text('Revenue: SAR ${r.revenue.toStringAsFixed(2)}'),
            Text('Cost: SAR ${r.cost.toStringAsFixed(2)}'),
            Text('Profit: SAR ${r.profit.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
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
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool force = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _result = await ref.read(reportRepositoryProvider).expenses(forceRefresh: force);
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: LoadingView());
    if (_error != null) {
      return Scaffold(
        body: ErrorView(
          message: AppErrorMapper.localize(context, _error!),
          error: _error,
          onRetry: () => _load(force: true),
        ),
      );
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_result!.isCached) const Text('Cached data (offline)', style: TextStyle(color: Colors.grey)),
          Text('Total: SAR ${_result!.data.totalAmount.toStringAsFixed(2)}'),
          ..._result!.data.byCategory.map((c) => ListTile(
                title: Text(c.categoryName ?? 'Category'),
                trailing: Text('SAR ${c.total.toStringAsFixed(2)}'),
              )),
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
  late String _from;
  late String _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = '${now.year}-01-01';
    _to = DateFormat('yyyy-MM-dd').format(now);
  }

  void _refresh() {
    ref.invalidate(expenseSummaryReportProvider(ExpenseSummaryParams(from: _from, to: _to)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final params = ExpenseSummaryParams(from: _from, to: _to);
    final reportAsync = ref.watch(expenseSummaryReportProvider(params));

    return Scaffold(
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          message: AppErrorMapper.localize(context, e),
          error: e,
          onRetry: _refresh,
        ),
        data: (result) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (result.isCached)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: MaterialBanner(
                  content: Text(l10n.adminShowingCachedList(
                    result.fetchedAt != null ? result.fetchedAt!.substring(0, 16) : '',
                  )),
                  leading: const Icon(Icons.cloud_off_outlined),
                  actions: [TextButton(onPressed: _refresh, child: Text(l10n.commonRetry))],
                ),
              ),
            Text(
              'Grand Total: SAR ${result.data.grandTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...result.data.byPeriod.map((p) => ListTile(
                  title: Text(p.periodKey ?? ''),
                  trailing: Text('SAR ${p.total.toStringAsFixed(2)}'),
                )),
          ],
        ),
      ),
    );
  }
}
