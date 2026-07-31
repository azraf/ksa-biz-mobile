import 'package:equatable/equatable.dart';

import 'customer_assignment_models.dart';
import 'customer_metrics.dart';
import 'user.dart';

class CustomerTypeModel extends Equatable {
  const CustomerTypeModel({required this.id, required this.typeName});

  final int id;
  final String typeName;

  factory CustomerTypeModel.fromJson(Map<String, dynamic> json) {
    return CustomerTypeModel(
      id: json['id'] as int,
      typeName: json['type_name'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, typeName];
}

class CustomerVanModel extends Equatable {
  const CustomerVanModel({
    required this.id,
    required this.name,
    this.mobile,
    this.areaId,
    this.areaName,
    this.primaryContact,
    this.lastOrderAt,
    this.isInactive = false,
    this.distanceKm,
    this.metrics = const CustomerMetricsFields(),
  });

  final int id;
  final String name;
  final String? mobile;
  final int? areaId;
  final String? areaName;
  final PrimaryContactModel? primaryContact;
  final String? lastOrderAt;
  final bool isInactive;
  final double? distanceKm;
  final CustomerMetricsFields metrics;

  factory CustomerVanModel.fromJson(Map<String, dynamic> json) {
    return CustomerVanModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      mobile: json['mobile'] as String?,
      areaId: json['area_id'] as int?,
      areaName: json['area'] is Map ? (json['area'] as Map)['name'] as String? : null,
      primaryContact: json['primary_contact'] is Map
          ? PrimaryContactModel.fromJson(json['primary_contact'] as Map<String, dynamic>)
          : null,
      lastOrderAt: json['last_order_at']?.toString(),
      isInactive: json['is_inactive'] as bool? ?? false,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      metrics: CustomerMetricsFields.fromJson(json),
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class CustomerImporterModel extends Equatable {
  const CustomerImporterModel({
    required this.id,
    required this.name,
    this.mobile,
    this.areaId,
    this.areaName,
    this.primaryContact,
    this.lastOrderAt,
    this.isInactive = false,
    this.metrics = const CustomerMetricsFields(),
  });

  final int id;
  final String name;
  final String? mobile;
  final int? areaId;
  final String? areaName;
  final PrimaryContactModel? primaryContact;
  final String? lastOrderAt;
  final bool isInactive;
  final CustomerMetricsFields metrics;

  factory CustomerImporterModel.fromJson(Map<String, dynamic> json) {
    return CustomerImporterModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      mobile: json['mobile'] as String?,
      areaId: json['area_id'] as int?,
      areaName: json['area'] is Map ? (json['area'] as Map)['name'] as String? : null,
      primaryContact: json['primary_contact'] is Map
          ? PrimaryContactModel.fromJson(json['primary_contact'] as Map<String, dynamic>)
          : null,
      lastOrderAt: json['last_order_at']?.toString(),
      isInactive: json['is_inactive'] as bool? ?? false,
      metrics: CustomerMetricsFields.fromJson(json),
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class OrderModificationModel extends Equatable {
  const OrderModificationModel({
    required this.id,
    required this.action,
    this.notes,
    this.before,
    this.after,
    this.user,
    this.createdAt,
  });

  final int id;
  final String action;
  final String? notes;
  final Map<String, dynamic>? before;
  final Map<String, dynamic>? after;
  final UserModel? user;
  final String? createdAt;

  factory OrderModificationModel.fromJson(Map<String, dynamic> json) {
    return OrderModificationModel(
      id: json['id'] as int,
      action: json['action'] as String? ?? '',
      notes: json['notes'] as String?,
      before: json['before'] is Map ? Map<String, dynamic>.from(json['before'] as Map) : null,
      after: json['after'] is Map ? Map<String, dynamic>.from(json['after'] as Map) : null,
      user: json['user'] is Map ? UserModel.fromJson(json['user'] as Map<String, dynamic>) : null,
      createdAt: json['created_at']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, action, createdAt];
}

class SalesPersonDueReport extends Equatable {
  const SalesPersonDueReport({
    required this.salesPersonId,
    required this.orders,
    required this.totalDue,
  });

  final int salesPersonId;
  final List<Map<String, dynamic>> orders;
  final double totalDue;

  factory SalesPersonDueReport.fromJson(Map<String, dynamic> json) {
    return SalesPersonDueReport(
      salesPersonId: json['sales_person_id'] as int,
      orders: (json['orders'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>(),
      totalDue: _toDouble(json['total_due']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  List<Object?> get props => [salesPersonId, totalDue];
}
