import 'package:core/core.dart';

import '../providers/customer_context_provider.dart';

List<OrderModel> filterOrdersForCustomer(List<OrderModel> orders, CustomerProfile profile) {
  return orders.where((order) {
    return switch (profile.role) {
      'customer_shop' => order.customerShopId == profile.entityId,
      'customer_van' => order.customerVanId == profile.entityId,
      'customer_importer' => order.customerImporterId == profile.entityId,
      _ => false,
    };
  }).toList();
}

List<ManualOrderRequestModel> filterManualOrdersForCustomer(
  List<ManualOrderRequestModel> requests,
  CustomerProfile profile,
) {
  return requests.where((r) {
    return switch (profile.role) {
      'customer_shop' => r.customerShopId == profile.entityId,
      'customer_van' => r.customerVanId == profile.entityId,
      'customer_importer' => r.customerImporterId == profile.entityId,
      _ => false,
    };
  }).toList();
}
