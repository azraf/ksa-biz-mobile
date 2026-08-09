import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/repositories.dart';

class CollectPaymentScreen extends ConsumerStatefulWidget {
  const CollectPaymentScreen({super.key, required this.orderId, required this.amountDue});

  final int orderId;
  final double amountDue;

  @override
  ConsumerState<CollectPaymentScreen> createState() => _CollectPaymentScreenState();
}

class _CollectPaymentScreenState extends ConsumerState<CollectPaymentScreen> {
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
    final l10n = AppLocalizations.of(context);
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.salesOrderEnterValidAmount)));
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(offlineOrderRepositoryProvider).recordPayment(
            widget.orderId,
            amount: amount,
            paymentMethod: _method,
            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          );
      ref.invalidate(pendingSyncCountProvider);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = NumberFormat.currency(symbol: 'SAR ');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.salesOrderCollectPaymentTitle(widget.orderId))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text(l10n.salesOrderAmountDue),
            trailing: Text(currency.format(widget.amountDue), style: Theme.of(context).textTheme.titleMedium),
          ),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.salesOrderAmountCollected, prefixText: 'SAR '),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _method,
            decoration: InputDecoration(labelText: l10n.salesOrderPaymentMethod),
            items: [
              DropdownMenuItem(value: 'cash', child: Text(l10n.commonCash)),
              DropdownMenuItem(value: 'transfer', child: Text(l10n.commonBankTransfer)),
              DropdownMenuItem(value: 'cheque', child: Text(l10n.commonCheque)),
              DropdownMenuItem(value: 'other', child: Text(l10n.commonOther)),
            ],
            onChanged: _saving ? null : (v) => setState(() => _method = v ?? 'cash'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(labelText: l10n.commonNotesOptional),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.salesOrderRecordPayment),
          ),
        ],
      ),
    );
  }
}
