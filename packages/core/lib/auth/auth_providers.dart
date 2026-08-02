import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import 'app_lock_service.dart';
import 'auth_repository.dart';
import 'biometric_auth_service.dart';
import 'secure_session_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

final secureSessionStoreProvider = Provider<SecureSessionStore>((ref) {
  return SecureSessionStore();
});

final biometricAuthServiceProvider = Provider<BiometricAuthService>((ref) {
  return BiometricAuthService();
});

final appLockServiceProvider = Provider<AppLockService>((ref) {
  return AppLockService();
});

AuthRepository createAuthRepository({
  required ApiClient api,
  required SharedPreferences prefs,
  required Ref ref,
}) {
  return AuthRepository(
    api,
    prefs,
    secureStore: ref.watch(secureSessionStoreProvider),
    biometricAuth: ref.watch(biometricAuthServiceProvider),
    appLock: ref.watch(appLockServiceProvider),
  );
}
