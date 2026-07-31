import 'package:equatable/equatable.dart';

import 'product.dart';

class StockMovementModel extends Equatable {
  const StockMovementModel({
    required this.id,
    required this.productId,
    required this.inQty,
    required this.outQty,
    required this.balance,
    this.salesPersonId,
    required this.movementType,
    this.notes,
    this.createdAt,
    this.product,
  });

  final int id;
  final int productId;
  final int inQty;
  final int outQty;
  final int balance;
  final int? salesPersonId;
  final String movementType;
  final String? notes;
  final String? createdAt;
  final ProductModel? product;

  factory StockMovementModel.fromJson(Map<String, dynamic> json) => StockMovementModel(
        id: json['id'] as int,
        productId: json['product_id'] as int,
        inQty: json['in'] as int? ?? 0,
        outQty: json['out'] as int? ?? 0,
        balance: json['balance'] as int? ?? 0,
        salesPersonId: json['sales_person_id'] as int?,
        movementType: json['movement_type'] as String? ?? '',
        notes: json['notes'] as String?,
        createdAt: json['created_at']?.toString(),
        product: json['product'] is Map
            ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
            : null,
      );

  @override
  List<Object?> get props => [id, productId, movementType];
}

class DamageReplacementModel extends Equatable {
  const DamageReplacementModel({
    required this.id,
    required this.replacementType,
    required this.productId,
    required this.quantity,
    this.salesPersonId,
    this.reason,
    this.status,
    this.product,
  });

  final int id;
  final String replacementType;
  final int productId;
  final int quantity;
  final int? salesPersonId;
  final String? reason;
  final String? status;
  final ProductModel? product;

  factory DamageReplacementModel.fromJson(Map<String, dynamic> json) => DamageReplacementModel(
        id: json['id'] as int,
        replacementType: json['replacement_type'] as String? ?? '',
        productId: json['product_id'] as int,
        quantity: json['quantity'] as int? ?? 0,
        salesPersonId: json['sales_person_id'] as int?,
        reason: json['reason'] as String?,
        status: json['status'] as String?,
        product: json['product'] is Map
            ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
            : null,
      );

  @override
  List<Object?> get props => [id, productId, quantity];
}

class ProductExchangeModel extends Equatable {
  const ProductExchangeModel({
    required this.id,
    required this.salesPersonId,
    required this.settlementType,
    this.cashAmount,
    this.reason,
    this.status,
    this.lines = const [],
  });

  final int id;
  final int salesPersonId;
  final String settlementType;
  final double? cashAmount;
  final String? reason;
  final String? status;
  final List<ProductExchangeLineModel> lines;

