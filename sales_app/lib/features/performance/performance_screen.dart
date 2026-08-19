import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';

/// The logged-in salesperson's own performance. The server locks the
/// report to their sales_person id; this screen only picks the period.
class PerformanceReviewScreen extends ConsumerStatefulWidget {
  const PerformanceReviewScreen({super.key});

  @override
  ConsumerState<PerformanceReviewScreen> createState() =>
      _PerformanceReviewScreenState();
}

class _PerformanceReviewScreenState
    extends ConsumerState<PerformanceReviewScreen> {
  PerformancePeriod _period = PerformancePeriod.thisMonth;
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
          .performance(
            range: _period.range,
            fromDate: _period.fromDate,
            toDate: _period.toDate,
            forceRefresh: force,
          );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'SAR ', decimalDigits: 0);
    final report = _result?.data;
    final row = (report?.rows.isEmpty ?? true) ? null : report!.rows.first;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Performance Review')),
      body: RefreshIndicator(
        onRefresh: () => _load(force: true),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            PerformancePeriodChips(
              value: _period,
              onChanged: (p) {
                setState(() => _period = p);
                _load();
              },
            ),
            if (report?.from != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  report!.from == report.to
                      ? report.from!
                      : '${report.from} → ${report.to}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
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
              PerformanceDetail(row: row, trend: report?.trend),
              const SectionHeader(title: 'By item'),
              if (report?.items?.isEmpty ?? true)
                Text(
                  'No items sold in this period.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ...(report?.items ?? []).map(
                (i) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
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
