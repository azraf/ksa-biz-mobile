import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import '../orders/collect_payment_screen.dart';

class DuesScreen extends ConsumerStatefulWidget {
  const DuesScreen({super.key});

  @override
  ConsumerState<DuesScreen> createState() => _DuesScreenState();
}

class _DuesScreenState extends ConsumerState<DuesScreen> {
  SalesPersonDueReport? _report;
  bool _loading = true;
  String? _error;
  bool _forceRefresh = false;
  bool _fromCache = false;
  bool _isStale = false;
  String? _fetchedAt;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref.read(reportRepositoryProvider).salesPersonDue(
            salesPersonId!,
            forceRefresh: _forceRefresh,
            onRevalidate: _applyRevalidate,
          );
      setState(() {
        _report = result.data;
        _fromCache = result.isCached;
        _isStale = result.isStale;
        _fetchedAt = result.fetchedAt;
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

  void _applyRevalidate(ReportResult<SalesPersonDueReport> result) {
    if (!mounted) return;
    setState(() {
      _report = result.data;
      _fromCache = result.isCached;
      _isStale = result.isStale;
      _fetchedAt = result.fetchedAt;
    });
  }

  Future<void> _collectPayment(OrderModel order) async {
    final due = order.amountDue > 0 ? order.amountDue : order.totalBill - order.amountPaid;
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CollectPaymentScreen(orderId: order.id, amountDue: due),
      ),
    );
    if (ok == true) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = NumberFormat.currency(symbol: 'SAR ');

    if (_loading) return LoadingView(message: l10n.commonLoading);
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final report = _report!;
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_fromCache && _isStale && _fetchedAt != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MaterialBanner(
                content: Text(l10n.salesDashboardCachedDues(_fetchedAt!.substring(0, 16))),
                leading: const Icon(Icons.cloud_off_outlined),
                actions: [
                  TextButton(onPressed: _refresh, child: Text(l10n.commonRetry)),
                ],
              ),
            ),
          Card(
            child: ListTile(
              title: Text(l10n.salesDuesTotalDue),
              trailing: Text(currency.format(report.totalDue), style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          if (report.orders.isEmpty) EmptyView(message: l10n.salesDuesNone),
          for (final raw in report.orders)
            Builder(
              builder: (_) {
                final order = OrderModel.fromJson(raw);
                final due = order.amountDue > 0 ? order.amountDue : order.totalBill - order.amountPaid;
                return Card(
                  child: ListTile(
                    title: Text(l10n.commonOrderNumber(order.id)),
                    subtitle: Text(
                      '${localizedStatusLabel(context, order.paymentStatus)} · ${l10n.commonDue} ${currency.format(due)}',
                    ),
                    trailing: Text(currency.format(order.totalBill)),
                    onTap: () => context.push('/orders/${order.id}'),
                    onLongPress: () => _collectPayment(order),
                  ),
                );
              },
            ),
          const SizedBox(height: 8),
          Text(l10n.salesDuesLongPressHint),
        ],
      ),
    );
  }
}
