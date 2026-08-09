import 'package:core/core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sales_app/app.dart';
import 'package:sales_app/providers/repositories.dart';

class _FakeBiometrics extends BiometricAuthService {
  @override
  Future<bool> canCheckBiometrics() async => false;

  @override
  Future<bool> isDeviceSupported() async => false;
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Real plugin channels never respond in widget tests; unmocked calls hang.
    const storage = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
    binding.defaultBinaryMessenger.setMockMethodCallHandler(storage, (call) async {
      if (call.method == 'readAll') return <String, String>{};
      return null;
    });
  });

  testWidgets('App boots to login screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          biometricAuthServiceProvider.overrideWithValue(_FakeBiometrics()),
        ],
        child: const SalesApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsOneWidget);
  });
}
