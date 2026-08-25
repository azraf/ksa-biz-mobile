import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
      qr: 'AQtLU0EgQml6IFRlc3Q=', // any base64 payload renders
      status: 'generated',
      printCount: 1,
    ),
    items: const [
      OrderItemModel(
        id: 1,
        productId: 1,
        quantity: 2,
        productPrice: 100,
        productVat: 30,
        bill: 230,
        product: ProductModel(id: 1, name: 'Cola Carton', nameAr: 'كرتون كولا'),
      ),
    ],
  );

  testWidgets('renders seller header, Arabic name, totals, COPY and QR', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SingleChildScrollView(
          child: InvoiceReceiptWidget(order: order, config: config, isCopy: true),
        ),
      ),
    );

    expect(find.text('شركة التجارة'), findsOneWidget);
    expect(find.text('VAT: 310000000000003'), findsOneWidget);
    expect(find.text('Simplified Tax Invoice'), findsOneWidget);
    expect(find.text('* COPY *'), findsOneWidget);
    expect(find.text('Cola Carton'), findsOneWidget);
    expect(find.text('كرتون كولا'), findsOneWidget);
    expect(find.text('230.00'), findsWidgets);
    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.textContaining('ICV'), findsOneWidget);
  });

  testWidgets('plain receipt without ZATCA shows no QR and no tax-invoice title', (tester) async {
    final plainOrder = OrderModel(
      id: 8,
      customerTypeId: 1,
      totalBill: 100,
      items: order.items,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SingleChildScrollView(
          child: InvoiceReceiptWidget(order: plainOrder, config: const ZatcaConfig()),
        ),
      ),
    );

    expect(find.text('Invoice'), findsOneWidget);
    expect(find.text('Simplified Tax Invoice'), findsNothing);
    expect(find.byType(QrImageView), findsNothing);
  });
}
