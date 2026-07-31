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
  }) async {
    if (_isOnline()) {
      try {
        final result = await _remote.list(
          search: search,
          categoryId: categoryId,
          brandId: brandId,
          page: page,
        );
        for (final product in result.items) {
          await _db.cacheEntity(
            entityType: 'product',
            entityId: product.id,
            data: {
              'id': product.id,
              'name': product.name,
              'price': product.price,
              'wholesale_price': product.wholesalePrice,
              'alert_quantity': product.alertQuantity,
              if (product.description != null) 'description': product.description,
            },
          );
        }
        return result;
      } catch (_) {
        return _cachedList(search: search);
      }
    }
    return _cachedList(search: search);
  }

  Future<PaginatedResponse<ProductModel>> _cachedList({String? search}) async {
    final cached = await _db.getCachedEntities('product');
    final items = cached
        .map((e) => ProductModel.fromJson(e))
        .where((e) => _matchesSearch(e.name, search))
        .toList();
    return PaginatedResponse(
      items: items,
      currentPage: 1,
      lastPage: 1,
      total: items.length,
    );
  }

  bool _matchesSearch(String name, String? search) {
    if (search == null || search.isEmpty) return true;
    return name.toLowerCase().contains(search.toLowerCase());
  }

  Future<bool> hasCachedProducts() async {
    final products = await _db.getCachedEntities('product');
    return products.isNotEmpty;
  }
}
