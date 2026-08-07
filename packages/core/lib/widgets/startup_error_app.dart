import 'package:flutter/material.dart';

/// Minimal fallback UI when startup initialization fails before the main app loads.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({
    super.key,
    required this.title,
    required this.message,
    this.exportData,
  });

  final String title;
  final String message;
  final String? exportData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
                if (exportData != null) ...[
                  const SizedBox(height: 16),
                  SelectableText(
                    exportData!,
                    style: const TextStyle(fontSize: 11),
                    maxLines: 8,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
