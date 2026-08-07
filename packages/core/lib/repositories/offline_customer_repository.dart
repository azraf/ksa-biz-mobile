import '../models/admin_models.dart';
import '../models/customer.dart';
import '../models/customer_assignment_models.dart';
import '../models/paginated_response.dart';
import '../offline/local_database.dart';
import 'customer_repository.dart';

class OfflineCustomerRepository {
  OfflineCustomerRepository({
    required CustomerRepository remote,
    required LocalDatabase db,
    required bool Function() isOnline,
  })  : _remote = remote,
        _db = db,
        _isOnline = isOnline;

  final CustomerRepository _remote;
  final LocalDatabase _db;
  final bool Function() _isOnline;

  Future<List<CustomerTypeModel>> customerTypes() async {
    if (_isOnline()) {
      try {
        final types = await _remote.customerTypes();
        await _db.cacheEntitiesBatch(
          entityType: 'customer_type',
          entities: types
              .map((type) => (entityId: type.id, data: {'id': type.id, 'type_name': type.typeName}))
              .toList(),
        );
        return types;
      } catch (_) {
        return _cachedCustomerTypes();
      }
    }
    return _cachedCustomerTypes();
  }

  Future<List<CustomerTypeModel>> _cachedCustomerTypes() async {
    final cached = await _db.getCachedEntities('customer_type');
    return cached.map((e) => CustomerTypeModel.fromJson(e)).toList();
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
        await _cacheShopsBatch(result.items);
        return result;
      } catch (_) {
        return _cachedShopsPage(search: search, page: page, perPage: perPage);
      }
    }
    return _cachedShopsPage(search: search, page: page, perPage: perPage);
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
        await _cacheVansBatch(result.items);
        return result;
      } catch (_) {
        return _cachedVansPage(search: search, page: page, perPage: perPage);
      }
    }
    return _cachedVansPage(search: search, page: page, perPage: perPage);
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
        await _cacheImportersBatch(result.items);
        return result;
      } catch (_) {
        return _cachedImportersPage(search: search, page: page, perPage: perPage);
      }
    }
    return _cachedImportersPage(search: search, page: page, perPage: perPage);
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
    for (Future<PaginatedResponse<dynamic>> Function(int page) fetch in [
      (page) => shops(salesPersonId: salesPersonId, scoped: true, page: page),
      (page) => vans(salesPersonId: salesPersonId, scoped: true, page: page),
      (page) => importers(salesPersonId: salesPersonId, scoped: true, page: page),
    ]) {
      var page = 1;
      while (page <= 3) {
        final result = await fetch(page);
        if (!result.hasMore) break;
        page++;
      }
    }
  }

  Future<PaginatedResponse<CustomerShopModel>> _cachedShopsPage({
    String? search,
    required int page,
    required int perPage,
  }) async {
    final cached = await _db.getCachedEntities('customer_shop');
    final items = cached
        .map((e) => CustomerShopModel.fromJson(e))
        .where((e) => !e.isSystem)
        .where((e) => _matchesShopSearch(e, search))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return _pageSlice(items, page, perPage);
  }

  Future<PaginatedResponse<CustomerVanModel>> _cachedVansPage({
    String? search,
    required int page,
    required int perPage,
  }) async {
    final cached = await _db.getCachedEntities('customer_van');
    final items = cached
        .map((e) => CustomerVanModel.fromJson(e))
        .where((e) => _matchesNameOrMobile(e.name, e.mobile, search))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return _pageSlice(items, page, perPage);
  }

  Future<PaginatedResponse<CustomerImporterModel>> _cachedImportersPage({
    String? search,
    required int page,
    required int perPage,
  }) async {
    final cached = await _db.getCachedEntities('customer_importer');
    final items = cached
        .map((e) => CustomerImporterModel.fromJson(e))
        .where((e) => _matchesNameOrMobile(e.name, e.mobile, search))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return _pageSlice(items, page, perPage);
  }

  PaginatedResponse<T> _pageSlice<T>(List<T> items, int page, int perPage) {
    final total = items.length;
    final lastPage = total == 0 ? 1 : (total / perPage).ceil();
    final start = (page - 1) * perPage;
    final slice = start >= total ? <T>[] : items.sublist(start, (start + perPage).clamp(0, total));
    return PaginatedResponse(items: slice, currentPage: page, lastPage: lastPage, total: total);
  }

  bool _matchesShopSearch(CustomerShopModel shop, String? search) {
    if (search == null || search.isEmpty) return true;
    final s = search.toLowerCase();
    if (shop.name.toLowerCase().contains(s)) return true;
    final pc = shop.primaryContact;
    if (pc?.contactName?.toLowerCase().contains(s) ?? false) return true;
    if (pc?.contactMobile?.contains(search.replaceAll(RegExp(r'\D'), '')) ?? false) return true;
    return false;
  }

  bool _matchesNameOrMobile(String name, String? mobile, String? search) {
    if (search == null || search.isEmpty) return true;
    final s = search.toLowerCase();
    if (name.toLowerCase().contains(s)) return true;
    if (mobile != null && mobile.contains(search.replaceAll(RegExp(r'\D'), ''))) return true;
    return false;
  }

  Future<void> _cacheShopsBatch(List<CustomerShopModel> shops) async {
    await _db.cacheEntitiesBatch(
      entityType: 'customer_shop',
      entities: shops.map((shop) => (entityId: shop.id, data: _shopData(shop))).toList(),
    );
  }

  Map<String, dynamic> _shopData(CustomerShopModel shop) => {
        'id': shop.id,
        'name': shop.name,
        if (shop.gps != null) 'gps': shop.gps,
        'is_system': shop.isSystem,
        if (shop.areaId != null) 'area_id': shop.areaId,
        if (shop.areaName != null) 'area_name': shop.areaName,
        if (shop.primaryContact != null) 'primary_contact': {
          'contact_name': shop.primaryContact!.contactName,
          'contact_mobile': shop.primaryContact!.contactMobile,
        },
        if (shop.lastOrderAt != null) 'last_order_at': shop.lastOrderAt,
        'is_inactive': shop.isInactive,
      };

  Future<void> _cacheVansBatch(List<CustomerVanModel> vans) async {
    await _db.cacheEntitiesBatch(
      entityType: 'customer_van',
      entities: vans.map((van) => (entityId: van.id, data: _vanData(van))).toList(),
    );
  }

  Map<String, dynamic> _vanData(CustomerVanModel van) => {
        'id': van.id,
        'name': van.name,
        if (van.mobile != null) 'mobile': van.mobile,
        if (van.areaId != null) 'area_id': van.areaId,
        if (van.isInactive) 'is_inactive': true,
      };

  Future<void> _cacheImportersBatch(List<CustomerImporterModel> importers) async {
    await _db.cacheEntitiesBatch(
      entityType: 'customer_importer',
      entities: importers.map((importer) => (entityId: importer.id, data: _importerData(importer))).toList(),
    );
  }

  Map<String, dynamic> _importerData(CustomerImporterModel importer) => {
        'id': importer.id,
        'name': importer.name,
        if (importer.mobile != null) 'mobile': importer.mobile,
      };

  Future<bool> hasCachedCatalog() async {
    final types = await _db.getCachedEntities('customer_type');
    final shops = await _db.getCachedEntities('customer_shop');
    final vans = await _db.getCachedEntities('customer_van');
    final importers = await _db.getCachedEntities('customer_importer');
    return types.isNotEmpty &&
        (shops.isNotEmpty || vans.isNotEmpty || importers.isNotEmpty);
  }

  Future<void> prefetchWalkInShop() async {
    if (!_isOnline()) return;
    try {
      final shop = await _remote.walkInShop();
      if (shop == null) return;
      await _db.cacheEntity(
        entityType: 'customer_shop',
        entityId: shop.id,
        data: _shopData(shop),
      );
      await _db.cacheEntity(
        entityType: 'mobile_config',
        entityId: 1,
        data: {'walk_in_shop_id': shop.id},
      );
    } catch (_) {}
  }

  Future<CustomerShopModel> getShop(int id) async {
    if (_isOnline()) {
      try {
        final shop = await _remote.getShop(id);
        await _db.cacheEntity(entityType: 'customer_shop', entityId: shop.id, data: _shopData(shop));
        return shop;
      } catch (_) {}
    }
    final cached = await _db.getCachedEntity('customer_shop', id);
    if (cached != null) return CustomerShopModel.fromJson(cached);
    throw Exception('Shop not available offline');
  }

  Future<CustomerVanModel> getVan(int id) async {
    if (_isOnline()) {
      try {
        final van = await _remote.getVan(id);
        await _db.cacheEntity(entityType: 'customer_van', entityId: van.id, data: _vanData(van));
        return van;
      } catch (_) {}
    }
    final cached = await _db.getCachedEntity('customer_van', id);
    if (cached != null) return CustomerVanModel.fromJson(cached);
    throw Exception('Van not available offline');
  }

  Future<CustomerImporterModel> getImporter(int id) async {
    if (_isOnline()) {
      try {
        final importer = await _remote.getImporter(id);
        await _db.cacheEntity(
          entityType: 'customer_importer',
          entityId: importer.id,
          data: _importerData(importer),
        );
        return importer;
      } catch (_) {}
    }
    final cached = await _db.getCachedEntity('customer_importer', id);
    if (cached != null) return CustomerImporterModel.fromJson(cached);
    throw Exception('Importer not available offline');
  }

  Future<int?> walkInShopId() async {
    final config = await _db.getCachedEntities('mobile_config');
    if (config.isNotEmpty) {
      final id = config.first['walk_in_shop_id'];
      if (id is int) return id;
      return int.tryParse('$id');
    }
    final shops = await _db.getCachedEntities('customer_shop');
    for (final row in shops) {
      if (row['is_system'] == true) {
        final id = row['id'];
        if (id is int) return id;
        return int.tryParse('$id');
      }
    }
    return null;
  }
}
