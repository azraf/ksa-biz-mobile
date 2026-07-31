import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/customer_context_provider.dart';
import '../../providers/repositories.dart';

class CreateManualOrderScreen extends ConsumerStatefulWidget {
  const CreateManualOrderScreen({super.key});

  @override
  ConsumerState<CreateManualOrderScreen> createState() => _CreateManualOrderScreenState();
}

class _CreateManualOrderScreenState extends ConsumerState<CreateManualOrderScreen> {
  final _notesController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final profile = ref.read(customerContextProvider).profile;
    if (profile == null || !profile.isShop) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only shop accounts can create manual requests')),
      );
      return;
    }

    final notes = _notesController.text.trim();
    if (notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter order notes')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final request = await ref.read(manualOrderRepositoryProvider).create(
            customerShopId: profile.entityId,
            notes: notes,
          );
      if (mounted) context.go('/manual-orders/${request.id}');
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
              leading: const Icon(Icons.storefront),
              title: Text(profile.displayName),
              subtitle: const Text('Manual order request'),
            ),
          ),
        const SizedBox(height: 16),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Order notes',
            hintText: 'Describe products, quantities, or special instructions',
            alignLabelWithHint: true,
          ),
          maxLines: 6,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Submit request'),
        ),
      ],
    );
  }
}
