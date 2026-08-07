import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';
import '../../widgets/line_items_editor.dart';

class AdminOrderEditScreen extends ConsumerStatefulWidget {
  const AdminOrderEditScreen({super.key, required this.orderId});

  final int orderId;

  @override
  ConsumerState<AdminOrderEditScreen> createState() => _AdminOrderEditScreenState();
}

class _AdminOrderEditScreenState extends ConsumerState<AdminOrderEditScreen> {
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
      final order = await ref.read(orderRepositoryProvider).get(widget.orderId);
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
      final order = await ref.read(orderRepositoryProvider).addItem(widget.orderId, LineItemDraft(product: product).toJson());
      setState(() => _order = order);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);
    final order = _order!;
    if (!order.isEditable) return const Center(child: Text('This order cannot be edited.'));

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
                  if (value == 'remove') {
                    await ref.read(orderRepositoryProvider).removeItem(widget.orderId, item.id);
                    await _load();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'remove', child: Text('Remove item')),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
