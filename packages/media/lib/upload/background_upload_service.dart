import 'dart:async';

import 'package:flutter_uploader/flutter_uploader.dart';

class UploadProgress {
  const UploadProgress({
    required this.taskId,
    required this.progress,
    required this.status,
  });

  final String taskId;
  final double progress;
  final UploadTaskStatus status;
}

class BackgroundUploadService {
  BackgroundUploadService() {
    _uploader.progress.listen((event) {
      _progressController.add(UploadProgress(
        taskId: event.taskId,
        progress: (event.progress ?? 0).toDouble(),
        status: event.status,
      ));
    });
    _uploader.result.listen((event) {
      _resultController.add(event);
    });
  }

  final FlutterUploader _uploader = FlutterUploader();
  final _progressController = StreamController<UploadProgress>.broadcast();
  final _resultController = StreamController<UploadTaskResponse>.broadcast();

  Stream<UploadProgress> get onProgress => _progressController.stream;
  Stream<UploadTaskResponse> get onResult => _resultController.stream;

  Future<String> enqueueUpload({
    required String filePath,
    required String uploadUrl,
    required String fieldName,
    required String authToken,
    Map<String, String>? fields,
  }) async {
    return _uploader.enqueue(
      MultipartFormDataUpload(
        url: uploadUrl,
        files: [FileItem(path: filePath, field: fieldName)],
        method: UploadMethod.POST,
        headers: {'Authorization': 'Bearer $authToken', 'Accept': 'application/json'},
        data: fields ?? {},
        tag: filePath,
      ),
    );
  }

  Future<void> cancel(String taskId) => _uploader.cancel(taskId: taskId);

  void dispose() {
    _progressController.close();
    _resultController.close();
  }
}
