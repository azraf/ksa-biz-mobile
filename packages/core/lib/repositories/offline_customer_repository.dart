import '../models/admin_models.dart';
import '../models/customer.dart';
import '../models/customer_assignment_models.dart';
import '../models/paginated_response.dart';
import '../offline/stores/customer_local_store.dart';
import 'customer_repository.dart';

class OfflineCustomerRepository {
  OfflineCustomerRepository({
    required CustomerRepository remote,
    required CustomerLocalStore customers,
    required bool Function() isOnline,
  })  : _remote = remote,
        _customers = customers,
        _isOnline = isOnline;

  final CustomerRepository _remote;
  final CustomerLocalStore _customers;
  final bool Function() _isOnline;

  Future<List<CustomerTypeModel>> customerTypes() async {
    if (_isOnline()) {
      try {
        final types = await _remote.customerTypes();
        for (final type in types) {
          await _customers.upsertType(type);
        }
        return types;
      } catch (_) {
        return _customers.listTypes();
      }
    }
    return _customers.listTypes();
  }

  Future<PaginatedResponse<CustomerShopModel>> shops({
    String? search,
    String? searchMode,
    int? salesPersonId,
    bool scoped = true,
    int? lastOrderWithinDays,
    int? areaId,
    String sort = 'name',
    double? lat,
    double? lng,
    int page = 1,
    int perPage = 25,
  }) async {
    final query = CustomerListQuery(
      search: search,
      searchMode: searchMode,
      salesPersonId: salesPersonId,
      scoped: scoped,
      lastOrderWithinDays: lastOrderWithinDays,
      areaId: areaId,
      sort: sort,
      lat: lat,
      lng: lng,
      page: page,
      perPage: perPage,
    );
    if (_isOnline()) {
      try {
        final result = await _remote.shops(query: query);
        for (final shop in result.items) {
          await _customers.upsertShop(shop, salesPersonId: salesPersonId);
        }
        return result;
      } catch (_) {
        return _cachedShopsPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage);
      }
    }
    return _cachedShopsPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage);
  }

  Future<PaginatedResponse<CustomerVanModel>> vans({
    String? search,
    String? searchMode,
    int? salesPersonId,
    bool scoped = true,
    int? lastOrderWithinDays,
    int? areaId,
    int page = 1,
    int perPage = 25,
  }) async {
    final query = CustomerListQuery(
      search: search,
      searchMode: searchMode,
      salesPersonId: salesPersonId,
      scoped: scoped,
      lastOrderWithinDays: lastOrderWithinDays,
      areaId: areaId,
      page: page,
      perPage: perPage,
    );
    if (_isOnline()) {
      try {
        final result = await _remote.vans(query: query);
        for (final van in result.items) {
          await _customers.upsertVan(van, salesPersonId: salesPersonId);
        }
        return result;
      } catch (_) {
        return _cachedVansPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage);
      }
    }
    return _cachedVansPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage);
  }

  Future<PaginatedResponse<CustomerImporterModel>> importers({
    String? search,
    String? searchMode,
    int? salesPersonId,
    bool scoped = true,
    int? lastOrderWithinDays,
    int? areaId,
    int page = 1,
    int perPage = 25,
  }) async {
    final query = CustomerListQuery(
      search: search,
      searchMode: searchMode,
      salesPersonId: salesPersonId,
      scoped: scoped,
      lastOrderWithinDays: lastOrderWithinDays,
      areaId: areaId,
      page: page,
      perPage: perPage,
    );
    if (_isOnline()) {
      try {
        final result = await _remote.importers(query: query);
        for (final importer in result.items) {
          await _customers.upsertImporter(importer, salesPersonId: salesPersonId);
        }
        return result;
      } catch (_) {
        return _cachedImportersPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage);
      }
    }
    return _cachedImportersPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage);
  }

  Future<PaginatedResponse<SalesCustomerRow>> salesCustomersPhoneSearch({
    required String search,
    int page = 1,
    String? customerType,
  }) async {
    if (!_isOnline()) {
      return PaginatedResponse(items: [], currentPage: 1, lastPage: 1, total: 0);
    }
    return _remote.salesCustomers(search: search, searchMode: 'phone', page: page, customerType: customerType);
  }

  Future<void> prefetchAssignedForSalesPerson(int salesPersonId) async {
    if (!_isOnline()) return;
    for (final Future<PaginatedResponse<dynamic>> Function(int page) fetch in [
      (page) => shops(salesPersonId: salesPersonId, scoped: true, page: page),
      (page) => vans(salesPersonId: salesPersonId, scoped: true, page: page),
      (page) => importers(salesPersonId: salesPersonId, scoped: true, page: page),
    ]) {
      var page = 1;
      while (page <= 50) {
        final result = await fetch(page);
        if (!result.hasMore) break;
        page++;
      }
    }
  }

  Future<PaginatedResponse<CustomerShopModel>> _cachedShopsPage({
    String? search,
    int? salesPersonId,
    required int page,
    required int perPage,
  }) async {
    final offset = (page - 1) * perPage;
    final items = await _customers.searchShops(
      query: search,
      salesPersonId: salesPersonId,
      offset: offset,
      limit: perPage,
    );
    final total = await _customers.countShops(salesPersonId: salesPersonId);
    final lastPage = total == 0 ? 1 : (total / perPage).ceil();
    return PaginatedResponse(items: items, currentPage: page, lastPage: lastPage, total: total);
  }

  Future<PaginatedResponse<CustomerVanModel>> _cachedVansPage({
    String? search,
    int? salesPersonId,
    required int page,
    required int perPage,
  }) async {
    final offset = (page - 1) * perPage;
    final items = await _customers.searchVans(
      query: search,
      salesPersonId: salesPersonId,
      offset: offset,
      limit: perPage,
    );
    final total = await _customers.countVans(salesPersonId: salesPersonId);
    final lastPage = total == 0 ? 1 : (total / perPage).ceil();
    return PaginatedResponse(items: items, currentPage: page, lastPage: lastPage, total: total);
  }

  Future<PaginatedResponse<CustomerImporterModel>> _cachedImportersPage({
    String? search,
    int? salesPersonId,
    required int page,
    required int perPage,
  }) async {
    final offset = (page - 1) * perPage;
    final items = await _customers.searchImporters(
      query: search,
      salesPersonId: salesPersonId,
      offset: offset,
      limit: perPage,
    );
    final total = await _customers.countImporters(salesPersonId: salesPersonId);
    final lastPage = total == 0 ? 1 : (total / perPage).ceil();
    return PaginatedResponse(items: items, currentPage: page, lastPage: lastPage, total: total);
  }

  Future<bool> hasCachedCatalog() => _customers.hasCatalog();

  Future<void> prefetchWalkInShop() async {
    if (!_isOnline()) return;
    try {
      final shop = await _remote.walkInShop();
      if (shop == null) return;
      await _customers.upsertShop(shop);
      await _customers.setConfig('mobile_config', {'walk_in_shop_id': shop.id});
    } catch (_) {}
  }

  Future<int?> walkInShopId() => _customers.walkInShopId();
}
