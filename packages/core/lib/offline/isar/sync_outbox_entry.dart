import 'package:isar_community/isar.dart';

import 'enums.dart';

part 'sync_outbox_entry.g.dart';

@collection
class SyncOutboxEntry {
  Id id = Isar.autoIncrement;

  @Enumerated(EnumType.name)
  late SyncEntityType entityType;

  @Enumerated(EnumType.name)
  late SyncOperation operation;

  @Index()
  int? localEntityId;

  int? serverEntityId;

  @Index()
  @Enumerated(EnumType.name)
  late SyncStatus status;

  late String payloadJson;

  @Index()
  late DateTime createdAt;

  int retryCount = 0;
  String? errorMessage;
  String? clientRequestId;
  DateTime? nextRetryAt;
}
