import '../models/paginated_response.dart';
import '../models/product.dart';
import '../offline/local_database.dart';
import 'product_repository.dart';

class OfflineProductRepository {
  OfflineProductRepository({
    required ProductRepository remote,
    required LocalDatabase db,
    required bool Function() isOnline,
  })  : _remote = remote,
        _db = db,
        _isOnline = isOnline;

  final ProductRepository _remote;
  final LocalDatabase _db;
  final bool Function() _isOnline;

  Future<PaginatedResponse<ProductModel>> list({
    String? search,
    int? categoryId,
    int? brandId,
    int page = 1,
    int perPage = 20,
    bool withStock = false,
    Set<String>? sources,
    bool inStock = false,
    String? sort,
  }) async {
    if (_isOnline()) {
      try {
        final result = await _remote.list(
          search: search,
          categoryId: categoryId,
          brandId: brandId,
          page: page,
          perPage: perPage,
          withStock: withStock,
          sources: sources,
          inStock: inStock,
          sort: sort,
        );
        await _db.cacheEntitiesBatch(
          entityType: 'product',
          entities: result.items
              .map(
                (product) => (
                  entityId: product.id,
                  data: {
                    'id': product.id,
                    'name': product.name,
                    if (product.nameAr != null) 'name_ar': product.nameAr,
                    'price': product.price,
                    'wholesale_price': product.wholesalePrice,
                    'alert_quantity': product.alertQuantity,
                    if (product.description != null) 'description': product.description,
                    'allow_break_pack': product.allowBreakPack,
                    'pieces_per_carton': product.piecesPerCarton,
                    'piece_price': product.piecePrice,
                    if (product.pcsUnitId != null) 'pcs_unit_id': product.pcsUnitId,
                    if (product.cartonUnitId != null) 'carton_unit_id': product.cartonUnitId,
                    if (product.unitId != null) 'unit_id': product.unitId,
                    if (product.featureImageUrl != null)
                      'feature_image_url': product.featureImageUrl,
                    // Kept so the catalog can filter by brand/category and show
                    // stock while offline.
                    if (product.categoryId != null) 'category_id': product.categoryId,
                    if (product.brandId != null) 'brand_id': product.brandId,
                    if (product.brandName != null) 'brand_name': product.brandName,
                    if (product.categoryName != null) 'category_name': product.categoryName,
                    if (product.stock != null) 'stock': product.stock!.toJson(),
                  },
                ),
              )
              .toList(),
        );
        return result;
      } catch (_) {
        return _cachedList(
          search: search,
          categoryId: categoryId,
          brandId: brandId,
          sources: sources,
          inStock: inStock,
          sort: sort,
        );
      }
    }
    return _cachedList(
      search: search,
      categoryId: categoryId,
      brandId: brandId,
      sources: sources,
      inStock: inStock,
      sort: sort,
    );
  }

  Future<PaginatedResponse<ProductModel>> _cachedList({
    String? search,
    int? categoryId,
    int? brandId,
    Set<String>? sources,
    bool inStock = false,
    String? sort,
  }) async {
    final cached = await _db.getCachedEntities('product');
    final items = cached
        .map((e) => ProductModel.fromJson(e))
        .where((e) => _matchesSearch(e.name, search))
        .where((e) => categoryId == null || e.categoryId == categoryId)
        .where((e) => brandId == null || e.brandId == brandId)
        .where((e) => !inStock || _piecesIn(e, sources) > 0)
        .toList();

    // The cached stock snapshot is whatever the last online fetch stored, so
    // sorting by it is best-effort — the "as of" stamp tells the user that.
    switch (sort) {
      case 'stock_desc':
        items.sort((a, b) => _piecesIn(b, sources).compareTo(_piecesIn(a, sources)));
      case 'stock_asc':
        items.sort((a, b) => _piecesIn(a, sources).compareTo(_piecesIn(b, sources)));
      case 'price_asc':
        items.sort((a, b) => a.price.compareTo(b.price));
      case 'price_desc':
        items.sort((a, b) => b.price.compareTo(a.price));
      default:
        items.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }

    return PaginatedResponse(
      items: items,
      currentPage: 1,
      lastPage: 1,
      total: items.length,
    );
  }

  /// Cached pieces across [sources]; all sources when none are named.
  int _piecesIn(ProductModel product, Set<String>? sources) {
    final stock = product.stock;
    if (stock == null) return 0;
    if (sources == null || sources.isEmpty) return stock.totalPieces;
    return stock.sources
        .where((s) => sources.contains(s.key))
        .fold(0, (sum, s) => sum + s.balancePieces);
  }

  bool _matchesSearch(String name, String? search) {
    if (search == null || search.isEmpty) return true;
    // Same shape as the server: every word must appear somewhere in the name.
    final haystack = name.toLowerCase();
    return search
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .every(haystack.contains);
  }

  /// When the product cache was last written, for an "as of" stamp.
  Future<DateTime?> cachedAt() => _db.cachedAt('product');

  Future<bool> hasCachedProducts() async {
    final products = await _db.getCachedEntities('product');
    return products.isNotEmpty;
  }
}
