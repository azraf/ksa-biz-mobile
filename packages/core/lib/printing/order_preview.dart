import 'package:flutter/material.dart';

import '../models/order.dart';
import '../models/order_item.dart';
import '../models/sales_person.dart';
import '../models/zatca_config.dart';
import '../widgets/line_items_editor.dart';
import 'invoice_receipt_widget.dart';

/// Builds a synthetic [OrderModel] from line-item drafts so the invoice can be
/// previewed before the order exists on the server. Totals follow the
/// [LineItemDraft.applyVat] math (subtotal + vatTotal == totalBill by
/// construction); `zatca` stays null so the receipt shows its pending-QR line.
OrderModel buildPreviewOrder({
  required List<LineItemDraft> items,
  required OrderVatSettings vat,
  String? customerName,
  String? salesPersonName,
  DateTime? createdAt,
}) {
  var subtotal = 0.0;
  var vatTotal = 0.0;
  var totalBill = 0.0;
  final orderItems = <OrderItemModel>[];

  for (var i = 0; i < items.length; i++) {
    final draft = items[i];
    final excl = draft.exclTotal(vat);
    final gross = draft.grossTotal(vat);
    final lineVat = gross - excl;
    subtotal += excl;
    vatTotal += lineVat;
    totalBill += gross;
    orderItems.add(OrderItemModel(
      id: -(i + 1),
      productId: draft.product.id,
      quantity: draft.quantity,
      unitId: draft.unitId,
      productPrice: draft.price,
      productDiscount: draft.discount,
      productVat: lineVat,
      vatRate: vat.enabled ? vat.rate : null,
      bill: gross,
      product: draft.product,
    ));
  }

  return OrderModel(
    id: 0,
    customerTypeId: 0,
    status: 'draft',
    subtotal: subtotal,
    vatTotal: vatTotal,
    totalBill: totalBill,
    includeVat: vat.enabled,
    vatInclusive: vat.inclusive,
    vatRate: vat.enabled ? vat.rate : null,
    items: orderItems,
    customerShopName: customerName,
    salesPerson: salesPersonName == null
        ? null
        : SalesPersonModel(id: 0, name: salesPersonName),
    createdAt: (createdAt ?? DateTime.now()).toIso8601String(),
  );
}

/// Bottom sheet previewing [previewOrder] as the printed invoice, asking the
/// user to confirm the order or keep it as a draft.
///
/// Resolves to `true` on Confirm, `false` on Keep as draft, `null` when
/// dismissed.
Future<bool?> showOrderPreviewConfirmSheet(
  BuildContext context, {
  required OrderModel previewOrder,
  required ZatcaConfig config,
  String? confirmLabel,
  String? keepDraftLabel,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useRootNavigator: true,
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: InvoiceReceiptWidget(order: previewOrder, config: config),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(
                'Preview — QR is generated at invoicing',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(sheetContext).pop(false),
                      child: Text(keepDraftLabel ?? 'Keep as draft'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(sheetContext).pop(true),
                      child: Text(confirmLabel ?? 'Confirm'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
