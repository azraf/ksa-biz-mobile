import 'package:equatable/equatable.dart';

import 'product.dart';
import 'shipping.dart';

class PurchaseItemModel extends Equatable {
  const PurchaseItemModel({
    required this.id,
    required this.purchaseId,
    required this.productId,
    required this.quantity,
    this.unitPrice,
    this.unitCost,
    this.discount,
    this.tax,
    this.lineTotal,
    this.productName,
    this.product,
  });

  final int id;
  final int purchaseId;
  final int productId;
  final int quantity;
  final double? unitPrice;
  final double? unitCost;
  final double? discount;
  final double? tax;
  final double? lineTotal;
  final String? productName;
  final ProductModel? product;

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) => PurchaseItemModel(
        id: json['id'] as int,
        purchaseId: json['purchase_id'] as int,
        productId: json['product_id'] as int,
        quantity: json['quantity'] as int? ?? 0,
        unitPrice: _toDouble(json['unit_price'] ?? json['unit_cost']),
        unitCost: _toDouble(json['unit_cost']),
        discount: _toDouble(json['discount']),
        tax: _toDouble(json['tax']),
        lineTotal: _toDouble(json['line_total']),
        productName: json['product_name'] as String?,
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
        'quantity': quantity,
        if (unitPrice != null) 'unit_price': unitPrice,
        if (unitCost != null) 'unit_cost': unitCost,
        if (discount != null) 'discount': discount,
        if (tax != null) 'tax': tax,
      };

  @override
  List<Object?> get props => [id, productId, quantity];
}

class PurchaseModel extends Equatable {
  const PurchaseModel({
    required this.id,
    this.supplierId,
    this.shippingContainerId,
    this.totalAmount,
    this.date,
    this.purchaseType,
    this.referenceNumber,
    this.status,
    this.notes,
    this.subtotal,
    this.orderDiscount,
    this.orderTax,
    this.discountTotal,
    this.taxTotal,
    this.supplier,
    this.shippingContainer,
    this.items = const [],
  });

  final int id;
  final int? supplierId;
  final int? shippingContainerId;
  final double? totalAmount;
  final String? date;
  final String? purchaseType;
  final String? referenceNumber;
  final String? status;
  final String? notes;
  final double? subtotal;
  final double? orderDiscount;
  final double? orderTax;
  final double? discountTotal;
  final double? taxTotal;
  final SupplierModel? supplier;
  final ShippingContainerModel? shippingContainer;
  final List<PurchaseItemModel> items;

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
        id: json['id'] as int,
        supplierId: json['supplier_id'] as int?,
        shippingContainerId: json['shipping_container_id'] as int?,
        totalAmount: _toDouble(json['total_amount']),
        date: json['date']?.toString(),
        purchaseType: json['purchase_type'] as String?,
        referenceNumber: json['reference_number'] as String?,
        status: json['status'] as String?,
        notes: json['notes'] as String?,
        subtotal: _toDouble(json['subtotal']),
        orderDiscount: _toDouble(json['order_discount']),
        orderTax: _toDouble(json['order_tax']),
        discountTotal: _toDouble(json['discount_total']),
        taxTotal: _toDouble(json['tax_total']),
        supplier: json['supplier'] is Map
            ? SupplierModel.fromJson(json['supplier'] as Map<String, dynamic>)
            : null,
        shippingContainer: json['shipping_container'] is Map
            ? ShippingContainerModel.fromJson(
                json['shipping_container'] as Map<String, dynamic>,
              )
            : null,
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => PurchaseItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() => {
        if (supplierId != null) 'supplier_id': supplierId,
        if (shippingContainerId != null) 'shipping_container_id': shippingContainerId,
        if (date != null) 'date': date,
        if (purchaseType != null) 'purchase_type': purchaseType,
        if (referenceNumber != null) 'reference_number': referenceNumber,
        if (notes != null) 'notes': notes,
        'items': items.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [id, totalAmount, date, status];
}
