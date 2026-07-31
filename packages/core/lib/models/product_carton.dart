import 'package:equatable/equatable.dart';

import 'customer.dart';
import 'product.dart';

class ProductCartonModel extends Equatable {
  const ProductCartonModel({
    required this.id,
    required this.productId,
    required this.cartonName,
    this.cartonSize,
    this.numPieces = 1,
  });

  final int id;
  final int productId;
  final String cartonName;
  final String? cartonSize;
  final int numPieces;

  factory ProductCartonModel.fromJson(Map<String, dynamic> json) =>
      ProductCartonModel(
        id: json['id'] as int,
        productId: json['product_id'] as int,
        cartonName: json['carton_name'] as String? ?? '',
        cartonSize: json['carton_size'] as String?,
        numPieces: json['num_pieces'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'carton_name': cartonName,
        if (cartonSize != null) 'carton_size': cartonSize,
        'num_pieces': numPieces,
      };

  @override
  List<Object?> get props => [id, productId, cartonName];
}

class ProductPriceModel extends Equatable {
  const ProductPriceModel({
    required this.id,
    required this.productId,
    required this.customerTypeId,
    required this.price,
    this.wholesalePrice,
    this.validFrom,
    this.validTo,
    this.product,
    this.customerType,
  });

  final int id;
  final int productId;
  final int customerTypeId;
  final double price;
  final double? wholesalePrice;
  final String? validFrom;
  final String? validTo;
  final ProductModel? product;
  final CustomerTypeModel? customerType;

  factory ProductPriceModel.fromJson(Map<String, dynamic> json) =>
      ProductPriceModel(
        id: json['id'] as int,
        productId: json['product_id'] as int,
        customerTypeId: json['customer_type_id'] as int,
        price: _toDouble(json['price']),
        wholesalePrice: _toDouble(json['wholesale_price']),
        validFrom: json['valid_from']?.toString(),
        validTo: json['valid_to']?.toString(),
        product: json['product'] is Map
            ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
            : null,
        customerType: json['customer_type'] is Map
            ? CustomerTypeModel.fromJson(json['customer_type'] as Map<String, dynamic>)
            : null,
      );

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'customer_type_id': customerTypeId,
        'price': price,
        if (wholesalePrice != null) 'wholesale_price': wholesalePrice,
        if (validFrom != null) 'valid_from': validFrom,
        if (validTo != null) 'valid_to': validTo,
      };

  @override
  List<Object?> get props => [id, productId, customerTypeId];
}
