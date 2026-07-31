import 'package:equatable/equatable.dart';

import 'lookup_models.dart';
import 'product.dart';

class SupplierModel extends Equatable {
  const SupplierModel({
    required this.id,
    required this.name,
    this.countryId,
    this.country,
    this.mobile,
    this.email,
    this.address,
  });

  final int id;
  final String name;
  final int? countryId;
  final CountryModel? country;
  final String? mobile;
  final String? email;
  final String? address;

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        countryId: json['country_id'] as int?,
        country: json['country'] is Map
            ? CountryModel.fromJson(json['country'] as Map<String, dynamic>)
            : null,
        mobile: json['mobile'] as String?,
        email: json['email'] as String?,
        address: json['address'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        if (countryId != null) 'country_id': countryId,
        if (mobile != null) 'mobile': mobile,
        if (email != null) 'email': email,
        if (address != null) 'address': address,
      };

  @override
  List<Object?> get props => [id, name];
}

class ContainerProductModel extends Equatable {
  const ContainerProductModel({
    required this.id,
    required this.shippingContainerId,
    required this.productId,
    required this.quantity,
    this.unitId,
    this.costPerUnit,
    this.product,
  });

  final int id;
  final int shippingContainerId;
  final int productId;
  final int quantity;
  final int? unitId;
  final double? costPerUnit;
  final ProductModel? product;

  factory ContainerProductModel.fromJson(Map<String, dynamic> json) =>
      ContainerProductModel(
        id: json['id'] as int,
        shippingContainerId: json['shipping_container_id'] as int,
        productId: json['product_id'] as int,
        quantity: json['quantity'] as int? ?? 0,
        unitId: json['unit_id'] as int?,
        costPerUnit: _toDouble(json['cost_per_unit']),
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
        'shipping_container_id': shippingContainerId,
        'product_id': productId,
        'quantity': quantity,
        if (unitId != null) 'unit_id': unitId,
        if (costPerUnit != null) 'cost_per_unit': costPerUnit,
      };

  @override
  List<Object?> get props => [id, productId, quantity];
}

class ShippingContainerModel extends Equatable {
  const ShippingContainerModel({
    required this.id,
    this.supplierId,
    this.countryId,
    this.containerNumber,
    this.receivedAt,
    this.status,
    this.notes,
    this.supplier,
    this.country,
    this.containerProducts = const [],
  });

  final int id;
  final int? supplierId;
  final int? countryId;
  final String? containerNumber;
  final String? receivedAt;
  final String? status;
  final String? notes;
  final SupplierModel? supplier;
  final CountryModel? country;
  final List<ContainerProductModel> containerProducts;

  factory ShippingContainerModel.fromJson(Map<String, dynamic> json) =>
      ShippingContainerModel(
        id: json['id'] as int,
        supplierId: json['supplier_id'] as int?,
        countryId: json['country_id'] as int?,
        containerNumber: json['container_number'] as String?,
        receivedAt: json['received_at']?.toString(),
        status: json['status'] as String?,
        notes: json['notes'] as String?,
        supplier: json['supplier'] is Map
            ? SupplierModel.fromJson(json['supplier'] as Map<String, dynamic>)
            : null,
        country: json['country'] is Map
            ? CountryModel.fromJson(json['country'] as Map<String, dynamic>)
            : null,
        containerProducts: (json['container_products'] as List<dynamic>? ?? [])
            .map((e) => ContainerProductModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        if (supplierId != null) 'supplier_id': supplierId,
        if (countryId != null) 'country_id': countryId,
        if (containerNumber != null) 'container_number': containerNumber,
        if (receivedAt != null) 'received_at': receivedAt,
        if (status != null) 'status': status,
        if (notes != null) 'notes': notes,
      };

  @override
  List<Object?> get props => [id, containerNumber, status];
}
