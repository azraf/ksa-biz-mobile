import 'package:equatable/equatable.dart';

class AreaModel extends Equatable {
  const AreaModel({required this.id, required this.name, this.code, this.parentId, this.active = true});

  final int id;
  final String name;
  final String? code;
  final int? parentId;
  final bool active;

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        code: json['code'] as String?,
        parentId: json['parent_id'] as int?,
        active: json['active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        if (code != null) 'code': code,
        if (parentId != null) 'parent_id': parentId,
        'active': active,
      };

  @override
  List<Object?> get props => [id, name];
}

class PrimaryContactModel extends Equatable {
  const PrimaryContactModel({this.contactName, this.contactMobile});

  final String? contactName;
  final String? contactMobile;

  factory PrimaryContactModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PrimaryContactModel();
    return PrimaryContactModel(
      contactName: json['contact_name'] as String?,
      contactMobile: json['contact_mobile'] as String?,
    );
  }

  @override
  List<Object?> get props => [contactName, contactMobile];
}

class CustomerAssignmentModel extends Equatable {
  const CustomerAssignmentModel({
    required this.id,
    required this.salesPersonId,
    required this.customerType,
    this.customerShopId,
    this.customerVanId,
    this.customerImporterId,
    required this.assignmentKind,
    this.startsAt,
    this.endsAt,
    this.reason,
    this.replacedSalesPersonId,
    this.active = true,
    this.salesPersonName,
  });

  final int id;
  final int salesPersonId;
  final String customerType;
  final int? customerShopId;
  final int? customerVanId;
  final int? customerImporterId;
  final String assignmentKind;
  final String? startsAt;
  final String? endsAt;
  final String? reason;
  final int? replacedSalesPersonId;
  final bool active;
  final String? salesPersonName;

  factory CustomerAssignmentModel.fromJson(Map<String, dynamic> json) => CustomerAssignmentModel(
        id: json['id'] as int,
        salesPersonId: json['sales_person_id'] as int,
        customerType: json['customer_type'] as String? ?? '',
        customerShopId: json['customer_shop_id'] as int?,
        customerVanId: json['customer_van_id'] as int?,
        customerImporterId: json['customer_importer_id'] as int?,
        assignmentKind: json['assignment_kind'] as String? ?? 'permanent',
        startsAt: json['starts_at']?.toString(),
        endsAt: json['ends_at']?.toString(),
        reason: json['reason'] as String?,
        replacedSalesPersonId: json['replaced_sales_person_id'] as int?,
        active: json['active'] as bool? ?? true,
        salesPersonName: json['sales_person'] is Map
            ? (json['sales_person'] as Map)['name'] as String?
            : null,
      );

  @override
  List<Object?> get props => [id, salesPersonId, customerType];
}

class SalesCustomerRow extends Equatable {
  const SalesCustomerRow({
    required this.type,
    required this.id,
    required this.name,
    this.phone,
    this.areaName,
    this.isInactive = false,
  });

  final String type;
  final int id;
  final String name;
  final String? phone;
  final String? areaName;
  final bool isInactive;

  factory SalesCustomerRow.fromJson(Map<String, dynamic> json) => SalesCustomerRow(
        type: json['type'] as String? ?? '',
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        phone: json['phone'] as String?,
        areaName: json['area'] is Map ? (json['area'] as Map)['name'] as String? : null,
        isInactive: json['is_inactive'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [type, id, name];
}

class SalesPersonAreaModel extends Equatable {
  const SalesPersonAreaModel({
    required this.id,
    required this.salesPersonId,
    required this.areaId,
    this.areaName,
    this.salesPersonName,
    this.active = true,
    this.startsAt,
    this.endsAt,
  });

  final int id;
  final int salesPersonId;
  final int areaId;
  final String? areaName;
  final String? salesPersonName;
  final bool active;
  final String? startsAt;
  final String? endsAt;

  factory SalesPersonAreaModel.fromJson(Map<String, dynamic> json) => SalesPersonAreaModel(
        id: json['id'] as int,
        salesPersonId: json['sales_person_id'] as int,
        areaId: json['area_id'] as int,
        areaName: json['area'] is Map ? (json['area'] as Map)['name'] as String? : null,
        salesPersonName: json['sales_person'] is Map
            ? (json['sales_person'] as Map)['name'] as String?
            : null,
        active: json['active'] as bool? ?? true,
        startsAt: json['starts_at']?.toString(),
        endsAt: json['ends_at']?.toString(),
      );

  @override
  List<Object?> get props => [id, salesPersonId, areaId];
}

/// Activity filter options for customer picker: (days, label). null days = All.
const customerActivityFilterOptions = <(int?, String)>[
  (null, 'All'),
  (1, '1 day'),
  (7, '1 week'),
  (15, '15 days'),
  (30, '30 days'),
  (60, '60 days'),
  (90, '90 days'),
];
