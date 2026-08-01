import 'package:isar_community/isar.dart';

part 'local_admin_list_cache.g.dart';

@collection
class LocalAdminListCache {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String cacheKey;

  late String payloadJson;
  late DateTime fetchedAt;
}
