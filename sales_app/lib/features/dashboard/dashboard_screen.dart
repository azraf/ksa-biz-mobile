import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/screen_providers.dart';
import '../watchlist/watchlist_screens.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider);
    final currency = NumberFormat.currency(symbol: 'SAR ');
    final salesPersonId = requireSalesPersonId(auth);

    if (salesPersonId == null) {
      final message = auth.canPickSalesPerson ? l10n.salesDashboardSelectSp : l10n.salesDashboardNoProfile;
      return ErrorView(
        message: message,
        onRetry: auth.canPickSalesPerson ? () => context.go('/select-salesperson') : null,
      );
    }

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
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            if (data.fromCache && data.isStale && data.duesCachedAt != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: MaterialBanner(
                  content: Text(l10n.salesDashboardCachedDues(data.duesCachedAt!)),
                  leading: const Icon(Icons.cloud_off_outlined),
                  actions: [
                    TextButton(
                      onPressed: () => ref.read(dashboardProvider.notifier).refresh(),
                      child: Text(l10n.commonRetry),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.salesHello(auth.user?.name ?? l10n.salesDefaultSalesperson),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.push('/notifications'),
                ),
              ],
            ),
            if (auth.activeSalesPerson != null)
              Text(l10n.salesActingAsName(auth.activeSalesPerson!.name), style: Theme.of(context).textTheme.bodyMedium)
            else if (auth.salesPerson != null)
              Text(auth.salesPerson!.name, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            _SummaryCard(
              title: l10n.salesCardOutstandingDues,
              value: currency.format(data.totalDue),
              subtitle: l10n.salesCardUnpaidOrders(data.unpaidOrders),
              icon: Icons.payments,
              onTap: () => context.go('/dues'),
            ),
            _SummaryCard(
              title: l10n.salesCardManualOrders,
              value: '${data.openManualOrders}',
              subtitle: l10n.salesCardManualSubtitle,
              icon: Icons.phone_in_talk,
              onTap: () => context.go('/manual-orders'),
            ),
            _SummaryCard(
              title: l10n.salesCardVanStock,
              value: l10n.salesCardVanProducts(data.vanProducts),
              subtitle: data.lowStock > 0
                  ? l10n.salesCardLowStockAlerts(data.lowStock)
                  : l10n.salesCardTapManageStock,
              icon: Icons.local_shipping,
              onTap: () => context.go('/van-stock'),
            ),
            _SummaryCard(
              title: l10n.salesCardMyOrders,
              value: l10n.salesCardViewAll,
              subtitle: l10n.salesCardOrdersSubtitle,
              icon: Icons.receipt_long,
              onTap: () => context.go('/orders'),
            ),
            _SummaryCard(
              title: l10n.salesCardWatchlist,
              value: l10n.salesCardWatchlistValue,
              subtitle: l10n.salesCardWatchlistSubtitle,
              icon: Icons.bookmark_add_outlined,
              onTap: () => context.push('/watchlist'),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () => quickSaveWatchlistLocation(context, ref),
              icon: const Icon(Icons.add_location_alt),
              label: Text(l10n.salesQuickSaveLocation),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
        onTap: onTap,
      ),
    );
  }
}
