import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppConfig {
  static const appLocaleKey = 'app_locale';
  static const supportedLocales = [Locale('en'), Locale('ar'), Locale('bn')];
  static const defaultApiBaseUrl = 'https://ksabiz.makewebsmart.com/api/v1';
  static const apiBaseUrlKey = 'api_base_url';
  static const authTokenKey = 'auth_token';
  static const authUserKey = 'auth_user';
  static const salesPersonKey = 'sales_person';
  static const activeSalesPersonKey = 'active_sales_person';
  static const authRolesKey = 'auth_roles';
  static const canPickSalesPersonKey = 'can_pick_sales_person';
  static const biometricEnabledKey = 'biometric_enabled';
  static const lastUserEmailKey = 'last_user_email';
  static const tokenExpiresAtKey = 'token_expires_at';
  static const sessionMigratedKey = 'auth_session_migrated';

  static const appLockTimeout = Duration(minutes: 15);

  static const googleMapsApiKey =
      String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: '');

  /// Injected by scripts/build_release_apk.sh; 0 / empty in debug builds,
  /// which disables the in-app update banner.
  static const buildNumber = int.fromEnvironment('KSA_BUILD_NUMBER');
  static const appKey = String.fromEnvironment('KSA_APP_KEY', defaultValue: '');

  /// True when a non-empty Maps key was passed via `--dart-define`.
  static bool get hasGoogleMapsApiKey => googleMapsApiKey.trim().isNotEmpty;

  /// Log API request durations in debug builds.
  static bool get logApiTiming => kDebugMode;

  /// Editable API URL field is shown only in debug builds.
  static bool get showApiBaseUrlField => kDebugMode;

  /// Resolves the API base URL. In release always uses [defaultApiBaseUrl].
  /// In debug, uses [override] when non-empty.
  static String resolveApiBaseUrl([String? override]) {
    if (showApiBaseUrlField) {
      final trimmed = override?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return defaultApiBaseUrl;
  }
}
