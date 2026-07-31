import 'package:equatable/equatable.dart';

import 'admin_models.dart';
import 'media.dart';
import 'order.dart';
import 'sales_person.dart';

class ManualOrderRequestModel extends Equatable {
  const ManualOrderRequestModel({
    required this.id,
    required this.customerShopId,
    required this.source,
    required this.status,
    this.notes,
    this.callReference,
    this.manualReference,
    this.assignedSalesPersonId,
    this.claimedBySalesPersonId,
    this.convertedOrderId,
    this.customerShop,
    this.assignedSalesPerson,
    this.claimedBySalesPerson,
    this.convertedOrder,
    this.recordings = const [],
    this.createdAt,
  });

  final int id;
  final int customerShopId;
  final String source;
  final String status;
  final String? notes;
  final String? callReference;
  final String? manualReference;
  final int? assignedSalesPersonId;
  final int? claimedBySalesPersonId;
  final int? convertedOrderId;
  final CustomerShopModel? customerShop;
  final SalesPersonModel? assignedSalesPerson;
  final SalesPersonModel? claimedBySalesPerson;
  final OrderModel? convertedOrder;
  final List<MediaModel> recordings;
  final String? createdAt;

  bool get isEditable => !['converted', 'cancelled'].contains(status);
  bool get isOpenPool => assignedSalesPersonId == null;

  factory ManualOrderRequestModel.fromJson(Map<String, dynamic> json) {
    return ManualOrderRequestModel(
      id: json['id'] as int,
      customerShopId: json['customer_shop_id'] as int,
      source: json['source'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      callReference: json['call_reference'] as String?,
      manualReference: json['manual_reference'] as String?,
      assignedSalesPersonId: json['assigned_sales_person_id'] as int?,
      claimedBySalesPersonId: json['claimed_by_sales_person_id'] as int?,
      convertedOrderId: json['converted_order_id'] as int?,
      customerShop: json['customer_shop'] is Map
          ? CustomerShopModel.fromJson(json['customer_shop'] as Map<String, dynamic>)
          : null,
      assignedSalesPerson: json['assigned_sales_person'] is Map
          ? SalesPersonModel.fromJson(json['assigned_sales_person'] as Map<String, dynamic>)
          : null,
      claimedBySalesPerson: json['claimed_by_sales_person'] is Map
          ? SalesPersonModel.fromJson(json['claimed_by_sales_person'] as Map<String, dynamic>)
          : null,
      convertedOrder: json['converted_order'] is Map
          ? OrderModel.fromJson(json['converted_order'] as Map<String, dynamic>)
          : null,
      recordings: (json['recordings'] as List<dynamic>? ?? [])
          .map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, status, source];
}
