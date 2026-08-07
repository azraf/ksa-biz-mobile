import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../providers/shared_preferences_provider.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'app_theme_mode';

  @override
  ThemeMode build() {
    final raw = ref.watch(sharedPreferencesProvider).getString(_key);
    switch (raw) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setDark(bool enabled) async {
    final mode = enabled ? ThemeMode.dark : ThemeMode.light;
    await ref.read(sharedPreferencesProvider).setString(
          _key,
          enabled ? 'dark' : 'light',
        );
    state = mode;
  }
}

final themeModeNotifierProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
