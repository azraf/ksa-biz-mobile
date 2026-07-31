import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  OrderModel? _order;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final order = await ref.read(orderRepositoryProvider).get(widget.id);
      setState(() {
        _order = order;
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

    if (_loading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final order = _order!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text('Order #${order.id}'),
          subtitle: Text('${order.status} · ${order.paymentStatus}'),
          trailing: Text(
            currency.format(order.totalBill),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Divider(),
        Text('Items', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...order.items.map(
          (item) => ListTile(
            title: Text(item.product?.name ?? 'Product #${item.productId}'),
            subtitle: Text('Qty ${item.quantity} @ ${currency.format(item.productPrice)}'),
            trailing: Text(currency.format(item.bill)),
          ),
        ),
      ],
    );
  }
}
