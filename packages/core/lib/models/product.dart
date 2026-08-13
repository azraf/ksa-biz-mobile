import 'package:equatable/equatable.dart';

class ProductGalleryImage extends Equatable {
  const ProductGalleryImage({required this.id, required this.url, this.caption});

  final int id;
  final String url;
  final String? caption;

  factory ProductGalleryImage.fromJson(Map<String, dynamic> json) =>
      ProductGalleryImage(
        id: json['id'] as int,
        url: json['url'] as String? ?? '',
        caption: json['caption'] as String?,
      );

  @override
  List<Object?> get props => [id, url, caption];
}

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.name,
    this.price = 0,
    this.wholesalePrice = 0,
    this.profitMargin = 0,
    this.alertQuantity = 0,
    this.description,
    this.allowBreakPack = false,
    this.piecesPerCarton = 1,
    this.piecePrice = 0,
    this.pcsUnitId,
    this.cartonUnitId,
    this.unitId,
    this.stockUnitId,
    this.categoryId,
    this.brandId,
    this.tagId,
    this.cost,
    this.featureImageUrl,
    this.galleryImages = const [],
  });

  final int id;
  final String name;
  final double price;
  final double wholesalePrice;
  final double profitMargin;
  final int alertQuantity;
  final String? description;
  final bool allowBreakPack;
  final int piecesPerCarton;
  final double piecePrice;
  final int? pcsUnitId;
  final int? cartonUnitId;
  final int? unitId;
  final int? stockUnitId;
  final int? categoryId;
  final int? brandId;
  final int? tagId;

  /// Default purchase cost, used to pre-fill a purchase line's price. Null
  /// when the product has variants (cost varies per variant).
  final double? cost;

  final String? featureImageUrl;
  final List<ProductGalleryImage> galleryImages;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      price: _toDouble(json['price']),
      wholesalePrice: _toDouble(json['wholesale_price']),
      profitMargin: _toDouble(json['profit_margin']),
      alertQuantity: json['alert_quantity'] as int? ?? 0,
      description: json['description'] as String?,
      allowBreakPack: json['allow_break_pack'] as bool? ?? false,
      piecesPerCarton: json['pieces_per_carton'] as int? ?? 1,
      piecePrice: _toDouble(json['piece_price']),
      pcsUnitId: json['pcs_unit_id'] as int?,
      cartonUnitId: json['carton_unit_id'] as int?,
      unitId: json['unit_id'] as int?,
      stockUnitId: json['stock_unit_id'] as int?,
      categoryId: json['category_id'] as int?,
      brandId: json['brand_id'] as int?,
      tagId: json['tag_id'] as int?,
      cost: (json['effective_cost'] ?? json['cost']) != null
          ? _toDouble(json['effective_cost'] ?? json['cost'])
          : null,
      featureImageUrl: json['feature_image_url'] as String?,
      galleryImages: (json['gallery_urls'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ProductGalleryImage.fromJson)
          .toList(),
    );
  }

  int get defaultCartonUnitId => cartonUnitId ?? unitId ?? 0;

  double priceForUnitId(int? unitId) {
    if (pcsUnitId != null && unitId == pcsUnitId) {
      return piecePrice > 0 ? piecePrice : (piecesPerCarton > 0 ? price / piecesPerCarton : price);
    }
    return price;
  }

  /// Purchase cost for the selected unit (carton cost stored on product).
  double? costForUnitId(int? unitId) {
    if (cost == null) return null;
    if (pcsUnitId != null && unitId == pcsUnitId) {
      final ppc = piecesPerCarton;
      return ppc > 0 ? cost! / ppc : cost;
    }
    return cost;
  }

  bool get canPurchaseByPiece => piecesPerCarton > 1 && pcsUnitId != null;

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
