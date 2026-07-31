import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/auth_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/repositories.dart';

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
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (ref.read(onlineStatusProvider)) {
        await ref.read(syncServiceProvider).syncIfOnline();
        ref.invalidate(pendingSyncCountProvider);
      }
      final result = await ref.read(offlineOrderRepositoryProvider).list(salesPersonId: salesPersonId);
      setState(() {
        _orders = result.items;
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
    final currency = NumberFormat.currency(symbol: 'SAR ');

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/orders/create'),
        icon: const Icon(Icons.add),
        label: const Text('New order'),
      ),
      body: _loading
          ? const LoadingView()
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _orders.isEmpty
                  ? const EmptyView(message: 'No orders yet')
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        itemCount: _orders.length,
                        itemBuilder: (_, i) {
                          final order = _orders[i];
                          final pending = isPendingSyncOrder(order.id);
                          return ListTile(
                            title: Row(
                              children: [
                                Text('Order #${formatOrderId(order.id)}'),
                                if (pending) ...[
                                  const SizedBox(width: 8),
                                  const StatusChip(label: 'Pending sync'),
                                ],
                              ],
                            ),
                            subtitle: Text('${order.paymentStatus} · ${order.status}'),
                            trailing: Text(currency.format(order.totalBill)),
                            onTap: () => context.push('/orders/${order.id}'),
                          );
                        },
                      ),
                    ),
    );
  }
}