  factory ProductExchangeModel.fromJson(Map<String, dynamic> json) => ProductExchangeModel(
        id: json['id'] as int,
        salesPersonId: json['sales_person_id'] as int,
        settlementType: json['settlement_type'] as String? ?? '',
        cashAmount: _toDouble(json['cash_amount']),
        reason: json['reason'] as String?,
        status: json['status'] as String?,
        lines: (json['lines'] as List<dynamic>? ?? [])
            .map((e) => ProductExchangeLineModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  @override
  List<Object?> get props => [id, salesPersonId, settlementType];
}

class ProductExchangeLineModel extends Equatable {
  const ProductExchangeLineModel({
    required this.direction,
    required this.productId,
    required this.quantity,
    this.product,
  });

  final String direction;
  final int productId;
  final int quantity;
  final ProductModel? product;

  factory ProductExchangeLineModel.fromJson(Map<String, dynamic> json) => ProductExchangeLineModel(
        direction: json['direction'] as String? ?? '',
        productId: json['product_id'] as int,
        quantity: json['quantity'] as int? ?? 0,
        product: json['product'] is Map
            ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
            : null,
      );

  @override
  List<Object?> get props => [direction, productId, quantity];
}

class InventoryValuationModel extends Equatable {
  const InventoryValuationModel({
    required this.lines,
    required this.totalValue,
    this.totalCostValue,
    this.totalRetailValue,
    this.totalMarginValue,
  });

  final List<InventoryValuationLineModel> lines;
  final double totalValue;
  final double? totalCostValue;
  final double? totalRetailValue;
  final double? totalMarginValue;

  factory InventoryValuationModel.fromJson(Map<String, dynamic> json) => InventoryValuationModel(
        lines: (json['lines'] as List<dynamic>? ?? [])
            .map((e) => InventoryValuationLineModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalValue: (json['total_value'] as num?)?.toDouble() ?? 0,
        totalCostValue: (json['total_cost_value'] as num?)?.toDouble(),
        totalRetailValue: (json['total_retail_value'] as num?)?.toDouble(),
        totalMarginValue: (json['total_margin_value'] as num?)?.toDouble(),
      );

  @override
  List<Object?> get props => [totalValue];
}

class InventoryValuationLineModel extends Equatable {
  const InventoryValuationLineModel({
    required this.productId,
    required this.balance,
    required this.unitCost,
    required this.totalValue,
    this.unitPrice,
    this.costValue,
    this.retailValue,
    this.marginValue,
    this.product,
  });

  final int productId;
  final int balance;
  final double unitCost;
  final double totalValue;
  final double? unitPrice;
  final double? costValue;
  final double? retailValue;
  final double? marginValue;
  final ProductModel? product;

  factory InventoryValuationLineModel.fromJson(Map<String, dynamic> json) => InventoryValuationLineModel(
        productId: json['product_id'] as int,
        balance: json['balance'] as int? ?? 0,
        unitCost: (json['unit_cost'] as num?)?.toDouble() ?? 0,
        totalValue: (json['total_value'] as num?)?.toDouble() ?? 0,
        unitPrice: (json['unit_price'] as num?)?.toDouble(),
        costValue: (json['cost_value'] as num?)?.toDouble(),
        retailValue: (json['retail_value'] as num?)?.toDouble(),
        marginValue: (json['margin_value'] as num?)?.toDouble(),
        product: json['product'] is Map
            ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
            : null,
      );

  @override
  List<Object?> get props => [productId, balance];
}

class BulkLoadLineDraft {
  const BulkLoadLineDraft({
    required this.productId,
    required this.quantity,
    this.productName,
    this.balanceDisplay,
    this.unitId,
  });

  final int productId;
  final int quantity;
  final String? productName;
  final String? balanceDisplay;
  final int? unitId;
}

class BulkLoadLineResult extends Equatable {
  const BulkLoadLineResult({
    required this.productId,
    required this.quantity,
    required this.movementId,
  });

  final int productId;
  final int quantity;
  final int movementId;

  factory BulkLoadLineResult.fromJson(Map<String, dynamic> json) => BulkLoadLineResult(
        productId: json['product_id'] as int,
        quantity: json['quantity'] as int? ?? 0,
        movementId: json['movement_id'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [productId, quantity, movementId];
}

class BulkLoadResult extends Equatable {
  const BulkLoadResult({
    required this.loaded,
    this.errors = const [],
  });

  final List<BulkLoadLineResult> loaded;
  final List<Map<String, dynamic>> errors;

  factory BulkLoadResult.fromJson(Map<String, dynamic> json) => BulkLoadResult(
        loaded: (json['loaded'] as List<dynamic>? ?? [])
            .map((e) => BulkLoadLineResult.fromJson(e as Map<String, dynamic>))
            .toList(),
        errors: (json['errors'] as List<dynamic>? ?? [])
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList(),
      );

  @override
  List<Object?> get props => [loaded, errors];
}

class BulkLoadPreviewLine extends Equatable {
  const BulkLoadPreviewLine({
    required this.productId,
    required this.quantity,
    this.productName,
    this.balanceDisplay,
    this.quantityDisplay,
    this.unitId,
  });

  final int productId;
  final int quantity;
  final String? productName;
  final String? balanceDisplay;
  final String? quantityDisplay;
  final int? unitId;

  factory BulkLoadPreviewLine.fromJson(Map<String, dynamic> json) => BulkLoadPreviewLine(
        productId: json['product_id'] as int,
        quantity: json['quantity'] as int? ?? 0,
        productName: json['product_name'] as String?,
        balanceDisplay: json['balance_display'] as String?,
        quantityDisplay: json['quantity_display'] as String?,
        unitId: json['unit_id'] as int?,
      );

  @override
  List<Object?> get props => [productId, quantity, unitId];
}
