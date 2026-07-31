import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../maps_ui.dart' show kDefaultMapLat, kDefaultMapLng, OpenInMapsButton;

enum MapLayerFilter { shops, watchlist, both }

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({
    super.key,
    required this.title,
    required this.pins,
    this.initialFilter = MapLayerFilter.both,
    this.filterHeader,
    this.onPinTap,
    this.loading = false,
  });

  final String title;
  final List<MapPin> pins;
  final MapLayerFilter initialFilter;
  final Widget? filterHeader;
  final void Function(MapPin pin)? onPinTap;
  final bool loading;

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  late MapLayerFilter _filter;
  BitmapDescriptor? _shopIcon;
  BitmapDescriptor? _watchlistIcon;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
    _loadMarkerIcons();
  }

  Future<void> _loadMarkerIcons() async {
    _shopIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    _watchlistIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    if (mounted) setState(() {});
  }

  List<MapPin> get _visiblePins {
    return widget.pins.where((pin) {
      return switch (_filter) {
        MapLayerFilter.shops => pin.type == MapPinType.shop,
        MapLayerFilter.watchlist => pin.type == MapPinType.watchlist,
        MapLayerFilter.both => true,
      };
    }).toList();
  }

  Set<Marker> _buildMarkers() {
    return _visiblePins.map((pin) {
      final hue = pin.type == MapPinType.shop
          ? BitmapDescriptor.hueAzure
          : BitmapDescriptor.hueOrange;
      return Marker(
        markerId: MarkerId('${pin.type.name}_${pin.id}'),
        position: LatLng(pin.lat, pin.lng),
        icon: pin.type == MapPinType.shop
            ? (_shopIcon ?? BitmapDescriptor.defaultMarkerWithHue(hue))
            : (_watchlistIcon ?? BitmapDescriptor.defaultMarkerWithHue(hue)),
        infoWindow: InfoWindow(
          title: pin.title,
          snippet: pin.subtitle,
        ),
        onTap: widget.onPinTap == null ? null : () => widget.onPinTap!(pin),
      );
    }).toSet();
  }

  CameraPosition _initialCamera(List<MapPin> pins) {
    if (pins.length == 1) {
      return CameraPosition(target: LatLng(pins.first.lat, pins.first.lng), zoom: 15);
    }
    return const CameraPosition(
      target: LatLng(kDefaultMapLat, kDefaultMapLng),
      zoom: 11,
    );
  }

  Future<void> _fitBounds(List<MapPin> pins) async {
    if (pins.isEmpty || pins.length == 1) return;
    final controller = await _mapController.future;
    double minLat = pins.first.lat;
    double maxLat = pins.first.lat;
    double minLng = pins.first.lng;
    double maxLng = pins.first.lng;
    for (final pin in pins) {
      minLat = minLat < pin.lat ? minLat : pin.lat;
      maxLat = maxLat > pin.lat ? maxLat : pin.lat;
      minLng = minLng < pin.lng ? minLng : pin.lng;
      maxLng = maxLng > pin.lng ? maxLng : pin.lng;
    }
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 48));
  }

  @override
  void didUpdateWidget(LocationMapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pins != widget.pins) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fitBounds(_visiblePins));
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visiblePins;
    final hasMapKey = AppConfig.hasGoogleMapsApiKey;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SegmentedButton<MapLayerFilter>(
              segments: const [
                ButtonSegment(value: MapLayerFilter.shops, label: Text('Shops')),
                ButtonSegment(value: MapLayerFilter.watchlist, label: Text('Watchlist')),
                ButtonSegment(value: MapLayerFilter.both, label: Text('Both')),
              ],
              selected: {_filter},
              onSelectionChanged: (selected) {
                setState(() => _filter = selected.first);
                _fitBounds(_visiblePins);
              },
            ),
          ),
        ),
      ),
      body: widget.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (widget.filterHeader != null) widget.filterHeader!,
                Expanded(
                  child: hasMapKey
                      ? GoogleMap(
                          initialCameraPosition: _initialCamera(visible),
                          markers: _buildMarkers(),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          onMapCreated: (controller) {
                            _mapController.complete(controller);
                            _fitBounds(visible);
                          },
                        )
                      : _MapUnavailableFallback(pins: visible),
                ),
              ],
            ),
    );
  }
}

class _MapUnavailableFallback extends StatelessWidget {
  const _MapUnavailableFallback({required this.pins});

  final List<MapPin> pins;

  @override
  Widget build(BuildContext context) {
    if (pins.isEmpty) {
      return const Center(child: Text('No locations with GPS'));
    }
    return Column(
      children: [
        MaterialBanner(
          content: const Text(
            'Map unavailable — configure GOOGLE_MAPS_API_KEY for embedded maps. '
            'You can still navigate to each location below.',
          ),
          actions: const [SizedBox.shrink()],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: pins.length,
            itemBuilder: (_, i) {
              final pin = pins[i];
              final gps = '${pin.lat},${pin.lng}';
              return ListTile(
                leading: Icon(
                  pin.type == MapPinType.shop ? Icons.store : Icons.place,
                  color: pin.type == MapPinType.shop ? Colors.blue : Colors.orange,
                ),
                title: Text(pin.title),
                subtitle: Text(pin.subtitle ?? gps),
                trailing: OpenInMapsButton(gps: gps),
              );
            },
          ),
        ),
      ],
    );
  }
}
