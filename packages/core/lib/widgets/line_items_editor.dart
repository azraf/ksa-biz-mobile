import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

/// Order-level VAT settings that drive line VAT math and display.
class OrderVatSettings {
  const OrderVatSettings({this.enabled = false, this.inclusive = false, this.rate = 15});

  final bool enabled;

  /// True when entered prices already include VAT.
  final bool inclusive;

  /// Percentage, e.g. 15 for 15%.
  final double rate;
}

/// Half-up rounding to 2 decimal places, half away from zero for negatives.
/// Dart's roundToDouble is not reliably half-up on binary floats.
double round2(double v) {
  if (v < 0) return -round2(-v);
  return ((v * 100) + 0.5).floorToDouble() / 100;
}

class LineItemDraft {
  LineItemDraft({
    required this.product,
    this.quantity = 1,
    int? unitId,
    double? price,
    this.discount = 0,
    this.vat = 0,
    this.vatRate = 15,
  })  : unitId = unitId ?? product.defaultCartonUnitId,
        price = price ?? product.priceForUnitId(unitId ?? product.defaultCartonUnitId);

  final ProductModel product;
  int quantity;
  int? unitId;
  double price;
  double discount;

  /// Derived from the order's [OrderVatSettings] by [applyVat]; kept as a
  /// field so the create payload and legacy [lineTotal] keep working.
  double vat;

  /// Rate used by the last [applyVat] call, sent as `vat_rate`.
  double vatRate;

  double get lineTotal => (price * quantity) - discount + vat;

  double get _base => (price * quantity) - discount;

  /// Recomputes [vat] for [s] and records the rate used into [vatRate].
  void applyVat(OrderVatSettings s) {
    vatRate = s.rate;
    if (!s.enabled) {
      vat = 0;
      return;
    }
    if (s.inclusive) {
      final total = round2(_base);
      final excl = round2(total / (1 + s.rate / 100));
      vat = total - excl; // excl + vat == total by construction
    } else {
      vat = round2(_base * s.rate / 100);
    }
  }

  /// Line total excluding VAT under [s].
  double exclTotal(OrderVatSettings s) {
    if (!s.enabled) return _base;
    if (s.inclusive) {
      final total = round2(_base);
      return round2(total / (1 + s.rate / 100));
    }
    return round2(_base);
  }

  /// Line total including VAT under [s].
  double grossTotal(OrderVatSettings s) {
    if (!s.enabled) return _base;
    if (s.inclusive) return round2(_base);
    return round2(_base) + round2(_base * s.rate / 100);
  }

  String get unitLabel => product.unitLabel(unitId);

  String get quantityLabel => '$quantity $unitLabel';

  void setUnit(int? newUnitId) {
    unitId = newUnitId;
    price = product.priceForUnitId(newUnitId);
  }

  Map<String, dynamic> toJson() => {
        'product_id': product.id,
        'quantity': quantity,
        if (unitId != null) 'unit_id': unitId,
        'product_price': price,
        'product_discount': discount,
        'product_vat': vat,
        'vat_rate': vatRate,
        'is_preorder': false,
      };
}

class LineItemsEditor extends StatelessWidget {
  const LineItemsEditor({
    super.key,
    required this.items,
    required this.onChanged,
    this.onRemove,
    this.readOnly = false,
    this.vat = const OrderVatSettings(),
  });

  final List<LineItemDraft> items;
  final VoidCallback onChanged;
  final void Function(int index)? onRemove;
  final bool readOnly;
  final OrderVatSettings vat;

  String _subtitle(AppLocalizations l10n, NumberFormat currency, LineItemDraft item) {
    if (!vat.enabled) {
      return '${item.quantityLabel} · ${currency.format(item.lineTotal)}';
    }
    final excl = item.exclTotal(vat);
    final gross = item.grossTotal(vat);
    return l10n.lineItemVatSubtitle(
      item.quantityLabel,
      currency.format(excl),
      currency.format(gross - excl),
      currency.format(gross),
    );
  }

