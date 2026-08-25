import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import '../../widgets/line_items_editor.dart';

/// Sentinel for "whole cartons" — the server treats a missing unit id as
/// cartons.
const _kCartonChoice = 0;

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
  String? _returnQtyError;
  String? _outQtyError;

  /// [_kCartonChoice] or the respective product's pcs unit id.
  int _returnUnitChoice = _kCartonChoice;
  int _outUnitChoice = _kCartonChoice;
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

  static bool _canBreakPack(ProductModel? product) =>
      product != null && product.allowBreakPack && product.pcsUnitId != null;

  Future<void> _submit() async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null || _returnProduct == null) return;
    if (_settlement == 'product' && _outProduct == null) return;

    // Reject bad quantities instead of silently substituting 1 — this moves
    // real stock both ways.
    final returnQuantity = int.tryParse(_returnQty.text.trim());
    final outQuantity =
        _settlement == 'product' ? int.tryParse(_outQty.text.trim()) : null;
    final returnInvalid = returnQuantity == null || returnQuantity < 1;
    final outInvalid =
        _settlement == 'product' && (outQuantity == null || outQuantity < 1);
    if (returnInvalid || outInvalid) {
      final message = AppLocalizations.of(context).commonEnterQuantityMin;
      setState(() {
        _returnQtyError = returnInvalid ? message : null;
        _outQtyError = outInvalid ? message : null;
      });
      return;
    }

    final returnPieces =
        _canBreakPack(_returnProduct) && _returnUnitChoice == _returnProduct!.pcsUnitId;
    final outPieces = _settlement == 'product' &&
        _canBreakPack(_outProduct) &&
        _outUnitChoice == _outProduct!.pcsUnitId;

    setState(() {
      _returnQtyError = null;
      _outQtyError = null;
      _saving = true;
    });
    try {
      await ref.read(inventoryRepositoryProvider).createProductExchange(
            salesPersonId: salesPersonId,
            settlementType: _settlement,
            returnProductId: _returnProduct!.id,
            returnQuantity: returnQuantity,
            // Unit ids omitted for cartons — the server treats missing unit
            // ids as whole cartons.
            returnUnitId: returnPieces ? _returnProduct!.pcsUnitId : null,
            outProductId: _settlement == 'product' ? _outProduct!.id : null,
            outQuantity: outQuantity,
            outUnitId: outPieces ? _outProduct!.pcsUnitId : null,
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

  Widget _unitDropdown({
    required ProductModel product,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    final l10n = AppLocalizations.of(context);
    return DropdownButtonFormField<int>(
      key: ValueKey('unit_${product.id}'),
      initialValue: value,
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
          value: product.pcsUnitId,
          child: Text(l10n.commonUnitPiece(product.piecesPerCarton)),
        ),
      ],
      onChanged: (v) => onChanged(v ?? _kCartonChoice),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.salesVanExchangeReturns, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () async {
            final product = await pickProduct(context, ref);
            if (product != null) {
              setState(() {
                _returnProduct = product;
                // Units are per-product; never carry a pieces choice over.
                _returnUnitChoice = _kCartonChoice;
              });
            }
          },
          child: Text(_returnProduct?.name ?? l10n.salesVanExchangeSelectReturn),
        ),
        if (_canBreakPack(_returnProduct)) ...[
          const SizedBox(height: 12),
          _unitDropdown(
            product: _returnProduct!,
            value: _returnUnitChoice,
            onChanged: (v) => setState(() => _returnUnitChoice = v),
          ),
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _returnQty,
          decoration: InputDecoration(
            // "(cartons)" only applies while no unit can be chosen.
            labelText: _canBreakPack(_returnProduct)
                ? l10n.commonQuantity
                : l10n.salesVanExchangeReturnQty,
            border: const OutlineInputBorder(),
            errorText: _returnQtyError,
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) {
            if (_returnQtyError != null) setState(() => _returnQtyError = null);
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _settlement,
          decoration: InputDecoration(labelText: l10n.salesVanExchangeSettlement, border: const OutlineInputBorder()),
          items: [
            DropdownMenuItem(value: 'product', child: Text(l10n.salesVanExchangeGiveProduct)),
            DropdownMenuItem(value: 'cash', child: Text(l10n.salesVanExchangeCashRefund)),
          ],
          onChanged: (v) => setState(() => _settlement = v ?? 'product'),
        ),
        if (_settlement == 'product') ...[
          const SizedBox(height: 16),
          Text(l10n.salesVanExchangeGiveTo, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              final product = await pickProduct(context, ref);
              if (product != null) {
                setState(() {
                  _outProduct = product;
                  // Units are per-product; never carry a pieces choice over.
                  _outUnitChoice = _kCartonChoice;
                });
              }
            },
            child: Text(_outProduct?.name ?? l10n.salesVanExchangeSelectOut),
          ),
          if (_canBreakPack(_outProduct)) ...[
            const SizedBox(height: 12),
            _unitDropdown(
              product: _outProduct!,
              value: _outUnitChoice,
              onChanged: (v) => setState(() => _outUnitChoice = v),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _outQty,
            decoration: InputDecoration(
              // "(cartons)" only applies while no unit can be chosen.
              labelText: _canBreakPack(_outProduct)
                  ? l10n.commonQuantity
                  : l10n.salesVanExchangeOutQty,
              border: const OutlineInputBorder(),
              errorText: _outQtyError,
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) {
              if (_outQtyError != null) setState(() => _outQtyError = null);
            },
          ),
        ],
        if (_settlement == 'cash') ...[
          const SizedBox(height: 12),
          TextField(
            controller: _cashAmount,
            decoration: InputDecoration(labelText: l10n.salesVanExchangeCashAmount, border: const OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _reason,
          decoration: InputDecoration(labelText: l10n.commonReason, border: const OutlineInputBorder()),
          maxLines: 2,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(l10n.salesVanExchangeRecord),
        ),
      ],
    );
  }
}
