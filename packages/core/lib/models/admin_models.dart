import 'package:equatable/equatable.dart';

import '../support/json_parse.dart';

import 'media.dart';

import 'customer.dart';
import 'customer_assignment_models.dart';
import 'customer_metrics.dart';
import 'product.dart';
import 'user.dart';

class CustomerShopModel extends Equatable {
  const CustomerShopModel({
    required this.id,
    required this.name,
    this.nameAr,
    this.mobile,
    this.email,
    this.vatNumber,
    this.gps,
    this.isSystem = false,
    this.contactsCount,
    this.contacts = const [],
    this.areaId,
    this.areaName,
    this.primaryContact,
    this.lastOrderAt,
    this.createdAt,
    this.isInactive = false,
    this.distanceKm,
    this.salesPersonName,
    this.metrics = const CustomerMetricsFields(),
    this.images = const [],
    this.user,
    this.allowUserAccountCreation = false,
  });

  final int id;
  final String name;

  /// Arabic name — printed on the Fatoora invoice when set.
  final String? nameAr;
  /// The shop's own number (customer_shops.mobile); see [primaryPhone].
  final String? mobile;
  final String? email;

  /// Buyer VAT registration number — printed on ZATCA invoices when set.
  final String? vatNumber;
  final String? gps;
  final bool isSystem;
  final int? contactsCount;
  final List<CustomerShopContactModel> contacts;
  final int? areaId;
  final String? areaName;
  final PrimaryContactModel? primaryContact;
  final String? lastOrderAt;
  final String? createdAt;
  final bool isInactive;
  final double? distanceKm;
  final String? salesPersonName;
  final CustomerMetricsFields metrics;
  final List<MediaModel> images;
  final CustomerLinkedUserModel? user;

  /// Admin-set flag: salesperson may create a login for this customer.
  final bool allowUserAccountCreation;

  factory CustomerShopModel.fromJson(Map<String, dynamic> json) =>
      CustomerShopModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        nameAr: json['name_ar'] as String?,
        mobile: json['mobile'] as String?,
        email: json['email'] as String?,
        vatNumber: json['vat_number'] as String?,
        gps: json['gps'] as String?,
        isSystem: parseJsonBool(json['is_system']),
        contactsCount: json['contacts_count'] as int?,
        contacts: (json['contacts'] as List<dynamic>? ?? [])
            .map((e) => CustomerShopContactModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        areaId: json['area_id'] as int?,
        areaName: json['area_name'] as String? ??
            (json['area'] is Map ? (json['area'] as Map)['name'] as String? : null),
        primaryContact: json['primary_contact'] is Map
            ? PrimaryContactModel.fromJson(json['primary_contact'] as Map<String, dynamic>)
            : null,
        lastOrderAt: json['last_order_at']?.toString(),
        createdAt: json['created_at']?.toString(),
        isInactive: parseJsonBool(json['is_inactive']),
        distanceKm: (json['distance_km'] as num?)?.toDouble(),
        salesPersonName: json['sales_person_name'] as String? ??
            (json['sales_person'] is Map
                ? (json['sales_person'] as Map)['name'] as String?
                : null),
        metrics: CustomerMetricsFields.fromJson(json),
        images: (json['images'] as List<dynamic>? ?? [])
            .map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        user: parseCustomerLinkedUser(json['user']),
        allowUserAccountCreation:
            parseJsonBool(json['allow_user_account_creation']),
      );

  /// Column first; legacy shops may only carry the number on a contact.
  String? get primaryPhone =>
      (mobile != null && mobile!.isNotEmpty) ? mobile : primaryContact?.contactMobile;

  Map<String, dynamic> toJson() => {
        'name': name,
        if (nameAr != null) 'name_ar': nameAr,
        if (mobile != null) 'mobile': mobile,
        if (email != null) 'email': email,
        if (vatNumber != null) 'vat_number': vatNumber,
        if (gps != null) 'gps': gps,
        if (isSystem) 'is_system': isSystem,
      };

  @override
  List<Object?> get props => [id, name, nameAr, mobile, isSystem, user, allowUserAccountCreation];
}

