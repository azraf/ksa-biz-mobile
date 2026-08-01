/// Called after outbox enqueue; [SyncService] registers the handler at startup.
class OfflineSyncTrigger {
  static Future<void> Function()? onEnqueue;

  static void requestSync() {
    final handler = onEnqueue;
    if (handler != null) {
      handler();
    }
  }
}
