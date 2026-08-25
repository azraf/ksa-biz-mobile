import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n/l10n.dart';

const _product = ProductModel(id: 1, name: 'Cola Carton', price: 50);

Future<LineItemDraft> _pumpEditor(
  WidgetTester tester, {
  required OrderVatSettings vat,
  void Function()? onChanged,
}) async {
  final item = LineItemDraft(product: _product, quantity: 2, price: 50);
  await tester.pumpWidget(MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: StatefulBuilder(
        // Rebuild on change, as the hosting screens do.
        builder: (context, setState) => LineItemsEditor(
          items: [item],
          onChanged: () {
            onChanged?.call();
            setState(() {});
          },
          vat: vat,
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();
  return item;
}

Finder _field(String label) => find.widgetWithText(TextField, label);

String _fieldText(WidgetTester tester, String label) =>
    tester.widget<TextField>(_field(label)).controller!.text;

void main() {
  const inclusive = OrderVatSettings(enabled: true, inclusive: true, rate: 15);

  testWidgets('dialog shows VAT breakdown and no free-text VAT field', (tester) async {
    await _pumpEditor(tester, vat: inclusive);

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    // Fields: Quantity, Price, Discount, Total — the free-text VAT input is gone.
    expect(_field('Quantity'), findsOneWidget);
    expect(_field('Price'), findsOneWidget);
    expect(_field('Discount'), findsOneWidget);
    expect(_field('Total'), findsOneWidget);
    expect(_field('VAT'), findsNothing);

    // base 100 inclusive @15 => total 100.00, excl 86.96, VAT 13.04.
    expect(_fieldText(tester, 'Total'), '100.00');
    expect(find.text('Excl. VAT'), findsOneWidget);
    expect(find.text('86.96'), findsOneWidget);
    expect(find.text('13.04'), findsOneWidget);
  });

  testWidgets('editing Total in included mode back-computes price and snaps', (tester) async {
    var changed = false;
    final item = await _pumpEditor(tester, vat: inclusive, onChanged: () => changed = true);

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    await tester.enterText(_field('Total'), '90');
    await tester.pumpAndSettle();

    // price = round2((90 + 0) / 2) = 45.00; snap total = round2(45 * 2) = 90.00
    expect(_fieldText(tester, 'Price'), '45.00');
    expect(_fieldText(tester, 'Total'), '90.00');

    // VAT rows follow: excl = round2(90 / 1.15) = 78.26, vat = 11.74.
    expect(find.text('78.26'), findsOneWidget);
    expect(find.text('11.74'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(changed, isTrue);
    expect(item.price, 45.00);
    expect(item.vat, closeTo(11.74, 1e-9));
    expect(item.vatRate, 15);

    // Card subtitle now renders the VAT-aware breakdown.
    expect(find.textContaining('excl SAR 78.26'), findsOneWidget);
    expect(find.textContaining('VAT SAR 11.74'), findsOneWidget);
    expect(find.textContaining('SAR 90.00'), findsWidgets); // subtitle + footer
  });

  testWidgets('editing quantity recomputes the total field', (tester) async {
    await _pumpEditor(tester, vat: inclusive);

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    await tester.enterText(_field('Quantity'), '3');
    await tester.pumpAndSettle();

    expect(_fieldText(tester, 'Total'), '150.00');
  });

  testWidgets('zero quantity skips the Total back-compute', (tester) async {
    await _pumpEditor(tester, vat: inclusive);

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    await tester.enterText(_field('Quantity'), '0');
    await tester.pumpAndSettle();
    await tester.enterText(_field('Total'), '55');
    await tester.pumpAndSettle();

    // Price untouched, total left as typed (no snap with qty <= 0).
    expect(_fieldText(tester, 'Price'), '50.0');
    expect(_fieldText(tester, 'Total'), '55');
  });

  testWidgets('with VAT disabled the editor renders like before', (tester) async {
    await _pumpEditor(tester, vat: const OrderVatSettings());

    expect(find.textContaining('excl'), findsNothing);
    expect(find.textContaining('SAR 100.00'), findsWidgets);

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(find.text('Excl. VAT'), findsNothing);
    expect(_fieldText(tester, 'Total'), '100.00');
  });
}
