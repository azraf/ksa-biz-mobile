import 'package:isar_community/isar.dart';

import '../../models/product.dart';
import '../isar/local_product.dart';
import '../isar/mappers/entity_mappers.dart';
import '../isar_service.dart';

class CatalogLocalStore {
  CatalogLocalStore(this._isar);

  final IsarService _isar;

  Isar get _db => _isar.isar;

  Future<void> upsert(ProductModel product) async {
    final local = ProductMapper.fromModel(product);
    await _isar.writeTxn(() async {
      final existing = await _db.localProducts.filter().serverIdEqualTo(product.id).findFirst();
      if (existing != null) local.isarId = existing.isarId;
      await _db.localProducts.put(local);
    });
  }

  Future<void> upsertAll(Iterable<ProductModel> products) async {
    await _isar.writeTxn(() async {
      for (final product in products) {
        final local = ProductMapper.fromModel(product);
        final existing = await _db.localProducts.filter().serverIdEqualTo(product.id).findFirst();
        if (existing != null) local.isarId = existing.isarId;
        await _db.localProducts.put(local);
      }
    });
  }

  Future<List<ProductModel>> search({
    String? query,
    int offset = 0,
    int limit = 50,
  }) async {
    final q = _db.localProducts.where();
    List<LocalProduct> rows;
    if (query != null && query.isNotEmpty) {
      rows = await q
          .filter()
          .nameContains(query, caseSensitive: false)
          .sortByName()
          .offset(offset)
          .limit(limit)
          .findAll();
    } else {
      rows = await q.sortByName().offset(offset).limit(limit).findAll();
    }
    return rows.map<ProductModel>(ProductMapper.toModel).toList();
  }

  Future<bool> hasCatalog() async {
    final count = await _db.localProducts.count();
    return count > 0;
  }

  Future<int> count() => _db.localProducts.count();
}
