import 'package:equatable/equatable.dart';

class MediaModel extends Equatable {
  const MediaModel({
    required this.id,
    required this.type,
    this.caption,
    this.originalName,
    this.mimeType,
    this.url,
  });

  final int id;
  final String type;
  final String? caption;
  final String? originalName;
  final String? mimeType;
  final String? url;

  bool get isAudio => type == 'recording_audio';
  bool get isVideo => type == 'recording_video';

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'] as int,
      type: json['type'] as String? ?? '',
      caption: json['caption'] as String?,
      originalName: json['original_name'] as String?,
      mimeType: json['mime_type'] as String?,
      url: json['url'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, type, url];
}
