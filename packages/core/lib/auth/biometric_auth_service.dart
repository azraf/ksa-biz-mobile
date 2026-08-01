import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'biometric_enable_result.dart';

class BiometricAuthService {
  BiometricAuthService({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  Future<bool> isDeviceSupported() => _localAuth.isDeviceSupported();

  Future<bool> canCheckBiometrics() async {
    try {
      if (await _localAuth.canCheckBiometrics) return true;
      final enrolled = await _localAuth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (_) {
      return const [];
    }
  }

  Future<bool> authenticate({required String reason}) async {
    final result = await authenticateWithResult(reason: reason);
    return result == BiometricAuthResult.success;
  }

  Future<BiometricAuthResult> authenticateWithResult({required String reason}) async {
    try {
      final ok = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      return ok ? BiometricAuthResult.success : BiometricAuthResult.cancelled;
    } on PlatformException catch (e) {
      return _mapPlatformException(e);
    } catch (_) {
      return BiometricAuthResult.failed;
    }
  }

  BiometricAuthResult _mapPlatformException(PlatformException e) {
    switch (e.code) {
      case 'NotAvailable':
      case 'notAvailable':
      case 'no_fragment_activity':
        return BiometricAuthResult.unavailable;
      case 'NotEnrolled':
      case 'notEnrolled':
      case 'PasscodeNotSet':
      case 'passcodeNotSet':
        return BiometricAuthResult.notEnrolled;
      case 'LockedOut':
      case 'PermanentlyLockedOut':
      case 'lockedOut':
      case 'permanentlyLockedOut':
        return BiometricAuthResult.failed;
      case 'UserCancel':
      case 'auth_in_progress':
      case 'systemCancel':
        return BiometricAuthResult.cancelled;
      default:
        return BiometricAuthResult.failed;
    }
  }
}
