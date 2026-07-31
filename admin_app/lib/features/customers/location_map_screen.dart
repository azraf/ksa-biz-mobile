import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_ui/maps_ui.dart';

import '../../providers/repositories.dart';

/// Combined shop + watchlist map for admin (area filter on shops).
class AdminLocationMapScreen extends ConsumerStatefulWidget {
  const AdminLocationMapScreen({super.key});

  @override
  ConsumerState<AdminLocationMapScreen> createState() => _AdminLocationMapScreenState();
}

class _AdminLocationMapScreenState extends ConsumerState<AdminLocationMapScreen> {
  List<MapPin> _shopPins = [];
  List<MapPin> _watchlistPins = [];
  List<AreaModel> _areas = [];
  int? _areaFilter;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final customerRepo = ref.read(customerRepositoryProvider);
      final watchlistRepo = ref.read(watchlistRepositoryProvider);
      _areas = await customerRepo.areas();
      final shops = await customerRepo.mapShops(areaId: _areaFilter);
      final watchlist = await watchlistRepo.mapPins();
      _shopPins = shops.map(MapPin.fromShopMapJson).toList();
      _watchlistPins = watchlist.map(MapPin.fromWatchlistMapJson).toList();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final areaHeader = _areas.isEmpty
        ? null
        : Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: DropdownButtonFormField<int?>(
              value: _areaFilter,
              decoration: const InputDecoration(labelText: 'Filter shops by area'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All areas')),
                ..._areas.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))),
              ],
              onChanged: (v) {
                setState(() => _areaFilter = v);
                _load();
              },
            ),
          );

    return LocationMapScreen(
      title: 'Location map',
      pins: [..._shopPins, ..._watchlistPins],
      initialFilter: MapLayerFilter.both,
      loading: _loading,
      filterHeader: areaHeader,
    );
  }
}
