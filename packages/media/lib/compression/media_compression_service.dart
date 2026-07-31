import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

import 'package:core/core.dart';

import '../models/compressed_media.dart';

class MediaCompressionService {
  static const int imageQuality = 82;
  static const int maxImageEdge = 2048;
  static const int maxFileBytes = 25 * 1024 * 1024;

  Future<CompressedMedia> compressImage(File input, {String? entityType, int? localId}) async {
    final originalBytes = await input.length();
    final targetDir = await _mediaDir(entityType: entityType, localId: localId);
    final outputPath = p.join(targetDir, '${const Uuid().v4()}.webp');

    final result = await FlutterImageCompress.compressAndGetFile(
      input.absolute.path,
      outputPath,
      quality: imageQuality,
      minWidth: maxImageEdge,
      minHeight: maxImageEdge,
      format: CompressFormat.webp,
      keepExif: false,
    );

    if (result == null) {
      throw StateError('Image compression failed.');
    }

    final compressedBytes = await File(result.path).length();
    _ensureUnderLimit(compressedBytes);

    return CompressedMedia(
      localPath: result.path,
      mimeType: 'image/webp',
      kind: MediaKind.image,
      originalBytes: originalBytes,
      compressedBytes: compressedBytes,
      originalName: p.basename(input.path),
    );
  }

  Future<CompressedMedia> compressVideo(File input, {String? entityType, int? localId}) async {
    final originalBytes = await input.length();
    await VideoCompress.setLogLevel(0);

    final info = await VideoCompress.compressVideo(
      input.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );

    if (info == null || info.file == null) {
      throw StateError('Video compression failed.');
    }

    final compressedFile = info.file!;
    final targetDir = await _mediaDir(entityType: entityType, localId: localId);
    final outputPath = p.join(targetDir, '${const Uuid().v4()}.mp4');
    await compressedFile.copy(outputPath);

    final compressedBytes = await File(outputPath).length();
    _ensureUnderLimit(compressedBytes);

    return CompressedMedia(
      localPath: outputPath,
      mimeType: 'video/mp4',
      kind: MediaKind.video,
      originalBytes: originalBytes,
      compressedBytes: compressedBytes,
      originalName: p.basename(input.path),
    );
  }

  Future<CompressedMedia> finalizeAudio(
    String tempPath, {
    String? entityType,
    int? localId,
  }) async {
    final input = File(tempPath);
    final originalBytes = await input.length();
    final targetDir = await _mediaDir(entityType: entityType, localId: localId);
    final outputPath = p.join(targetDir, '${const Uuid().v4()}.m4a');
    await input.copy(outputPath);

    final compressedBytes = await File(outputPath).length();
    _ensureUnderLimit(compressedBytes);

    return CompressedMedia(
      localPath: outputPath,
      mimeType: 'audio/mp4',
      kind: MediaKind.audio,
      originalBytes: originalBytes,
      compressedBytes: compressedBytes,
      originalName: p.basename(tempPath),
    );
  }

  Future<String> _mediaDir({String? entityType, int? localId}) async {
    final docs = await getApplicationDocumentsDirectory();
    final parts = ['media'];
    if (entityType != null) parts.add(entityType);
    if (localId != null) parts.add(localId.toString());
    final dir = Directory(p.joinAll([docs.path, ...parts]));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  void _ensureUnderLimit(int bytes) {
    if (bytes > maxFileBytes) {
      throw StateError('Compressed file exceeds 25 MB limit.');
    }
  }
}
