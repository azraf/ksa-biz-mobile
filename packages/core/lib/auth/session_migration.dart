import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import 'secure_session_store.dart';

class SessionMigration {
  SessionMigration(this._prefs, this._secureStore);

  final SharedPreferences _prefs;
  final SecureSessionStore _secureStore;

  Future<Map<String, dynamic>?> migrateLegacySessionIfNeeded() async {
    if (_prefs.getBool(AppConfig.sessionMigratedKey) == true) {
      return null;
    }

    final token = _prefs.getString(AppConfig.authTokenKey);
    final userJson = _prefs.getString(AppConfig.authUserKey);
    if (token == null || userJson == null) {
      await _prefs.setBool(AppConfig.sessionMigratedKey, true);
      return null;
    }

    final payload = <String, dynamic>{
      'token': token,
      'api_base_url': _prefs.getString(AppConfig.apiBaseUrlKey) ?? AppConfig.defaultApiBaseUrl,
      'user': jsonDecode(userJson),
      'roles': _prefs.getStringList(AppConfig.authRolesKey) ?? <String>[],
      'can_pick_sales_person': _prefs.getBool(AppConfig.canPickSalesPersonKey) ?? false,
    };

    final salesPersonJson = _prefs.getString(AppConfig.salesPersonKey);
    if (salesPersonJson != null) {
      payload['sales_person'] = jsonDecode(salesPersonJson);
    }
    final activeJson = _prefs.getString(AppConfig.activeSalesPersonKey);
    if (activeJson != null) {
      payload['active_sales_person'] = jsonDecode(activeJson);
    }

    await _secureStore.writeSession(jsonEncode(payload));
    await _clearLegacyPrefs();
    await _prefs.setBool(AppConfig.sessionMigratedKey, true);
    return payload;
  }

  Future<void> _clearLegacyPrefs() async {
    await _prefs.remove(AppConfig.authTokenKey);
    await _prefs.remove(AppConfig.authUserKey);
    await _prefs.remove(AppConfig.salesPersonKey);
    await _prefs.remove(AppConfig.activeSalesPersonKey);
    await _prefs.remove(AppConfig.authRolesKey);
    await _prefs.remove(AppConfig.canPickSalesPersonKey);
  }
}
