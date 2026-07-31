import 'package:equatable/equatable.dart';

import 'media_kind.dart';

enum MediaUploadStatus {
  pending,
  uploading,
  done,
  failed;

  static MediaUploadStatus fromString(String? value) {
    return MediaUploadStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => MediaUploadStatus.pending,
    );
  }
}

class LocalMediaAttachment extends Equatable {
  const LocalMediaAttachment({
    required this.blobId,
    required this.path,
    required this.kind,
    required this.mime,
    this.uploadStatus = MediaUploadStatus.pending,
    this.originalName,
  });

  final int blobId;
  final String path;
  final MediaKind kind;
  final String mime;
  final MediaUploadStatus uploadStatus;
  final String? originalName;

  bool get isPending => uploadStatus != MediaUploadStatus.done;

  factory LocalMediaAttachment.fromJson(Map<String, dynamic> json) {
    return LocalMediaAttachment(
      blobId: json['blob_id'] as int? ?? 0,
      path: json['path'] as String? ?? '',
      kind: MediaKind.fromString(json['kind'] as String?) ?? MediaKind.image,
      mime: json['mime'] as String? ?? 'application/octet-stream',
      uploadStatus: MediaUploadStatus.fromString(json['upload_status'] as String?),
      originalName: json['original_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'blob_id': blobId,
        'path': path,
        'kind': kind.value,
        'mime': mime,
        'upload_status': uploadStatus.name,
        if (originalName != null) 'original_name': originalName,
      };

  LocalMediaAttachment copyWith({MediaUploadStatus? uploadStatus}) {
    return LocalMediaAttachment(
      blobId: blobId,
      path: path,
      kind: kind,
      mime: mime,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      originalName: originalName,
    );
  }

  @override
  List<Object?> get props => [blobId, path, kind, uploadStatus];
}

List<LocalMediaAttachment> parseLocalMediaList(dynamic json) {
  if (json is! List) return const [];
  return json
      .map((e) => LocalMediaAttachment.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();
}

List<Map<String, dynamic>> localMediaToJsonList(List<LocalMediaAttachment> items) {
  return items.map((e) => e.toJson()).toList();
}
