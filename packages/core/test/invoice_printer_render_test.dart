import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

// Regression: captureFromWidget(targetSize: null) clamped the offscreen
// layout to the phone screen, clipping header/footer/QR off any receipt
// taller (or wider — 80mm paper) than the display.
void main() {
  testWidgets('renderWidget captures the full receipt, not just the screen', (tester) async {
    tester.view.physicalSize = const Size(400, 800); // small fake phone
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    const config = ZatcaConfig(
      phase: 'phase1',
      sellerName: 'KSA Biz Trading',
      sellerNameAr: 'شركة التجارة',
      vatNumber: '310000000000003',
    );
    final order = OrderModel(
      id: 7,
      customerTypeId: 1,
      invoiceNumber: 'SA-M2608241030ABC',
      subtotal: 200,
      vatTotal: 30,
      totalBill: 230,
      createdAt: '2026-08-24T10:30:00',
      customerShopName: 'Test Shop',
      zatca: const OrderZatcaModel(
        invoiceGenerated: true,
        icv: 12,
        qr: 'AQtLU0EgQml6IFRlc3Q=',
        status: 'generated',
        printCount: 0,
      ),
      items: List.generate(
        25,
        (i) => OrderItemModel(
          id: i + 1,
          productId: i + 1,
          quantity: 2,
          productPrice: 100,
          productVat: 30,
          bill: 230,
          product: ProductModel(id: i + 1, name: 'Product $i', nameAr: 'منتج $i'),
        ),
      ),
    );

    // runAsync: the capture awaits a real delay and a real engine toImage,
    // both of which never complete inside the fake-async test zone.
    final png = await tester.runAsync(
      () => const InvoicePrinter().renderWidget(
        InvoiceReceiptWidget(order: order, config: config, widthDots: 576),
        widthDots: 576,
        pixelRatio: 1.0,
      ),
    );

    final decoded = img.decodePng(png!);
    expect(decoded, isNotNull);
    // 80mm paper (576 dots) is wider than the 400px screen.
    expect(decoded!.width, 576);
    // 25 bilingual items + QR + footer tower over the 800px screen.
    expect(decoded.height, greaterThan(800));
  });
}
