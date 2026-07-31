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

  Future<void> prefetch({int? salesPersonId}) async {
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
    } catch (_) {}
  }

  Future<void> _prefetchPages<T>(
    Future<PaginatedResponse<T>> Function({int page}) fetch,
  ) async {
    var page = 1;
    while (page <= _maxPages) {
      final result = await fetch(page: page);
      if (!result.hasMore) break;
      page++;
    }
  }

  Future<bool> hasCachedCatalog() async {
    final hasCustomers = await _customerRepo.hasCachedCatalog();
    final hasProducts = await _productRepo.hasCachedProducts();
    return hasCustomers && hasProducts;
  }
}
