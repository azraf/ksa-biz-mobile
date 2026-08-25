import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/format_providers.dart';
import '../../providers/repositories.dart';
import '../orders/collect_payment_screen.dart';
import '../plan/visit_form_sheet.dart';

/// One prepared dues row: the parsed order plus what the server report does
/// not carry — a locally resolved customer name and any offline-collected
/// payment still sitting in the sync outbox.
class _DueRow {
  const _DueRow({
    required this.order,
    required this.serverDue,
    this.customerName,
    this.queuedPayment = 0,
  });

  final OrderModel order;

  /// Due as the server sees it. The dues report serializes raw orders (no
  /// amount_due/amount_paid columns exist), so this is derived from the
  /// included payments relation the way Order::getAmountDue() does.
  final double serverDue;
  final String? customerName;

  /// Sum of payments queued offline for this order, not yet synced.
  final double queuedPayment;

  double get displayDue =>
      (serverDue - queuedPayment).clamp(0, double.infinity).toDouble();
}

class DuesScreen extends ConsumerStatefulWidget {
  const DuesScreen({super.key});

  @override
  ConsumerState<DuesScreen> createState() => _DuesScreenState();
}

class _DuesScreenState extends ConsumerState<DuesScreen> {
  SalesPersonDueReport? _report;
  List<_DueRow> _rows = const [];
  double _queuedTotal = 0;
  bool _loading = true;
  bool _missingSalesPerson = false;
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
    if (salesPersonId == null) {
      // Same guard as the dashboard/watch-list: an account with no linked
      // salesperson is a recoverable state, not a crash.
      setState(() {
        _missingSalesPerson = true;
        _loading = false;
        _error = null;
      });
      return;
    }
    setState(() {
      _missingSalesPerson = false;
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref.read(reportRepositoryProvider).salesPersonDue(
            salesPersonId,
            forceRefresh: _forceRefresh,
            onRevalidate: _applyRevalidate,
          );
      final rows = await _buildRows(result.data);
      if (!mounted) return;
      setState(() {
        _report = result.data;
        _rows = rows;
        _queuedTotal = rows.fold(0.0, (sum, r) => sum + r.queuedPayment);
        _fromCache = result.isCached;
        _isStale = result.isStale;
        _fetchedAt = result.fetchedAt;
        _forceRefresh = false;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
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
    _buildRows(result.data).then((rows) {
      if (!mounted) return;
      setState(() {
        _report = result.data;
        _rows = rows;
        _queuedTotal = rows.fold(0.0, (sum, r) => sum + r.queuedPayment);
        _fromCache = result.isCached;
        _isStale = result.isStale;
        _fetchedAt = result.fetchedAt;
      });
    });
  }

  /// Parses the raw report orders, resolves customer names from the local
  /// cache (the report API sends only ids — see report), folds in queued
  /// offline payments, and sorts by customer then oldest due first.
  Future<List<_DueRow>> _buildRows(SalesPersonDueReport report) async {
    // Offline-collected payments still in the sync outbox, summed per order,
    // so a due doesn't look uncollected after the cash was already taken.
    final queued = <int, double>{};
    try {
      final items = await ref.read(localDatabaseProvider).actionableSyncItems();
      for (final item in items) {
        if (item.entityType != 'order' || item.operation != 'payment') continue;
        final orderId = item.serverId;
        if (orderId == null) continue;
        final amount = item.payload['amount'];
        final value = amount is num ? amount.toDouble() : double.tryParse('$amount') ?? 0.0;
        queued[orderId] = (queued[orderId] ?? 0) + value;
      }
    } catch (_) {}

    final customerRepo = ref.read(offlineCustomerRepositoryProvider);
    final names = <String, String?>{};
    final rows = <_DueRow>[];
    for (final raw in report.orders) {
      final OrderModel order;
      try {
        order = OrderModel.fromJson(raw);
      } catch (_) {
        continue; // one malformed row must not blank the whole screen
      }
      String? name = order.customerShopName;
      final target = _customerRef(order);
      if ((name == null || name.isEmpty) && target != null) {
        final key = '${target.type}_${target.id}';
        if (!names.containsKey(key)) {
          try {
            names[key] = await customerRepo.cachedCustomerName(target.type, target.id);
          } catch (_) {
            names[key] = null;
          }
        }
        name = names[key];
      }
      rows.add(_DueRow(
        order: order,
        serverDue: _serverDue(order),
        customerName: (name != null && name.isEmpty) ? null : name,
        queuedPayment: queued[order.id] ?? 0,
      ));
    }
    rows.sort(_compareRows);
    return rows;
  }

  /// Report rows lack amount_due/amount_paid (raw table columns only), so
  /// outstandingDue would degrade to the full bill. Derive the real due from
  /// the payments relation the report does include, mirroring the server's
  /// Order::getAmountDue().
  static double _serverDue(OrderModel order) {
    if (order.amountDue > 0 || order.amountPaid > 0 || order.payments.isEmpty) {
      return order.outstandingDue;
    }
    final paid = order.payments
        .where((p) => !p.isVoided)
        .fold(0.0, (sum, p) => sum + p.amount);
    return (order.totalBill - paid).clamp(0, double.infinity).toDouble();
  }

  static ({String type, int id})? _customerRef(OrderModel order) {
    if (order.customerShopId != null) return (type: 'customer_shop', id: order.customerShopId!);
    if (order.customerVanId != null) return (type: 'customer_van', id: order.customerVanId!);
    if (order.customerImporterId != null) {
      return (type: 'customer_importer', id: order.customerImporterId!);
    }
    return null;
  }

  /// Named customers alphabetically, unnamed grouped per customer after them;
  /// within one customer, oldest due first.
  static int _compareRows(_DueRow a, _DueRow b) {
    final an = a.customerName?.toLowerCase();
    final bn = b.customerName?.toLowerCase();
    int byCustomer;
    if (an != null && bn != null) {
      byCustomer = an.compareTo(bn);
    } else if (an != null) {
      byCustomer = -1;
    } else if (bn != null) {
      byCustomer = 1;
    } else {
      byCustomer = _anonKey(a).compareTo(_anonKey(b));
    }
    if (byCustomer != 0) return byCustomer;
    return _dueDateKey(a.order).compareTo(_dueDateKey(b.order));
  }

  static String _anonKey(_DueRow row) {
    final ref = _customerRef(row.order);
    return ref == null ? 'order_${row.order.id}' : '${ref.type}_${ref.id}';
  }

  /// ISO strings compare lexicographically; missing dates sort last.
  static String _dueDateKey(OrderModel order) =>
      order.dueDate ?? order.createdAt ?? '9999-12-31';

  /// Server appends days_overdue only on the order endpoints, not on this
  /// report — derive it from due_date when absent.
  static int _daysOverdue(OrderModel order) {
    if (order.daysOverdue > 0) return order.daysOverdue;
    final raw = order.dueDate;
    if (raw == null) return 0;
    final due = DateTime.tryParse(raw);
    if (due == null) return 0;
    final now = DateTime.now();
    final days = DateTime(now.year, now.month, now.day)
        .difference(DateTime(due.year, due.month, due.day))
        .inDays;
    return days > 0 ? days : 0;
  }

  Future<void> _collectPayment(_DueRow row) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CollectPaymentScreen(orderId: row.order.id, amountDue: row.displayDue),
      ),
    );
    if (ok == true) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencyFormatProvider);

