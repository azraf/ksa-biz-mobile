import 'package:isar_community/isar.dart';

part 'local_customer.g.dart';

@collection
class LocalCustomerType {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late int serverId;

  late String typeName;
}

@collection
class LocalCustomerShop {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late int serverId;

  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  @Index(type: IndexType.value, caseSensitive: false)
  String phone = '';

  @Index()
  int? salesPersonId;

  @Index()
  int? areaId;

  String? areaName;
  String? gps;
  bool isSystem = false;
  bool isInactive = false;
  String? contactName;
  String? lastOrderAt;

  @Index(composite: [CompositeIndex('salesPersonId'), CompositeIndex('name')])
  late String salesPersonNameKey;
}

@collection
class LocalCustomerVan {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late int serverId;

  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  @Index(type: IndexType.value, caseSensitive: false)
  String mobile = '';

  @Index()
  int? salesPersonId;

  int? areaId;
  bool isInactive = false;
}

@collection
class LocalCustomerImporter {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late int serverId;

  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  @Index(type: IndexType.value, caseSensitive: false)
  String mobile = '';

  @Index()
  int? salesPersonId;
}
