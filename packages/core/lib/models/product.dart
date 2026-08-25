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

/// One inventory location's balance for a product.
///
/// [key] is `warehouse`, `mine`, `other_vans`, or `van:<id>`. A salesperson
/// only ever receives the first three — the server collapses every colleague's
/// van into a single anonymous `other_vans` row with a null [salesPersonId].
class ProductStockSource extends Equatable {
  const ProductStockSource({
    required this.key,
    required this.label,
    this.salesPersonId,
    this.balancePieces = 0,
    this.balance = 0,
    this.balanceDisplay = '0',
  });

  final String key;
  final String label;
  final int? salesPersonId;
  final int balancePieces;
  final int balance;
  final String balanceDisplay;

  bool get isWarehouse => key == 'warehouse';
  bool get isOwnVan => key == 'mine';

  factory ProductStockSource.fromJson(Map<String, dynamic> json) => ProductStockSource(
        key: json['key'] as String? ?? '',
        label: json['label'] as String? ?? '',
        salesPersonId: json['sales_person_id'] as int?,
        balancePieces: json['balance_pieces'] as int? ?? 0,
        balance: json['balance'] as int? ?? 0,
        balanceDisplay: json['balance_display'] as String? ?? '0',
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'label': label,
        'sales_person_id': salesPersonId,
        'balance_pieces': balancePieces,
        'balance': balance,
        'balance_display': balanceDisplay,
      };

  @override
  List<Object?> get props => [key, salesPersonId, balancePieces];
}

/// A product's stock across the inventory sources the caller asked for.
class ProductStock extends Equatable {
  const ProductStock({
    this.totalPieces = 0,
    this.totalDisplay = '0',
    this.sources = const [],
  });

  final int totalPieces;
  final String totalDisplay;
  final List<ProductStockSource> sources;

  bool get inStock => totalPieces > 0;

  int balanceFor(String key) => sources
      .where((s) => s.key == key)
      .fold(0, (sum, s) => sum + s.balancePieces);

  int get warehousePieces => balanceFor('warehouse');
  int get ownVanPieces => balanceFor('mine');

  factory ProductStock.fromJson(Map<String, dynamic> json) => ProductStock(
        totalPieces: json['total_pieces'] as int? ?? 0,
        totalDisplay: json['total_display'] as String? ?? '0',
        sources: (json['sources'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(ProductStockSource.fromJson)
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'total_pieces': totalPieces,
        'total_display': totalDisplay,
        'sources': sources.map((s) => s.toJson()).toList(),
      };

  @override
  List<Object?> get props => [totalPieces, sources];
}

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.name,
    this.nameAr,
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
    this.brandName,
    this.categoryName,
    this.stock,
  });

  final int id;
  final String name;

  /// Arabic product name — shown on printed invoices when set.
  final String? nameAr;
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

  /// Names come from the nested `brand` / `category` objects the API has always
  /// sent; they were simply never parsed.
  final String? brandName;
  final String? categoryName;

  /// Present only when the list was fetched with `withStock: true`.
  final ProductStock? stock;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
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
      brandName: _nestedName(json['brand']) ?? json['brand_name'] as String?,
      categoryName: _nestedName(json['category']) ?? json['category_name'] as String?,
      stock: json['stock'] is Map
          ? ProductStock.fromJson(json['stock'] as Map<String, dynamic>)
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

  static String? _nestedName(dynamic value) =>
      value is Map ? value['name'] as String? : null;

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  List<Object?> get props => [id, name, price, wholesalePrice, alertQuantity, allowBreakPack, piecesPerCarton];
}
