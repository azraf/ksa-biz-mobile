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
        final hasCatalog = await ref.read(referenceDataPrefetcherProvider).hasCachedCatalog();
        if (!hasCatalog) {
          await ref.read(referenceDataPrefetcherProvider).prefetch(
                salesPersonId: state.effectiveSalesPersonId,
              );
        }
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
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

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
    await _authRepository.clearSession();
    state = const AuthState(isLoading: false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

int? requireSalesPersonId(AuthState auth) => auth.effectiveSalesPersonId;
