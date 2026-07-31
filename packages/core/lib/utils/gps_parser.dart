import 'dart:math' as math;

class GpsCoordinates {
  const GpsCoordinates({required this.lat, required this.lng});

  final double lat;
  final double lng;
}

class GpsParser {
  GpsParser._();

  static GpsCoordinates? parseGps(String? gps) {
    if (gps == null || gps.trim().isEmpty) return null;
    final parts = gps.split(',');
    if (parts.length < 2) return null;
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return null;
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return null;
    return GpsCoordinates(lat: lat, lng: lng);
  }

  static double? distanceMeters(
    double fromLat,
    double fromLng,
    String? gps,
  ) {
    final coords = parseGps(gps);
    if (coords == null) return null;
    return _haversineMeters(fromLat, fromLng, coords.lat, coords.lng);
  }

  static double _haversineMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earthRadiusM = 6371000.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusM * c;
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;
}
