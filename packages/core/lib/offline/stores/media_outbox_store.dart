import 'dart:async';
import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../models/media_kind.dart';
import '../../models/media_target.dart';
import '../isar/enums.dart';
import '../isar/local_media_blob.dart';
import '../isar_service.dart';

class MediaOutboxStore {
  MediaOutboxStore(this._isar);

  final IsarService _isar;

  Isar get _db => _isar.isar;

  Future<int> insert({
    required String localPath,
    required String mimeType,
    required String mediaKind,
    required String parentEntityType,
    required String uploadEndpoint,
    String uploadField = 'file',
    String? originalName,
    int sizeBytes = 0,
    int? parentLocalId,
    int? parentServerId,
    Map<String, String> extraFields = const {},
  }) async {
    final blob = LocalMediaBlob()
      ..localPath = localPath
      ..mimeType = mimeType
      ..mediaKind = mediaKind
      ..parentEntityType = parentEntityType
      ..parentLocalId = parentLocalId
      ..parentServerId = parentServerId
      ..uploadEndpoint = uploadEndpoint
      ..uploadField = uploadField
      ..originalName = originalName
      ..sizeBytes = sizeBytes
      ..extraFieldsJson = jsonEncode(extraFields)
      ..status = MediaUploadStatus.pending
      ..createdAt = DateTime.now();
    return _isar.writeTxn(() => _db.localMediaBlobs.put(blob));
  }

  Future<List<MediaBlobRecord>> pendingBlobs() async {
    final rows = await _db.localMediaBlobs
        .filter()
        .group(
          (q) => q.statusEqualTo(MediaUploadStatus.pending).or().statusEqualTo(MediaUploadStatus.failed),
        )
        .sortByCreatedAt()
        .findAll();
    return rows.map(_toRecord).toList();
  }

  Future<int> pendingCount() async {
    return _db.localMediaBlobs
        .filter()
        .group(
          (q) => q
              .statusEqualTo(MediaUploadStatus.pending)
              .or()
              .statusEqualTo(MediaUploadStatus.failed)
              .or()
              .statusEqualTo(MediaUploadStatus.uploading),
        )
        .count();
  }

  Stream<int> watchPendingCount() async* {
    yield await pendingCount();
    await for (final _ in _db.localMediaBlobs.watchLazy(fireImmediately: true)) {
      yield await pendingCount();
    }
  }

  Future<int> failedCount() async {
    return _db.localMediaBlobs.filter().statusEqualTo(MediaUploadStatus.failed).count();
  }

  Stream<int> watchFailedCount() async* {
    yield await failedCount();
    await for (final _ in _db.localMediaBlobs.watchLazy(fireImmediately: true)) {
      yield await failedCount();
    }
  }

  Future<void> updateStatus(
    int id, {
    required String status,
    String? nativeTaskId,
    String? errorMessage,
    int? retryCount,
    int? parentServerId,
  }) async {
    await _isar.writeTxn(() async {
      final blob = await _db.localMediaBlobs.get(id);
      if (blob == null) return;
      blob.status = MediaUploadStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => MediaUploadStatus.pending,
      );
      if (nativeTaskId != null) blob.nativeTaskId = nativeTaskId;
      if (errorMessage != null) blob.errorMessage = errorMessage;
      if (retryCount != null) blob.retryCount = retryCount;
      if (parentServerId != null) blob.parentServerId = parentServerId;
      await _db.localMediaBlobs.put(blob);
    });
  }

  Future<void> resolveParents({
    required String parentEntityType,
    required int parentLocalId,
    required int parentServerId,
  }) async {
    await _isar.writeTxn(() async {
      final rows = await _db.localMediaBlobs
          .filter()
          .parentEntityTypeEqualTo(parentEntityType)
          .parentLocalIdEqualTo(parentLocalId)
          .parentServerIdIsNull()
          .findAll();
      for (final row in rows) {
        row.parentServerId = parentServerId;
        await _db.localMediaBlobs.put(row);
      }
    });
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _db.localMediaBlobs.delete(id);
    });
  }

  MediaBlobRecord _toRecord(LocalMediaBlob blob) {
    return MediaBlobRecord(
      id: blob.id,
      localPath: blob.localPath,
      mimeType: blob.mimeType,
      mediaKind: MediaKind.fromString(blob.mediaKind) ?? MediaKind.image,
      parentEntityType: blob.parentEntityType,
      parentLocalId: blob.parentLocalId,
      parentServerId: blob.parentServerId,
      uploadEndpoint: blob.uploadEndpoint,
      uploadField: blob.uploadField,
      extraFields: Map<String, String>.from(
        jsonDecode(blob.extraFieldsJson) as Map<String, dynamic>? ?? {},
      ).map((k, v) => MapEntry(k, v.toString())),
      originalName: blob.originalName,
      sizeBytes: blob.sizeBytes,
      status: blob.status.name,
      nativeTaskId: blob.nativeTaskId,
      retryCount: blob.retryCount,
      errorMessage: blob.errorMessage,
    );
  }
}
