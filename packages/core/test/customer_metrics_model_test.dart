import 'package:core/models/customer_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('avg_days_between_orders accepts the string a Laravel decimal cast emits', () {
    final m = CustomerMetricsFields.fromJson({'avg_days_between_orders': '2.58', 'order_count': 1});
    expect(m.avgDaysBetweenOrders, 2.58);
    expect(CustomerMetricsFields.fromJson({'avg_days_between_orders': 3}).avgDaysBetweenOrders, 3.0);
    expect(CustomerMetricsFields.fromJson({}).avgDaysBetweenOrders, isNull);
  });
}
