import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../providers/connectivity_provider.dart';
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
      final order = await ref.read(orderRepositoryProvider).addItem(widget.id, LineItemDraft(product: product).toJson());
      setState(() => _order = order);
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    }
  }

  Future<void> _updateQty(OrderItemModel item, int qty) async {
    try {
      final order = await ref.read(orderRepositoryProvider).updateItem(widget.id, item.id, {'quantity': qty});
      setState(() => _order = order);
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    }
  }

  Future<void> _removeItem(OrderItemModel item) async {
    try {
      final order = await ref.read(orderRepositoryProvider).removeItem(widget.id, item.id);
      setState(() => _order = order);
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    }
  }

  Future<void> _returnItem(OrderItemModel item) async {
    final l10n = AppLocalizations.of(context);
    final qtyController = TextEditingController(text: '1');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.salesOrderSalesReturn),
        content: TextField(
          controller: qtyController,
          decoration: InputDecoration(labelText: l10n.commonQuantity),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.salesOrderReturn)),
        ],
      ),
    );
    if (confirmed != true) return;
    final qty = int.tryParse(qtyController.text) ?? 1;
    try {
      await ref.read(orderRepositoryProvider).recordReturn(widget.id, [
        {'product_id': item.productId, 'quantity': qty},
      ]);
      final order = await ref.read(orderRepositoryProvider).get(widget.id);
      setState(() => _order = order);
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final offline = !ref.watch(onlineStatusProvider);
    final pendingLocal = widget.id < 0;

    if (offline || pendingLocal) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.commonEditOrder)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                offline ? Icons.cloud_off : Icons.cloud_upload_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                pendingLocal ? l10n.salesOrderEditPendingSync : l10n.salesOrderEditOfflineBlocked,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_loading) return LoadingView(message: l10n.commonLoading);
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);
    final order = _order!;
    if (!order.isEditable) {
      return Center(child: Text(l10n.salesOrderCannotEdit));
    }

    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(onPressed: _addItem, icon: const Icon(Icons.add), label: Text(l10n.salesOrderAddProduct)),
          const SizedBox(height: 12),
          for (final item in order.items)
            Card(
              child: ListTile(
                title: Text(item.product?.name ?? l10n.commonProductFallback(item.productId)),
                subtitle: Text(l10n.commonQtyLine('${item.quantity}')),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'qty') {
                      final controller = TextEditingController(text: '${item.quantity}');
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(l10n.salesOrderUpdateQty),
                          content: TextField(controller: controller, keyboardType: TextInputType.number),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonCancel)),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text(l10n.commonSave),
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
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'qty', child: Text(l10n.salesOrderChangeQty)),
                    PopupMenuItem(value: 'return', child: Text(l10n.salesOrderSalesReturn)),
                    PopupMenuItem(value: 'remove', child: Text(l10n.salesOrderRemoveItem)),
                  ],
                ),
              ),
            ),
        ],
    );
  }
}
