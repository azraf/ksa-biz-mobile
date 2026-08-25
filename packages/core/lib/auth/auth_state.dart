import 'dart:async' show TimeoutException;
import 'dart:io' show SocketException;

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' show ClientException;
import 'package:l10n/l10n.dart';

import '../api/api_exception.dart';
import '../models/sales_person.dart';
import '../models/user.dart';

/// Maps a raw error to a short message safe to show to the user, instead of
/// surfacing exception `toString()` noise on the login and selection screens.
///
/// Takes [AppLocalizations] rather than a BuildContext so notifiers without
/// a context can resolve one via `lookupAppLocalizations(locale)`.
String friendlyErrorMessage(AppLocalizations l10n, Object error) {
  if (error is ApiException) {
    if (error.statusCode == 401) {
      return l10n.authErrorInvalidCredentials;
    }
    if (error.statusCode == 408) {
      return l10n.authErrorTimeout;
    }
    if (error.statusCode != null && error.statusCode! >= 500) {
      return l10n.authErrorServer;
    }
    // Other server-provided messages (validation etc.) are already
    // human-readable; fall back to a generic line when there is none.
    final message = error.message.trim();
    if (message.isNotEmpty && !message.startsWith('Request failed')) {
      return message;
    }
    return l10n.salesErrorGeneric;
  }
  if (error is SocketException ||
      error is TimeoutException ||
      error is ClientException) {
    return l10n.authErrorNetwork;
  }
  return l10n.salesErrorGeneric;
}

class AuthState extends Equatable {
  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.pendingBiometricUnlock = false,
    this.isAppLocked = false,
    this.biometricEnabled = false,
    this.biometricAvailable = false,
    this.storedUserEmail,
    this.tokenExpiresAt,
    this.user,
    this.salesPerson,
    this.activeSalesPerson,
    this.roles = const [],
    this.canPickSalesPerson = false,
    this.token,
    this.apiBaseUrl,
    this.error,
  });

  final bool isLoading;
  final bool isAuthenticated;
  final bool pendingBiometricUnlock;
  final bool isAppLocked;
  final bool biometricEnabled;
  final bool biometricAvailable;
  final String? storedUserEmail;
  final DateTime? tokenExpiresAt;
  final UserModel? user;
  final SalesPersonModel? salesPerson;
  final SalesPersonModel? activeSalesPerson;
  final List<String> roles;
  final bool canPickSalesPerson;
  final String? token;
  final String? apiBaseUrl;
  final String? error;

  bool get hasSalesPerson => salesPerson != null;
  bool get hasActiveSalesPerson => activeSalesPerson != null;
  int? get effectiveSalesPersonId => activeSalesPerson?.id ?? salesPerson?.id;

  bool get needsSalesPersonSelection =>
      canPickSalesPerson && activeSalesPerson == null;

  bool get isAdmin => roles.contains('admin');

  bool get showBiometricLogin =>
      !isAuthenticated &&
      !isLoading &&
      biometricEnabled &&
      storedUserEmail != null &&
      (pendingBiometricUnlock || !isAuthenticated);

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? pendingBiometricUnlock,
    bool? isAppLocked,
    bool? biometricEnabled,
    bool? biometricAvailable,
    String? storedUserEmail,
    DateTime? tokenExpiresAt,
    UserModel? user,
    SalesPersonModel? salesPerson,
    SalesPersonModel? activeSalesPerson,
    List<String>? roles,
    bool? canPickSalesPerson,
    String? token,
    String? apiBaseUrl,
    String? error,
    bool clearError = false,
    bool clearSalesPerson = false,
    bool clearActiveSalesPerson = false,
    bool clearStoredUserEmail = false,
    bool clearTokenExpiresAt = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      pendingBiometricUnlock: pendingBiometricUnlock ?? this.pendingBiometricUnlock,
      isAppLocked: isAppLocked ?? this.isAppLocked,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      storedUserEmail:
          clearStoredUserEmail ? null : (storedUserEmail ?? this.storedUserEmail),
      tokenExpiresAt:
          clearTokenExpiresAt ? null : (tokenExpiresAt ?? this.tokenExpiresAt),
      user: user ?? this.user,
      salesPerson: clearSalesPerson ? null : (salesPerson ?? this.salesPerson),
      activeSalesPerson: clearActiveSalesPerson
          ? null
          : (activeSalesPerson ?? this.activeSalesPerson),
      roles: roles ?? this.roles,
      canPickSalesPerson: canPickSalesPerson ?? this.canPickSalesPerson,
      token: token ?? this.token,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isAuthenticated,
        pendingBiometricUnlock,
        isAppLocked,
        biometricEnabled,
        biometricAvailable,
        storedUserEmail,
        tokenExpiresAt,
        user,
        salesPerson,
        activeSalesPerson,
        roles,
        canPickSalesPerson,
        token,
        apiBaseUrl,
        error,
      ];
}
