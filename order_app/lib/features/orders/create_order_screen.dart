import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/customer_context_provider.dart';
import '../../providers/repositories.dart';
import '../../widgets/line_items_editor.dart';

class CreateOrderScreen extends ConsumerStatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  ConsumerState<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen> {
  final _items = <LineItemDraft>[];
  bool _submitting = false;

  Future<void> _submit() async {
    final profile = ref.read(customerContextProvider).profile;
    if (profile == null || _items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one product')),
      );
      return;
    }

    final body = <String, dynamic>{
      'customer_type_id': profile.customerTypeId,
      'payment_status': 'pending',
      'items': _items.map((e) => e.toJson()).toList(),
      ...profile.orderCustomerFields(),
    };

    setState(() => _submitting = true);
    try {
      final order = await ref.read(orderRepositoryProvider).create(body);
      if (mounted) context.go('/orders/${order.id}');
    } catch (e) {
      setState(() => _submitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(customerContextProvider).profile;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (profile != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.store),
              title: Text(profile.displayName),
              subtitle: Text(profile.role.replaceAll('_', ' ')),
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text('Items', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: () async {
                final product = await pickProduct(context, ref);
                if (product != null) {
                  setState(() => _items.add(LineItemDraft(product: product)));
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        LineItemsEditor(
          items: _items,
          onChanged: () => setState(() {}),
          onRemove: (i) => setState(() => _items.removeAt(i)),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Place order'),
        ),
      ],
    );
  }
}
