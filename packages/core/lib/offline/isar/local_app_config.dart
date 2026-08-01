import 'package:isar_community/isar.dart';

part 'local_app_config.g.dart';

@collection
class LocalAppConfig {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String key;

  late String valueJson;
}
