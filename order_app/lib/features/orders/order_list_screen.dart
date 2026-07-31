import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/customer_context_provider.dart';
import '../../providers/repositories.dart';
import '../../utils/order_filters.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  List<OrderModel> _orders = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = ref.read(customerContextProvider).profile;
    if (profile == null) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      setState(() {
        _loading = false;
        _error = l10n.orderCustomerProfileNotLoaded;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await ref.read(orderRepositoryProvider).list();
      final filtered = filterOrdersForCustomer(result.items, profile);
      setState(() {
        _orders = filtered;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final customerState = ref.watch(customerContextProvider);
    final currency = NumberFormat.currency(symbol: 'SAR ');

    if (customerState.isLoading) return const LoadingView();
    if (customerState.error != null) {
      return ErrorView(
        message: customerState.error!,
        onRetry: () => ref.read(customerContextProvider.notifier).load(),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/orders/create'),
        icon: const Icon(Icons.add),
        label: Text(l10n.commonNewOrder),
      ),
      body: _loading
          ? const LoadingView()
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _orders.isEmpty
                  ? EmptyView(message: l10n.commonNoOrdersYet)
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        itemCount: _orders.length,
                        itemBuilder: (_, i) {
                          final order = _orders[i];
                          return ListTile(
                            title: Text(l10n.commonOrderNumber(order.id)),
                            subtitle: Text(
                              '${localizedStatusLabel(context, order.paymentStatus)} · ${localizedStatusLabel(context, order.status)}',
                            ),
                            trailing: Text(currency.format(order.totalBill)),
                            onTap: () => context.push('/orders/${order.id}'),
                          );
                        },
                      ),
                    ),
    );
  }
}
