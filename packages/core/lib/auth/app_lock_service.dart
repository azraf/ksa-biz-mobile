import '../config/app_config.dart';

class AppLockService {
  DateTime? _lastUnlockedAt;
  bool _isLocked = false;

  bool get isLocked => _isLocked;

  void markUnlocked() {
    _lastUnlockedAt = DateTime.now();
    _isLocked = false;
  }

  void lock() {
    _isLocked = true;
  }

  bool requiresUnlock({DateTime? now}) {
    if (_isLocked) return true;
    final last = _lastUnlockedAt;
    if (last == null) return false;
    final current = now ?? DateTime.now();
    return current.difference(last) >= AppConfig.appLockTimeout;
  }

  void onAppPaused() {
    // Lock is evaluated on resume via requiresUnlock().
  }

  void onAppResumed({required bool biometricEnabled, required bool hasSession}) {
    if (!biometricEnabled || !hasSession) {
      markUnlocked();
      return;
    }
    if (requiresUnlock()) {
      _isLocked = true;
    }
  }
}