  double _runningTotal() => items.fold<double>(
        0,
        (s, e) => s + (vat.enabled ? e.grossTotal(vat) : e.lineTotal),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (items.isEmpty) {
      return EmptyView(message: l10n.commonNoItemsYet);
    }

    final currency = NumberFormat.currency(symbol: 'SAR ');

    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          Card(
            child: ListTile(
              title: Text(items[i].product.name),
              subtitle: Text(_subtitle(l10n, currency, items[i])),
              trailing: readOnly
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: onRemove == null ? null : () => onRemove!(i),
                    ),
              onTap: readOnly
                  ? null
                  : () async {
                      final updated = await showDialog<LineItemDraft>(
                        context: context,
                        builder: (_) => _LineItemDialog(item: items[i], vat: vat),
                      );
                      if (updated != null) {
                        items[i] = updated;
                        onChanged();
                      }
                    },
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              l10n.commonTotal(currency.format(_runningTotal())),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}

class _LineItemDialog extends StatefulWidget {
  const _LineItemDialog({required this.item, required this.vat});

  final LineItemDraft item;
  final OrderVatSettings vat;

  @override
  State<_LineItemDialog> createState() => _LineItemDialogState();
}

class _LineItemDialogState extends State<_LineItemDialog> {
  late final TextEditingController _qty;
  late final TextEditingController _price;
  late final TextEditingController _discount;
  late final TextEditingController _total;
  late int? _unitId;

  /// Guards the qty/price/discount ↔ total listeners against re-entrancy.
  bool _syncing = false;

  OrderVatSettings get _vat => widget.vat;

  int get _qtyValue => int.tryParse(_qty.text) ?? 0;
  double get _priceValue => double.tryParse(_price.text) ?? 0;
  double get _discountValue => double.tryParse(_discount.text) ?? 0;
  double get _baseValue => (_priceValue * _qtyValue) - _discountValue;

  double get _grossValue {
    final base = _baseValue;
    if (!_vat.enabled) return base;
    if (_vat.inclusive) return round2(base);
    return round2(base) + round2(base * _vat.rate / 100);
  }

  double get _exclValue {
    final base = _baseValue;
    if (!_vat.enabled) return base;
    if (_vat.inclusive) return round2(round2(base) / (1 + _vat.rate / 100));
    return round2(base);
  }

  @override
  void initState() {
    super.initState();
    _unitId = widget.item.unitId;
    _qty = TextEditingController(text: '${widget.item.quantity}');
    _price = TextEditingController(text: '${widget.item.price}');
    _discount = TextEditingController(text: '${widget.item.discount}');
    _total = TextEditingController();
    _total.text = _grossValue.toStringAsFixed(2);
    _qty.addListener(_recomputeTotal);
    _price.addListener(_recomputeTotal);
    _discount.addListener(_recomputeTotal);
    _total.addListener(_onTotalEdited);
  }

  @override
  void dispose() {
    _qty.dispose();
    _price.dispose();
    _discount.dispose();
    _total.dispose();
    super.dispose();
  }

  /// Qty/price/discount edited → recompute the total field.
  void _recomputeTotal() {
    if (_syncing) return;
    _syncing = true;
    _total.text = _grossValue.toStringAsFixed(2);
    _syncing = false;
    setState(() {});
  }

  /// Total edited → back-compute a 2dp price, then snap the total back to the
  /// price-derived value so the display matches what the server will compute.
  void _onTotalEdited() {
    if (_syncing) return;
    final qty = _qtyValue;
    if (qty <= 0) return;
    final total = double.tryParse(_total.text);
    if (total == null) return;
    _syncing = true;
    final double price;
    if (_vat.enabled && !_vat.inclusive) {
      price = round2((total / (1 + _vat.rate / 100) + _discountValue) / qty);
    } else {
      price = round2((total + _discountValue) / qty);
    }
    _price.text = price.toStringAsFixed(2);
    _total.text = _grossValue.toStringAsFixed(2);
    _syncing = false;
    setState(() {});
  }

  void _onUnitChanged(int? unitId) {
    setState(() {
      _unitId = unitId;
      _price.text = '${widget.item.product.priceForUnitId(unitId)}';
    });
  }

  Widget _readOnlyRow(BuildContext context, String label, double value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          Text(value.toStringAsFixed(2), style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final product = widget.item.product;
    final canBreakPack = product.allowBreakPack && product.pcsUnitId != null;

    return AlertDialog(
      title: Text(product.name),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canBreakPack)
              DropdownButtonFormField<int>(
                initialValue: _unitId,
                decoration: InputDecoration(labelText: l10n.commonUnit),
                items: [
                  if (product.defaultCartonUnitId > 0)
                    DropdownMenuItem(
                      value: product.defaultCartonUnitId,
                      child: Text(l10n.commonUnitCarton),
                    ),
                  DropdownMenuItem(
                    value: product.pcsUnitId,
                    child: Text(l10n.commonUnitPiece(product.piecesPerCarton)),
                  ),
                ],
                onChanged: _onUnitChanged,
              ),
            TextField(
              controller: _qty,
              decoration: InputDecoration(labelText: l10n.commonQuantity),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _price,
              decoration: InputDecoration(labelText: l10n.commonPrice),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _discount,
              decoration: InputDecoration(labelText: l10n.commonDiscount),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _total,
              decoration: InputDecoration(labelText: l10n.commonTotalLabel),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            if (_vat.enabled) ...[
              _readOnlyRow(context, l10n.commonExclVat, _exclValue),
              _readOnlyRow(context, l10n.commonVat, _grossValue - _exclValue),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.commonCancel)),
        FilledButton(
          onPressed: () {
            widget.item.quantity = int.tryParse(_qty.text) ?? widget.item.quantity;
            widget.item.unitId = _unitId;
            widget.item.price = double.tryParse(_price.text) ?? widget.item.price;
            widget.item.discount = double.tryParse(_discount.text) ?? widget.item.discount;
            widget.item.applyVat(widget.vat);
            Navigator.pop(context, widget.item);
          },
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
