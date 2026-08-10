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
}
