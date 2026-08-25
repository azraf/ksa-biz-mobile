import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_repository.dart';
import '../auth/auth_state.dart';
import '../auth/biometric_auth_service.dart';
import 'biometric_unlock_gate.dart';

typedef AuthStateFromSession = AuthState Function(AuthSession session, {bool isLoading});
typedef OnAuthenticatedCallback = Future<void> Function(AuthState state);

class BiometricAppShell extends ConsumerStatefulWidget {
  const BiometricAppShell({
    super.key,
    required this.child,
    required this.auth,
    required this.authRepository,
    required this.onUnlock,
    required this.onAppLocked,
  });

  final Widget child;
  final AuthState auth;
  final AuthRepository authRepository;
  final Future<bool> Function(String reason) onUnlock;
  final VoidCallback onAppLocked;

  @override
  ConsumerState<BiometricAppShell> createState() => _BiometricAppShellState();
}

class _BiometricAppShellState extends ConsumerState<BiometricAppShell> {
  late final BiometricLifecycleObserver _lifecycleObserver;

  @override
  void initState() {
    super.initState();
    _lifecycleObserver = BiometricLifecycleObserver(
      onPaused: () => widget.authRepository.appLock.onAppPaused(),
      onResumed: _handleResumed,
    );
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  void _handleResumed() {
    final repo = widget.authRepository;
    repo.appLock.onAppResumed(
      biometricEnabled: widget.auth.biometricEnabled,
      hasSession: widget.auth.isAuthenticated,
    );
    if (repo.appLock.isLocked) {
      widget.onAppLocked();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BiometricUnlockGate(
      isAppLocked: widget.auth.isAppLocked,
      biometricEnabled: widget.auth.biometricEnabled,
      isAuthenticated: widget.auth.isAuthenticated,
      onUnlock: widget.onUnlock,
      child: widget.child,
    );
  }
}

/// Shared restore/unlock helpers for app [AuthNotifier] implementations.
class BiometricAuthSupport {
  BiometricAuthSupport(this._repository, this._biometricAuth);

  final AuthRepository _repository;
  final BiometricAuthService _biometricAuth;

  Future<AuthState> buildInitialRestoreState({
    required AuthStateFromSession stateFromSession,
  }) async {
    final biometricAvailable = await _biometricAuth.canCheckBiometrics();
    final result = await _repository.prepareRestore();

    if (result.pendingBiometricUnlock) {
      return AuthState(
        isLoading: false,
        pendingBiometricUnlock: true,
        biometricEnabled: true,
        biometricAvailable: biometricAvailable,
        storedUserEmail: result.storedUserEmail,
        tokenExpiresAt: result.tokenExpiresAt,
      );
    }

    if (result.session != null) {
      return stateFromSession(result.session!).copyWith(
        biometricAvailable: biometricAvailable,
        biometricEnabled: result.biometricEnabled,
      );
    }

    return AuthState(
      isLoading: false,
      biometricEnabled: result.biometricEnabled,
      biometricAvailable: biometricAvailable,
      storedUserEmail: result.storedUserEmail,
      tokenExpiresAt: result.tokenExpiresAt,
    );
  }

  Future<AuthState?> unlock({
    required String reason,
    required AuthStateFromSession stateFromSession,
    required String sessionExpiredMessage,
  }) async {
    final session = await _repository.unlockWithBiometric(reason: reason);
    if (session == null) return null;

    final valid = await _repository.validateSessionOnline();
    if (!valid) {
      // The token is dead, so the session ends — but biometric enrollment
      // and the remembered email survive: the user re-authenticates with
      // their password once and biometrics keep working afterwards.
      await _repository.clearSession();
      return AuthState(
        isLoading: false,
        biometricEnabled: _repository.isBiometricEnabled,
        storedUserEmail: _repository.storedUserEmail,
      ).copyWith(error: sessionExpiredMessage);
    }

    _repository.appLock.markUnlocked();
    return stateFromSession(session).copyWith(
      pendingBiometricUnlock: false,
      isAppLocked: false,
      biometricEnabled: true,
    );
  }
}
