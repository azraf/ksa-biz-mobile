import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/screen_providers.dart';
import '../orders/collect_payment_screen.dart';

class DuesScreen extends ConsumerWidget {
  const DuesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = NumberFormat.currency(symbol: 'SAR ');
    final duesAsync = ref.watch(duesProvider);

    return duesAsync.when(
      loading: () => ListView.builder(
        itemCount: 6,
        itemBuilder: (_, __) => const SkeletonListTile(),
      ),
      error: (e, _) => ErrorView(
        message: AppErrorMapper.localize(context, e),
        error: e,
        onRetry: () => ref.read(duesProvider.notifier).refresh(),
      ),
      data: (data) {
        final report = data.report;
        return RefreshIndicator(
          onRefresh: () => ref.read(duesProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              if (data.fromCache && data.isStale && data.fetchedAt != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: MaterialBanner(
                    content: Text(l10n.salesDashboardCachedDues(data.fetchedAt!)),
                    leading: const Icon(Icons.cloud_off_outlined),
                    actions: [
                      TextButton(
                        onPressed: () => ref.read(duesProvider.notifier).refresh(),
                        child: Text(l10n.commonRetry),
                      ),
                    ],
                  ),
                ),
              Card(
                child: ListTile(
                  title: Text(l10n.salesDuesTotalDue),
                  trailing: Text(
                    currency.format(report.totalDue),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
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
                        title: Text(
                          order.id >= 0
                              ? l10n.commonOrderNumber(order.id)
                              : 'Order #${formatOrderId(order.id)}',
                        ),
                        subtitle: Text(
                          '${localizedStatusLabel(context, order.paymentStatus)} · ${l10n.commonDue} ${currency.format(due)}',
                        ),
                        trailing: Text(currency.format(order.totalBill)),
                        onTap: () => context.push('/orders/${order.id}'),
                        onLongPress: () => _collectPayment(context, ref, order),
                      ),
                    );
                  },
                ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.salesDuesLongPressHint),
            ],
          ),
        );
      },
    );
  }

  Future<void> _collectPayment(BuildContext context, WidgetRef ref, OrderModel order) async {
    final due = order.amountDue > 0 ? order.amountDue : order.totalBill - order.amountPaid;
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CollectPaymentScreen(orderId: order.id, amountDue: due),
      ),
    );
    if (ok == true) {
      AppHaptics.success();
      await ref.read(duesProvider.notifier).refresh();
      ref.invalidate(orderListProvider);
    }
  }
}
