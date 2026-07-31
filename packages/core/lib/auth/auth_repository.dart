import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../config/app_config.dart';
import '../models/sales_person.dart';
import '../models/user.dart';

class AuthSession {
  const AuthSession({
    required this.user,
    required this.token,
    required this.apiBaseUrl,
    this.salesPerson,
    this.activeSalesPerson,
    this.roles = const [],
    this.canPickSalesPerson = false,
  });

  final UserModel user;
  final SalesPersonModel? salesPerson;
  final SalesPersonModel? activeSalesPerson;
  final List<String> roles;
  final bool canPickSalesPerson;
  final String token;
  final String apiBaseUrl;
}

class AuthRepository {
  AuthRepository(this._api, this._prefs);

  final ApiClient _api;
  final SharedPreferences _prefs;

  Future<AuthSession> login({
    required String email,
    required String password,
    String? apiBaseUrl,
  }) async {
    final resolvedUrl = AppConfig.resolveApiBaseUrl(apiBaseUrl);
    _api.setBaseUrl(resolvedUrl);
    final response = await _api.post('/login', body: {
      'email': email,
      'password': password,
    });

    final session = _sessionFromLoginResponse(response, resolvedUrl);
    await _persistSession(session);
    _api.setToken(session.token);
    return session;
  }

  Future<void> logout() async {
    try {
      await _api.post('/logout');
    } catch (_) {}
    await clearSession();
  }

  Future<void> clearSession() async {
    await _prefs.remove(AppConfig.authTokenKey);
    await _prefs.remove(AppConfig.authUserKey);
    await _prefs.remove(AppConfig.salesPersonKey);
    await _prefs.remove(AppConfig.activeSalesPersonKey);
    await _prefs.remove(AppConfig.authRolesKey);
    await _prefs.remove(AppConfig.canPickSalesPersonKey);
    _api.setToken(null);
  }

  Future<AuthSession?> restoreSession() async {
    final token = _prefs.getString(AppConfig.authTokenKey);
    final apiBaseUrl = AppConfig.showApiBaseUrlField
        ? (_prefs.getString(AppConfig.apiBaseUrlKey) ?? AppConfig.defaultApiBaseUrl)
        : AppConfig.defaultApiBaseUrl;
    final userJson = _prefs.getString(AppConfig.authUserKey);

    if (token == null || userJson == null) return null;

    _api.setBaseUrl(apiBaseUrl);
    _api.setToken(token);

    return AuthSession(
      user: UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>),
      salesPerson: _readSalesPerson(AppConfig.salesPersonKey),
      activeSalesPerson: _readSalesPerson(AppConfig.activeSalesPersonKey),
      roles: _readRoles(),
      canPickSalesPerson: _prefs.getBool(AppConfig.canPickSalesPersonKey) ?? false,
      token: token,
      apiBaseUrl: apiBaseUrl,
    );
  }

  Future<void> saveActiveSalesPerson(SalesPersonModel? person) async {
    if (person == null) {
      await _prefs.remove(AppConfig.activeSalesPersonKey);
      return;
    }
    await _prefs.setString(
      AppConfig.activeSalesPersonKey,
      jsonEncode(person.toJson()),
    );
  }

  Future<void> saveApiBaseUrl(String url) async {
    await _prefs.setString(AppConfig.apiBaseUrlKey, url);
    _api.setBaseUrl(url);
  }

  AuthSession _sessionFromLoginResponse(
    Map<String, dynamic> response,
    String apiBaseUrl,
  ) {
    final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
    final salesPerson = response['sales_person'] is Map
        ? SalesPersonModel.fromJson(response['sales_person'] as Map<String, dynamic>)
        : null;
    final roles = (response['roles'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    final canPick = response['can_pick_sales_person'] as bool? ?? false;

    SalesPersonModel? activeSalesPerson;
    if (!canPick && salesPerson != null) {
      activeSalesPerson = salesPerson;
    } else if (canPick) {
      activeSalesPerson = _readSalesPerson(AppConfig.activeSalesPersonKey);
    }

    return AuthSession(
      user: user,
      salesPerson: salesPerson,
      activeSalesPerson: activeSalesPerson,
      roles: roles,
      canPickSalesPerson: canPick,
      token: response['token'] as String,
      apiBaseUrl: apiBaseUrl,
    );
  }

  Future<void> _persistSession(AuthSession session) async {
    await _prefs.setString(AppConfig.apiBaseUrlKey, session.apiBaseUrl);
    await _prefs.setString(AppConfig.authTokenKey, session.token);
    await _prefs.setString(AppConfig.authUserKey, jsonEncode(session.user.toJson()));
    await _prefs.setStringList(AppConfig.authRolesKey, session.roles);
    await _prefs.setBool(AppConfig.canPickSalesPersonKey, session.canPickSalesPerson);

    if (session.salesPerson != null) {
      await _prefs.setString(
        AppConfig.salesPersonKey,
        jsonEncode(session.salesPerson!.toJson()),
      );
    } else {
      await _prefs.remove(AppConfig.salesPersonKey);
    }

    await saveActiveSalesPerson(session.activeSalesPerson);
  }

  SalesPersonModel? _readSalesPerson(String key) {
    final json = _prefs.getString(key);
    if (json == null) return null;
    return SalesPersonModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  List<String> _readRoles() => _prefs.getStringList(AppConfig.authRolesKey) ?? [];
}
