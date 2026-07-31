import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  List<InventoryStockModel> _vanStock = [];
  List<SalesPersonModel> _salesPersons = [];
  InventoryStockModel? _selectedProduct;
  SalesPersonModel? _selectedTarget;
  final _qtyController = TextEditingController(text: '1');
  bool _loading = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    setState(() => _loading = true);
    try {
      final stock = await ref.read(inventoryRepositoryProvider).vanStock(salesPersonId!);
      final persons = await ref.read(customerRepositoryProvider).salesPersons();
      setState(() {
        _vanStock = stock;
        _salesPersons = persons.items.where((p) => p.id != salesPersonId).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _submit() async {
    final fromId = requireSalesPersonId(ref.read(authProvider));
    if (fromId == null || _selectedProduct == null || _selectedTarget == null) return;
    setState(() => _submitting = true);
    try {
      await ref.read(inventoryRepositoryProvider).transfer(
            productId: _selectedProduct!.productId,
            quantity: int.tryParse(_qtyController.text) ?? 1,
            fromSalesPersonId: fromId,
            toSalesPersonId: _selectedTarget!.id,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transfer completed')));
        context.pop();
      }
    } catch (e) {
      setState(() => _submitting = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();
    return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<InventoryStockModel>(
                    key: ValueKey(_selectedProduct?.productId),
                    initialValue: _selectedProduct,
                    decoration: const InputDecoration(labelText: 'Your van product'),
                    items: _vanStock
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text('${s.product?.name ?? s.productId} (${s.displayBalance})'),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedProduct = v),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<SalesPersonModel>(
                    key: ValueKey(_selectedTarget?.id),
                    initialValue: _selectedTarget,
                    decoration: const InputDecoration(labelText: 'Transfer to'),
                    items: _salesPersons
                        .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedTarget = v),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _qtyController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting ? const CircularProgressIndicator() : const Text('Transfer'),
                  ),
                ],
              ),
    );
  }
}
