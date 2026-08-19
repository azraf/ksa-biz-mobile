import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/report_models.dart';
import '../theme/app_colors.dart';
import 'v3_building_blocks.dart';

/// A period for the sales-performance report: either a server preset
/// (`range`) or a single day (`fromDate == toDate`). The server owns the
/// date math (`SalesPerformanceService::resolveWindow`), the client only
/// names the window.
class PerformancePeriod {
  const PerformancePeriod.preset(this.range)
      : fromDate = null,
        toDate = null;

  const PerformancePeriod.day(String date)
      : range = null,
        fromDate = date,
        toDate = date;

  final String? range;
  final String? fromDate;
  final String? toDate;

  bool get isDay => fromDate != null;

  static const thisMonth = PerformancePeriod.preset('this_month');
}

/// Preset chips shared by sales_app (own data) and admin_app (any person).
class PerformancePeriodChips extends StatelessWidget {
  const PerformancePeriodChips({
    super.key,
    required this.value,
    required this.onChanged,
    this.showAll = false,
  });

  final PerformancePeriod value;
  final ValueChanged<PerformancePeriod> onChanged;

  /// 'All time' is admin/monitor only — the server ignores it for a
  /// sales_person caller anyway.
  final bool showAll;

  static const _presets = <String, String>{
    'this_month': 'This month',
    'week_1': 'Wk 1',
    'week_2': 'Wk 2',
    'week_3': 'Wk 3',
    'week_4': 'Wk 4',
    'last_month': 'Last month',
    'last_3_months': 'Last 3 months',
    'all': 'All time',
  };

  Future<void> _pickDay(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          value.isDay ? DateTime.tryParse(value.fromDate!) ?? now : now,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
    );
    if (picked != null) {
      onChanged(PerformancePeriod.day(DateFormat('yyyy-MM-dd').format(picked)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().day;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        for (final e in _presets.entries)
          if (e.key != 'all' || showAll)
            ChoiceChip(
              label: Text(e.value),
              selected: value.range == e.key,
              // A week that has not started yet has nothing to show.
              onSelected: e.key.startsWith('week_') &&
                      (int.parse(e.key.substring(5)) - 1) * 7 + 1 > today
                  ? null
                  : (_) => onChanged(PerformancePeriod.preset(e.key)),
            ),
        ChoiceChip(
          avatar: const Icon(Icons.calendar_today, size: 16),
          label: Text(value.isDay
              ? DateFormat.MMMd().format(DateTime.parse(value.fromDate!))
              : 'Pick a day'),
          selected: value.isDay,
          onSelected: (_) => _pickDay(context),
        ),
      ],
    );
  }
}

/// KPI grid + per-day / per-week trend for a single salesperson row.
class PerformanceDetail extends StatelessWidget {
  const PerformanceDetail({super.key, required this.row, this.trend});

  final SalesPersonPerformanceRow row;
  final List<PerformanceTrendRow>? trend;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'SAR ', decimalDigits: 0);
    final theme = Theme.of(context);
    final trendRows = trend ?? const [];
    final weekly =
        trendRows.isNotEmpty && trendRows.first.label.startsWith('Week of');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                icon: Icons.receipt_long),
            KpiCard(
                title: 'Sales',
                value: currency.format(row.orderValue),
                icon: Icons.point_of_sale),
            KpiCard(
                title: 'Avg order',
                value: currency.format(row.averageOrderValue),
                icon: Icons.functions),
            KpiCard(
                title: 'Cartons',
                value: row.totalCartons.toStringAsFixed(1),
                icon: Icons.inventory_2_outlined),
            KpiCard(
                title: 'Collected',
                value: currency.format(row.collected),
                icon: Icons.payments),
            KpiCard(
              title: 'Collection rate',
              value: row.collectionRate == null
                  ? '—'
                  : '${row.collectionRate!.toStringAsFixed(1)}%',
              icon: Icons.percent,
            ),
            KpiCard(
                title: 'Returns',
                value: currency.format(row.returns),
                icon: Icons.assignment_return_outlined),
            KpiCard(
                title: 'Due (running)',
                value: currency.format(row.outstanding),
                icon: Icons.warning_amber_outlined),
            KpiCard(
                title: 'Shops served',
                value: '${row.shopsServed}',
                icon: Icons.storefront_outlined),
            KpiCard(
                title: 'New clients',
                value: '${row.newShops}',
                icon: Icons.person_add_alt),
            KpiCard(
              title: 'Prospects',
              value: '${row.prospectsConverted}/${row.prospects}',
              subtitle: 'converted / added',
              icon: Icons.flag_outlined,
            ),
          ],
        ),
        if (trendRows.isNotEmpty) ...[
          SectionHeader(title: weekly ? 'By week' : 'By day'),
          Table(
            columnWidths: const {0: FlexColumnWidth(2)},
            children: [
              TableRow(
                children: [
                  for (final h in const [
                    'Period',
                    'Orders',
                    'Sales',
                    'Collected'
                  ])
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      child: Text(
                        h,
                        textAlign:
                            h == 'Period' ? TextAlign.start : TextAlign.end,
                        style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                ],
              ),
              for (final t in trendRows)
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                  ),
                  children: [
                    _cell(theme,
                        weekly ? t.label.replaceFirst('Week of ', '') : t.label,
                        start: true, dim: t.orders == 0),
                    _cell(theme, '${t.orders}', dim: t.orders == 0),
                    _cell(theme, currency.format(t.sales), dim: t.orders == 0),
                    _cell(theme, currency.format(t.collections),
                        dim: t.collections == 0),
                  ],
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _cell(ThemeData theme, String text,
          {bool start = false, bool dim = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Text(
          text,
          textAlign: start ? TextAlign.start : TextAlign.end,
          style: theme.textTheme.bodySmall?.copyWith(
            color: dim
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.onSurface,
          ),
        ),
      );
}
