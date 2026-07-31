import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import '../../widgets/line_items_editor.dart';

class DamageReplacementScreen extends ConsumerStatefulWidget {
  const DamageReplacementScreen({super.key});

  @override
  ConsumerState<DamageReplacementScreen> createState() => _DamageReplacementScreenState();
}

class _DamageReplacementScreenState extends ConsumerState<DamageReplacementScreen> {
  ProductModel? _product;
  final _quantity = TextEditingController(text: '1');
  final _reason = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _quantity.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null || _product == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(inventoryRepositoryProvider).createDamageReplacement(
            replacementType: 'van_customer',
            productId: _product!.id,
            quantity: int.tryParse(_quantity.text) ?? 1,
            salesPersonId: salesPersonId,
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton(
            onPressed: () async {
              final product = await pickProduct(context, ref);
              if (product != null) setState(() => _product = product);
            },
            child: Text(_product?.name ?? 'Select product'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _quantity,
            decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reason,
            decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder()),
            maxLines: 2,
          ),
          const Spacer(),
          FilledButton(
            onPressed: _saving || _product == null ? null : _submit,
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Record replacement'),
          ),
        ],
      ),
    );
  }
}
