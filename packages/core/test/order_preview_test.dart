import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _cola = ProductModel(id: 1, name: 'Cola Carton', nameAr: 'كرتون كولا', price: 50);
const _chips = ProductModel(id: 2, name: 'Chips Box', price: 99.99);

const _config = ZatcaConfig(
  phase: 'phase1',
  sellerName: 'KSA Biz Trading',
  sellerNameAr: 'شركة التجارة',
  vatNumber: '310000000000003',
);

void main() {
  group('buildPreviewOrder', () {
    test('totals are consistent with the applyVat math (inclusive)', () {
      const vat = OrderVatSettings(enabled: true, inclusive: true, rate: 15);
      final order = buildPreviewOrder(
        items: [
          LineItemDraft(product: _cola, quantity: 2, price: 50), // gross 100
          LineItemDraft(product: _chips, quantity: 1, price: 99.99), // gross 99.99
        ],
        vat: vat,
        customerName: 'Test Shop',
        salesPersonName: 'Ali',
      );

      expect(order.totalBill, closeTo(199.99, 1e-9));
      expect(order.subtotal, closeTo(86.96 + 86.95, 1e-9));
      expect(order.vatTotal, closeTo(13.04 + 13.04, 1e-9));
      expect(order.subtotal + order.vatTotal, closeTo(order.totalBill, 1e-9));
      expect(order.includeVat, isTrue);
      expect(order.vatInclusive, isTrue);
      expect(order.vatRate, 15);
      expect(order.zatca, isNull);
      expect(order.customerShopName, 'Test Shop');
      expect(order.salesPerson?.name, 'Ali');

      final item = order.items.first;
      expect(item.product?.name, 'Cola Carton');
      expect(item.bill, 100.00);
      expect(item.productVat, closeTo(13.04, 1e-9));
      expect(item.vatRate, 15);
    });

    test('vat off keeps plain totals and no rate', () {
      final order = buildPreviewOrder(
        items: [LineItemDraft(product: _cola, quantity: 2, price: 50)],
        vat: const OrderVatSettings(),
      );
      expect(order.totalBill, 100);
      expect(order.subtotal, 100);
      expect(order.vatTotal, 0);
      expect(order.includeVat, isFalse);
      expect(order.vatRate, isNull);
    });
  });

  testWidgets('preview sheet renders the receipt and pops true on confirm', (tester) async {
    const vat = OrderVatSettings(enabled: true, inclusive: true, rate: 15);
    final order = buildPreviewOrder(
      items: [LineItemDraft(product: _cola, quantity: 2, price: 50)],
      vat: vat,
      customerName: 'Test Shop',
    );

    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () async {
                result = await showOrderPreviewConfirmSheet(
                  context,
                  previewOrder: order,
                  config: _config,
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Receipt header and preview hint.
    expect(find.text('KSA Biz Trading'), findsOneWidget);
    expect(find.text('شركة التجارة'), findsOneWidget);
    expect(find.text('Cola Carton'), findsOneWidget);
    expect(find.text('Preview — QR is generated at invoicing'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
    expect(find.text('Keep as draft'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
    expect(find.text('Confirm'), findsNothing);
  });

  testWidgets('keep-as-draft pops false', (tester) async {
    final order = buildPreviewOrder(
      items: [LineItemDraft(product: _cola, quantity: 1, price: 50)],
      vat: const OrderVatSettings(enabled: true, rate: 15),
    );

    bool? result = true;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () async {
                result = await showOrderPreviewConfirmSheet(
                  context,
                  previewOrder: order,
                  config: _config,
                  confirmLabel: 'Yes, confirm',
                  keepDraftLabel: 'Later',
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Yes, confirm'), findsOneWidget);
    await tester.tap(find.text('Later'));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });
}
