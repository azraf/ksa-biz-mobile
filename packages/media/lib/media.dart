library media;

export 'media_capture_facade.dart';
export 'compression/media_compression_service.dart';
export 'models/compressed_media.dart';
// customer_diary_section.dart is deliberately NOT exported here: the apps'
// thin wrappers reuse the same class name, so they deep-import it instead.
export 'widgets/media_audio_player.dart';
export 'widgets/media_gallery_section.dart';
export 'widgets/media_image_tile.dart';
export 'widgets/media_video_player.dart';
