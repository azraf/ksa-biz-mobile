import 'package:equatable/equatable.dart';

import '../support/json_parse.dart';
import 'product.dart';

class OrderItemModel extends Equatable {
  const OrderItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.productPrice,
    this.unitId,
    this.baseQuantity = 0,
    this.productDiscount = 0,
    this.productVat = 0,
    this.vatRate,
    this.bill = 0,
    this.isPreorder = false,
    this.product,
    this.unit,
  });

  final int id;
  final int productId;
  final int quantity;
  final int? unitId;
  final int baseQuantity;
  final double productPrice;
  final double productDiscount;
  final double productVat;

  /// VAT rate applied to this line (absent on legacy rows).
  final double? vatRate;
  final double bill;
  final bool isPreorder;
  final ProductModel? product;
  final Map<String, dynamic>? unit;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int? ?? 0,
      unitId: json['unit_id'] as int?,
      baseQuantity: json['base_quantity'] as int? ?? 0,
      productPrice: _toDouble(json['product_price']),
      productDiscount: _toDouble(json['product_discount']),
      productVat: _toDouble(json['product_vat']),
      vatRate: parseJsonDoubleOrNull(json['vat_rate']),
      bill: _toDouble(json['bill']),
      isPreorder: json['is_preorder'] as bool? ?? false,
      product: json['product'] is Map
          ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      unit: json['unit'] is Map ? Map<String, dynamic>.from(json['unit'] as Map) : null,
    );
  }

  Map<String, dynamic> toCreateJson() => {
        'product_id': productId,
        'quantity': quantity,
        if (unitId != null) 'unit_id': unitId,
        'product_price': productPrice,
        'product_discount': productDiscount,
        'product_vat': productVat,
        'is_preorder': isPreorder,
      };

  String get quantityLabel {
    final unitName = unit?['short_name'] as String? ?? product?.unitLabel(unitId) ?? '';
    return '$quantity $unitName'.trim();
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  List<Object?> get props => [id, productId, quantity, unitId, bill];
}
