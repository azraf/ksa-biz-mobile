import 'dart:async';
import 'dart:io';

import '../api/api_client.dart';
import '../models/local_media_attachment.dart';
import '../models/media_kind.dart';
import '../models/media_target.dart';
import '../offline/local_database.dart';

/// Compressed file metadata passed from the media package.
class MediaFileInput {
  const MediaFileInput({
    required this.localPath,
    required this.mimeType,
    required this.kind,
    required this.compressedBytes,
    this.originalName,
  });

  final String localPath;
  final String mimeType;
  final MediaKind kind;
  final int compressedBytes;
  final String? originalName;
}

class MediaUploadRepository {
  MediaUploadRepository({
    required ApiClient apiClient,
    required LocalDatabase db,
    this.getAuthToken,
  })  : _api = apiClient,
        _db = db;

  final ApiClient _api;
  final LocalDatabase _db;
  final Future<String?> Function()? getAuthToken;

  final _statusController = StreamController<MediaSyncEvent>.broadcast();
  Stream<MediaSyncEvent> get statusStream => _statusController.stream;

  Future<int> pendingCount() => _db.pendingMediaCount();

  Future<void> attachMedia({
    required MediaFileInput file,
    required MediaTarget target,
  }) async {
    final blobId = await _db.insertMediaBlob(
      localPath: file.localPath,
      mimeType: file.mimeType,
      mediaKind: file.kind.value,
      parentEntityType: target.parentEntityType,
      parentLocalId: target.parentLocalId,
      parentServerId: target.parentServerId,
      uploadEndpoint: target.uploadEndpoint,
      uploadField: target.uploadField,
      originalName: file.originalName,
      sizeBytes: file.compressedBytes,
      extraFields: target.extraFields,
    );

    if (target.entityCacheKey != null && target.parentLocalId != null) {
      final cached = await _db.getCachedEntity(target.entityCacheKey!, target.parentLocalId!);
      if (cached != null) {
        final localMedia = parseLocalMediaList(cached['local_media']);
        localMedia.add(LocalMediaAttachment(
          blobId: blobId,
          path: file.localPath,
          kind: file.kind,
          mime: file.mimeType,
          originalName: file.originalName,
        ));
        await _db.patchCachedEntityData(target.entityCacheKey!, target.parentLocalId!, {
          'local_media': localMediaToJsonList(localMedia),
          '_pending_sync': true,
        });
      }
    }

    _statusController.add(MediaSyncEvent(blobId: blobId, status: 'pending'));

    if (target.hasServerParent) {
      await uploadBlobById(blobId);
    }
  }

  Future<void> uploadPendingBlobs() async {
    final blobs = await _db.pendingMediaBlobs();
    for (final blob in blobs) {
      if (blob.parentServerId == null || blob.parentServerId! <= 0) continue;
      await uploadBlob(blob);
    }
  }

  Future<void> uploadBlobById(int blobId) async {
    final blobs = await _db.pendingMediaBlobs();
    for (final blob in blobs) {
      if (blob.id == blobId) {
        await uploadBlob(blob);
        return;
      }
    }
  }

  Future<void> uploadBlob(MediaBlobRecord blob) async {
    if (blob.parentServerId == null || blob.parentServerId! <= 0) return;

    final file = File(blob.localPath);
    if (!await file.exists()) {
      await _db.updateMediaBlobStatus(blob.id, status: 'failed', errorMessage: 'File missing');
      return;
    }

    await _db.updateMediaBlobStatus(blob.id, status: 'uploading');
    _statusController.add(MediaSyncEvent(blobId: blob.id, status: 'uploading'));

    try {
      final bytes = await file.readAsBytes();
      final filename = blob.originalName ?? file.uri.pathSegments.last;
      final endpoint = _resolvedEndpoint(blob);
      final field = _resolvedUploadField(blob);
      await _api.uploadMultipart(
        endpoint,
        fileField: field,
        bytes: bytes,
        filename: filename,
        fields: blob.extraFields.isEmpty ? null : blob.extraFields,
      );

      await _db.updateMediaBlobStatus(blob.id, status: 'done');
      _statusController.add(MediaSyncEvent(blobId: blob.id, status: 'done'));

      await _markEntityMediaDone(blob);
      await file.delete();
      await _db.deleteMediaBlob(blob.id);
    } catch (e) {
      await _db.updateMediaBlobStatus(
        blob.id,
        status: 'failed',
        errorMessage: e.toString(),
        retryCount: blob.retryCount + 1,
      );
      _statusController.add(MediaSyncEvent(blobId: blob.id, status: 'failed', errorMessage: e.toString()));
    }
  }

  Future<void> _markEntityMediaDone(MediaBlobRecord blob) async {
    if (blob.parentLocalId == null) return;
    final entityType = blob.parentEntityType;
    final cached = await _db.getCachedEntity(entityType, blob.parentLocalId!);
    if (cached == null) return;

    final localMedia = parseLocalMediaList(cached['local_media'])
        .map((m) => m.blobId == blob.id ? m.copyWith(uploadStatus: MediaUploadStatus.done) : m)
        .toList();
    await _db.patchCachedEntityData(entityType, blob.parentLocalId!, {
      'local_media': localMediaToJsonList(localMedia),
    });
  }

  Future<void> retryFailed() async {
    final blobs = await _db.pendingMediaBlobs();
    for (final blob in blobs.where((b) => b.status == 'failed')) {
      await uploadBlob(blob);
    }
  }

  void dispose() => _statusController.close();

  String _resolvedEndpoint(MediaBlobRecord blob) {
    if (blob.uploadEndpoint.contains('{parent_id}')) {
      return blob.uploadEndpoint.replaceAll('{parent_id}', '${blob.parentServerId}');
    }
    final id = blob.parentServerId;
    if (id == null) return blob.uploadEndpoint;
    return switch (blob.parentEntityType) {
      'watchlist' => '/watchlist-items/$id/attachments',
      'diary' => '/customer-diary-notes/$id/recording',
      'manual_order' => '/manual-order-requests/$id/recordings',
      'shop' => '/customer-shops/$id/images',
      'van' => '/customer-vans/$id/images',
      _ => blob.uploadEndpoint,
    };
  }

  String _resolvedUploadField(MediaBlobRecord blob) {
    if (blob.parentEntityType == 'shop' || blob.parentEntityType == 'van') {
      return 'attachment';
    }
    return blob.uploadField;
  }
}
