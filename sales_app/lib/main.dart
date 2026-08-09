import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'services/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await LocalDatabase.instance.database;
  } catch (e) {
    Map<String, dynamic>? export;
    try {
      export = await LocalDatabase.instance.exportRecoveryData();
    } catch (_) {}
    runApp(StartupErrorApp(
      title: 'Failed to start ARM Sales',
      message: 'Could not open offline database.\n\n$e',
      exportData: export != null ? jsonEncode(export) : null,
    ));
    return;
  }
  final prefs = await SharedPreferences.getInstance();
  await PushNotificationService.instance.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SalesApp(),
    ),
  );
}
