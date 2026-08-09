import 'package:flutter/material.dart';

/// Semantic status tokens, brightness-aware. Foreground colors hold >=4.5:1
/// on their matching container in both modes.
class AppColors {
  static const seed = Color(0xFF4053B4);

  static bool _dark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;

  static Color success(BuildContext c) =>
      _dark(c) ? const Color(0xFF7DDA9C) : const Color(0xFF166534);
  static Color successContainer(BuildContext c) =>
      _dark(c) ? const Color(0xFF14432A) : const Color(0xFFDCFCE7);

  static Color warning(BuildContext c) =>
      _dark(c) ? const Color(0xFFFFC46B) : const Color(0xFF92400E);
  static Color warningContainer(BuildContext c) =>
      _dark(c) ? const Color(0xFF4A3007) : const Color(0xFFFEF3C7);

  static Color pending(BuildContext c) =>
      _dark(c) ? const Color(0xFF8FC3FF) : const Color(0xFF1D4ED8);
  static Color pendingContainer(BuildContext c) =>
      _dark(c) ? const Color(0xFF1B3358) : const Color(0xFFDBEAFE);

  static Color danger(BuildContext c) =>
      _dark(c) ? const Color(0xFFFFA8A0) : const Color(0xFFB91C1C);
  static Color dangerContainer(BuildContext c) =>
      _dark(c) ? const Color(0xFF4F1512) : const Color(0xFFFEE2E2);

  static Color offline(BuildContext c) => Theme.of(c).colorScheme.error;
  static Color offlineContainer(BuildContext c) => Theme.of(c).colorScheme.errorContainer;
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  /// Bottom list padding so the last rows can scroll clear of a FAB.
  static const fabClearance = 88.0;
}

class AppRadii {
  static const sm = 10.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
}

class AppDurations {
  static const fast = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 350);
}
