import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/// Runtime permission helpers for location, camera, microphone, and media.
class AppPermissions {
  static Future<bool> requestLocation() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }
    return status.isGranted;
  }

  static Future<bool> requestCamera() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  static Future<bool> requestMicrophone() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  static Future<bool> requestPhotos() async {
    if (Platform.isAndroid) {
      final photos = await Permission.photos.request();
      if (photos.isGranted) return true;
      final storage = await Permission.storage.request();
      return storage.isGranted;
    }
    final status = await Permission.photos.request();
    return status.isGranted;
  }
}
