import 'package:equatable/equatable.dart';

import 'admin_models.dart';
import 'media.dart';
import 'order.dart';
import 'sales_person.dart';

class ManualOrderRequestModel extends Equatable {
  const ManualOrderRequestModel({
    required this.id,
    this.customerShopId,
    this.customerVanId,
    this.customerImporterId,
    required this.source,
    required this.status,
    this.notes,
    this.callReference,
    this.manualReference,
    this.assignedSalesPersonId,
    this.claimedBySalesPersonId,
    this.convertedOrderId,
    this.customerShop,
    this.customerVanName,
    this.customerImporterName,
    this.assignedSalesPerson,
    this.claimedBySalesPerson,
    this.convertedOrder,
    this.recordings = const [],
    this.media = const [],
    this.linkedOrders = const [],
    this.createdAt,
  });

  final int id;
  final int? customerShopId;
  final int? customerVanId;
  final int? customerImporterId;
  final String source;
  final String status;
  final String? notes;
  final String? callReference;
  final String? manualReference;
  final int? assignedSalesPersonId;
  final int? claimedBySalesPersonId;
  final int? convertedOrderId;
  final CustomerShopModel? customerShop;
  final String? customerVanName;
  final String? customerImporterName;
  final SalesPersonModel? assignedSalesPerson;
  final SalesPersonModel? claimedBySalesPerson;
  final OrderModel? convertedOrder;
  final List<MediaModel> recordings;

  /// Every attachment (photos + recordings) from the `media` relation.
  final List<MediaModel> media;

  /// Orders this instruction has been linked to (M:N trace).
  final List<OrderModel> linkedOrders;
  final String? createdAt;

  bool get isEditable => !['converted', 'cancelled'].contains(status);
  bool get isOpenPool => assignedSalesPersonId == null;

  /// All attachments, preferring the full media list when present.
  List<MediaModel> get allMedia => media.isNotEmpty ? media : recordings;

  String? get customerName =>
      customerShop?.name ??
      customerVanName ??
      customerImporterName;

  factory ManualOrderRequestModel.fromJson(Map<String, dynamic> json) {
    return ManualOrderRequestModel(
      id: json['id'] as int,
      customerShopId: json['customer_shop_id'] as int?,
      customerVanId: json['customer_van_id'] as int?,
      customerImporterId: json['customer_importer_id'] as int?,
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
      customerVanName: json['customer_van'] is Map
          ? (json['customer_van'] as Map<String, dynamic>)['name'] as String?
          : null,
      customerImporterName: json['customer_importer'] is Map
          ? (json['customer_importer'] as Map<String, dynamic>)['name'] as String?
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
      media: (json['media'] as List<dynamic>? ?? [])
          .map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      linkedOrders: (json['orders'] as List<dynamic>? ?? [])
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, status, source];
}
