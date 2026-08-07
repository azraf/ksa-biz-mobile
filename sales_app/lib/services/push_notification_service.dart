import 'package:flutter/foundation.dart';

/// Placeholder for Firebase Cloud Messaging integration.
///
/// Add `firebase_core` + `firebase_messaging`, place `google-services.json`,
/// then call [PushNotificationService.initialize] from `main.dart` after Firebase init.
class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    if (kDebugMode) {
      debugPrint('PushNotificationService: FCM not configured — using pull inbox only.');
    }
    _initialized = true;
  }

  Future<void> subscribeToSalesAlerts() async {
    await initialize();
  }
}
