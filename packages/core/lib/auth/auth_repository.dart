import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../api/api_exception.dart';
import '../config/app_config.dart';
import '../models/sales_person.dart';
import '../models/user.dart';
import '../offline/local_database.dart';
import 'app_lock_service.dart';
import 'biometric_auth_service.dart';
import 'secure_session_store.dart';
import 'session_migration.dart';

class AuthSession {
  const AuthSession({
    required this.user,
    required this.token,
    required this.apiBaseUrl,
    this.salesPerson,
    this.activeSalesPerson,
    this.roles = const [],
    this.canPickSalesPerson = false,
    this.tokenExpiresAt,
    this.linkedCustomer,
  });

  final UserModel user;
  final SalesPersonModel? salesPerson;
  final SalesPersonModel? activeSalesPerson;
  final List<String> roles;
  final bool canPickSalesPerson;
  final String token;
  final String apiBaseUrl;
  final DateTime? tokenExpiresAt;
  final LinkedCustomerModel? linkedCustomer;

  Map<String, dynamic> toJson() => {
        'token': token,
        'api_base_url': apiBaseUrl,
        'user': user.toJson(),
        'roles': roles,
        'can_pick_sales_person': canPickSalesPerson,
        if (salesPerson != null) 'sales_person': salesPerson!.toJson(),
        if (activeSalesPerson != null) 'active_sales_person': activeSalesPerson!.toJson(),
        if (tokenExpiresAt != null) 'token_expires_at': tokenExpiresAt!.toIso8601String(),
        if (linkedCustomer != null)
          'linked_customer': {
            'type': linkedCustomer!.type,
            'id': linkedCustomer!.id,
            'name': linkedCustomer!.name,
            if (linkedCustomer!.customerTypeId != null)
              'customer_type_id': linkedCustomer!.customerTypeId,
          },
      };

