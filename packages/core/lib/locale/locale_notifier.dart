import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../providers/shared_preferences_provider.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final code = ref.watch(sharedPreferencesProvider).getString(AppConfig.appLocaleKey);
    return _localeFromCode(code) ?? const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppConfig.appLocaleKey, locale.languageCode);
    state = locale;
  }

  static Locale? _localeFromCode(String? code) {
    if (code == null || code.isEmpty) return null;
    for (final locale in AppConfig.supportedLocales) {
      if (locale.languageCode == code) return locale;
    }
    return null;
  }
}

final localeNotifierProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
