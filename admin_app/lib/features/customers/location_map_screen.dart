import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:maps_ui/maps_ui.dart';

import '../../providers/repositories.dart';

/// Combined shop + watchlist map for admin, with the same filter/sort/search
/// drawer as sales_app's Field Map, plus a multi-select sales person filter
/// (admin sees every rep's book, not just their own).
class AdminLocationMapScreen extends ConsumerStatefulWidget {
  const AdminLocationMapScreen({super.key});

  @override
  ConsumerState<AdminLocationMapScreen> createState() => _AdminLocationMapScreenState();
}

class _AdminLocationMapScreenState extends ConsumerState<AdminLocationMapScreen> {
  List<Map<String, dynamic>> _rawShops = [];
  List<MapPin> _watchlistPins = [];
  List<AreaModel> _areas = [];
  List<SalesPersonModel> _salesPersons = [];
  bool _loading = true;
  String? _error;

  int? _areaFilter;
  String? _frequencyBand;
  int? _priorityMin;
  String? _paymentReliability;
  int? _inactiveDays;
  bool? _hasDue;
  Set<int> _salesPersonIds = {};
  final _searchController = TextEditingController();

  ShopMapSort _sort = ShopMapSort.name;
  Position? _myPosition;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final customerRepo = ref.read(customerRepositoryProvider);
      final watchlistRepo = ref.read(watchlistRepositoryProvider);
      final search = _searchController.text.trim();
      final results = await Future.wait([
        customerRepo.areas(),
        customerRepo.salesPersons().then((r) => r.items),
        customerRepo.mapShops(
          areaId: _areaFilter,
          frequencyBand: _frequencyBand,
          priorityRatingMin: _priorityMin,
          paymentReliability: _paymentReliability,
          inactiveDays: _inactiveDays,
          search: search.isEmpty ? null : search,
          hasDue: _hasDue,
          salesPersonIds: _salesPersonIds,
        ),
        watchlistRepo.mapPins(),
      ]);
      if (!mounted) return;
      setState(() {
        _areas = results[0] as List<AreaModel>;
        _salesPersons = results[1] as List<SalesPersonModel>;
        _rawShops = results[2] as List<Map<String, dynamic>>;
        _watchlistPins = (results[3] as List<Map<String, dynamic>>).map(MapPin.fromWatchlistMapJson).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _onSortChanged(ShopMapSort sort) async {
    if (sort == ShopMapSort.distance && _myPosition == null) {
      if (!await AppPermissions.requestLocation()) return;
      if (!await Geolocator.isLocationServiceEnabled()) return;
      _myPosition = await Geolocator.getCurrentPosition();
    }
    if (mounted) setState(() => _sort = sort);
  }

  double _distanceMeters(Map<String, dynamic> shop) {
    final pos = _myPosition;
    final lat = (shop['lat'] as num?)?.toDouble();
    final lng = (shop['lng'] as num?)?.toDouble();
    if (pos == null || lat == null || lng == null) return double.infinity;
    return Geolocator.distanceBetween(pos.latitude, pos.longitude, lat, lng);
  }

  List<Map<String, dynamic>> get _sortedShops {
    final list = [..._rawShops];
    switch (_sort) {
      case ShopMapSort.name:
        list.sort((a, b) => (a['name']?.toString() ?? '').compareTo(b['name']?.toString() ?? ''));
      case ShopMapSort.priority:
        list.sort((a, b) => ((b['priority_rating'] as int?) ?? -1).compareTo((a['priority_rating'] as int?) ?? -1));
      case ShopMapSort.distance:
        list.sort((a, b) => _distanceMeters(a).compareTo(_distanceMeters(b)));
    }
    return list;
  }

  void _clearFilters() {
    setState(() {
      _areaFilter = null;
      _frequencyBand = null;
      _priorityMin = null;
      _paymentReliability = null;
      _inactiveDays = null;
      _hasDue = null;
      _salesPersonIds = {};
      _searchController.clear();
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Location map')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!),
              const SizedBox(height: 12),
              FilledButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final shopPins = _sortedShops.map(MapPin.fromShopMapJson).toList();
    final activeFilterCount = [
      _areaFilter,
      _frequencyBand,
      _priorityMin,
      _paymentReliability,
      _inactiveDays,
      _hasDue,
    ].where((v) => v != null).length + (_salesPersonIds.isEmpty ? 0 : 1);

    return LocationMapScreen(
      title: activeFilterCount == 0 ? 'Location map' : 'Location map ($activeFilterCount)',
      pins: [...shopPins, ..._watchlistPins],
      initialFilter: MapLayerFilter.both,
      loading: _loading,
      onPinTap: (pin) => pin.type == MapPinType.shop
          ? context.push('/customers/shops/${pin.id}')
          : null,
      endDrawer: ShopMapFiltersDrawer(
        searchController: _searchController,
        onSearchSubmitted: _load,
        areas: _areas,
        areaId: _areaFilter,
        onAreaChanged: (v) {
          setState(() => _areaFilter = v);
          _load();
        },
        frequencyBand: _frequencyBand,
        onFrequencyChanged: (v) {
          setState(() => _frequencyBand = v);
          _load();
        },
        paymentReliability: _paymentReliability,
        onPaymentReliabilityChanged: (v) {
          setState(() => _paymentReliability = v);
          _load();
        },
        priorityMin: _priorityMin,
        onPriorityMinChanged: (v) {
          setState(() => _priorityMin = v);
          _load();
        },
        inactiveDays: _inactiveDays,
        onInactiveDaysChanged: (v) {
          setState(() => _inactiveDays = v);
          _load();
        },
        hasDue: _hasDue,
        onHasDueChanged: (v) {
          setState(() => _hasDue = v);
          _load();
        },
        salesPersons: _salesPersons,
        selectedSalesPersonIds: _salesPersonIds,
        onSalesPersonsChanged: (v) {
          setState(() => _salesPersonIds = v);
          _load();
        },
        sort: _sort,
        onSortChanged: _onSortChanged,
        onClear: _clearFilters,
      ),
    );
  }
}
