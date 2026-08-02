import 'package:core/auth/app_lock_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLockService', () {
    test('markUnlocked clears lock state', () {
      final service = AppLockService();
      service.lock();
      expect(service.isLocked, isTrue);

      service.markUnlocked();
      expect(service.isLocked, isFalse);
    });
  });
}
