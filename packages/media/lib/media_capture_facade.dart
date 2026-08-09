import 'dart:io';

import 'package:core/core.dart';
import 'package:media/media.dart';

/// Facade combining compression (media package) and upload queue (core).
class MediaCaptureFacade {
  MediaCaptureFacade({
    MediaCompressionService? compression,
    required MediaUploadRepository uploadRepository,
  }) : _compression = compression ?? MediaCompressionService(),
       _upload = uploadRepository;

  final MediaCompressionService _compression;
  final MediaUploadRepository _upload;

  Future<void> attachShopPhoto(File input, int shopId) async {
    final compressed = await _compression.compressImage(input, entityType: 'shop', localId: shopId);
    await _upload.attachMedia(
      file: MediaFileInput(
        localPath: compressed.localPath,
        mimeType: compressed.mimeType,
        kind: compressed.kind,
        compressedBytes: compressed.compressedBytes,
        originalName: compressed.originalName ?? 'shop.webp',
      ),
      target: MediaTarget(
        parentEntityType: 'shop',
        parentServerId: shopId,
        uploadEndpoint: '/customer-shops/$shopId/images',
        uploadField: 'attachment',
      ),
    );
  }

  Future<void> attachVanPhoto(File input, int vanId) async {
    final compressed = await _compression.compressImage(input, entityType: 'van', localId: vanId);
    await _upload.attachMedia(
      file: MediaFileInput(
        localPath: compressed.localPath,
        mimeType: compressed.mimeType,
        kind: compressed.kind,
        compressedBytes: compressed.compressedBytes,
        originalName: compressed.originalName ?? 'van.webp',
      ),
      target: MediaTarget(
        parentEntityType: 'van',
        parentServerId: vanId,
        uploadEndpoint: '/customer-vans/$vanId/images',
        uploadField: 'attachment',
      ),
    );
  }

  Future<MediaFileInput> compressManualOrderRecording(File input, String kind) async {
    if (kind == 'recording_video') {
      final c = await _compression.compressVideo(input, entityType: 'manual_order');
      return MediaFileInput(
        localPath: c.localPath,
        mimeType: c.mimeType,
        kind: c.kind,
        compressedBytes: c.compressedBytes,
        originalName: c.originalName,
      );
    }
    final c = await _compression.finalizeAudio(input.path, entityType: 'manual_order');
    return MediaFileInput(
      localPath: c.localPath,
      mimeType: c.mimeType,
      kind: c.kind,
      compressedBytes: c.compressedBytes,
      originalName: c.originalName,
    );
  }

  Future<void> attachManualOrderPhoto(File input, int requestId, {int? localId}) async {
    final compressed = await _compression.compressImage(
      input,
      entityType: 'manual_order',
      localId: localId ?? requestId,
    );
    await _upload.attachMedia(
      file: MediaFileInput(
        localPath: compressed.localPath,
        mimeType: compressed.mimeType,
        kind: compressed.kind,
        compressedBytes: compressed.compressedBytes,
        originalName: compressed.originalName,
      ),
      target: MediaTarget(
        parentEntityType: 'manual_order',
        parentLocalId: localId,
        parentServerId: requestId > 0 ? requestId : null,
        uploadEndpoint: '/manual-order-requests/{parent_id}/attachments',
      ),
    );
  }

  Future<void> attachManualOrderMedia(
    File input,
    int requestId, {
    int? localId,
    bool isVideo = false,
    int? durationSeconds,
  }) async {
    final CompressedMedia compressed = isVideo
        ? await _compression.compressVideo(input, entityType: 'manual_order', localId: localId ?? requestId)
        : await _compression.finalizeAudio(input.path, entityType: 'manual_order', localId: localId ?? requestId);

    await _upload.attachMedia(
      file: MediaFileInput(
        localPath: compressed.localPath,
        mimeType: compressed.mimeType,
        kind: compressed.kind,
        compressedBytes: compressed.compressedBytes,
        originalName: compressed.originalName,
      ),
      target: MediaTarget(
        parentEntityType: 'manual_order',
        parentLocalId: localId,
        parentServerId: requestId > 0 ? requestId : null,
        uploadEndpoint: '/manual-order-requests/{parent_id}/attachments',
        extraFields: {
          if (durationSeconds != null) 'duration_seconds': '$durationSeconds',
        },
      ),
    );
  }

