import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../providers/format_providers.dart';
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
  String? _error;

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
      final result = await ref
          .read(reportRepositoryProvider)
          .performance(
            range: _period.range,
            fromDate: _period.fromDate,
            toDate: _period.toDate,
            forceRefresh: force,
          );
      if (!mounted) return;
      setState(() => _result = result);
    } catch (e) {
      // Offline with no cache must read as an error, not "no activity".
      if (!mounted) return;
      setState(() => _error = AppErrorMapper.localize(context, e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(wholeCurrencyFormatProvider);
    final report = _result?.data;
    final row = (report?.rows.isEmpty ?? true) ? null : report!.rows.first;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.perfTitle)),
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
            else if (row == null && _error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: ErrorView(message: _error!, onRetry: _load),
              )
            else if (row == null)
              // Only a successful fetch may claim "no activity".
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text(l10n.perfNoActivity)),
              )
            else ...[
              if (_error != null)
                NoticeCard(
                  kind: NoticeKind.warning,
                  icon: Icons.sync_problem_outlined,
                  title: _error!,
                  subtitle: l10n.perfShowingPreviousData,
                ),
              if (_result?.isCached == true)
                NoticeCard(
                  kind: NoticeKind.info,
                  icon: Icons.offline_pin,
                  title: l10n.perfCachedTitle,
                  subtitle: l10n.perfCachedSubtitle,
                ),
              PerformanceDetail(row: row, trend: report?.trend),
              SectionHeader(title: l10n.perfByItem),
              if (report?.items?.isEmpty ?? true)
                Text(
                  l10n.perfNoItemsSold,
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
