import 'package:isar_community/isar.dart';

part 'local_diary.g.dart';

@collection
class LocalDiaryNote {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late int serverId;

  @Index()
  late String customerType;

  @Index()
  late int customerId;

  @Index(composite: [CompositeIndex('customerType'), CompositeIndex('customerId')])
  late String customerKey;

  late String noteType;
  String? body;
  int? customerShopId;
  int? customerVanId;
  int? customerImporterId;
  String? createdAt;

  @Index()
  late bool pendingSync;

  @Index()
  late DateTime updatedAt;
}
