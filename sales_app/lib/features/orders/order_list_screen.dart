import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/screen_providers.dart';

class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = NumberFormat.currency(symbol: 'SAR ');
    final ordersAsync = ref.watch(orderListProvider);

    final listPadding = fabScrollPadding(context, extendedFab: true, includeBottomNav: true);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/orders/create'),
        icon: const Icon(Icons.add),
        label: Text(l10n.commonNewOrder),
      ),
      body: ordersAsync.when(
        loading: () => ListView.builder(
          padding: listPadding,
          itemCount: 8,
          itemBuilder: (_, __) => const SkeletonListTile(),
        ),
        error: (e, _) => ErrorView(
          message: AppErrorMapper.localize(context, e),
          error: e,
          onRetry: () => ref.read(orderListProvider.notifier).refresh(),
        ),
        data: (state) => state.orders.isEmpty
            ? EmptyView(
                message: l10n.commonNoOrdersYet,
                actionLabel: l10n.commonNewOrder,
                onAction: () => context.push('/orders/create'),
              )
            : RefreshIndicator(
                onRefresh: () => ref.read(orderListProvider.notifier).refresh(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n is ScrollEndNotification &&
                        n.metrics.extentAfter < 200 &&
                        state.hasMore &&
                        !state.loadingMore) {
                      ref.read(orderListProvider.notifier).loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: listPadding,
                    itemCount: state.orders.length + (state.loadingMore ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i >= state.orders.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final order = state.orders[i];
                      return OrderCard(
                        order: order,
                        currency: currency,
                        onTap: () => context.push('/orders/${order.id}'),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
