import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'media_kind.dart';

Map<String, String> _parseExtraFields(dynamic raw) {
  if (raw is String && raw.isNotEmpty) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
    } catch (_) {}
    return {};
  }
  if (raw is Map) {
    return raw.map((k, v) => MapEntry(k.toString(), v.toString()));
  }
  return {};
}

class MediaTarget extends Equatable {
  const MediaTarget({
    required this.parentEntityType,
    required this.uploadEndpoint,
    this.parentLocalId,
    this.parentServerId,
    this.uploadField = 'file',
    this.extraFields = const {},
    this.entityCacheKey,
  });

  final String parentEntityType;
  final int? parentLocalId;
  final int? parentServerId;
  final String uploadEndpoint;
  final String uploadField;
  final Map<String, String> extraFields;
  final String? entityCacheKey;

  bool get hasServerParent => parentServerId != null && parentServerId! > 0;

  @override
  List<Object?> get props => [parentEntityType, parentLocalId, parentServerId, uploadEndpoint];
}

class MediaBlobRecord extends Equatable {
  const MediaBlobRecord({
    required this.id,
    required this.localPath,
    required this.mimeType,
    required this.mediaKind,
    required this.parentEntityType,
    required this.uploadEndpoint,
    required this.uploadField,
    this.originalName,
    this.sizeBytes = 0,
    this.parentLocalId,
    this.parentServerId,
    this.extraFields = const {},
    this.status = 'pending',
    this.nativeTaskId,
    this.retryCount = 0,
    this.errorMessage,
  });

  final int id;
  final String localPath;
  final String mimeType;
  final MediaKind mediaKind;
  final String parentEntityType;
  final int? parentLocalId;
  final int? parentServerId;
  final String uploadEndpoint;
  final String uploadField;
  final Map<String, String> extraFields;
  final String? originalName;
  final int sizeBytes;
  final String status;
  final String? nativeTaskId;
  final int retryCount;
  final String? errorMessage;

  bool get isPending => status == 'pending' || status == 'failed';

  static const int backgroundThresholdBytes = 1024 * 1024;

  bool get useBackgroundUpload => sizeBytes >= backgroundThresholdBytes;

  @override
  List<Object?> get props => [id, localPath, status, parentServerId];

  factory MediaBlobRecord.fromMap(Map<String, dynamic> map) {
    return MediaBlobRecord(
      id: map['id'] as int,
      localPath: map['local_path'] as String,
      mimeType: map['mime_type'] as String,
      mediaKind: MediaKind.fromString(map['media_kind'] as String?) ?? MediaKind.image,
      parentEntityType: map['parent_entity_type'] as String,
      parentLocalId: map['parent_local_id'] as int?,
      parentServerId: map['parent_server_id'] as int?,
      uploadEndpoint: map['upload_endpoint'] as String,
      uploadField: map['upload_field'] as String? ?? 'file',
      extraFields: _parseExtraFields(map['extra_fields']),
      originalName: map['original_name'] as String?,
      sizeBytes: map['size_bytes'] as int? ?? 0,
      status: map['status'] as String? ?? 'pending',
      nativeTaskId: map['native_task_id'] as String?,
      retryCount: map['retry_count'] as int? ?? 0,
      errorMessage: map['error_message'] as String?,
    );
  }
}

class MediaSyncEvent extends Equatable {
  const MediaSyncEvent({
    required this.blobId,
    required this.status,
    this.progress,
    this.errorMessage,
  });

  final int blobId;
  final String status;
  final double? progress;
  final String? errorMessage;

  @override
  List<Object?> get props => [blobId, status, progress];
}
