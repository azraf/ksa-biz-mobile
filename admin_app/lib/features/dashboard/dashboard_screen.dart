import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/screen_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dashboardAsync = ref.watch(dashboardProvider);

    return dashboardAsync.when(
      loading: () => const SkeletonDashboard(),
      error: (e, _) => ErrorView(
        message: AppErrorMapper.localize(context, e),
        error: e,
        onRetry: () => ref.read(dashboardProvider.notifier).refresh(),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (data.salesFromCache && data.salesIsStale && data.salesCachedAt != null)
              _cachedBanner(context, ref, l10n, data.salesCachedAt!),
            _kpiCard(
              context,
              l10n.adminDashboardSalesMonth,
              '${data.sales.ordersCount} orders',
              'SAR ${data.sales.totalBill.toStringAsFixed(2)}',
              Icons.receipt_long,
              cachedAt: data.salesFromCache ? data.salesCachedAt : null,
              onTap: () => context.go('/reports/sales'),
            ),
            _kpiCard(
              context,
              l10n.adminDashboardExpensesYtd,
              'SAR ${data.expenseSummary.grandTotal.toStringAsFixed(2)}',
              '${data.expenseSummary.byPeriod.length} periods',
              Icons.payments,
              cachedAt: data.expenseFromCache ? data.expenseCachedAt : null,
              onTap: () => context.go('/reports/expense-summary'),
            ),
            _kpiCard(
              context,
              l10n.adminDashboardPendingManual,
              '${data.pendingManualOrders}',
              'Awaiting review',
              Icons.phone_in_talk,
              onTap: () => context.go('/sales/manual-orders'),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Quick links', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(label: Text(l10n.commonNewOrder), onPressed: () => context.go('/sales/orders/create')),
                ActionChip(label: const Text('New Expense'), onPressed: () => context.go('/expenses/list/create')),
                ActionChip(label: const Text('Products'), onPressed: () => context.go('/catalog/products')),
                ActionChip(label: const Text('Warehouse'), onPressed: () => context.go('/inventory/warehouse')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cachedBanner(BuildContext context, WidgetRef ref, AppLocalizations l10n, String fetchedAt) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: MaterialBanner(
        content: Text(l10n.adminShowingCachedList(fetchedAt.substring(0, 16))),
        leading: const Icon(Icons.cloud_off_outlined),
        actions: [
          TextButton(
            onPressed: () => ref.read(dashboardProvider.notifier).refresh(),
            child: Text(l10n.commonRetry),
          ),
        ],
      ),
    );
  }

  Widget _kpiCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon, {
    String? cachedAt,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(subtitle),
            if (cachedAt != null)
              Text('Updated: ${cachedAt.substring(0, 16)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
