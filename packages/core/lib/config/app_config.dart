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

  static const googleMapsApiKey =
      String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: '');

  static bool get hasGoogleMapsApiKey => googleMapsApiKey.isNotEmpty;

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
