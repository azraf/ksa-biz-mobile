import 'package:isar_community/isar.dart';

part 'local_expense.g.dart';

@collection
class LocalExpense {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late int serverId;

  late String dataJson;

  @Index()
  late bool pendingSync;

  @Index()
  late DateTime updatedAt;
}
