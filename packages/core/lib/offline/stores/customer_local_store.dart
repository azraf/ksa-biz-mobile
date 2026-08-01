import 'package:isar_community/isar.dart';

import '../../models/admin_models.dart';
import '../../models/customer.dart';
import '../isar/local_app_config.dart';
import '../isar/local_customer.dart';
import '../isar/mappers/entity_mappers.dart';
import '../isar_service.dart';

class CustomerLocalStore {
  CustomerLocalStore(this._isar);

  final IsarService _isar;

  Isar get _db => _isar.isar;

  Future<void> upsertType(CustomerTypeModel type) async {
    final local = CustomerMapper.typeFromModel(type);
    await _isar.writeTxn(() async {
      final existing = await _db.localCustomerTypes.filter().serverIdEqualTo(type.id).findFirst();
      if (existing != null) local.isarId = existing.isarId;
      await _db.localCustomerTypes.put(local);
    });
  }

  Future<void> upsertShop(CustomerShopModel shop, {int? salesPersonId}) async {
    final local = CustomerMapper.shopFromModel(shop, salesPersonId: salesPersonId);
    await _isar.writeTxn(() async {
      final existing = await _db.localCustomerShops.filter().serverIdEqualTo(shop.id).findFirst();
      if (existing != null) local.isarId = existing.isarId;
      await _db.localCustomerShops.put(local);
    });
  }

  Future<void> upsertVan(CustomerVanModel van, {int? salesPersonId}) async {
    final local = CustomerMapper.vanFromModel(van, salesPersonId: salesPersonId);
    await _isar.writeTxn(() async {
      final existing = await _db.localCustomerVans.filter().serverIdEqualTo(van.id).findFirst();
      if (existing != null) local.isarId = existing.isarId;
      await _db.localCustomerVans.put(local);
    });
  }

  Future<void> upsertImporter(CustomerImporterModel importer, {int? salesPersonId}) async {
    final local = CustomerMapper.importerFromModel(importer, salesPersonId: salesPersonId);
    await _isar.writeTxn(() async {
      final existing =
          await _db.localCustomerImporters.filter().serverIdEqualTo(importer.id).findFirst();
      if (existing != null) local.isarId = existing.isarId;
      await _db.localCustomerImporters.put(local);
    });
  }

  Future<List<CustomerTypeModel>> listTypes() async {
    final rows = await _db.localCustomerTypes.where().findAll();
    return rows.map<CustomerTypeModel>(CustomerMapper.typeToModel).toList();
  }

  Future<List<CustomerShopModel>> searchShops({
    String? query,
    int? salesPersonId,
    int offset = 0,
    int limit = 25,
  }) async {
    var q = _db.localCustomerShops.filter().isSystemEqualTo(false);
    if (salesPersonId != null) {
      q = q.salesPersonIdEqualTo(salesPersonId);
    }
    if (query != null && query.isNotEmpty) {
      final digits = query.replaceAll(RegExp(r'\D'), '');
      q = q.group(
        (g) => g
            .nameContains(query, caseSensitive: false)
            .or()
            .phoneContains(digits.isEmpty ? query : digits, caseSensitive: false),
      );
    }
    final rows = await q.sortByName().offset(offset).limit(limit).findAll();
    return rows.map<CustomerShopModel>(CustomerMapper.shopToModel).toList();
  }

  Future<int> countShops({int? salesPersonId}) async {
    var q = _db.localCustomerShops.filter().isSystemEqualTo(false);
    if (salesPersonId != null) q = q.salesPersonIdEqualTo(salesPersonId);
    return q.count();
  }

  Future<List<CustomerVanModel>> searchVans({
    String? query,
    int? salesPersonId,
    int offset = 0,
    int limit = 25,
  }) async {
    var rows = await _db.localCustomerVans.where().findAll();
    if (salesPersonId != null) {
      rows = rows.where((v) => v.salesPersonId == salesPersonId).toList();
    }
    if (query != null && query.isNotEmpty) {
      final s = query.toLowerCase();
      final digits = query.replaceAll(RegExp(r'\D'), '');
      rows = rows
          .where(
            (v) =>
                v.name.toLowerCase().contains(s) ||
                (digits.isNotEmpty && v.mobile.contains(digits)),
          )
          .toList();
    }
    rows.sort((a, b) => a.name.compareTo(b.name));
    final page = rows.skip(offset).take(limit).toList();
    return page.map<CustomerVanModel>(CustomerMapper.vanToModel).toList();
  }

  Future<int> countVans({int? salesPersonId}) async {
    var rows = await _db.localCustomerVans.where().findAll();
    if (salesPersonId != null) {
      rows = rows.where((v) => v.salesPersonId == salesPersonId).toList();
    }
    return rows.length;
  }

  Future<List<CustomerImporterModel>> searchImporters({
    String? query,
    int? salesPersonId,
    int offset = 0,
    int limit = 25,
  }) async {
    var rows = await _db.localCustomerImporters.where().findAll();
    if (salesPersonId != null) {
      rows = rows.where((v) => v.salesPersonId == salesPersonId).toList();
    }
    if (query != null && query.isNotEmpty) {
      final s = query.toLowerCase();
      final digits = query.replaceAll(RegExp(r'\D'), '');
      rows = rows
          .where(
            (v) =>
                v.name.toLowerCase().contains(s) ||
                (digits.isNotEmpty && v.mobile.contains(digits)),
          )
          .toList();
    }
    rows.sort((a, b) => a.name.compareTo(b.name));
    final page = rows.skip(offset).take(limit).toList();
    return page.map<CustomerImporterModel>(CustomerMapper.importerToModel).toList();
  }

  Future<int> countImporters({int? salesPersonId}) async {
    var rows = await _db.localCustomerImporters.where().findAll();
    if (salesPersonId != null) {
      rows = rows.where((v) => v.salesPersonId == salesPersonId).toList();
    }
    return rows.length;
  }

  Future<bool> hasCatalog() async {
    final types = await _db.localCustomerTypes.count();
    if (types == 0) return false;
    final shops = await _db.localCustomerShops.count();
    final vans = await _db.localCustomerVans.count();
    final importers = await _db.localCustomerImporters.count();
    return shops > 0 || vans > 0 || importers > 0;
  }

  Future<void> setConfig(String key, Map<String, dynamic> value) async {
    await _isar.writeTxn(() async {
      final existing = await _db.localAppConfigs.filter().keyEqualTo(key).findFirst();
      final row = LocalAppConfig()
        ..key = key
        ..valueJson = encodeJson(value);
      if (existing != null) row.isarId = existing.isarId;
      await _db.localAppConfigs.put(row);
    });
  }

  Future<Map<String, dynamic>?> getConfig(String key) async {
    final row = await _db.localAppConfigs.filter().keyEqualTo(key).findFirst();
    if (row == null) return null;
    return decodeJson(row.valueJson);
  }

  Future<int?> walkInShopId() async {
    final config = await getConfig('mobile_config');
    final fromConfig = config?['walk_in_shop_id'];
    if (fromConfig is int) return fromConfig;
    if (fromConfig != null) return int.tryParse('$fromConfig');
    final system = await _db.localCustomerShops.filter().isSystemEqualTo(true).findFirst();
    return system?.serverId;
  }
}