  Future<void> attachWatchlistGallery(File input, int itemId, {int? localId}) async {
    final compressed = await _compression.compressImage(input, entityType: 'watchlist', localId: localId ?? itemId);
    await _upload.attachMedia(
      file: MediaFileInput(
        localPath: compressed.localPath,
        mimeType: compressed.mimeType,
        kind: compressed.kind,
        compressedBytes: compressed.compressedBytes,
        originalName: compressed.originalName,
      ),
      target: MediaTarget(
        parentEntityType: 'watchlist',
        parentLocalId: localId,
        parentServerId: itemId > 0 ? itemId : null,
        uploadEndpoint: '/watchlist-items/{parent_id}/attachments',
        extraFields: {'type': 'gallery'},
        entityCacheKey: localId != null ? 'watchlist' : null,
      ),
    );
  }

  Future<void> attachDiaryPhoto(File input, int noteId, {int? localId}) async {
    final compressed = await _compression.compressImage(input, entityType: 'diary', localId: localId ?? noteId);
    await _upload.attachMedia(
      file: MediaFileInput(
        localPath: compressed.localPath,
        mimeType: compressed.mimeType,
        kind: compressed.kind,
        compressedBytes: compressed.compressedBytes,
        originalName: compressed.originalName,
      ),
      target: MediaTarget(
        parentEntityType: 'diary',
        parentLocalId: localId,
        parentServerId: noteId > 0 ? noteId : null,
        uploadEndpoint: '/customer-diary-notes/{parent_id}/attachments',
      ),
    );
  }

  /// Voice goes to the back-compatible /recording endpoint; video to the
  /// attachments endpoint (which pins the mime family to the note type).
  Future<void> attachDiaryRecording(
    File input,
    int noteId, {
    int? localId,
    bool isVideo = false,
    int? durationSeconds,
  }) async {
    final CompressedMedia compressed = isVideo
        ? await _compression.compressVideo(input, entityType: 'diary', localId: localId ?? noteId)
        : await _compression.finalizeAudio(input.path, entityType: 'diary', localId: localId ?? noteId);

    await _upload.attachMedia(
      file: MediaFileInput(
        localPath: compressed.localPath,
        mimeType: compressed.mimeType,
        kind: compressed.kind,
        compressedBytes: compressed.compressedBytes,
        originalName: compressed.originalName,
      ),
      target: MediaTarget(
        parentEntityType: 'diary',
        parentLocalId: localId,
        parentServerId: noteId > 0 ? noteId : null,
        uploadEndpoint: isVideo
            ? '/customer-diary-notes/{parent_id}/attachments'
            : '/customer-diary-notes/{parent_id}/recording',
        extraFields: {
          if (durationSeconds != null) 'duration_seconds': '$durationSeconds',
        },
      ),
    );
  }

  Future<void> attachWatchlistAudio(File input, int itemId, {int? localId, int? durationSeconds}) async {
    final compressed = await _compression.finalizeAudio(input.path, entityType: 'watchlist', localId: localId ?? itemId);
    await _upload.attachMedia(
      file: MediaFileInput(
        localPath: compressed.localPath,
        mimeType: compressed.mimeType,
        kind: compressed.kind,
        compressedBytes: compressed.compressedBytes,
        originalName: compressed.originalName,
      ),
      target: MediaTarget(
        parentEntityType: 'watchlist',
        parentLocalId: localId,
        parentServerId: itemId > 0 ? itemId : null,
        uploadEndpoint: '/watchlist-items/{parent_id}/attachments',
        extraFields: {
          'type': 'recording_audio',
          if (durationSeconds != null) 'duration_seconds': '$durationSeconds',
        },
        entityCacheKey: localId != null ? 'watchlist' : null,
      ),
    );
  }
}
