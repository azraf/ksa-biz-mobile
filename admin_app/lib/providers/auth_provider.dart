import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories.dart';

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
      storedUserEmail: session.user.loginIdentifier,
      tokenExpiresAt: session.tokenExpiresAt ?? _authRepository.storedTokenExpiresAt,
      user: session.user,
      roles: session.roles,
      token: session.token,
      apiBaseUrl: session.apiBaseUrl,
    );
  }

  Future<bool> _ensureAdminRole(AuthSession session) async {
    if (session.roles.contains('admin')) return true;
    await _authRepository.clearSession();
    state = const AuthState(isLoading: false, error: 'Admin access required');
    return false;
  }

  Future<void> _restore() async {
    try {
      state = await _biometricSupport.buildInitialRestoreState(
        stateFromSession: _stateFromSession,
      );
      if (state.isAuthenticated) {
        final session = await _authRepository.restoreSession();
        if (session != null && !await _ensureAdminRole(session)) return;
        ref.read(syncServiceProvider).syncIfOnline();
        _prefetchInBackground();
      }
    } catch (_) {
      try {
        await _authRepository.clearSession();
      } catch (_) {}
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
      if (!await _ensureAdminRole(session)) return;
      state = _stateFromSession(session).copyWith(
        biometricAvailable: await ref.read(biometricAuthServiceProvider).canCheckBiometrics(),
      );
      ref.read(syncServiceProvider).syncIfOnline();
      _prefetchInBackground();
    } on ApiException catch (e) {
      final error = e.statusCode == 422 ? 'Invalid email or password.' : e.message;
      state = state.copyWith(isLoading: false, error: error);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> enableBiometricLogin(String reason) async {
    final ok = await _authRepository.enableBiometric(reason: reason);
    if (ok) state = state.copyWith(biometricEnabled: true);
    return ok;
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
      state = state.copyWith(isLoading: false, error: 'Biometric authentication failed. Try again or use your password.');
      return false;
    }
    if (next.isAuthenticated && !next.roles.contains('admin')) {
      await _authRepository.clearSession();
      state = const AuthState(isLoading: false, error: 'Admin access required');
      return false;
    }
    state = next;
    if (state.isAuthenticated) {
      ref.read(syncServiceProvider).syncIfOnline();
      _prefetchInBackground();
    }
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

  void _prefetchInBackground() {
    if (!ref.read(isOnlineProvider)) return;
    unawaited(
      ref.read(referenceDataPrefetcherProvider).prefetch().catchError((_) {}),
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState(isLoading: false);
  }

  Future<void> handleUnauthorized() async {
    // A stray 401 must not race a lock/unlock in progress: while the app is
    // locked or awaiting biometric unlock, the unlock's own online check is
    // the sole authority on whether the session ends. Also ignore repeats
    // once already logged out.
    if (!state.isAuthenticated || state.isAppLocked) return;
    await _authRepository.clearSession();
    state = const AuthState(isLoading: false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
