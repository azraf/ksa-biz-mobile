import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';
import '../../providers/screen_providers.dart';
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
  Object? _error;

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
      final order = await ref.read(offlineOrderRepositoryProvider).get(widget.orderId);
      setState(() {
        _order = order;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _addItem() async {
    final product = await pickProduct(context, ref);
    if (product == null || _order == null) return;
    try {
      await ref.read(orderRepositoryProvider).addItem(widget.orderId, LineItemDraft(product: product).toJson());
      ref.invalidate(adminOrdersProvider);
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppErrorMapper.localize(context, e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();
    if (_error != null) {
      return ErrorView(
        message: AppErrorMapper.localize(context, _error!),
        error: _error,
        onRetry: _load,
      );
    }
    final order = _order!;
    if (!order.isEditable || isPendingSyncOrder(order.id)) {
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
                  if (value == 'remove') {
                    try {
                      await ref.read(orderRepositoryProvider).removeItem(widget.orderId, item.id);
                      ref.invalidate(adminOrdersProvider);
                      await _load();
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppErrorMapper.localize(context, e))),
                        );
                      }
                    }
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
