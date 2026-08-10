import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';

enum _SortKey {
  name,
  orders,
  orderValue,
  cartons,
  collected,
  outstanding,
  newShops,
}

extension on _SortKey {
  String get label => switch (this) {
    _SortKey.name => 'Name',
    _SortKey.orders => 'Orders',
    _SortKey.orderValue => 'Order value',
    _SortKey.cartons => 'Cartons',
    _SortKey.collected => 'Collected',
    _SortKey.outstanding => 'Outstanding',
    _SortKey.newShops => 'New shops',
  };

  Comparable value(SalesPersonPerformanceRow r) => switch (this) {
    _SortKey.name => r.name,
    _SortKey.orders => r.orders,
    _SortKey.orderValue => r.orderValue,
    _SortKey.cartons => r.totalCartons,
    _SortKey.collected => r.collected,
    _SortKey.outstanding => r.outstanding,
    _SortKey.newShops => r.newShops,
  };
}

const _rangeLabels = {
  'this_month': 'This month',
  'last_month': 'Last month',
  'all': 'All time',
};

/// Admin/monitor "Sales Performance" — every salesperson (or a filtered
/// selection), from a chosen window, with sort. Own copy per app rather than
/// a shared widget, matching how SalesReportScreen etc. are already
/// duplicated per app instead of factored into packages/core.
class SalesPerformanceScreen extends ConsumerStatefulWidget {
  const SalesPerformanceScreen({super.key});

  @override
  ConsumerState<SalesPerformanceScreen> createState() =>
      _SalesPerformanceScreenState();
}

class _SalesPerformanceScreenState
    extends ConsumerState<SalesPerformanceScreen> {
  String _range = 'all';
  Set<int> _salesPersonIds = {};
  _SortKey _sortKey = _SortKey.orderValue;
  bool _sortAsc = false;
  List<SalesPersonModel> _salesPersons = [];
  ReportResult<SalesPerformanceReport>? _result;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool force = false}) async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        ref
            .read(reportRepositoryProvider)
            .performance(
              range: _range,
              salesPersonIds: _salesPersonIds.isEmpty
                  ? null
                  : _salesPersonIds.toList(),
              forceRefresh: force,
            ),
        ref.read(customerRepositoryProvider).salesPersons(),
      ]);
      _result = results[0] as ReportResult<SalesPerformanceReport>;
      _salesPersons = (results[1] as PaginatedResponse<SalesPersonModel>).items;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<SalesPersonPerformanceRow> get _sortedRows {
    final rows = List<SalesPersonPerformanceRow>.from(
      _result?.data.rows ?? const [],
    );
    rows.sort((a, b) {
      final cmp = _sortKey.value(a).compareTo(_sortKey.value(b));
      return _sortAsc ? cmp : -cmp;
    });
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'SAR ');
    final rows = _sortedRows;
    final items = _result?.data.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Performance'),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: _FiltersDrawer(
        range: _range,
        onRangeChanged: (v) {
          setState(() => _range = v);
          _load();
        },
        salesPersons: _salesPersons,
        selectedIds: _salesPersonIds,
        onSalesPersonsChanged: (v) {
          setState(() => _salesPersonIds = v);
          _load();
        },
        sortKey: _sortKey,
        onSortKeyChanged: (v) => setState(() => _sortKey = v),
        sortAsc: _sortAsc,
        onSortDirChanged: (v) => setState(() => _sortAsc = v),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
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
                  Text(
                    _rangeLabels[_range] ?? _range,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (rows.isEmpty) const Text('No sales people recorded yet.'),
                  ...rows.map(
                    (r) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(r.name),
                        subtitle: Text(
                          '${r.orders} orders · ${r.totalCartons.toStringAsFixed(1)} cartons · '
                          '${r.newShops} new clients',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              currency.format(r.orderValue),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (r.outstanding > 0)
                              Text(
                                'Due ${currency.format(r.outstanding)}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (items != null) ...[
                    const Divider(height: 32),
                    const Text(
                      'By item',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...items.map(
                      (i) => ListTile(
                        title: Text(i.productName),
                        trailing: Text(
                          '${i.cartons.toStringAsFixed(1)} CTN — ${currency.format(i.revenue)}',
                        ),
                      ),
                    ),
                  ] else if (_salesPersonIds.isEmpty ||
                      _salesPersonIds.length > 5)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Select 5 or fewer sales people to see the item breakdown.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _FiltersDrawer extends StatelessWidget {
  const _FiltersDrawer({
    required this.range,
    required this.onRangeChanged,
    required this.salesPersons,
    required this.selectedIds,
    required this.onSalesPersonsChanged,
    required this.sortKey,
    required this.onSortKeyChanged,
    required this.sortAsc,
    required this.onSortDirChanged,
  });

  final String range;
  final ValueChanged<String> onRangeChanged;
  final List<SalesPersonModel> salesPersons;
  final Set<int> selectedIds;
  final ValueChanged<Set<int>> onSalesPersonsChanged;
  final _SortKey sortKey;
  final ValueChanged<_SortKey> onSortKeyChanged;
  final bool sortAsc;
  final ValueChanged<bool> onSortDirChanged;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters & sort',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: range,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Period',
                isDense: true,
              ),
              items: _rangeLabels.entries
                  .map(
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) onRangeChanged(v);
              },
            ),
            const SizedBox(height: 12),
            if (salesPersons.isNotEmpty)
              SalesPersonMultiSelectTile(
                salesPersons: salesPersons,
                selectedIds: selectedIds,
                onChanged: onSalesPersonsChanged,
              ),
            const Divider(height: 32),
            DropdownButtonFormField<_SortKey>(
              initialValue: sortKey,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Sort by',
                isDense: true,
              ),
              items: _SortKey.values
                  .map((k) => DropdownMenuItem(value: k, child: Text(k.label)))
                  .toList(),
              onChanged: (v) {
                if (v != null) onSortKeyChanged(v);
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Ascending'),
              value: sortAsc,
              onChanged: onSortDirChanged,
            ),
          ],
        ),
      ),
    );
  }
}
