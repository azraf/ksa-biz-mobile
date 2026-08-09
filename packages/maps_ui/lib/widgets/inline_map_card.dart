import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Small embedded map for one "lat,lng" location on detail screens.
/// Renders nothing when the string doesn't parse or no Maps API key is
/// configured (the existing GpsLocationRow/OpenInMapsButton remain the
/// fallback), so callers can drop it in unconditionally.
class InlineMapCard extends StatelessWidget {
  const InlineMapCard({super.key, required this.gps, this.height = 180});

  final String? gps;
  final double height;

  @override
  Widget build(BuildContext context) {
    final coords = GpsParser.parseGps(gps);
    if (coords == null || !AppConfig.hasGoogleMapsApiKey) {
      return const SizedBox.shrink();
    }

    final position = LatLng(coords.lat, coords.lng);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: height,
        child: GoogleMap(
          // Lite mode renders a static snapshot — cheap enough for a card.
          liteModeEnabled: true,
          initialCameraPosition: CameraPosition(target: position, zoom: 15),
          markers: {Marker(markerId: const MarkerId('location'), position: position)},
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          onTap: (_) => MapsLauncher.openLocation(coords.lat, coords.lng),
        ),
      ),
    );
  }
}
