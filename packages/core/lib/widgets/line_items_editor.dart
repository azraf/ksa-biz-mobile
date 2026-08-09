import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

class LineItemDraft {
  LineItemDraft({
    required this.product,
    this.quantity = 1,
    int? unitId,
    double? price,
    this.discount = 0,
    this.vat = 0,
  })  : unitId = unitId ?? product.defaultCartonUnitId,
        price = price ?? product.priceForUnitId(unitId ?? product.defaultCartonUnitId);

  final ProductModel product;
  int quantity;
  int? unitId;
  double price;
  double discount;
  double vat;

  double get lineTotal => (price * quantity) - discount + vat;

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
  });

  final List<LineItemDraft> items;
  final VoidCallback onChanged;
  final void Function(int index)? onRemove;
  final bool readOnly;

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
              subtitle: Text('${items[i].quantityLabel} · ${currency.format(items[i].lineTotal)}'),
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
                        builder: (_) => _LineItemDialog(item: items[i]),
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
              l10n.commonTotal(currency.format(items.fold<double>(0, (s, e) => s + e.lineTotal))),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}

class _LineItemDialog extends StatefulWidget {
  const _LineItemDialog({required this.item});

  final LineItemDraft item;

  @override
  State<_LineItemDialog> createState() => _LineItemDialogState();
}

class _LineItemDialogState extends State<_LineItemDialog> {
  late final TextEditingController _qty;
  late final TextEditingController _price;
  late final TextEditingController _discount;
  late final TextEditingController _vat;
  late int? _unitId;

  @override
  void initState() {
    super.initState();
    _unitId = widget.item.unitId;
    _qty = TextEditingController(text: '${widget.item.quantity}');
    _price = TextEditingController(text: '${widget.item.price}');
    _discount = TextEditingController(text: '${widget.item.discount}');
    _vat = TextEditingController(text: '${widget.item.vat}');
  }

  @override
  void dispose() {
    _qty.dispose();
    _price.dispose();
    _discount.dispose();
    _vat.dispose();
    super.dispose();
  }

  void _onUnitChanged(int? unitId) {
    setState(() {
      _unitId = unitId;
      _price.text = '${widget.item.product.priceForUnitId(unitId)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final product = widget.item.product;
    final canBreakPack = product.allowBreakPack && product.pcsUnitId != null;

    return AlertDialog(
      title: Text(product.name),
      content: Column(
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
            controller: _vat,
            decoration: InputDecoration(labelText: l10n.commonVat),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.commonCancel)),
        FilledButton(
          onPressed: () {
            widget.item.quantity = int.tryParse(_qty.text) ?? widget.item.quantity;
            widget.item.unitId = _unitId;
            widget.item.price = double.tryParse(_price.text) ?? widget.item.price;
            widget.item.discount = double.tryParse(_discount.text) ?? widget.item.discount;
            widget.item.vat = double.tryParse(_vat.text) ?? widget.item.vat;
            Navigator.pop(context, widget.item);
          },
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
