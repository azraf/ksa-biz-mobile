import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import '../../widgets/line_items_editor.dart';

class ProductExchangeScreen extends ConsumerStatefulWidget {
  const ProductExchangeScreen({super.key});

  @override
  ConsumerState<ProductExchangeScreen> createState() => _ProductExchangeScreenState();
}

class _ProductExchangeScreenState extends ConsumerState<ProductExchangeScreen> {
  ProductModel? _returnProduct;
  ProductModel? _outProduct;
  final _returnQty = TextEditingController(text: '1');
  final _outQty = TextEditingController(text: '1');
  final _cashAmount = TextEditingController();
  final _reason = TextEditingController();
  String _settlement = 'product';
  bool _saving = false;

  @override
  void dispose() {
    _returnQty.dispose();
    _outQty.dispose();
    _cashAmount.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null || _returnProduct == null) return;
    if (_settlement == 'product' && _outProduct == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(inventoryRepositoryProvider).createProductExchange(
            salesPersonId: salesPersonId,
            settlementType: _settlement,
            returnProductId: _returnProduct!.id,
            returnQuantity: int.tryParse(_returnQty.text) ?? 1,
            outProductId: _settlement == 'product' ? _outProduct!.id : null,
            outQuantity: _settlement == 'product' ? int.tryParse(_outQty.text) ?? 1 : null,
            cashAmount: _settlement == 'cash' ? double.tryParse(_cashAmount.text) : null,
            reason: _reason.text.isEmpty ? null : _reason.text,
          );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Customer returns', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () async {
            final product = await pickProduct(context, ref);
            if (product != null) setState(() => _returnProduct = product);
          },
          child: Text(_returnProduct?.name ?? 'Select return product'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _returnQty,
          decoration: const InputDecoration(labelText: 'Return quantity', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _settlement,
          decoration: const InputDecoration(labelText: 'Settlement', border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(value: 'product', child: Text('Give another product')),
            DropdownMenuItem(value: 'cash', child: Text('Cash refund')),
          ],
          onChanged: (v) => setState(() => _settlement = v ?? 'product'),
        ),
        if (_settlement == 'product') ...[
          const SizedBox(height: 16),
          Text('Give to customer', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              final product = await pickProduct(context, ref);
              if (product != null) setState(() => _outProduct = product);
            },
            child: Text(_outProduct?.name ?? 'Select out product'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _outQty,
            decoration: const InputDecoration(labelText: 'Out quantity', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
        ],
        if (_settlement == 'cash') ...[
          const SizedBox(height: 12),
          TextField(
            controller: _cashAmount,
            decoration: const InputDecoration(labelText: 'Cash amount (SAR)', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _reason,
          decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder()),
          maxLines: 2,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Record exchange'),
        ),
      ],
    );
  }
}
