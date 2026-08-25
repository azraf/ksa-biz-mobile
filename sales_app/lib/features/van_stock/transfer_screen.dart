import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

/// Sentinel for "whole cartons" in the unit dropdown — the server treats a
/// missing `unit_id` as cartons, so no real unit id is needed.
const kCartonUnitChoice = 0;

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
  String? _qtyError;
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  /// The global "pcs" unit id from `/units` — the van-stock payload's product
  /// rows don't carry `pcs_unit_id`, so it is resolved once here. Null hides
  /// the pieces option.
  int? _pcsUnitId;

  /// [kCartonUnitChoice] or [_pcsUnitId].
  int _unitChoice = kCartonUnitChoice;

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
    final l10n = AppLocalizations.of(context);
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null) {
      // No salesperson selected/attached — show a recoverable error instead
      // of crashing on a null-assert.
      setState(() {
        _loading = false;
        _error = l10n.salesSelectSalespersonFirst;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final stock = await ref.read(inventoryRepositoryProvider).vanStock(salesPersonId);
      final persons = await ref.read(customerRepositoryProvider).salesPersons();
      final pcsUnitId = await _resolvePcsUnitId();
      if (!mounted) return;
      setState(() {
        _vanStock = stock;
        _salesPersons = persons.items.where((p) => p.id != salesPersonId).toList();
        _pcsUnitId = pcsUnitId;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      showAppErrorSnackBar(context, e);
    }
  }

  /// Best-effort: without it the screen simply stays carton-only.
  Future<int?> _resolvePcsUnitId() async {
    try {
      final units = await AdminRepositories(ref.read(apiClientProvider)).units.list();
      for (final unit in units) {
        if (unit.shortName.toLowerCase() == 'pcs') return unit.id;
      }
    } catch (_) {
      // Offline or unreachable — carton-only transfer still works.
    }
    return null;
  }

  bool get _canBreakPack =>
      (_selectedProduct?.product?.allowBreakPack ?? false) && _pcsUnitId != null;

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final fromId = requireSalesPersonId(ref.read(authProvider));
    if (fromId == null || _selectedProduct == null || _selectedTarget == null) return;
    final quantity = int.tryParse(_qtyController.text.trim());
    if (quantity == null || quantity < 1) {
      // Reject instead of silently substituting 1 — this moves real stock.
      setState(
        () => _qtyError = l10n.commonEnterQuantityMin,
      );
      return;
    }
    final sendPieces = _canBreakPack && _unitChoice == _pcsUnitId;
    setState(() {
      _qtyError = null;
      _submitting = true;
    });
    try {
      await ref.read(inventoryRepositoryProvider).transfer(
            productId: _selectedProduct!.productId,
            quantity: quantity,
            fromSalesPersonId: fromId,
            toSalesPersonId: _selectedTarget!.id,
            // Omitted for cartons — the server treats a missing unit_id as
            // whole cartons.
            unitId: sendPieces ? _pcsUnitId : null,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.salesVanTransferCompleted)));
        context.pop();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      showAppErrorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) return LoadingView(message: l10n.commonLoading);
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final piecesPerCarton = _selectedProduct?.piecesPerCarton ?? 1;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButtonFormField<InventoryStockModel>(
            key: ValueKey(_selectedProduct?.productId),
            initialValue: _selectedProduct,
            decoration: InputDecoration(labelText: l10n.salesVanTransferProduct),
            items: _vanStock
                .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text('${s.product?.name ?? s.productId} (${s.displayBalance})'),
                    ))
                .toList(),
            onChanged: (v) => setState(() {
              _selectedProduct = v;
              // Units are per-product; never carry a pieces choice over.
              _unitChoice = kCartonUnitChoice;
            }),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<SalesPersonModel>(
            key: ValueKey(_selectedTarget?.id),
            initialValue: _selectedTarget,
            decoration: InputDecoration(labelText: l10n.salesVanTransferTo),
            items: _salesPersons
                .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                .toList(),
            onChanged: (v) => setState(() => _selectedTarget = v),
          ),
          if (_canBreakPack) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              key: ValueKey('unit_${_selectedProduct?.productId}'),
              initialValue: _unitChoice,
              decoration: InputDecoration(labelText: l10n.commonUnit),
              items: [
                DropdownMenuItem(
                  value: kCartonUnitChoice,
                  child: Text(l10n.commonUnitCarton),
                ),
                DropdownMenuItem(
                  value: _pcsUnitId,
                  child: Text(l10n.commonUnitPiece(piecesPerCarton)),
                ),
              ],
              onChanged: (v) => setState(() => _unitChoice = v ?? kCartonUnitChoice),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _qtyController,
            // Without a unit selector, quantities are booked as whole
            // cartons — the label must say so.
            decoration: InputDecoration(
              labelText: _canBreakPack ? l10n.commonQuantity : l10n.commonQuantityCartons,
              errorText: _qtyError,
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) {
              if (_qtyError != null) setState(() => _qtyError = null);
            },
          ),
          const Spacer(),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting ? const CircularProgressIndicator() : Text(l10n.salesVanTransfer),
          ),
        ],
      ),
    );
  }
}
