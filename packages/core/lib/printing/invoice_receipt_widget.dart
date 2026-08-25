import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/order.dart';
import '../models/zatca_config.dart';

/// The invoice as a widget, rendered offscreen to an image for both thermal
/// printing and sharing. Deliberately fixed black-on-white — this is ink on
/// paper, not themed UI (the one sanctioned exception to the AppColors rule).
class InvoiceReceiptWidget extends StatelessWidget {
  const InvoiceReceiptWidget({
    super.key,
    required this.order,
    required this.config,
    this.widthDots = 384,
    this.isCopy = false,
  });

  final OrderModel order;
  final ZatcaConfig config;

  /// 384 for 58mm paper, 576 for 80mm.
  final double widthDots;
  final bool isCopy;

  static const _black = Color(0xFF000000);
  static const _white = Color(0xFFFFFFFF);

  bool get _narrow => widthDots < 500;

  String _money(double v) => v.toStringAsFixed(2);

  TextStyle _style({double size = 20, FontWeight weight = FontWeight.w500}) =>
      TextStyle(color: _black, fontSize: size, fontWeight: weight, height: 1.3);

  @override
  Widget build(BuildContext context) {
    final base = _narrow ? 18.0 : 22.0;
    final qrData = order.zatca?.qr;

    return Container(
      width: widthDots,
      color: _white,
      padding: EdgeInsets.symmetric(horizontal: _narrow ? 8 : 16, vertical: 12),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (config.sellerNameAr.isNotEmpty)
              Text(
                config.sellerNameAr,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: _style(size: base + 8, weight: FontWeight.w700),
              ),
            if (config.sellerName.isNotEmpty)
              Text(
                config.sellerName,
                textAlign: TextAlign.center,
                style: _style(size: base + 2, weight: FontWeight.w600),
              ),
            if (config.vatNumber.isNotEmpty)
              Text('VAT: ${config.vatNumber}', textAlign: TextAlign.center, style: _style(size: base - 2)),
            if (config.crNumber.isNotEmpty)
              Text('CR: ${config.crNumber}', textAlign: TextAlign.center, style: _style(size: base - 2)),
            if (config.sellerAddress.isNotEmpty)
              Text(config.sellerAddress, textAlign: TextAlign.center, style: _style(size: base - 2)),
            SizedBox(height: base / 2),
            if (config.enabled) ...[
              Text('فاتورة ضريبية مبسطة',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: _style(size: base + 2, weight: FontWeight.w700)),
              Text('Simplified Tax Invoice',
                  textAlign: TextAlign.center, style: _style(size: base, weight: FontWeight.w600)),
            ] else
              Text('Invoice', textAlign: TextAlign.center, style: _style(size: base + 2, weight: FontWeight.w700)),
            if (isCopy)
              Text('* COPY *', textAlign: TextAlign.center, style: _style(size: base, weight: FontWeight.w700)),
            SizedBox(height: base / 2),
            _rule(),
            _kv('Invoice #', order.invoiceNumber ?? '#${order.id}', base),
            if (order.zatca?.icv != null) _kv('ICV', '${order.zatca!.icv}', base),
            _kv('Date', (order.createdAt ?? '').replaceFirst('T', ' ').split('.').first, base),
            if (order.customerShopName != null) _kv('Customer', order.customerShopName!, base),
            if (order.salesPerson?.name != null) _kv('Salesperson', order.salesPerson!.name, base),
            _rule(),
            // Line items
            for (final item in order.items) ...[
              Text(
                item.product?.name ?? 'Item #${item.productId}',
                style: _style(size: base, weight: FontWeight.w600),
              ),
              if (item.product?.nameAr != null && item.product!.nameAr!.isNotEmpty)
                Text(
                  item.product!.nameAr!,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: _style(size: base),
                ),
              Row(
                children: [
                  Expanded(
                    child: Text('${item.quantityLabel} x ${_money(item.productPrice)}',
                        style: _style(size: base - 2)),
                  ),
                  Text(_money(item.bill), style: _style(size: base, weight: FontWeight.w600)),
                ],
              ),
              SizedBox(height: base / 4),
            ],
            _rule(),
            _totalRow('Subtotal', order.subtotal + order.grandDiscount, base),
            if (order.grandDiscount > 0) _totalRow('Discount', -order.grandDiscount, base),
            _totalRow('VAT', order.vatTotal, base),
            _rule(),
            Row(
              children: [
                Expanded(child: Text('TOTAL (SAR)', style: _style(size: base + 4, weight: FontWeight.w800))),
                Text(_money(order.totalBill), style: _style(size: base + 4, weight: FontWeight.w800)),
              ],
            ),
            if (order.amountPaid > 0) ...[
              _totalRow('Paid', order.amountPaid, base),
              _totalRow('Due', order.outstandingDue, base),
            ],
            if (qrData != null && qrData.isNotEmpty) ...[
              SizedBox(height: base / 2),
              Center(
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: _narrow ? 220 : 280,
                  backgroundColor: _white,
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: _black,
                  ),
                  eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: _black),
                ),
              ),
            ] else if (config.enabled) ...[
              SizedBox(height: base / 2),
              Text('E-invoice pending — QR on reprint',
                  textAlign: TextAlign.center, style: _style(size: base - 2)),
            ],
            SizedBox(height: base / 2),
            Text('شكراً لتعاملكم معنا',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: _style(size: base - 2)),
            Text('Thank you for your business',
                textAlign: TextAlign.center, style: _style(size: base - 2)),
          ],
        ),
      ),
    );
  }

  Widget _rule() => Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        height: 2,
        color: _black,
      );

  Widget _kv(String label, String value, double base) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: _style(size: base - 2)),
          Expanded(
            child: Text(value, textAlign: TextAlign.right, style: _style(size: base - 2, weight: FontWeight.w600)),
          ),
        ],
      );

  Widget _totalRow(String label, double value, double base) => Row(
        children: [
          Expanded(child: Text(label, style: _style(size: base))),
          Text(_money(value), style: _style(size: base, weight: FontWeight.w600)),
        ],
      );
}
