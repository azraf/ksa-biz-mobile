import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

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
    final l10n = AppLocalizations.of(context);
    final currency = NumberFormat.currency(symbol: 'SAR ');

    if (_loading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final order = _order!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text(l10n.commonOrderNumber(order.id)),
          subtitle: Text(
            '${localizedStatusLabel(context, order.status)} · ${localizedStatusLabel(context, order.paymentStatus)}',
          ),
          trailing: Text(
            currency.format(order.totalBill),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (order.isPending)
          NoticeCard(
            kind: NoticeKind.warning,
            icon: Icons.hourglass_top,
            title: l10n.statusPending,
            subtitle: 'Your order is awaiting salesperson approval.',
          ),
        const Divider(),
        Text(l10n.commonItems, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...order.items.map(
          (item) => ListTile(
            title: Text(item.product?.name ?? l10n.commonProductFallback(item.productId)),
            subtitle: Text(
              l10n.commonQtyAtPrice('${item.quantity}', currency.format(item.productPrice)),
            ),
            trailing: Text(currency.format(item.bill)),
          ),
        ),
      ],
    );
  }
}
