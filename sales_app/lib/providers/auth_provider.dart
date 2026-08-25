import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

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
      salesPerson: session.salesPerson,
      activeSalesPerson: session.activeSalesPerson,
      roles: session.roles,
      canPickSalesPerson: session.canPickSalesPerson,
      token: session.token,
      apiBaseUrl: session.apiBaseUrl,
    );
  }

  void _runBackgroundAuthTasks() {
    if (!ref.read(isOnlineProvider)) return;
    unawaited(() async {
      try {
        await ref.read(syncServiceProvider).syncIfOnline();
        // Always attempt a refresh on app start/restore — prefetch() has its
        // own in-memory TTL (resets on cold start) so this is a real re-sync
        // each time the app opens, not just the very first time ever.
        await ref.read(referenceDataPrefetcherProvider).prefetch(
              salesPersonId: state.effectiveSalesPersonId,
            );
        ref.invalidate(pendingSyncCountProvider);
      } catch (_) {}
    }());
  }

  Future<void> _restore() async {
    try {
      state = await _biometricSupport.buildInitialRestoreState(
        stateFromSession: _stateFromSession,
      );
      if (state.isAuthenticated) {
        _runBackgroundAuthTasks();
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
      state = _stateFromSession(session).copyWith(
        biometricAvailable: await ref.read(biometricAuthServiceProvider).canCheckBiometrics(),
      );
      _runBackgroundAuthTasks();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: friendlyErrorMessage(_l10n, e));
    }
  }

  /// Notifiers have no BuildContext; resolve the current locale's strings
  /// directly so state-carried messages still follow the app language.
  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeNotifierProvider));

  Future<bool> enableBiometricLogin(String reason) async {
    final ok = await _authRepository.enableBiometric(reason: reason);
    if (ok) {
      state = state.copyWith(biometricEnabled: true);
    }
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
      state = state.copyWith(isLoading: false);
      return false;
    }
    state = next;
    if (state.isAuthenticated) {
      _runBackgroundAuthTasks();
      return true;
    }
    return false;
  }

  void lockApp() {
    _authRepository.appLock.lock();
    state = state.copyWith(isAppLocked: true);
  }

  Future<bool> unlockApp(String reason, {required String sessionExpiredMessage}) async {
    final ok = await unlockWithBiometric(reason, sessionExpiredMessage: sessionExpiredMessage);
    if (ok) {
      state = state.copyWith(isAppLocked: false);
    }
    return ok;
  }

  Future<void> selectActiveSalesPerson(SalesPersonModel person) async {
    await _authRepository.saveActiveSalesPerson(person);
    state = state.copyWith(activeSalesPerson: person);
    if (ref.read(isOnlineProvider)) {
      unawaited(
        ref.read(referenceDataPrefetcherProvider).prefetch(salesPersonId: person.id).catchError((_) {}),
      );
    }
  }

  Future<void> clearActiveSalesPerson() async {
    await _authRepository.saveActiveSalesPerson(null);
    state = state.copyWith(clearActiveSalesPerson: true);
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
    // Keep the remembered email and biometric enrollment (clearSession
    // preserves both on purpose) and tell the user why they are back at the
    // login screen instead of dumping them there silently.
    state = AuthState(
      isLoading: false,
      biometricEnabled: _authRepository.isBiometricEnabled,
      biometricAvailable: state.biometricAvailable,
      storedUserEmail: _authRepository.storedUserEmail,
      error: _l10n.sessionExpired,
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

int? requireSalesPersonId(AuthState auth) => auth.effectiveSalesPersonId;
