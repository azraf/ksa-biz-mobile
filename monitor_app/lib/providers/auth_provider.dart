import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories.dart';

const _monitorRole = 'monitor';

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _authRepository;
  late final BiometricAuthSupport _biometricSupport;

  @override
  AuthState build() {
    _authRepository = ref.read(authRepositoryProvider);
    _biometricSupport = BiometricAuthSupport(
      _authRepository,
      ref.read(biometricAuthServiceProvider),
    );
    Future.microtask(_restore);
    return const AuthState(isLoading: true);
  }

  AuthState _stateFromSession(AuthSession session, {bool isLoading = false}) {
    return AuthState(
      isLoading: isLoading,
      isAuthenticated: true,
      biometricEnabled: _authRepository.isBiometricEnabled,
      biometricAvailable: state.biometricAvailable,
      storedUserEmail: session.user.email,
      tokenExpiresAt: session.tokenExpiresAt ?? _authRepository.storedTokenExpiresAt,
      user: session.user,
      roles: session.roles,
      token: session.token,
      apiBaseUrl: session.apiBaseUrl,
    );
  }

  bool _isMonitor(List<String> roles) => roles.contains(_monitorRole);

  Future<bool> _ensureMonitorRole(AuthSession session) async {
    if (_isMonitor(session.roles)) return true;
    await _authRepository.clearSession();
    state = const AuthState(isLoading: false, error: 'Monitor access required');
    return false;
  }

  Future<void> _restore() async {
    try {
      state = await _biometricSupport.buildInitialRestoreState(
        stateFromSession: _stateFromSession,
      );
      if (state.isAuthenticated && state.user != null) {
        final session = await _authRepository.restoreSession();
        if (session != null && !await _ensureMonitorRole(session)) return;
      }
    } catch (_) {
      await _authRepository.clearSession();
      state = const AuthState(isLoading: false);
    }
  }

  Future<void> login({
    required String email,
    required String password,
    String? apiBaseUrl,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final session = await _authRepository.login(
        email: email,
        password: password,
        apiBaseUrl: apiBaseUrl,
      );
      if (!await _ensureMonitorRole(session)) return;
      state = _stateFromSession(session).copyWith(
        biometricAvailable: await ref.read(biometricAuthServiceProvider).canCheckBiometrics(),
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<BiometricEnableResult> enableBiometricLogin(String reason) async {
    final result = await _authRepository.enableBiometric(reason: reason);
    if (result == BiometricEnableResult.success) {
      state = state.copyWith(biometricEnabled: true);
    }
    return result;
  }

  Future<void> refreshBiometricAvailability() async {
    final available = await ref.read(biometricAuthServiceProvider).canCheckBiometrics();
    state = state.copyWith(biometricAvailable: available);
  }

  Future<void> disableBiometricLogin() async {
    await _authRepository.disableBiometric();
    state = state.copyWith(biometricEnabled: false, isAppLocked: false);
  }

  Future<bool> unlockWithBiometric(String reason, {required String sessionExpiredMessage}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final next = await _biometricSupport.unlock(
      reason: reason,
      stateFromSession: _stateFromSession,
      sessionExpiredMessage: sessionExpiredMessage,
    );
    if (next == null) {
      state = state.copyWith(isLoading: false);
      return false;
    }
    if (next.isAuthenticated && next.roles.isNotEmpty && !_isMonitor(next.roles)) {
      await _authRepository.clearSession();
      state = const AuthState(isLoading: false, error: 'Monitor access required');
      return false;
    }
    state = next;
    return state.isAuthenticated;
  }

  void lockApp() {
    _authRepository.appLock.lock();
    state = state.copyWith(isAppLocked: true);
  }

  Future<bool> unlockApp(String reason, {required String sessionExpiredMessage}) async {
    final ok = await unlockWithBiometric(reason, sessionExpiredMessage: sessionExpiredMessage);
    if (ok) state = state.copyWith(isAppLocked: false);
    return ok;
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState(isLoading: false);
  }

  Future<void> handleUnauthorized() async {
    await _authRepository.clearSession();
    state = const AuthState(isLoading: false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

String formatOrderId(int id) => '$id';
