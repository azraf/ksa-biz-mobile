import 'package:equatable/equatable.dart';

import '../utils/gps_parser.dart';
import 'admin_models.dart';
import 'watchlist_item.dart';

enum MapPinType { shop, watchlist }

class MapPin extends Equatable {
  const MapPin({
    required this.id,
    required this.lat,
    required this.lng,
    required this.title,
    this.subtitle,
    this.type = MapPinType.shop,
  });

  final int id;
  final double lat;
  final double lng;
  final String title;
  final String? subtitle;
  final MapPinType type;

  factory MapPin.fromShopMapJson(Map<String, dynamic> json) {
    return MapPin(
      id: json['id'] as int,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      title: json['name']?.toString() ?? 'Shop',
      subtitle: json['area_name']?.toString(),
      type: MapPinType.shop,
    );
  }

  factory MapPin.fromWatchlistMapJson(Map<String, dynamic> json) {
    return MapPin(
      id: json['id'] as int,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      title: json['name']?.toString() ?? 'Watchlist',
      subtitle: json['sales_person_name']?.toString(),
      type: MapPinType.watchlist,
    );
  }

  factory MapPin.fromGpsString({
    required int id,
    required String gps,
    required String title,
    String? subtitle,
    MapPinType type = MapPinType.shop,
  }) {
    final coords = GpsParser.parseGps(gps);
    if (coords == null) {
      throw ArgumentError('Invalid GPS: $gps');
    }
    return MapPin(
      id: id,
      lat: coords.lat,
      lng: coords.lng,
      title: title,
      subtitle: subtitle,
      type: type,
    );
  }

  factory MapPin.fromWatchlistItem(WatchlistItemModel item) {
    final coords = GpsParser.parseGps(item.gps);
    if (coords == null) {
      throw ArgumentError('Invalid GPS on watchlist item ${item.id}');
    }
    return MapPin(
      id: item.id,
      lat: coords.lat,
      lng: coords.lng,
      title: item.displayTitle,
      subtitle: item.noteText,
      type: MapPinType.watchlist,
    );
  }

  factory MapPin.fromCustomerShop(CustomerShopModel shop) {
    final coords = GpsParser.parseGps(shop.gps);
    if (coords == null) {
      throw ArgumentError('Invalid GPS on shop ${shop.id}');
    }
    return MapPin(
      id: shop.id,
      lat: coords.lat,
      lng: coords.lng,
      title: shop.name,
      subtitle: shop.areaName,
      type: MapPinType.shop,
    );
  }

  static MapPin? tryFromWatchlistItem(WatchlistItemModel item) {
    final coords = GpsParser.parseGps(item.gps);
    if (coords == null) return null;
    return MapPin(
      id: item.id,
      lat: coords.lat,
      lng: coords.lng,
      title: item.displayTitle,
      subtitle: item.noteText,
      type: MapPinType.watchlist,
    );
  }

  @override
  List<Object?> get props => [id, lat, lng, type];
}
