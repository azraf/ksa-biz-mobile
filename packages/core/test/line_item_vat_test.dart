import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

const _product = ProductModel(id: 1, name: 'Cola Carton', price: 100);

LineItemDraft _draft({int qty = 1, double price = 100, double discount = 0}) =>
    LineItemDraft(product: _product, quantity: qty, price: price, discount: discount);

void main() {
  group('round2', () {
    test('is half-up on exact halves', () {
      // 0.125 and 12.5 are exactly representable doubles — a true half.
      expect(round2(0.125), 0.13);
      expect(round2(2.375), 2.38);
    });

    test('is half-away-from-zero for negatives', () {
      expect(round2(-0.125), -0.13);
      expect(round2(-1.234), -1.23);
    });

    test('leaves 2dp values alone', () {
      expect(round2(99.99), 99.99);
      expect(round2(15.0), 15.0);
    });
  });

  group('applyVat', () {
    test('vat off: vat is 0 and both totals equal the base', () {
      final d = _draft(qty: 2, price: 50)..vat = 9; // stale value must be cleared
      const s = OrderVatSettings();
      d.applyVat(s);
      expect(d.vat, 0);
      expect(d.vatRate, 15);
      expect(d.exclTotal(s), 100);
      expect(d.grossTotal(s), 100);
      expect(d.lineTotal, 100);
    });

    test('excluded 100 @ 15 => vat 15.00, total 115.00', () {
      final d = _draft();
      const s = OrderVatSettings(enabled: true, rate: 15);
      d.applyVat(s);
      expect(d.vat, 15.00);
      expect(d.exclTotal(s), 100.00);
      expect(d.grossTotal(s), 115.00);
      expect(d.vatRate, 15);
    });

    test('included 100 @ 15 => excl 86.96, vat 13.04, total stays 100', () {
      final d = _draft();
      const s = OrderVatSettings(enabled: true, inclusive: true, rate: 15);
      d.applyVat(s);
      expect(d.exclTotal(s), 86.96);
      expect(d.vat, closeTo(13.04, 1e-9));
      expect(d.grossTotal(s), 100.00);
      // excl + vat == total by construction
      expect(d.exclTotal(s) + d.vat, closeTo(d.grossTotal(s), 1e-9));
    });

    test('included 99.99 @ 15 => excl 86.95, vat 13.04', () {
      final d = _draft(price: 99.99);
      const s = OrderVatSettings(enabled: true, inclusive: true, rate: 15);
      d.applyVat(s);
      expect(d.grossTotal(s), 99.99);
      expect(d.exclTotal(s), 86.95);
      expect(d.vat, closeTo(13.04, 1e-9));
    });

    test('rate 5 works in both modes', () {
      const excluded = OrderVatSettings(enabled: true, rate: 5);
      final a = _draft()..applyVat(excluded);
      expect(a.vat, 5.00);
      expect(a.grossTotal(excluded), 105.00);
      expect(a.vatRate, 5);

      const included = OrderVatSettings(enabled: true, inclusive: true, rate: 5);
      final b = _draft(price: 105)..applyVat(included);
      expect(b.grossTotal(included), 105.00);
      expect(b.exclTotal(included), 100.00);
      expect(b.vat, closeTo(5.00, 1e-9));
    });

    test('half-up edge: base 2.50 @ 5 gives vat 0.13, not 0.12', () {
      // 2.5 * 5 / 100 == 0.125 exactly in doubles — a true half.
      final d = _draft(price: 2.5);
      const s = OrderVatSettings(enabled: true, rate: 5);
      d.applyVat(s);
      expect(d.vat, 0.13);
      expect(d.grossTotal(s), closeTo(2.63, 1e-9));
    });

    test('discount reduces the VAT base', () {
      final d = _draft(qty: 2, price: 60, discount: 20); // base 100
      const s = OrderVatSettings(enabled: true, rate: 15);
      d.applyVat(s);
      expect(d.vat, 15.00);
      expect(d.grossTotal(s), 115.00);
    });
  });

  test('toJson carries product_vat and vat_rate', () {
    final d = _draft();
    const s = OrderVatSettings(enabled: true, inclusive: true, rate: 15);
    d.applyVat(s);
    final json = d.toJson();
    expect(json['product_vat'], closeTo(13.04, 1e-9));
    expect(json['vat_rate'], 15);
    expect(json['product_price'], 100);
  });
}
