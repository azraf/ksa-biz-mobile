import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';
import '../../widgets/line_items_editor.dart';

class OrderEditScreen extends ConsumerStatefulWidget {
  const OrderEditScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<OrderEditScreen> createState() => _OrderEditScreenState();
}

class _OrderEditScreenState extends ConsumerState<OrderEditScreen> {
  OrderModel? _order;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
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

  Future<void> _addItem() async {
    final product = await pickProduct(context, ref);
    if (product == null || _order == null) return;
    try {
      await ref.read(orderRepositoryProvider).addItem(widget.id, LineItemDraft(product: product).toJson());
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _updateQty(OrderItemModel item, int qty) async {
    try {
      await ref.read(orderRepositoryProvider).updateItem(widget.id, item.id, {'quantity': qty});
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _removeItem(OrderItemModel item) async {
    try {
      await ref.read(orderRepositoryProvider).removeItem(widget.id, item.id);
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _returnItem(OrderItemModel item) async {
    final qtyController = TextEditingController(text: '1');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sales return'),
        content: TextField(
          controller: qtyController,
          decoration: const InputDecoration(labelText: 'Quantity'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Return')),
        ],
      ),
    );
    if (confirmed != true) return;
    final qty = int.tryParse(qtyController.text) ?? 1;
    try {
      await ref.read(orderRepositoryProvider).recordReturn(widget.id, [
        {'product_id': item.productId, 'quantity': qty},
      ]);
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);
    final order = _order!;
    if (!order.isEditable) {
      return const Center(child: Text('This order cannot be edited.'));
    }

    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(onPressed: _addItem, icon: const Icon(Icons.add), label: const Text('Add product')),
          const SizedBox(height: 12),
          for (final item in order.items)
            Card(
              child: ListTile(
                title: Text(item.product?.name ?? 'Product #${item.productId}'),
                subtitle: Text('Qty: ${item.quantity}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'qty') {
                      final controller = TextEditingController(text: '${item.quantity}');
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Update quantity'),
                          content: TextField(controller: controller, keyboardType: TextInputType.number),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) await _updateQty(item, int.tryParse(controller.text) ?? item.quantity);
                    } else if (value == 'remove') {
                      await _removeItem(item);
                    } else if (value == 'return') {
                      await _returnItem(item);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'qty', child: Text('Change quantity')),
                    PopupMenuItem(value: 'return', child: Text('Sales return')),
                    PopupMenuItem(value: 'remove', child: Text('Remove item')),
                  ],
                ),
              ),
            ),
        ],
    );
  }
}
