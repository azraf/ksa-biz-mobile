import '../models/paginated_response.dart';
import '../repositories/offline_customer_repository.dart';
import '../repositories/offline_product_repository.dart';

class ReferenceDataPrefetcher {
  ReferenceDataPrefetcher({
    required OfflineCustomerRepository customerRepo,
    required OfflineProductRepository productRepo,
  })  : _customerRepo = customerRepo,
        _productRepo = productRepo;

  final OfflineCustomerRepository _customerRepo;
  final OfflineProductRepository _productRepo;

  static const _maxPages = 50;
  static const _batchSize = 4;
  DateTime? _lastPrefetchAt;

  Future<void> prefetch({int? salesPersonId, bool force = false}) async {
    if (!force &&
        _lastPrefetchAt != null &&
        DateTime.now().difference(_lastPrefetchAt!) < const Duration(hours: 6) &&
        await hasCachedCatalog()) {
      return;
    }

    try {
      await _customerRepo.customerTypes();
      if (salesPersonId != null) {
        await _customerRepo.prefetchAssignedForSalesPerson(salesPersonId);
      } else {
        await _prefetchPages(_customerRepo.shops);
        await _prefetchPages(_customerRepo.vans);
        await _prefetchPages(_customerRepo.importers);
      }
      await _customerRepo.prefetchWalkInShop();
      await _prefetchPages(_productRepo.list);
      _lastPrefetchAt = DateTime.now();
    } catch (_) {}
  }

  Future<void> _prefetchPages<T>(
    Future<PaginatedResponse<T>> Function({int page}) fetch,
  ) async {
    var page = 1;
    while (page <= _maxPages) {
      final batch = <Future<PaginatedResponse<T>>>[];
      for (var i = 0; i < _batchSize && page + i <= _maxPages; i++) {
        batch.add(fetch(page: page + i));
      }
      final results = await Future.wait(batch);
      var hasMore = false;
      for (final result in results) {
        if (result.hasMore) hasMore = true;
      }
      if (!hasMore) break;
      page += _batchSize;
    }
  }

  Future<bool> hasCachedCatalog() async {
    final hasCustomers = await _customerRepo.hasCachedCatalog();
    final hasProducts = await _productRepo.hasCachedProducts();
    return hasCustomers && hasProducts;
  }
}
