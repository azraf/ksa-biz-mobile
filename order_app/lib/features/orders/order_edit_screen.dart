import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/repositories.dart';
import '../../widgets/line_items_editor.dart';

/// Draft editing for customers: quantity steppers, item removal and adding
/// products, all through the order modification endpoints (the server permits
/// them on the customer's own drafts only). Confirmed orders stay read-only.
class OrderEditScreen extends ConsumerStatefulWidget {
  const OrderEditScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<OrderEditScreen> createState() => _OrderEditScreenState();
}

class _OrderEditScreenState extends ConsumerState<OrderEditScreen> {
  OrderModel? _order;
  bool _loading = true;
  bool _working = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final order = await ref.read(orderRepositoryProvider).get(widget.id);
      if (!mounted) return;
      setState(() {
        _order = order;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _working = true);
    try {
      await action();
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _addProduct() async {
    final product = await pickProduct(context, ref);
    if (product == null) return;
    final draft = LineItemDraft(product: product);
    await _run(() => ref.read(orderRepositoryProvider).addItem(widget.id, {
          'product_id': product.id,
          'quantity': draft.quantity,
          if (draft.unitId != null) 'unit_id': draft.unitId,
          'product_price': draft.price,
        }));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = NumberFormat.currency(symbol: 'SAR ');

    if (_loading) return LoadingView(message: l10n.commonLoading);
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final order = _order!;
    if (!order.isDraft) {
      return Center(child: Text(l10n.salesOrderCannotEdit));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text(l10n.commonOrderNumber(order.id)),
          subtitle: Text(localizedStatusLabel(context, order.status)),
          trailing: Text(
            currency.format(order.totalBill),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (_working) const LinearProgressIndicator(),
        const Divider(),
        Row(
          children: [
            Text(l10n.commonItems, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: _working ? null : _addProduct,
              icon: const Icon(Icons.add),
              label: Text(l10n.commonAdd),
            ),
          ],
        ),
        for (final item in order.items)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(item.product?.name ?? l10n.commonProductFallback(item.productId)),
            subtitle: Text(currency.format(item.bill)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _working || item.quantity <= 1
                      ? null
                      : () => _run(() => ref
                          .read(orderRepositoryProvider)
                          .updateItem(widget.id, item.id, {'quantity': item.quantity - 1})),
                ),
                Text('${item.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _working
                      ? null
                      : () => _run(() => ref
                          .read(orderRepositoryProvider)
                          .updateItem(widget.id, item.id, {'quantity': item.quantity + 1})),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: _working
                      ? null
                      : () => _run(
                          () => ref.read(orderRepositoryProvider).removeItem(widget.id, item.id)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
