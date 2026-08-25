import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import '../../widgets/line_items_editor.dart';

/// Sentinel for "whole cartons" — the server treats a missing `unit_id` as
/// cartons.
const _kCartonChoice = 0;

class DamageReplacementScreen extends ConsumerStatefulWidget {
  const DamageReplacementScreen({super.key});

  @override
  ConsumerState<DamageReplacementScreen> createState() => _DamageReplacementScreenState();
}

class _DamageReplacementScreenState extends ConsumerState<DamageReplacementScreen> {
  ProductModel? _product;
  final _quantity = TextEditingController(text: '1');
  String? _qtyError;
  final _reason = TextEditingController();

  /// [_kCartonChoice] or the product's pcs unit id.
  int _unitChoice = _kCartonChoice;
  bool _saving = false;

  @override
  void dispose() {
    _quantity.dispose();
    _reason.dispose();
    super.dispose();
  }

  bool get _canBreakPack =>
      _product != null && _product!.allowBreakPack && _product!.pcsUnitId != null;

  Future<void> _submit() async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null || _product == null) return;
    final quantity = int.tryParse(_quantity.text.trim());
    if (quantity == null || quantity < 1) {
      // Reject instead of silently substituting 1 — this writes off stock.
      setState(
        () => _qtyError = AppLocalizations.of(context).commonEnterQuantityMin,
      );
      return;
    }
    final sendPieces = _canBreakPack && _unitChoice == _product!.pcsUnitId;
    setState(() {
      _qtyError = null;
      _saving = true;
    });
    try {
      await ref.read(inventoryRepositoryProvider).createDamageReplacement(
            replacementType: 'van_customer',
            productId: _product!.id,
            quantity: quantity,
            // Omitted for cartons — the server treats a missing unit_id as
            // whole cartons.
            unitId: sendPieces ? _product!.pcsUnitId : null,
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
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton(
            onPressed: () async {
              final product = await pickProduct(context, ref);
              if (product != null) {
                setState(() {
                  _product = product;
                  // Units are per-product; never carry a pieces choice over.
                  _unitChoice = _kCartonChoice;
                });
              }
            },
            child: Text(_product?.name ?? l10n.salesVanDamageSelect),
          ),
          if (_canBreakPack) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              key: ValueKey('unit_${_product?.id}'),
              initialValue: _unitChoice,
              decoration: InputDecoration(
                labelText: l10n.commonUnit,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: _kCartonChoice,
                  child: Text(l10n.commonUnitCarton),
                ),
                DropdownMenuItem(
                  value: _product!.pcsUnitId,
                  child: Text(l10n.commonUnitPiece(_product!.piecesPerCarton)),
                ),
              ],
              onChanged: (v) => setState(() => _unitChoice = v ?? _kCartonChoice),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _quantity,
            // Without a unit selector, quantities are booked as whole
            // cartons — the label must say so.
            decoration: InputDecoration(
              labelText: _canBreakPack ? l10n.commonQuantity : l10n.commonQuantityCartons,
              border: const OutlineInputBorder(),
              errorText: _qtyError,
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) {
              if (_qtyError != null) setState(() => _qtyError = null);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reason,
            decoration: InputDecoration(labelText: l10n.commonReason, border: const OutlineInputBorder()),
            maxLines: 2,
          ),
          const Spacer(),
          FilledButton(
            onPressed: _saving || _product == null ? null : _submit,
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.salesVanDamageRecord),
          ),
        ],
      ),
    );
  }
}
