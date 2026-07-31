import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'gps_parser.dart';

class MapsLauncher {
  MapsLauncher._();

  /// Opens turn-by-turn directions in Google Maps (origin = user's location).
  static Future<bool> openDirections(
    double lat,
    double lng, {
    BuildContext? context,
  }) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );
    return _launch(uri, context: context);
  }

  /// Opens a location pin in Google Maps.
  static Future<bool> openLocation(
    double lat,
    double lng, {
    String? label,
    BuildContext? context,
  }) async {
    final query = label != null && label.isNotEmpty
        ? Uri.encodeComponent('$lat,$lng ($label)')
        : '$lat,$lng';
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );
    return _launch(uri, context: context);
  }

  /// Opens directions from a GPS string (`"lat,lng"`).
  static Future<bool> openDirectionsFromGps(
    String? gps, {
    BuildContext? context,
  }) async {
    final coords = GpsParser.parseGps(gps);
    if (coords == null) return false;
    return openDirections(coords.lat, coords.lng, context: context);
  }

  static Future<bool> _launch(Uri uri, {BuildContext? context}) async {
    if (!await canLaunchUrl(uri)) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
      return false;
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps')),
      );
    }
    return launched;
  }
}
