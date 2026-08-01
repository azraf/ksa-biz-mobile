import 'package:isar_community/isar.dart';

part 'local_report_cache.g.dart';

@collection
class LocalReportCache {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String cacheKey;

  @Index()
  late String reportType;

  late String dataJson;

  @Index()
  late DateTime fetchedAt;
}
