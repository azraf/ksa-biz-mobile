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

  testWidgets('save rejects qty < 1 with an inline error and keeps the dialog open', (tester) async {
    final item = await _pumpEditor(tester, vat: const OrderVatSettings());

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    await tester.enterText(_field('Quantity'), '0');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Enter a quantity of 1 or more'), findsOneWidget);
    expect(item.quantity, 2); // unchanged

    // Fixing the quantity clears the error and lets the save through.
    await tester.enterText(_field('Quantity'), '3');
    await tester.pumpAndSettle();
    expect(find.text('Enter a quantity of 1 or more'), findsNothing);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(item.quantity, 3);
  });

  testWidgets('save rejects discount above the line value', (tester) async {
    final item = await _pumpEditor(tester, vat: const OrderVatSettings());

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    // qty 2 x price 50 = 100 — a 150 discount is impossible.
    await tester.enterText(_field('Discount'), '150');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Discount cannot exceed the line total'), findsOneWidget);
    expect(item.discount, 0); // unchanged

    await tester.enterText(_field('Discount'), '10');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(item.discount, 10);
    expect(item.lineTotal, 90); // (50 * 2) - 10, VAT off
  });

  testWidgets('save rejects a negative price', (tester) async {
    final item = await _pumpEditor(tester, vat: const OrderVatSettings());

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    await tester.enterText(_field('Price'), '-5');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Enter a price of 0 or more'), findsOneWidget);
    expect(item.price, 50); // unchanged
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
