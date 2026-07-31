import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories.dart';

const _monitorRole = 'monitor';

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.read(authRepositoryProvider);
    Future.microtask(_restore);
    return const AuthState(isLoading: true);
  }

  AuthState _stateFromSession(AuthSession session, {bool isLoading = false}) {
    return AuthState(
      isLoading: isLoading,
      isAuthenticated: true,
      user: session.user,
      roles: session.roles,
      token: session.token,
      apiBaseUrl: session.apiBaseUrl,
    );
  }

  bool _isMonitor(List<String> roles) => roles.contains(_monitorRole);

  Future<void> _restore() async {
    try {
      final session = await _authRepository.restoreSession();
      if (session == null) {
        state = const AuthState(isLoading: false);
        return;
      }
      if (!_isMonitor(session.roles)) {
        await _authRepository.clearSession();
        state = const AuthState(isLoading: false, error: 'Monitor access required');
        return;
      }
      state = _stateFromSession(session);
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
      if (!_isMonitor(session.roles)) {
        await _authRepository.clearSession();
        state = const AuthState(
          isLoading: false,
          error: 'Only monitor users can access this app',
        );
        return;
      }
      state = _stateFromSession(session);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState(isLoading: false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

String formatOrderId(int id) => '$id';
