import 'package:isar_community/isar.dart';

import 'enums.dart';

part 'local_media_blob.g.dart';

@collection
class LocalMediaBlob {
  Id id = Isar.autoIncrement;

  late String localPath;
  late String mimeType;
  String? originalName;
  int sizeBytes = 0;
  late String mediaKind;

  @Index()
  late String parentEntityType;

  @Index()
  int? parentLocalId;

  int? parentServerId;

  late String uploadEndpoint;
  String uploadField = 'file';
  String extraFieldsJson = '{}';

  @Index()
  @Enumerated(EnumType.name)
  late MediaUploadStatus status;

  String? nativeTaskId;
  int retryCount = 0;
  String? errorMessage;

  @Index()
  late DateTime createdAt;
}
