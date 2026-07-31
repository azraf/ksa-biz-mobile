import 'package:workmanager/workmanager.dart';

const mediaUploadTaskName = 'ksaMediaUploadCheck';

/// Registers periodic background check for pending media uploads (Android-first).
Future<void> registerMediaUploadWorker() async {
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    'ksa-media-upload',
    mediaUploadTaskName,
    frequency: const Duration(minutes: 30),
    constraints: Constraints(networkType: NetworkType.connected),
  );
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Native upload queue is triggered from app resume via SyncService.
    return Future.value(true);
  });
}
