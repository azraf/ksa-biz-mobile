import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories.dart';

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
      salesPerson: session.salesPerson,
      activeSalesPerson: session.activeSalesPerson,
      roles: session.roles,
      canPickSalesPerson: session.canPickSalesPerson,
      token: session.token,
      apiBaseUrl: session.apiBaseUrl,
    );
  }

  Future<void> _onAuthenticated() async {
    if (ref.read(isOnlineProvider)) {
      await ref.read(syncServiceProvider).syncIfOnline();
      await ref.read(referenceDataPrefetcherProvider).prefetch(
            salesPersonId: state.effectiveSalesPersonId,
          );
      ref.invalidate(pendingSyncCountProvider);
    }
  }

  Future<void> _restore() async {
    try {
      final session = await _authRepository.restoreSession();
      if (session == null) {
        state = const AuthState(isLoading: false);
        return;
      }
      state = _stateFromSession(session);
      await _onAuthenticated();
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
      state = _stateFromSession(session);
      await _onAuthenticated();
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> selectActiveSalesPerson(SalesPersonModel person) async {
    await _authRepository.saveActiveSalesPerson(person);
    state = state.copyWith(activeSalesPerson: person);
    if (ref.read(isOnlineProvider)) {
      await ref.read(referenceDataPrefetcherProvider).prefetch(salesPersonId: person.id);
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

String formatOrderId(int id) => id < 0 ? 'L${-id}' : '$id';

bool isPendingSyncOrder(int id) => id < 0;
