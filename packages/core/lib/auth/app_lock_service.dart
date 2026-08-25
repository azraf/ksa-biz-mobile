import '../config/app_config.dart';

class AppLockService {
  /// When the app last went to the background. The lock timeout counts from
  /// here — not from the last unlock — so a momentary pause (notification
  /// shade, app switcher, phone call) never locks the app mid-task.
  DateTime? _pausedAt;
  bool _isLocked = false;

  bool get isLocked => _isLocked;

  void markUnlocked() {
    _pausedAt = null;
    _isLocked = false;
  }

  void lock() {
    _isLocked = true;
  }

  void onAppPaused({DateTime? now}) {
    // Keep the earliest stamp if pause fires more than once before a resume.
    _pausedAt ??= now ?? DateTime.now();
  }

  bool requiresUnlock({DateTime? now}) {
    if (_isLocked) return true;
    final paused = _pausedAt;
    if (paused == null) return false;
    final current = now ?? DateTime.now();
    return current.difference(paused) >= AppConfig.appLockTimeout;
  }

  void onAppResumed({
    required bool biometricEnabled,
    required bool hasSession,
    DateTime? now,
  }) {
    if (!biometricEnabled || !hasSession) {
      markUnlocked();
      return;
    }
    if (requiresUnlock(now: now)) {
      _isLocked = true;
    }
    // The background interval has been judged; a future momentary pause
    // starts its own clock.
    _pausedAt = null;
  }
}
