import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:core/api/api_client.dart';
import 'package:core/models/paginated_response.dart';
import 'package:core/models/admin_models.dart';
import 'package:core/offline/local_database.dart';
import 'package:core/repositories/customer_repository.dart';
import 'package:core/repositories/offline_customer_repository.dart';

/// A remote that always fails, to simulate a live API error (bad token,
/// timeout, 500, ...) independent of what's in the local cache.
class _ThrowingCustomerRepository extends CustomerRepository {
  _ThrowingCustomerRepository() : super(ApiClient());

  @override
  Future<PaginatedResponse<CustomerShopModel>> shops({
    CustomerListQuery? query,
    String? search,
    int page = 1,
    int perPage = 25,
  }) {
    throw Exception('simulated network failure');
  }
}

/// A remote that always succeeds with a fixed shop list, to drive the live
/// fetch → cacheBatch path (which tags rows with the fetching salesperson).
class _FixedShopsRepository extends CustomerRepository {
  _FixedShopsRepository(this._shops) : super(ApiClient());

  final List<CustomerShopModel> _shops;

  @override
  Future<PaginatedResponse<CustomerShopModel>> shops({
    CustomerListQuery? query,
    String? search,
    int page = 1,
    int perPage = 25,
  }) async =>
      PaginatedResponse(
        items: _shops,
        currentPage: 1,
        lastPage: 1,
        total: _shops.length,
      );
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  OfflineCustomerRepository repo() => OfflineCustomerRepository(
        remote: _ThrowingCustomerRepository(),
        db: LocalDatabase.instance,
        isOnline: () => true,
      );

  test('a failed live fetch rethrows when the cache has nothing to fall back to', () async {
    await expectLater(
      () => repo().shops(search: 'zzz-nonexistent-offline-repo-test-marker'),
      throwsA(isA<Exception>()),
    );
  });

  test('a failed live fetch falls back to cache when the cache has data', () async {
    await LocalDatabase.instance.cacheEntitiesBatch(
      entityType: 'customer_shop',
      entities: const [
        (entityId: 999901, data: {'id': 999901, 'name': 'zzz-cache-hit-offline-repo-test-marker'}),
      ],
    );

    final result = await repo().shops(search: 'zzz-cache-hit-offline-repo-test-marker');
    expect(result.items, isNotEmpty);
    expect(result.items.first.name, 'zzz-cache-hit-offline-repo-test-marker');
  });

  test('cachedShops reads the local snapshot without touching the network', () async {
    await LocalDatabase.instance.cacheEntitiesBatch(
      entityType: 'customer_shop',
      entities: const [
        (entityId: 999902, data: {'id': 999902, 'name': 'zzz-cache-first-test-marker'}),
      ],
    );

    // remote is _ThrowingCustomerRepository — if this hit the network it would throw.
    final result = await repo().cachedShops(search: 'zzz-cache-first-test-marker');
    expect(result.items, isNotEmpty);
    expect(result.items.first.name, 'zzz-cache-first-test-marker');
  });

  test('cached search: multi-word AND, no match-all on letters, fuzzy fallback, active first', () async {
    await LocalDatabase.instance.cacheEntitiesBatch(
      entityType: 'customer_van',
      entities: const [
        (entityId: 999910, data: {'id': 999910, 'name': 'Zed Alpha Van', 'mobile': '0501112222', 'is_inactive': true}),
        (entityId: 999911, data: {'id': 999911, 'name': 'Zed Beta Van', 'mobile': '0503334444', 'is_inactive': false}),
      ],
    );

    var r = await repo().cachedVans(search: 'zed van');
    expect(r.items.map((v) => v.name), ['Zed Beta Van', 'Zed Alpha Van']); // active first
    expect(r.isFuzzy, isFalse);

    r = await repo().cachedVans(search: 'zed alpha');
    expect(r.items.map((v) => v.name), ['Zed Alpha Van']);

    // Letters that match nothing must not return every row (old contains('') bug).
    r = await repo().cachedVans(search: 'qqqqqq');
    expect(r.items, isEmpty);
    expect(r.isFuzzy, isFalse);

    // Misspelling → most likely
    r = await repo().cachedVans(search: 'zed betta');
    expect(r.items.map((v) => v.name), ['Zed Beta Van']);
    expect(r.isFuzzy, isTrue);

    // Phone digits with formatting
    r = await repo().cachedVans(search: '050 333 4444');
    expect(r.items.map((v) => v.name), ['Zed Beta Van']);
  });

  group('per-salesperson cache scoping', () {
    OfflineCustomerRepository fixedRepo(List<CustomerShopModel> shops) =>
        OfflineCustomerRepository(
          remote: _FixedShopsRepository(shops),
          db: LocalDatabase.instance,
          isOnline: () => true,
        );

    test('cached rows are visible only to the salesperson whose fetch cached them', () async {
      const marker = 'zzz-sp-scope-test-marker';
      const shop = CustomerShopModel(id: 999920, name: marker);

      // Salesperson 71's live fetch caches (and tags) the row.
      await fixedRepo([shop]).shops(search: marker, salesPersonId: 71, scoped: true);

      final mine = await repo().cachedShops(search: marker, salesPersonId: 71);
      expect(mine.items.map((s) => s.id), [999920]);

      // Another salesperson on the same device must not see it offline.
      final theirs = await repo().cachedShops(search: marker, salesPersonId: 72);
      expect(theirs.items, isEmpty);

      // Admin (null) sees everything.
      final admin = await repo().cachedShops(search: marker);
      expect(admin.items.map((s) => s.id), [999920]);
    });

    test('tags merge across salespeople and survive an untagged (admin) refetch', () async {
      const marker = 'zzz-sp-merge-test-marker';
      const shop = CustomerShopModel(id: 999921, name: marker);

      await fixedRepo([shop]).shops(search: marker, salesPersonId: 73, scoped: true);
      await fixedRepo([shop]).shops(search: marker, salesPersonId: 74, scoped: true);
      // An admin fetch (no salesperson) must not strip the existing tags.
      await fixedRepo([shop]).shops(search: marker);

      final sp73 = await repo().cachedShops(search: marker, salesPersonId: 73);
      final sp74 = await repo().cachedShops(search: marker, salesPersonId: 74);
      final sp75 = await repo().cachedShops(search: marker, salesPersonId: 75);
      expect(sp73.items.map((s) => s.id), [999921]);
      expect(sp74.items.map((s) => s.id), [999921]);
      expect(sp75.items, isEmpty);
    });

    test('offline shops() filters the cache by the requesting salesperson', () async {
      const marker = 'zzz-sp-offline-scope-marker';
      const shop = CustomerShopModel(id: 999922, name: marker);
      await fixedRepo([shop]).shops(search: marker, salesPersonId: 76, scoped: true);

      final offline = OfflineCustomerRepository(
        remote: _ThrowingCustomerRepository(),
        db: LocalDatabase.instance,
        isOnline: () => false,
      );
      final mine = await offline.shops(search: marker, salesPersonId: 76);
      expect(mine.items.map((s) => s.id), [999922]);
      final theirs = await offline.shops(search: marker, salesPersonId: 77);
      expect(theirs.items, isEmpty);
    });
  });
}
