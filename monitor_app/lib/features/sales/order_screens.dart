import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref.read(orderRepositoryProvider).list();
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

    if (_loading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);
    if (_orders.isEmpty) return const EmptyView(message: 'No orders found');

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (_, i) {
          final order = _orders[i];
          return ListTile(
            title: Text('Order #${formatOrderId(order.id)}'),
            subtitle: Text('${order.paymentStatus} · ${order.status}'),
            trailing: Text(currency.format(order.totalBill)),
            onTap: () => context.push('/sales/orders/${order.id}'),
          );
        },
      ),
    );
  }
}

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  OrderModel? _order;
  List<OrderModificationModel> _mods = [];
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
      final mods = await ref.read(orderRepositoryProvider).modifications(widget.id);
      setState(() {
        _order = order;
        _mods = mods;
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
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final order = _order!;
    final currency = NumberFormat.currency(symbol: 'SAR ');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (order.invoiceNumber != null)
          ListTile(
            title: const Text('Invoice'),
            subtitle: Text(order.invoiceNumber!),
          ),
        ListTile(
          title: Text(currency.format(order.totalBill)),
          subtitle: Text('Payment: ${order.paymentStatus}'),
          trailing: StatusChip(label: order.status),
        ),
        ListTile(
          title: const Text('Paid / Due'),
          subtitle: Text('${currency.format(order.amountPaid)} paid · ${currency.format(order.amountDue)} due'),
        ),
        if (order.grandDiscount > 0)
          ListTile(title: const Text('Grand discount'), subtitle: Text(currency.format(order.grandDiscount))),
        if (order.dueDate != null)
          ListTile(title: const Text('Due date'), subtitle: Text(order.dueDate!)),
        if (order.isOverdue)
          ListTile(title: const Text('Overdue'), subtitle: Text('${order.daysOverdue} days')),
        if (order.customerShopName != null)
          ListTile(title: const Text('Shop'), subtitle: Text(order.customerShopName!)),
        if (order.salesPerson != null)
          ListTile(title: const Text('Sales person'), subtitle: Text(order.salesPerson!.name)),
        Text('Items', style: Theme.of(context).textTheme.titleMedium),
        for (final item in order.items)
          ListTile(
            title: Text(item.product?.name ?? 'Product #${item.productId}'),
            subtitle: Text('Qty ${item.quantity}'),
            trailing: Text(currency.format(item.bill)),
          ),
        if (order.payments.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Payments', style: Theme.of(context).textTheme.titleMedium),
          for (final p in order.payments)
            ListTile(
              title: Text(p.paymentReference ?? 'Payment #${p.id}'),
              subtitle: Text(p.paymentMethod ?? ''),
              trailing: Text(currency.format(p.amount)),
            ),
        ],
        const SizedBox(height: 16),
        Text('Modification history', style: Theme.of(context).textTheme.titleMedium),
        if (_mods.isEmpty) const Text('No modifications'),
        for (final mod in _mods)
          ListTile(
            title: Text(mod.action.replaceAll('_', ' ')),
            subtitle: Text(mod.notes ?? mod.createdAt ?? ''),
          ),
      ],
    );
  }
}
