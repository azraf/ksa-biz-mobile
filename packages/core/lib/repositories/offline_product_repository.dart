import '../models/paginated_response.dart';
import '../models/product.dart';
import '../offline/stores/catalog_local_store.dart';
import 'product_repository.dart';

class OfflineProductRepository {
  OfflineProductRepository({
    required ProductRepository remote,
    required CatalogLocalStore catalog,
    required bool Function() isOnline,
  })  : _remote = remote,
        _catalog = catalog,
        _isOnline = isOnline;

  final ProductRepository _remote;
  final CatalogLocalStore _catalog;
  final bool Function() _isOnline;

  Future<PaginatedResponse<ProductModel>> list({
    String? search,
    int? categoryId,
    int? brandId,
    int page = 1,
    int perPage = 50,
  }) async {
    if (_isOnline()) {
      try {
        final result = await _remote.list(
          search: search,
          categoryId: categoryId,
          brandId: brandId,
          page: page,
        );
        await _catalog.upsertAll(result.items);
        return result;
      } catch (_) {
        return _cachedList(search: search, page: page, perPage: perPage);
      }
    }
    return _cachedList(search: search, page: page, perPage: perPage);
  }

  Future<PaginatedResponse<ProductModel>> _cachedList({
    String? search,
    int page = 1,
    int perPage = 50,
  }) async {
    final offset = (page - 1) * perPage;
    final items = await _catalog.search(query: search, offset: offset, limit: perPage);
    final total = await _catalog.count();
    final lastPage = total == 0 ? 1 : (total / perPage).ceil();
    return PaginatedResponse(
      items: items,
      currentPage: page,
      lastPage: lastPage,
      total: total,
    );
  }

  Future<bool> hasCachedProducts() => _catalog.hasCatalog();
}
