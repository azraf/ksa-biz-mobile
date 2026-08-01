import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureSessionStore {
  SecureSessionStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
            );

  static const _sessionKey = 'auth_session_secure';

  final FlutterSecureStorage _storage;

  Future<bool> hasSession() async {
    final value = await _storage.read(key: _sessionKey);
    return value != null && value.isNotEmpty;
  }

  Future<String?> readSession() => _storage.read(key: _sessionKey);

  Future<void> writeSession(String json) async {
    await _storage.write(key: _sessionKey, value: json);
  }

  Future<void> clear() async {
    await _storage.delete(key: _sessionKey);
  }

  Future<String?> readToken() async {
    final json = await readSession();
    if (json == null) return null;
    return _extractToken(json);
  }

  String? _extractToken(String json) {
    const marker = '"token":"';
    final start = json.indexOf(marker);
    if (start < 0) return null;
    final from = start + marker.length;
    final end = json.indexOf('"', from);
    if (end < 0) return null;
    return json.substring(from, end);
  }
}
