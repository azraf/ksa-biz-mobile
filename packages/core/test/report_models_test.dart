import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses a performance report with rows and an item breakdown', () {
    final report = SalesPerformanceReport.fromJson({
      'rows': [
        {
          'id': 4,
          'name': 'Sam',
          'orders': 12,
          'order_value': 5400.5,
          'average_order_value': 450,
          'shops_served': 9,
          'total_cartons': 37.5,
          'collected': 3000,
          'collection_rate': 55.6,
          'outstanding': 2400.5,
          'new_shops': 2,
          'prospects': 5,
          'prospects_converted': 1,
        },
      ],
      'items': [
        {
          'sales_person_id': 4,
          'product_id': 8,
          'product_name': 'Rice',
          'cartons': 12,
          'revenue': 1200
        },
      ],
    });

    expect(report.rows, hasLength(1));
    final row = report.rows.single;
    expect(row.id, 4);
    expect(row.totalCartons, 37.5);
    expect(row.collectionRate, 55.6);

    expect(report.items, hasLength(1));
    expect(report.items!.single.productName, 'Rice');
  });

  test('a quiet salesperson has a null collection rate, not zero', () {
    final report = SalesPerformanceReport.fromJson({
      'rows': [
        {'id': 9, 'name': 'Quiet', 'collection_rate': null},
      ],
    });

    expect(report.rows.single.collectionRate, isNull);
    expect(report.rows.single.orders, 0);
  });

  test(
      'items is null (not an empty list) when the backend omits the drill-down',
      () {
    final report = SalesPerformanceReport.fromJson({'rows': []});

    expect(report.items, isNull);
  });

  test('round-trips through toJson', () {
    const original = SalesPerformanceReport(
      rows: [SalesPersonPerformanceRow(id: 1, name: 'Sam', totalCartons: 3.5)],
      items: [
        ProductPerformanceRow(
            salesPersonId: 1, productId: 2, productName: 'Rice', cartons: 3.5)
      ],
    );

    final restored = SalesPerformanceReport.fromJson(original.toJson());

    expect(restored, original);
  });
}
