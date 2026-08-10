import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';

class PerformanceReviewScreen extends ConsumerStatefulWidget {
  const PerformanceReviewScreen({super.key});

  @override
  ConsumerState<PerformanceReviewScreen> createState() =>
      _PerformanceReviewScreenState();
}

class _PerformanceReviewScreenState
    extends ConsumerState<PerformanceReviewScreen> {
  String _range = 'this_month';
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
      _result = await ref
          .read(reportRepositoryProvider)
          .performance(range: _range, forceRefresh: force);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'SAR ');
    final rows = _result?.data.rows ?? const [];
    final row = rows.isEmpty ? null : rows.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Performance Review')),
      body: RefreshIndicator(
        onRefresh: () => _load(force: true),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'this_month', label: Text('This month')),
                  ButtonSegment(value: 'last_month', label: Text('Last month')),
                ],
                selected: {_range},
                onSelectionChanged: (selection) {
                  setState(() => _range = selection.first);
                  _load();
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (row == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text('No activity in this period yet.')),
              )
            else ...[
              if (_result?.isCached == true)
                const NoticeCard(
                  kind: NoticeKind.info,
                  icon: Icons.offline_pin,
                  title: 'Showing cached data',
                  subtitle: 'Connect to refresh from server',
                ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.6,
                children: [
                  KpiCard(
                    title: 'Orders',
                    value: '${row.orders}',
                    icon: Icons.receipt_long,
                  ),
                  KpiCard(
                    title: 'Sales',
                    value: currency.format(row.orderValue),
                    icon: Icons.point_of_sale,
                  ),
                  KpiCard(
                    title: 'Cartons',
                    value: row.totalCartons.toStringAsFixed(1),
                    icon: Icons.inventory_2_outlined,
                  ),
                  KpiCard(
                    title: 'Collected',
                    value: currency.format(row.collected),
                    icon: Icons.payments,
                  ),
                  KpiCard(
                    title: 'Due',
                    value: currency.format(row.outstanding),
                    icon: Icons.warning_amber_outlined,
                  ),
                  KpiCard(
                    title: 'New clients',
                    value: '${row.newShops}',
                    icon: Icons.person_add_alt,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'By item',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...(_result?.data.items ?? []).map(
                (i) => ListTile(
                  title: Text(i.productName),
                  trailing: Text(
                    '${i.cartons.toStringAsFixed(1)} CTN — ${currency.format(i.revenue)}',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
