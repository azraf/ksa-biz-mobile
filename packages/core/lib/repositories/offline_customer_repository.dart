import 'package:flutter/foundation.dart';

import '../models/admin_models.dart';
import '../models/customer.dart';
import '../models/customer_assignment_models.dart';
import '../models/paginated_response.dart';
import '../support/search_match.dart';
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

  /// Key inside each cached row holding the salesperson ids whose fetches
  /// returned it. Cached list reads are filtered by this so one salesperson's
  /// offline cache never leaks another salesperson's customers on a shared
  /// device; an admin read (null salesPersonId) sees every row.
  static const salesPersonIdsKey = '_sp_ids';

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
      } catch (e) {
        final cached = await _cachedCustomerTypes();
        if (cached.isEmpty) {
          debugPrint('[OfflineCustomerRepository] customerTypes live fetch failed, no cache to fall back to: $e');
          rethrow;
        }
        return cached;
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
      return _liveOrCachedPage(
        live: () => _remote.shops(query: query),
        cacheBatch: (items) => _cacheShopsBatch(items, fetchedBy: salesPersonId),
        cachedFallback: () =>
            _cachedShopsPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage),
        label: 'shops',
      );
    }
    return _cachedShopsPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage);
  }

  /// Tries the live endpoint first; falls back to cache only if the cache
  /// actually has something to show. An empty cache after a failed live call
  /// rethrows instead of silently returning an empty-but-successful page —
  /// otherwise a scoping bug, an expired token, and a real empty result all
  /// look identical to the UI as "no customers."
  Future<PaginatedResponse<T>> _liveOrCachedPage<T>({
    required Future<PaginatedResponse<T>> Function() live,
    required Future<void> Function(List<T> items) cacheBatch,
    required Future<PaginatedResponse<T>> Function() cachedFallback,
    required String label,
  }) async {
    try {
      final result = await live();
      await cacheBatch(result.items);
      return result;
    } catch (e) {
      final cached = await cachedFallback();
      if (cached.items.isEmpty) {
        debugPrint('[OfflineCustomerRepository] $label live fetch failed, no cache to fall back to: $e');
        rethrow;
      }
      return cached;
    }
  }

  Future<PaginatedResponse<CustomerVanModel>> vans({
    String? search,
    String? searchMode,
    int? salesPersonId,
    bool scoped = true,
    int? lastOrderWithinDays,
    int? areaId,
    String sort = 'created_at',
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
      page: page,
      perPage: perPage,
    );
    if (_isOnline()) {
      return _liveOrCachedPage(
        live: () => _remote.vans(query: query),
        cacheBatch: (items) => _cacheVansBatch(items, fetchedBy: salesPersonId),
        cachedFallback: () =>
            _cachedVansPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage),
        label: 'vans',
      );
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
    String sort = 'created_at',
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
      page: page,
      perPage: perPage,
    );
    if (_isOnline()) {
      return _liveOrCachedPage(
        live: () => _remote.importers(query: query),
        cacheBatch: (items) => _cacheImportersBatch(items, fetchedBy: salesPersonId),
        cachedFallback: () =>
            _cachedImportersPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage),
        label: 'importers',
      );
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

  /// Reads straight from the local cache, no network call — for an instant
  /// first paint while the caller separately kicks off a live refresh.
  /// [salesPersonId] scopes the read to rows that salesperson's own fetches
  /// cached; null (admin) sees all rows.
  Future<PaginatedResponse<CustomerShopModel>> cachedShops({
    String? search,
    int? salesPersonId,
    int page = 1,
    int perPage = 25,
  }) =>
      _cachedShopsPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage);

  Future<PaginatedResponse<CustomerVanModel>> cachedVans({
    String? search,
    int? salesPersonId,
    int page = 1,
    int perPage = 25,
  }) =>
      _cachedVansPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage);

  Future<PaginatedResponse<CustomerImporterModel>> cachedImporters({
    String? search,
    int? salesPersonId,
    int page = 1,
    int perPage = 25,
  }) =>
      _cachedImportersPage(search: search, salesPersonId: salesPersonId, page: page, perPage: perPage);

  /// Best-effort local name lookup for one customer — cache only, no network.
  Future<String?> cachedCustomerName(String customerType, int id) async {
    final cached = await _db.getCachedEntity(customerType, id);
    final name = cached?['name'];
    return name is String && name.isNotEmpty ? name : null;
  }

  Future<PaginatedResponse<CustomerShopModel>> _cachedShopsPage({
    String? search,
    int? salesPersonId,
    required int page,
    required int perPage,
  }) async {
    final cached = await _db.getCachedEntities('customer_shop');
    final all = cached
        .where((e) => _visibleTo(e, salesPersonId))
        .map((e) => CustomerShopModel.fromJson(e))
        .where((e) => !e.isSystem)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return _searchSlice(all, search, (e) => [e.name, e.mobile, e.primaryContact?.contactName, e.primaryContact?.contactMobile], page, perPage);
  }

  Future<PaginatedResponse<CustomerVanModel>> _cachedVansPage({
    String? search,
    int? salesPersonId,
    required int page,
    required int perPage,
  }) async {
    final cached = await _db.getCachedEntities('customer_van');
    final all = cached
        .where((e) => _visibleTo(e, salesPersonId))
        .map((e) => CustomerVanModel.fromJson(e))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return _searchSlice(all, search, (e) => [e.name, e.mobile], page, perPage);
  }

  Future<PaginatedResponse<CustomerImporterModel>> _cachedImportersPage({
    String? search,
    int? salesPersonId,
    required int page,
    required int perPage,
  }) async {
    final cached = await _db.getCachedEntities('customer_importer');
    final all = cached
        .where((e) => _visibleTo(e, salesPersonId))
        .map((e) => CustomerImporterModel.fromJson(e))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return _searchSlice(all, search, (e) => [e.name, e.mobile], page, perPage);
  }

  /// A cached row is visible to a salesperson only when one of their own
  /// fetches cached it (rows written before tagging existed, or by an admin
  /// session only, stay admin-only until the salesperson's next live fetch).
  bool _visibleTo(Map<String, dynamic> row, int? salesPersonId) {
    if (salesPersonId == null) return true;
    final tags = row[salesPersonIdsKey];
    return tags is List && tags.contains(salesPersonId);
  }

  PaginatedResponse<T> _pageSlice<T>(List<T> items, int page, int perPage) {
    final total = items.length;
    final lastPage = total == 0 ? 1 : (total / perPage).ceil();
    final start = (page - 1) * perPage;
    final slice = start >= total ? <T>[] : items.sublist(start, (start + perPage).clamp(0, total));
    return PaginatedResponse(items: slice, currentPage: page, lastPage: lastPage, total: total);
  }

  /// Offline search over the cached list: same multi-word matcher (and
  /// fuzzy fallback) as the server; digits-only queries also match a phone
  /// with punctuation stripped. Active customers first while searching so the
  /// screen can section, exactly like the live response.
  PaginatedResponse<T> _searchSlice<T>(
    List<T> items,
    String? search,
    Iterable<String?> Function(T) fields,
    int page,
    int perPage,
  ) {
    if (search == null || search.trim().isEmpty) return _pageSlice(items, page, perPage);
    final digits = search.replaceAll(RegExp(r'\D'), '');
    final phoneMode = digits.length >= 7; // same heuristic as the server
    final r = phoneMode
        ? SearchMatch.filterOrFuzzy(items, digits, (e) => fields(e).map((f) => f?.replaceAll(RegExp(r'\D'), '')))
        : SearchMatch.filterOrFuzzy(items, search, fields);
    final sorted = [...r.items]..sort((a, b) => (_isInactive(a) ? 1 : 0).compareTo(_isInactive(b) ? 1 : 0));
    final pageResult = _pageSlice(sorted, page, perPage);
    return PaginatedResponse(
      items: pageResult.items,
      currentPage: pageResult.currentPage,
      lastPage: pageResult.lastPage,
      total: pageResult.total,
      searchMode: r.isFuzzy ? 'fuzzy' : 'exact',
    );
  }

  bool _isInactive(Object? e) => switch (e) {
        CustomerShopModel s => s.isInactive,
        CustomerVanModel v => v.isInactive,
        CustomerImporterModel i => i.isInactive,
        _ => false,
      };

  Future<void> _cacheShopsBatch(List<CustomerShopModel> shops, {int? fetchedBy}) async {
    await _cacheBatchTagged(
      entityType: 'customer_shop',
      entities: shops.map((shop) => (entityId: shop.id, data: _shopData(shop))).toList(),
      fetchedBy: fetchedBy,
    );
  }

  /// Writes a batch, tagging each row with the salesperson whose fetch
  /// returned it and carrying forward tags from earlier fetches (a customer
  /// can be legitimately visible to several salespeople on a shared device).
  /// An admin fetch (null) adds no tag but must not strip existing ones.
  Future<void> _cacheBatchTagged({
    required String entityType,
    required List<({int entityId, Map<String, dynamic> data})> entities,
    required int? fetchedBy,
  }) async {
    final tagged = <({int entityId, Map<String, dynamic> data})>[];
    for (final entity in entities) {
      tagged.add((
        entityId: entity.entityId,
        data: await _withMergedTags(entityType, entity.entityId, entity.data, fetchedBy),
      ));
    }
    await _db.cacheEntitiesBatch(entityType: entityType, entities: tagged);
  }

  Future<Map<String, dynamic>> _withMergedTags(
    String entityType,
    int entityId,
    Map<String, dynamic> data,
    int? fetchedBy,
  ) async {
    final existing = await _db.getCachedEntity(entityType, entityId);
    final ids = <int>{
      ...?(existing?[salesPersonIdsKey] as List?)?.whereType<int>(),
      if (fetchedBy != null) fetchedBy,
    };
    if (ids.isEmpty) return data;
    return {...data, salesPersonIdsKey: ids.toList()};
  }

  Map<String, dynamic> _shopData(CustomerShopModel shop) => {
        'id': shop.id,
        'name': shop.name,
        if (shop.nameAr != null) 'name_ar': shop.nameAr,
        if (shop.mobile != null) 'mobile': shop.mobile,
        if (shop.email != null) 'email': shop.email,
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

  Future<void> _cacheVansBatch(List<CustomerVanModel> vans, {int? fetchedBy}) async {
    await _cacheBatchTagged(
      entityType: 'customer_van',
      entities: vans.map((van) => (entityId: van.id, data: _vanData(van))).toList(),
      fetchedBy: fetchedBy,
    );
  }

  Map<String, dynamic> _vanData(CustomerVanModel van) => {
        'id': van.id,
        'name': van.name,
        if (van.nameAr != null) 'name_ar': van.nameAr,
        if (van.mobile != null) 'mobile': van.mobile,
        if (van.areaId != null) 'area_id': van.areaId,
        if (van.isInactive) 'is_inactive': true,
      };

  Future<void> _cacheImportersBatch(List<CustomerImporterModel> importers, {int? fetchedBy}) async {
    await _cacheBatchTagged(
      entityType: 'customer_importer',
      entities: importers.map((importer) => (entityId: importer.id, data: _importerData(importer))).toList(),
      fetchedBy: fetchedBy,
    );
  }

  Map<String, dynamic> _importerData(CustomerImporterModel importer) => {
        'id': importer.id,
        'name': importer.name,
        if (importer.nameAr != null) 'name_ar': importer.nameAr,
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
        data: await _withMergedTags('customer_shop', shop.id, _shopData(shop), null),
      );
      await _db.cacheEntity(
        entityType: 'mobile_config',
        entityId: 1,
        data: {'walk_in_shop_id': shop.id},
      );
    } catch (_) {}
  }

  Future<CustomerShopModel> getShop(int id) async {
    Object? liveError;
    if (_isOnline()) {
      try {
        final shop = await _remote.getShop(id);
        // Merge tags so a detail refresh can't strip list visibility.
        await _db.cacheEntity(
          entityType: 'customer_shop',
          entityId: shop.id,
          data: await _withMergedTags('customer_shop', shop.id, _shopData(shop), null),
        );
        return shop;
      } catch (e) {
        liveError = e;
      }
    }
    final cached = await _db.getCachedEntity('customer_shop', id);
    if (cached != null) return CustomerShopModel.fromJson(cached);
    if (liveError != null) throw liveError;
    throw Exception('Shop not available offline');
  }

  Future<CustomerVanModel> getVan(int id) async {
    Object? liveError;
    if (_isOnline()) {
      try {
        final van = await _remote.getVan(id);
        await _db.cacheEntity(
          entityType: 'customer_van',
          entityId: van.id,
          data: await _withMergedTags('customer_van', van.id, _vanData(van), null),
        );
        return van;
      } catch (e) {
        liveError = e;
      }
    }
    final cached = await _db.getCachedEntity('customer_van', id);
    if (cached != null) return CustomerVanModel.fromJson(cached);
    if (liveError != null) throw liveError;
    throw Exception('Van not available offline');
  }

  Future<CustomerImporterModel> getImporter(int id) async {
    Object? liveError;
    if (_isOnline()) {
      try {
        final importer = await _remote.getImporter(id);
        await _db.cacheEntity(
          entityType: 'customer_importer',
          entityId: importer.id,
          data: await _withMergedTags('customer_importer', importer.id, _importerData(importer), null),
        );
        return importer;
      } catch (e) {
        liveError = e;
      }
    }
    final cached = await _db.getCachedEntity('customer_importer', id);
    if (cached != null) return CustomerImporterModel.fromJson(cached);
    if (liveError != null) throw liveError;
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
