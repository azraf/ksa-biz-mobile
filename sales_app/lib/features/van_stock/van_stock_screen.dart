import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

class VanStockScreen extends ConsumerStatefulWidget {
  const VanStockScreen({super.key});

  @override
  ConsumerState<VanStockScreen> createState() => _VanStockScreenState();
}

class _VanStockScreenState extends ConsumerState<VanStockScreen> {
  List<InventoryStockModel> _stock = [];
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
      final stock = await ref.read(inventoryRepositoryProvider).vanStock(salesPersonId!);
      setState(() {
        _stock = stock;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _unloadProduct(InventoryStockModel item) async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null) return;
    final qtyController = TextEditingController(text: '1');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Unload ${item.product?.name ?? 'product'}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Return stock from van to warehouse.'),
            const SizedBox(height: 12),
            TextField(
              controller: qtyController,
              decoration: const InputDecoration(labelText: 'Quantity (cartons)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Unload')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(inventoryRepositoryProvider).unloadVan(
            productId: item.productId,
            quantity: int.tryParse(qtyController.text) ?? 1,
            salesPersonId: salesPersonId,
          );
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const LoadingView()
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _stock.isEmpty
                  ? const EmptyView(message: 'Van is empty')
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        itemCount: _stock.length,
                        itemBuilder: (_, i) {
                          final item = _stock[i];
                          final low = (item.product?.alertQuantity ?? 0) > 0 &&
                              item.balance <= (item.product?.alertQuantity ?? 0);
                          return ListTile(
                            title: Text(item.product?.name ?? 'Product #${item.productId}'),
                            subtitle: low ? const Text('Low stock', style: TextStyle(color: Colors.orange)) : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(item.displayBalance),
                                IconButton(
                                  icon: const Icon(Icons.undo_outlined),
                                  tooltip: 'Unload to warehouse',
                                  onPressed: () => _unloadProduct(item),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'exchange',
            onPressed: () => context.push('/van-stock/exchange'),
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Exchange'),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'damage',
            onPressed: () => context.push('/van-stock/damage'),
            icon: const Icon(Icons.build_outlined),
            label: const Text('Damage'),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'transfer',
            onPressed: () => context.push('/van-stock/transfer'),
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Transfer'),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'load',
            onPressed: () => context.push('/van-stock/load'),
            icon: const Icon(Icons.download_outlined),
            label: const Text('Load van'),
          ),
        ],
      ),
    );
  }
}
