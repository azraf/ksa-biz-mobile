import 'package:isar_community/isar.dart';

part 'local_watchlist.g.dart';

@collection
class LocalWatchlistItem {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late int serverId;

  @Index()
  late int salesPersonId;

  late String gps;
  String? placeName;
  String? noteText;

  @Index()
  late String status;

  String? archivedReason;
  int? customerShopId;
  String? createdAt;

  String? imagesJson;
  String? recordingsJson;

  @Index()
  late bool pendingSync;

  @Index()
  late DateTime updatedAt;
}
