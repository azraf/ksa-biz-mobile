import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:order_app/providers/customer_context_provider.dart';
import 'package:order_app/utils/order_filters.dart';

void main() {
  test('filterOrdersForCustomer keeps matching shop orders', () {
    const profile = CustomerProfile(
      role: 'customer_shop',
      customerTypeId: 3,
      entityId: 10,
      displayName: 'Demo Shop',
    );
    const orders = [
      OrderModel(id: 1, customerTypeId: 3, customerShopId: 10, totalBill: 100),
      OrderModel(id: 2, customerTypeId: 3, customerShopId: 99, totalBill: 50),
    ];

    final filtered = filterOrdersForCustomer(orders, profile);
    expect(filtered.length, 1);
    expect(filtered.first.id, 1);
  });
}
