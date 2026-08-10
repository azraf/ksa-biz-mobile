import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.name,
    this.price = 0,
    this.wholesalePrice = 0,
    this.alertQuantity = 0,
    this.description,
    this.allowBreakPack = false,
    this.piecesPerCarton = 1,
    this.piecePrice = 0,
    this.pcsUnitId,
    this.cartonUnitId,
    this.unitId,
    this.cost,
  });

  final int id;
  final String name;
  final double price;
  final double wholesalePrice;
  final int alertQuantity;
  final String? description;
  final bool allowBreakPack;
  final int piecesPerCarton;
  final double piecePrice;
  final int? pcsUnitId;
  final int? cartonUnitId;
  final int? unitId;

  /// Default purchase cost, used to pre-fill a purchase line's price. Null
  /// when the product has variants (cost varies per variant).
  final double? cost;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      price: _toDouble(json['price']),
      wholesalePrice: _toDouble(json['wholesale_price']),
      alertQuantity: json['alert_quantity'] as int? ?? 0,
      description: json['description'] as String?,
      allowBreakPack: json['allow_break_pack'] as bool? ?? false,
      piecesPerCarton: json['pieces_per_carton'] as int? ?? 1,
      piecePrice: _toDouble(json['piece_price']),
      pcsUnitId: json['pcs_unit_id'] as int?,
      cartonUnitId: json['carton_unit_id'] as int?,
      unitId: json['unit_id'] as int?,
      cost: (json['effective_cost'] ?? json['cost']) != null
          ? _toDouble(json['effective_cost'] ?? json['cost'])
          : null,
    );
  }

  int get defaultCartonUnitId => cartonUnitId ?? unitId ?? 0;

  double priceForUnitId(int? unitId) {
    if (pcsUnitId != null && unitId == pcsUnitId) {
      return piecePrice > 0 ? piecePrice : (piecesPerCarton > 0 ? price / piecesPerCarton : price);
    }
    return price;
  }

  String unitLabel(int? unitId) {
    if (pcsUnitId != null && unitId == pcsUnitId) {
      return 'pcs';
    }
    return 'CTN';
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  List<Object?> get props => [id, name, price, wholesalePrice, alertQuantity, allowBreakPack, piecesPerCarton];
}
