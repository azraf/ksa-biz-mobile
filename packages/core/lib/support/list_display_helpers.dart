import '../models/admin_models.dart';
import '../models/customer.dart';
import '../models/order.dart';
import '../utils/format_helpers.dart';

/// ISO date for list sort/display: created_at preferred, else last_order_at.
String? customerActivityDateIso(dynamic customer) {
  if (customer is CustomerShopModel) {
    return customer.createdAt ?? customer.lastOrderAt;
  }
  if (customer is CustomerVanModel) {
    return customer.createdAt ?? customer.lastOrderAt;
  }
  if (customer is CustomerImporterModel) {
    return customer.createdAt ?? customer.lastOrderAt;
  }
  return null;
}

String customerListSubtitle(dynamic customer) {
  final parts = <String>[];
  if (customer is CustomerShopModel) {
    if (customer.areaName != null) parts.add(customer.areaName!);
    if (customer.distanceKm != null) parts.add('${customer.distanceKm} km');
    final d = formatAppDateTime(customerActivityDateIso(customer));
    if (d.isNotEmpty) parts.add(d);
    if (customer.salesPersonName != null) parts.add(customer.salesPersonName!);
  } else if (customer is CustomerVanModel || customer is CustomerImporterModel) {
    final mobile = customer is CustomerVanModel ? customer.mobile : (customer as CustomerImporterModel).mobile;
    final area = customer is CustomerVanModel ? customer.areaName : (customer as CustomerImporterModel).areaName;
    if (mobile != null && mobile.isNotEmpty) parts.add(mobile);
    if (area != null) parts.add(area);
    final d = formatAppDateTime(customerActivityDateIso(customer));
    if (d.isNotEmpty) parts.add(d);
    final sp = customer is CustomerVanModel
        ? customer.salesPersonName
        : (customer as CustomerImporterModel).salesPersonName;
    if (sp != null) parts.add(sp);
  }
  return parts.join(' · ');
}

String orderListSubtitle(
  OrderModel order, {
  bool showSalesPerson = false,
  bool showCreatedAt = false,
}) {
  final parts = <String>[];
  if (showCreatedAt) {
    final d = formatAppDateTime(order.createdAt);
    if (d.isNotEmpty) parts.add(d);
  }
  if (order.customerShopAreaName != null && order.customerShopAreaName!.isNotEmpty) {
    parts.add(order.customerShopAreaName!);
  }
  if (showSalesPerson && order.salesPerson?.name != null) {
    parts.add(order.salesPerson!.name);
  }
  return parts.join(' · ');
}
