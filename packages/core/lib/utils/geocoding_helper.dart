import 'package:geocoding/geocoding.dart';

Future<String?> reverseGeocode(double lat, double lng) async {
  try {
    final places = await placemarkFromCoordinates(lat, lng);
    if (places.isEmpty) return null;
    final p = places.first;
    final parts = <String>[
      if (p.subLocality?.isNotEmpty == true) p.subLocality!,
      if (p.thoroughfare?.isNotEmpty == true) p.thoroughfare!,
      if (p.locality?.isNotEmpty == true) p.locality!,
      if (p.administrativeArea?.isNotEmpty == true) p.administrativeArea!,
    ];
    if (parts.isEmpty) return null;
    return parts.toSet().join(', ');
  } catch (_) {
    return null;
  }
}
