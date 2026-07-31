import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_ui/maps_ui.dart';

import '../../providers/repositories.dart';

class MonitorLocationMapScreen extends ConsumerStatefulWidget {
  const MonitorLocationMapScreen({super.key});

  @override
  ConsumerState<MonitorLocationMapScreen> createState() => _MonitorLocationMapScreenState();
}

class _MonitorLocationMapScreenState extends ConsumerState<MonitorLocationMapScreen> {
  List<MapPin> _shopPins = [];
  List<MapPin> _watchlistPins = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final customerRepo = ref.read(customerRepositoryProvider);
      final watchlistRepo = ref.read(watchlistRepositoryProvider);
      final shops = await customerRepo.mapShops();
      final watchlist = await watchlistRepo.mapPins();
      _shopPins = shops.map(MapPin.fromShopMapJson).toList();
      _watchlistPins = watchlist.map(MapPin.fromWatchlistMapJson).toList();
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Location map')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!),
              const SizedBox(height: 16),
              FilledButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return LocationMapScreen(
      title: 'Location map',
      pins: [..._shopPins, ..._watchlistPins],
      initialFilter: MapLayerFilter.both,
      loading: _loading,
    );
  }
}
