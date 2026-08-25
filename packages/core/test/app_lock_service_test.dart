import 'package:core/auth/app_lock_service.dart';
import 'package:core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLockService', () {
    final t0 = DateTime(2026, 1, 1, 12);
    const timeout = AppConfig.appLockTimeout;

    test('markUnlocked clears lock state', () {
      final service = AppLockService();
      service.lock();
      expect(service.isLocked, isTrue);

      service.markUnlocked();
      expect(service.isLocked, isFalse);
    });

    test('momentary pause does not lock, regardless of time since unlock', () {
      final service = AppLockService();
      service.markUnlocked();

      // Timeout counts from when the app went to the background — a short
      // pause long after the last unlock must not lock mid-task.
      service.onAppPaused(now: t0);
      service.onAppResumed(
        biometricEnabled: true,
        hasSession: true,
        now: t0.add(const Duration(seconds: 2)),
      );

      expect(service.isLocked, isFalse);
    });

    test('background for at least the timeout locks on resume', () {
      final service = AppLockService();
      service.markUnlocked();

      service.onAppPaused(now: t0);
      service.onAppResumed(
        biometricEnabled: true,
        hasSession: true,
        now: t0.add(timeout),
      );

      expect(service.isLocked, isTrue);
    });

    test('resume resets the pause stamp', () {
      final service = AppLockService();
      service.markUnlocked();

      service.onAppPaused(now: t0);
      service.onAppResumed(
        biometricEnabled: true,
        hasSession: true,
        now: t0.add(const Duration(seconds: 2)),
      );

      // Long after the first (short) pause: without a new pause there is no
      // background interval to judge.
      expect(
        service.requiresUnlock(now: t0.add(timeout * 2)),
        isFalse,
      );
    });

    test('repeated pause events keep the earliest stamp', () {
      final service = AppLockService();
      service.markUnlocked();

      service.onAppPaused(now: t0);
      service.onAppPaused(now: t0.add(timeout - const Duration(minutes: 1)));
      service.onAppResumed(
        biometricEnabled: true,
        hasSession: true,
        now: t0.add(timeout),
      );

      expect(service.isLocked, isTrue);
    });

    test('requiresUnlock without a pause stamp is false', () {
      final service = AppLockService();
      service.markUnlocked();

      expect(service.requiresUnlock(now: t0.add(timeout * 2)), isFalse);
    });

    test('requiresUnlock is true while explicitly locked', () {
      final service = AppLockService();
      service.lock();

      expect(service.requiresUnlock(now: t0), isTrue);
    });

    test('resume without biometric or session clears the lock', () {
      final service = AppLockService();
      service.onAppPaused(now: t0);
      service.lock();

      service.onAppResumed(
        biometricEnabled: false,
        hasSession: true,
        now: t0.add(timeout),
      );

      expect(service.isLocked, isFalse);
      expect(service.requiresUnlock(now: t0.add(timeout * 2)), isFalse);
    });
  });
}
