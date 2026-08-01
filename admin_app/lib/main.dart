import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'providers/repositories.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await IsarService.instance.open();
  } catch (e) {
    runApp(StartupErrorApp(
      title: 'Failed to start ARM Admin',
      message: 'Could not open offline database.\n\n$e',
    ));
    return;
  }
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const AdminApp(),
    ),
  );
}
