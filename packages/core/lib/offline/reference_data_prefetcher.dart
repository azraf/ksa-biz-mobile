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

  static const _maxPages = 10;
  static const _batchSize = 3;
  static const _initialPrefetchDelay = Duration(seconds: 5);
  static const _prefetchTtl = Duration(hours: 6);

  DateTime? _lastPrefetchAt;
  int? _lastSalesPersonId;
  String? _lastError;

  String? get lastError => _lastError;

  Future<void> prefetch({
    int? salesPersonId,
    Duration initialDelay = _initialPrefetchDelay,
    bool force = false,
  }) async {
    if (initialDelay > Duration.zero) {
      await Future<void>.delayed(initialDelay);
    }
    if (!force &&
        _lastPrefetchAt != null &&
        DateTime.now().difference(_lastPrefetchAt!) < _prefetchTtl &&
        _lastSalesPersonId == salesPersonId) {
      return;
    }
    _lastError = null;
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
      _lastSalesPersonId = salesPersonId;
    } catch (e) {
      _lastError = e.toString();
    }
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
