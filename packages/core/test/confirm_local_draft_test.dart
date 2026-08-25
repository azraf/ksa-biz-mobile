import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:core/api/api_client.dart';
import 'package:core/offline/local_database.dart';
import 'package:core/repositories/offline_order_repository.dart';
import 'package:core/repositories/order_repository.dart';

/// Remote that must never be reached — these tests run the offline path.
class _OfflineOrderRemote extends OrderRepository {
  _OfflineOrderRemote() : super(ApiClient());
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  OfflineOrderRepository repo() => OfflineOrderRepository(
        remote: _OfflineOrderRemote(),
        db: LocalDatabase.instance,
        isOnline: () => false,
      );

  test('confirmLocalDraft drops as_draft from the queued payload and flips the cache', () async {
    final order = await repo().create({
      'customer_type_id': 1,
      'customer_shop_id': 7,
      'as_draft': true,
      'include_vat': true,
      'vat_inclusive': true,
      'vat_rate': 15,
      'items': [
        {
          'product_id': 1,
          'quantity': 2,
          'product_price': 50.0,
          'product_discount': 0.0,
          'product_vat': 13.04,
          'vat_rate': 15,
          'is_preorder': false,
        },
      ],
    });

    expect(order.id, lessThan(0));
    expect(order.isDraft, isTrue);
    // Inclusive: the line bill is the gross amount, VAT not added on top.
    expect(order.totalBill, 100.0);
    expect(order.vatTotal, closeTo(13.04, 1e-9));
    expect(order.includeVat, isTrue);
    expect(order.vatInclusive, isTrue);
    expect(order.vatRate, 15);

    await repo().confirmLocalDraft(order.id);

    final queued = await LocalDatabase.instance.pendingQueueByLocalId(order.id);
    final create = queued.singleWhere(
      (q) => q.entityType == 'order' && q.operation == 'create',
    );
    expect(create.payload.containsKey('as_draft'), isFalse);
    expect(create.payload['include_vat'], true); // rest of the payload intact
    expect(create.payload['customer_type_id'], 1);

    final cached = await LocalDatabase.instance.getCachedEntity('order', order.id);
    expect(cached, isNotNull);
    expect(cached!['status'], 'confirmed');
    expect(cached['vat_total'], closeTo(13.04, 1e-9));
  });

  test('confirmLocalDraft throws StateError when no pending create exists', () async {
    await expectLater(
      () => repo().confirmLocalDraft(-987654),
      throwsStateError,
    );
  });
}
