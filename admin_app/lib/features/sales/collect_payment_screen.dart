import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';

class AdminCollectPaymentScreen extends ConsumerStatefulWidget {
  const AdminCollectPaymentScreen({super.key, required this.orderId, required this.amountDue});

  final int orderId;
  final double amountDue;

  @override
  ConsumerState<AdminCollectPaymentScreen> createState() => _AdminCollectPaymentScreenState();
}

class _AdminCollectPaymentScreenState extends ConsumerState<AdminCollectPaymentScreen> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String _method = 'cash';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amountDue.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(orderRepositoryProvider).recordPayment(
            widget.orderId,
            amount: amount,
            paymentMethod: _method,
            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'SAR ');

    return Scaffold(
      appBar: AppBar(title: Text('Collect payment #${widget.orderId}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Amount due'),
            trailing: Text(currency.format(widget.amountDue), style: Theme.of(context).textTheme.titleMedium),
          ),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Amount collected', prefixText: 'SAR '),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _method,
            decoration: const InputDecoration(labelText: 'Payment method'),
            // Server accepts only 'cash' and 'bank_transfer'.
            items: const [
              DropdownMenuItem(value: 'cash', child: Text('Cash')),
              DropdownMenuItem(value: 'bank_transfer', child: Text('Bank transfer')),
            ],
            onChanged: _saving ? null : (v) => setState(() => _method = v ?? 'cash'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes (optional)'),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Record payment'),
          ),
        ],
      ),
    );
  }
}
