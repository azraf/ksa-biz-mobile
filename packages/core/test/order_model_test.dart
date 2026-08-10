import 'package:flutter_test/flutter_test.dart';

import 'package:core/models/customer_financial_summary.dart';
import 'package:core/models/order.dart';
import 'package:core/repositories/order_repository.dart';

void main() {
  test('outstandingDue prefers server amount_due, else derives the remainder', () {
    final withServerDue = OrderModel.fromJson(const {
      'id': 1,
      'customer_type_id': 1,
      'total_bill': '100.00',
      'amount_paid': '40.00',
      'amount_due': '60.00',
    });
    expect(withServerDue.outstandingDue, 60.0);

    final legacyRow = OrderModel.fromJson(const {
      'id': 2,
      'customer_type_id': 1,
      'total_bill': '100.00',
      'amount_paid': '40.00',
      'amount_due': 0,
    });
    expect(legacyRow.outstandingDue, closeTo(60.0, 0.001));
  });

  test('isDraft matches the renamed server value and legacy cached rows', () {
    OrderModel order(String status) => OrderModel.fromJson({
          'id': 1,
          'customer_type_id': 1,
          'status': status,
        });

    expect(order('draft').isDraft, isTrue);
    // Rows cached by pre-rename builds.
    expect(order('pending').isDraft, isTrue);
    expect(order('confirmed').isDraft, isFalse);
  });

  test('isEditable is false for cancelled and cancellation_pending orders', () {
    OrderModel order(String status) => OrderModel.fromJson({
          'id': 1,
          'customer_type_id': 1,
          'status': status,
        });

    expect(order('cancelled').isEditable, isFalse);
    expect(order('cancellation_pending').isEditable, isFalse);
    expect(order('confirmed').isEditable, isTrue);
  });

  test('OrderListQuery emits customer scope, search and dates, omitting nulls', () {
    const query = OrderListQuery(
      customerType: 'customer_shop',
      customerId: 7,
      search: '42',
      fromDate: '2026-01-01',
      toDate: '2026-02-01',
    );

    final params = query.toQuery();
    expect(params['customer_type'], 'shop');
    expect(params['customer_id'], '7');
    expect(params['search'], '42');
    expect(params['from_date'], '2026-01-01');
    expect(params['to_date'], '2026-02-01');

    final bare = const OrderListQuery().toQuery();
    expect(bare.containsKey('customer_type'), isFalse);
    expect(bare.containsKey('search'), isFalse);
  });

  test('CustomerFinancialSummary coerces string decimals and keeps nulls', () {
    final summary = CustomerFinancialSummary.fromJson(const {
      'orders_count': 3,
      'purchased_total': '150.50',
      'paid_total': 100,
      'discount_total': '0.00',
      'due': '50.50',
      'overdue': 0,
      'oldest_due_date': '2026-08-01',
      'next_payment_amount': '50.50',
      'next_payment_date': '2026-08-01',
      'next_payment_order_id': 9,
      'last_payment_at': null,
    });

    expect(summary.ordersCount, 3);
    expect(summary.purchasedTotal, 150.5);
    expect(summary.paidTotal, 100.0);
    expect(summary.due, 50.5);
    expect(summary.nextPaymentAmount, 50.5);
    expect(summary.nextPaymentOrderId, 9);
    expect(summary.lastPaymentAt, isNull);
  });
}
