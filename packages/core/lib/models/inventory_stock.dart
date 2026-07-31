import 'package:equatable/equatable.dart';

import 'product.dart';

class InventoryStockModel extends Equatable {
  const InventoryStockModel({
    required this.productId,
    required this.balance,
    this.balancePieces = 0,
    this.balanceDisplay,
    this.piecesPerCarton = 1,
    this.product,
  });

  final int productId;
  final int balance;
  final int balancePieces;
  final String? balanceDisplay;
  final int piecesPerCarton;
  final ProductModel? product;

  String get displayBalance => balanceDisplay ?? '$balance';

  factory InventoryStockModel.fromJson(Map<String, dynamic> json) {
    final balancePieces = json['balance_pieces'] as int? ?? json['balance'] as int? ?? 0;

    return InventoryStockModel(
      productId: json['product_id'] as int,
      balance: json['balance'] as int? ?? balancePieces,
      balancePieces: balancePieces,
      balanceDisplay: json['balance_display'] as String?,
      piecesPerCarton: json['pieces_per_carton'] as int? ?? 1,
      product: json['product'] is Map
          ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [productId, balance, balancePieces, balanceDisplay];
}