  factory AuthSession.fromStoredJson(Map<String, dynamic> json) {
    return AuthSession(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      apiBaseUrl: json['api_base_url'] as String? ?? AppConfig.defaultApiBaseUrl,
      salesPerson: json['sales_person'] is Map
          ? SalesPersonModel.fromJson(json['sales_person'] as Map<String, dynamic>)
          : null,
      activeSalesPerson: json['active_sales_person'] is Map
          ? SalesPersonModel.fromJson(json['active_sales_person'] as Map<String, dynamic>)
          : null,
      roles: (json['roles'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      canPickSalesPerson: json['can_pick_sales_person'] as bool? ?? false,
      tokenExpiresAt: _parseDate(json['token_expires_at']),
      linkedCustomer: json['linked_customer'] is Map
          ? LinkedCustomerModel.fromJson(json['linked_customer'] as Map<String, dynamic>)
          : null,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

class AuthRestoreResult {
  const AuthRestoreResult({
    this.session,
    this.pendingBiometricUnlock = false,
    this.storedUserEmail,
    this.biometricEnabled = false,
    this.tokenExpiresAt,
  });

  final AuthSession? session;
  final bool pendingBiometricUnlock;
  final String? storedUserEmail;
  final bool biometricEnabled;
  final DateTime? tokenExpiresAt;
}

class AuthRepository {
  AuthRepository(
    this._api,
    this._prefs, {
    SecureSessionStore? secureStore,
    BiometricAuthService? biometricAuth,
    AppLockService? appLock,
  })  : _secureStore = secureStore ?? SecureSessionStore(),
        _biometricAuth = biometricAuth ?? BiometricAuthService(),
        _appLock = appLock ?? AppLockService() {
    _migration = SessionMigration(_prefs, _secureStore);
  }

  final ApiClient _api;
  final SharedPreferences _prefs;
  final SecureSessionStore _secureStore;
  final BiometricAuthService _biometricAuth;
  final AppLockService _appLock;
  late final SessionMigration _migration;

  AppLockService get appLock => _appLock;

  Future<String?> getAuthToken() => _secureStore.readToken();

  bool get isBiometricEnabled => _prefs.getBool(AppConfig.biometricEnabledKey) ?? false;

  String? get storedUserEmail => _prefs.getString(AppConfig.lastUserEmailKey);

  DateTime? get storedTokenExpiresAt {
    final raw = _prefs.getString(AppConfig.tokenExpiresAtKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<bool> canUseBiometrics() => _biometricAuth.canCheckBiometrics();

  Future<AuthSession> login({
    required String email,
    required String password,
    String? apiBaseUrl,
    String? client,
  }) async {
    final resolvedUrl = AppConfig.resolveApiBaseUrl(apiBaseUrl);
    _api.setBaseUrl(resolvedUrl);
    final response = await _api.post('/login', body: {
      'email': email,
      'password': password,
      if (client != null) 'client': client,
    });

    final session = await _sessionFromLoginResponse(response, resolvedUrl);
    // Before the token is applied — a background sync must never see a
    // stale queue belonging to whoever was previously logged in here.
    await _ensureOfflineDataOwner(session.user.id);
    await _persistSession(session);
    _api.setToken(session.token);
    _appLock.markUnlocked();
    return session;
  }

  Future<void> logout() async {
    try {
      await _api.post('/logout');
    } catch (_) {}
    // Explicit sign-out: drop the cached business data so it isn't left
    // readable on a shared device — but only when nothing is waiting to
    // sync ('syncing' rows count as pending too). With unsynced data the
    // cache stays intact; the logout guard has already warned the user.
    try {
      final db = LocalDatabase.instance;
      if (await db.pendingCount() == 0 && await db.pendingMediaCount() == 0) {
        await db.clearBusinessCaches();
      }
    } catch (_) {
      // Cache hygiene must never block signing out.
    }
    await clearSession();
    await _prefs.remove(AppConfig.biometricEnabledKey);
    await _prefs.remove(AppConfig.lastUserEmailKey);
    await _prefs.remove(AppConfig.apiBaseUrlKey);
  }

  /// Ends the session (token + secure store) but deliberately keeps the
  /// biometric enrollment and last-used email: a server-side 401 means the
  /// token died, not that the user chose to stop using biometrics. Only an
  /// explicit [logout] or [disableBiometric] removes those.
  Future<void> clearSession() async {
    await _secureStore.clear();
    await _prefs.remove(AppConfig.tokenExpiresAtKey);
    _api.setToken(null);
    _appLock.markUnlocked();
  }

  Future<AuthRestoreResult> prepareRestore() async {
    await _migration.migrateLegacySessionIfNeeded();

    final biometricEnabled = isBiometricEnabled;
    final hasSession = await _secureStore.hasSession();
    final storedEmail = storedUserEmail;
    final tokenExpiresAt = storedTokenExpiresAt;

    if (!hasSession) {
      return AuthRestoreResult(
        storedUserEmail: storedEmail,
        biometricEnabled: biometricEnabled,
        tokenExpiresAt: tokenExpiresAt,
      );
    }

    if (biometricEnabled) {
      return AuthRestoreResult(
        pendingBiometricUnlock: true,
        storedUserEmail: storedEmail,
        biometricEnabled: true,
        tokenExpiresAt: tokenExpiresAt,
      );
    }

    final session = await _readStoredSession();
    if (session == null) {
      return const AuthRestoreResult();
    }

    // Stamps last_user_id for an existing install that had never run this
    // check before — does not wipe, since the session being restored IS the
    // device's current user.
    await _ensureOfflineDataOwner(session.user.id);
    _applySessionToApi(session);
    _appLock.markUnlocked();
    return AuthRestoreResult(
      session: session,
      storedUserEmail: session.user.loginIdentifier,
      biometricEnabled: false,
      tokenExpiresAt: session.tokenExpiresAt ?? tokenExpiresAt,
    );
  }

  Future<AuthSession?> restoreSession() async {
    final result = await prepareRestore();
    return result.session;
  }

  Future<AuthSession?> unlockWithBiometric({required String reason}) async {
    final ok = await _biometricAuth.authenticate(reason: reason);
    if (!ok) return null;

    final session = await _readStoredSession();
    if (session == null) return null;

    await _ensureOfflineDataOwner(session.user.id);
    _applySessionToApi(session);
    _appLock.markUnlocked();
    return session;
  }

  Future<bool> enableBiometric({required String reason}) async {
    if (!await canUseBiometrics()) return false;
    final ok = await _biometricAuth.authenticate(reason: reason);
    if (!ok) return false;
    await _prefs.setBool(AppConfig.biometricEnabledKey, true);
    return true;
  }

  Future<void> disableBiometric() async {
    await _prefs.setBool(AppConfig.biometricEnabledKey, false);
    _appLock.markUnlocked();
  }

  /// True unless the server explicitly rejects the stored token (401). A
  /// network failure, timeout, or any other server error can't confirm the
  /// session is actually invalid, so it's treated as still valid — this app
  /// supports offline use and biometric unlock must work without connectivity.
  Future<bool> validateSessionOnline() async {
    try {
      await _api.get('/user');
      return true;
    } on ApiException catch (e) {
      return e.statusCode != 401;
    } catch (_) {
      return true;
    }
  }

  Future<void> saveActiveSalesPerson(SalesPersonModel? person) async {
    final session = await _readStoredSession();
    if (session == null) return;

    final updated = AuthSession(
      user: session.user,
      token: session.token,
      apiBaseUrl: session.apiBaseUrl,
      salesPerson: session.salesPerson,
      activeSalesPerson: person,
      roles: session.roles,
      canPickSalesPerson: session.canPickSalesPerson,
      tokenExpiresAt: session.tokenExpiresAt,
      linkedCustomer: session.linkedCustomer,
    );
    await _persistSession(updated);
  }

  Future<void> saveApiBaseUrl(String url) async {
    await _prefs.setString(AppConfig.apiBaseUrlKey, url);
    _api.setBaseUrl(url);
  }

  Future<AuthSession> _sessionFromLoginResponse(
    Map<String, dynamic> response,
    String apiBaseUrl,
  ) async {
    final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
    final salesPerson = response['sales_person'] is Map
        ? SalesPersonModel.fromJson(response['sales_person'] as Map<String, dynamic>)
        : null;
    final roles = (response['roles'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    final canPick = response['can_pick_sales_person'] as bool? ?? false;
    final linkedCustomer = response['linked_customer'] is Map
        ? LinkedCustomerModel.fromJson(response['linked_customer'] as Map<String, dynamic>)
        : null;

    SalesPersonModel? activeSalesPerson;
    if (!canPick && salesPerson != null) {
      activeSalesPerson = salesPerson;
    } else if (canPick) {
      final existing = await _readStoredSession();
      activeSalesPerson = existing?.activeSalesPerson;
    }

    return AuthSession(
      user: user,
      salesPerson: salesPerson,
      activeSalesPerson: activeSalesPerson,
      roles: roles,
      canPickSalesPerson: canPick,
      token: response['token'] as String,
      apiBaseUrl: apiBaseUrl,
      tokenExpiresAt: AuthSession._parseDate(response['token_expires_at']),
      linkedCustomer: linkedCustomer,
    );
  }

  Future<void> _persistSession(AuthSession session) async {
    await _secureStore.writeSession(jsonEncode(session.toJson()));
    await _prefs.setString(AppConfig.apiBaseUrlKey, session.apiBaseUrl);
    final identifier = session.user.loginIdentifier;
    if (identifier != null) {
      await _prefs.setString(AppConfig.lastUserEmailKey, identifier);
    }
    if (session.tokenExpiresAt != null) {
      await _prefs.setString(
        AppConfig.tokenExpiresAtKey,
        session.tokenExpiresAt!.toIso8601String(),
      );
    }
  }

  Future<AuthSession?> _readStoredSession() async {
    final raw = await _secureStore.readSession();
    if (raw == null) return null;
    try {
      return AuthSession.fromStoredJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      await _secureStore.clear();
      return null;
    }
  }

  void _applySessionToApi(AuthSession session) {
    _api.setBaseUrl(session.apiBaseUrl);
    _api.setToken(session.token);
  }

  /// Unsynced queue + media rows that a login by [targetUserId] would
  /// destroy because they belong to a different user (`last_user_id`).
  /// Returns 0 when the device user is unchanged, unknown (first run), or
  /// nothing is pending. A login flow can call this before [login] commits
  /// to show a confirmation instead of wiping silently.
  Future<int> pendingDataOwnerMismatchCount(int targetUserId) async {
    final db = LocalDatabase.instance;
    final lastUserId = await db.getLastUserId();
    if (lastUserId == null || lastUserId == targetUserId) return 0;
    return await db.pendingCount() + await db.pendingMediaCount();
  }

  /// Wipes the offline database when the user on this device changes, so
  /// one salesperson's cached customers/orders/queue are never shown to, or
  /// synced under, the next person who logs in. Same user re-logging in
  /// keeps the cache. A null `last_user_id` (first run, or an existing
  /// install updating into this check) stamps without wiping — preserving
  /// whichever user is already on the device rather than guessing.
  ///
  /// When the outgoing user still has unsynced data, a recovery snapshot
  /// (JSON, timestamped, last few kept) is written to app-private storage
  /// first, so the wipe never silently destroys work.
  Future<void> _ensureOfflineDataOwner(int userId) async {
    final db = LocalDatabase.instance;
    final lastUserId = await db.getLastUserId();
    if (lastUserId != null && lastUserId != userId) {
      try {
        final pending = await db.pendingCount() + await db.pendingMediaCount();
        if (pending > 0) {
          await db.writeRecoverySnapshot(previousUserId: lastUserId);
        }
      } catch (_) {
        // Best-effort — a snapshot failure must not block login.
      }
      await db.wipeUserData();
    }
    await db.setLastUserId(userId);
  }
}
