import 'dart:async';
import 'dart:io';
import 'dart:ui' show Locale;

import 'package:core/api/api_exception.dart';
import 'package:core/auth/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' show ClientException;
import 'package:l10n/l10n.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  group('friendlyErrorMessage', () {
    test('401 maps to wrong-credentials message', () {
      final message = friendlyErrorMessage(
        l10n,
        ApiException('Unauthenticated.', statusCode: 401),
      );
      expect(message, contains('Incorrect email or password'));
    });

    test('timeout maps to connection message', () {
      final message = friendlyErrorMessage(
        l10n,
        ApiException('Request timed out', statusCode: 408),
      );
      expect(message, contains('timed out'));
    });

    test('server errors map to a retry message, not the raw body', () {
      final message = friendlyErrorMessage(
        l10n,
        ApiException('Server Error', statusCode: 500),
      );
      expect(message, contains('server'));
      expect(message, isNot(contains('Server Error')));
    });

    test('validation messages from the server pass through', () {
      final message = friendlyErrorMessage(
        l10n,
        ApiException('The email field is required.', statusCode: 422),
      );
      expect(message, 'The email field is required.');
    });

    test('empty/fallback ApiException message becomes generic', () {
      final message = friendlyErrorMessage(
        l10n,
        ApiException('Request failed (404)', statusCode: 404),
      );
      expect(message, 'Something went wrong. Please try again.');
    });

    test('network errors map to check-connection message', () {
      for (final error in <Object>[
        const SocketException('Failed host lookup'),
        TimeoutException('timed out'),
        ClientException('Connection closed'),
      ]) {
        expect(friendlyErrorMessage(l10n, error), contains('connection'));
      }
    });

    test('unknown errors never leak toString', () {
      final message = friendlyErrorMessage(l10n, StateError('secret internals'));
      expect(message, isNot(contains('secret internals')));
      expect(message, 'Something went wrong. Please try again.');
    });

    test('localized instance follows the given locale', () {
      final ar = lookupAppLocalizations(const Locale('ar'));
      final message = friendlyErrorMessage(
        ar,
        ApiException('Unauthenticated.', statusCode: 401),
      );
      expect(message, ar.authErrorInvalidCredentials);
    });
  });
}
