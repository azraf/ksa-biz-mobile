import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('LocaleNotifier persists and restores locale', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    expect(container.read(localeNotifierProvider), const Locale('en'));

    await container.read(localeNotifierProvider.notifier).setLocale(const Locale('ar'));
    expect(container.read(localeNotifierProvider), const Locale('ar'));
    expect(prefs.getString(AppConfig.appLocaleKey), 'ar');

    final container2 = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container2.dispose);
    expect(container2.read(localeNotifierProvider), const Locale('ar'));
  });
}
