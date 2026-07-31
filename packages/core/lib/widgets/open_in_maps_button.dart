import 'package:flutter/material.dart';

import '../utils/gps_parser.dart';
import '../utils/maps_launcher.dart';

class OpenInMapsButton extends StatelessWidget {
  const OpenInMapsButton({
    super.key,
    required this.gps,
    this.icon = Icons.directions,
    this.tooltip = 'Navigate in Google Maps',
  });

  final String? gps;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    if (GpsParser.parseGps(gps) == null) return const SizedBox.shrink();
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: () => MapsLauncher.openDirectionsFromGps(gps, context: context),
    );
  }
}
