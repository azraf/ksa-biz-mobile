import 'dart:io';

import 'package:core/api/api_client.dart';
import 'package:core/auth/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<AuthRepository> buildRepo(http.Client client) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    return AuthRepository(ApiClient(client: client), prefs);
  }

  group('AuthRepository.validateSessionOnline', () {
    test('returns false when the server rejects the token with 401', () async {
      final repo = await buildRepo(
        MockClient((_) async => http.Response('{"message":"Unauthenticated."}', 401)),
      );

      expect(await repo.validateSessionOnline(), isFalse);
    });

    test('returns true when the server confirms the session', () async {
      final repo = await buildRepo(
        MockClient((_) async => http.Response('{"data":{}}', 200)),
      );

      expect(await repo.validateSessionOnline(), isTrue);
    });

    test('returns true (trusts local session) on a network failure, not just a 401', () async {
      final repo = await buildRepo(
        MockClient((_) async => throw const SocketException('no network')),
      );

      expect(await repo.validateSessionOnline(), isTrue);
    });

    test('returns true (trusts local session) on a server error other than 401', () async {
      final repo = await buildRepo(
        MockClient((_) async => http.Response('{"message":"Server error"}', 500)),
      );

      expect(await repo.validateSessionOnline(), isTrue);
    });
  });
}