    if (_loading) return LoadingView(message: l10n.commonLoading);
    if (_missingSalesPerson) {
      return ErrorView(message: l10n.salesSelectSalespersonFirst, onRetry: _load);
    }
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final report = _report!;
    final displayTotal =
        (report.totalDue - _queuedTotal).clamp(0, double.infinity).toDouble();
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
              subtitle: _queuedTotal > 0
                  ? Text(l10n.salesDuesIncludesUnsynced)
                  : null,
              trailing: Text(currency.format(displayTotal),
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          if (_rows.isEmpty) EmptyView(message: l10n.salesEmptyDuesHint),
          for (final row in _rows) _dueTile(context, row, l10n, currency),
          const SizedBox(height: 8),
          Text(l10n.salesDuesLongPressHint),
        ],
      ),
    );
  }

  Widget _dueTile(
    BuildContext context,
    _DueRow row,
    AppLocalizations l10n,
    NumberFormat currency,
  ) {
    final order = row.order;
    final theme = Theme.of(context);
    final days = _daysOverdue(order);
    return Card(
      child: ListTile(
        title: Text(row.customerName ?? l10n.commonOrderNumber(order.id)),
        // Text.rich instead of a Column: ListTile.subtitle Columns have blanked
        // rows in release builds before (see _CustomerListTile).
        subtitle: Text.rich(
          TextSpan(
            children: [
              if (row.customerName != null)
                TextSpan(text: '${l10n.commonOrderNumber(order.id)}\n'),
              TextSpan(
                text:
                    '${localizedStatusLabel(context, order.paymentStatus)} · ${l10n.commonDue} ${currency.format(row.displayDue)}',
              ),
              if (days > 0)
                TextSpan(
                  text: '\n${l10n.commonOverdue} · ${l10n.commonOverdueDays(days)}',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (row.queuedPayment > 0)
                TextSpan(
                  text: '\n${l10n.salesDuesIncludesUnsynced}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currency.format(order.totalBill)),
            if (order.customerShopId != null)
              IconButton(
                icon: const Icon(Icons.event_outlined),
                tooltip: l10n.planScheduleVisit,
                onPressed: () => showVisitFormSheet(
                  context,
                  ref,
                  prefill: VisitPrefill(
                    customerType: 'customer_shop',
                    customerId: order.customerShopId,
                    customerName: order.customerShopName ?? row.customerName,
                    purpose: 'due_collection',
                    scheduledAt: DateTime.now()
                        .add(const Duration(days: 1))
                        .copyWith(hour: 9, minute: 0),
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.payments_outlined),
              tooltip: l10n.salesDuesCollect,
              onPressed: () => _collectPayment(row),
            ),
          ],
        ),
        onTap: () => context.push('/orders/${order.id}'),
        // The on-screen hint promises exactly this gesture.
        onLongPress: () => _collectPayment(row),
      ),
    );
  }
}
