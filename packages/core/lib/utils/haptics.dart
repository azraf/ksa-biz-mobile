import 'package:flutter/services.dart';

class AppHaptics {
  static void light() => HapticFeedback.lightImpact();
  static void success() => HapticFeedback.mediumImpact();
}
