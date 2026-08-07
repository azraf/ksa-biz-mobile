import 'package:flutter/material.dart';

class AppColors {
  static const seed = Color(0xFF0D6E4F);

  static Color success(BuildContext context) => const Color(0xFF1B7F4E);
  static Color successContainer(BuildContext context) => const Color(0xFFD8F3E3);

  static Color warning(BuildContext context) => const Color(0xFFB86E00);
  static Color warningContainer(BuildContext context) => const Color(0xFFFFE8C2);

  static Color pending(BuildContext context) => const Color(0xFF1565C0);
  static Color pendingContainer(BuildContext context) => const Color(0xFFD6E8FF);

  static Color danger(BuildContext context) => const Color(0xFFC62828);
  static Color dangerContainer(BuildContext context) => const Color(0xFFFAD4D4);

  static Color offline(BuildContext context) => Theme.of(context).colorScheme.error;
  static Color offlineContainer(BuildContext context) => Theme.of(context).colorScheme.errorContainer;
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
}