class CustomerShopContactModel extends Equatable {
  const CustomerShopContactModel({
    required this.id,
    required this.customerShopId,
    required this.contactName,
    this.contactMobile,
    this.contactEmail,
    this.note,
    this.active = true,
  });

  final int id;
  final int customerShopId;
  final String contactName;
  final String? contactMobile;
  final String? contactEmail;
  final String? note;
  final bool active;

  factory CustomerShopContactModel.fromJson(Map<String, dynamic> json) =>
      CustomerShopContactModel(
        id: json['id'] as int,
        customerShopId: json['customer_shop_id'] as int,
        contactName: json['contact_name'] as String? ?? '',
        contactMobile: json['contact_mobile'] as String?,
        contactEmail: json['contact_email'] as String?,
        note: json['note'] as String?,
        active: parseJsonBool(json['active'], fallback: true),
      );

  Map<String, dynamic> toJson() => {
        'customer_shop_id': customerShopId,
        'contact_name': contactName,
        if (contactMobile != null) 'contact_mobile': contactMobile,
        if (contactEmail != null) 'contact_email': contactEmail,
        if (note != null) 'note': note,
        'active': active,
      };

  @override
  List<Object?> get props => [id, contactName];
}

class PromotionProductModel extends Equatable {
  const PromotionProductModel({
    required this.id,
    required this.productId,
    this.percentDiscount,
    this.flatDiscount,
    this.product,
  });

  final int id;
  final int productId;
  final double? percentDiscount;
  final double? flatDiscount;
  final ProductModel? product;

  factory PromotionProductModel.fromJson(Map<String, dynamic> json) =>
      PromotionProductModel(
        id: json['id'] as int,
        productId: json['product_id'] as int,
        percentDiscount: _toDouble(json['percent_discount']),
        flatDiscount: _toDouble(json['flat_discount']),
        product: json['product'] is Map
            ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
            : null,
      );

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        if (percentDiscount != null) 'percent_discount': percentDiscount,
        if (flatDiscount != null) 'flat_discount': flatDiscount,
      };

  @override
  List<Object?> get props => [id, productId];
}

class PromotionModel extends Equatable {
  const PromotionModel({
    required this.id,
    required this.name,
    this.description,
    this.customerTypeId,
    this.startDate,
    this.endDate,
    this.percentDiscount,
    this.flatDiscount,
    this.active = true,
    this.isExpired = false,
    this.customerType,
    this.promotionProducts = const [],
  });

  final int id;
  final String name;
  final String? description;
  final int? customerTypeId;
  final String? startDate;
  final String? endDate;
  final double? percentDiscount;
  final double? flatDiscount;
  final bool active;
  final bool isExpired;
  final CustomerTypeModel? customerType;
  final List<PromotionProductModel> promotionProducts;

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        description: json['description'] as String?,
        customerTypeId: json['customer_type_id'] as int?,
        startDate: json['start_date']?.toString(),
        endDate: json['end_date']?.toString(),
        percentDiscount: _toDouble(json['percent_discount']),
        flatDiscount: _toDouble(json['flat_discount']),
        active: parseJsonBool(json['active'], fallback: true),
        isExpired: parseJsonBool(json['is_expired']),
        customerType: json['customer_type'] is Map
            ? CustomerTypeModel.fromJson(json['customer_type'] as Map<String, dynamic>)
            : null,
        promotionProducts: (json['promotion_products'] as List<dynamic>? ?? [])
            .map((e) => PromotionProductModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        if (customerTypeId != null) 'customer_type_id': customerTypeId,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (percentDiscount != null) 'percent_discount': percentDiscount,
        if (flatDiscount != null) 'flat_discount': flatDiscount,
        'active': active,
        'is_expired': isExpired,
      };

  @override
  List<Object?> get props => [id, name, startDate, endDate];
}

class AdminUserModel extends Equatable {
  const AdminUserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.language,
    this.roles = const [],
    this.avatarUrl,
  });

  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? language;
  final List<String> roles;
  final String? avatarUrl;

  factory AdminUserModel.fromJson(Map<String, dynamic> json) => AdminUserModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        language: json['language'] as String?,
        roles: (json['roles'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
        avatarUrl: json['avatar_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (language != null) 'language': language,
      };

  @override
  List<Object?> get props => [id, name, email];
}
