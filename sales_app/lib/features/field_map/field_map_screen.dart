import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:maps_ui/maps_ui.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

enum _MapSort { name, priority, distance }

const _frequencyBands = ['frequent', 'regular', 'occasional', 'dormant', 'never'];
const _paymentReliabilities = ['good', 'fair', 'poor'];

/// A book-wide, filterable map of the caller's own assigned customers, built
/// on top of the same scoped /reports/map-shops + /reports/map-watchlist
/// endpoints the webapp's Field Map uses. Complements the smaller per-list
/// "peek" maps already on the Customers/Watchlist screens.
class FieldMapScreen extends ConsumerStatefulWidget {
  const FieldMapScreen({super.key});

  @override
  ConsumerState<FieldMapScreen> createState() => _FieldMapScreenState();
}

class _FieldMapScreenState extends ConsumerState<FieldMapScreen> {
  List<Map<String, dynamic>> _rawShops = [];
  List<MapPin> _watchlistPins = [];
  List<SalesPersonAreaModel> _areas = [];
  bool _loading = true;
  String? _error;

  int? _areaFilter;
  String? _frequencyBand;
  int? _priorityMin;
  String? _paymentReliability;
  int? _inactiveDays;
  bool? _hasDue;
  final _searchController = TextEditingController();

  _MapSort _sort = _MapSort.name;
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
    final spId = requireSalesPersonId(ref.read(authProvider));
    try {
      final customerRepo = ref.read(customerRepositoryProvider);
      final watchlistRepo = ref.read(watchlistRepositoryProvider);
      final search = _searchController.text.trim();
      final results = await Future.wait([
        customerRepo.salesPersonAreas(salesPersonId: spId),
        customerRepo.mapShops(
          areaId: _areaFilter,
          frequencyBand: _frequencyBand,
          priorityRatingMin: _priorityMin,
          paymentReliability: _paymentReliability,
          inactiveDays: _inactiveDays,
          search: search.isEmpty ? null : search,
          hasDue: _hasDue,
        ),
        watchlistRepo.mapPins(salesPersonId: spId),
      ]);
      if (!mounted) return;
      setState(() {
        _areas = results[0] as List<SalesPersonAreaModel>;
        _rawShops = results[1] as List<Map<String, dynamic>>;
        _watchlistPins = (results[2] as List<Map<String, dynamic>>).map(MapPin.fromWatchlistMapJson).toList();
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

  Future<void> _sortByDistance() async {
    if (_myPosition == null) {
      if (!await AppPermissions.requestLocation()) return;
      if (!await Geolocator.isLocationServiceEnabled()) return;
      _myPosition = await Geolocator.getCurrentPosition();
    }
    if (mounted) setState(() => _sort = _MapSort.distance);
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
      case _MapSort.name:
        list.sort((a, b) => (a['name']?.toString() ?? '').compareTo(b['name']?.toString() ?? ''));
      case _MapSort.priority:
        list.sort((a, b) => ((b['priority_rating'] as int?) ?? -1).compareTo((a['priority_rating'] as int?) ?? -1));
      case _MapSort.distance:
        list.sort((a, b) => _distanceMeters(a).compareTo(_distanceMeters(b)));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final spId = requireSalesPersonId(ref.watch(authProvider));
    if (spId == null) {
      return const Scaffold(body: ErrorView(message: 'Select a salesperson first.'));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Field map')),
        body: ErrorView(message: _error!, onRetry: _load),
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
    ].where((v) => v != null).length;

    return LocationMapScreen(
      title: activeFilterCount == 0 ? 'Field map' : 'Field map ($activeFilterCount)',
      pins: [...shopPins, ..._watchlistPins],
      initialFilter: MapLayerFilter.both,
      loading: _loading,
      onPinTap: (pin) => pin.type == MapPinType.shop
          ? context.push('/customers/shop/${pin.id}')
          : context.push('/watchlist/${pin.id}'),
      endDrawer: _buildFiltersDrawer(),
    );
  }

  Widget _buildFiltersDrawer() {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filters & sort', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by name or phone',
                prefixIcon: Icon(Icons.search),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _load(),
            ),
            const SizedBox(height: 16),
            if (_areas.isNotEmpty) ...[
              _fullWidthDropdown<int?>(
                label: 'Area',
                value: _areaFilter,
                items: [
                  const DropdownMenuItem(value: null, child: Text('All areas')),
                  ..._areas.map(
                    (a) => DropdownMenuItem(value: a.areaId, child: Text(a.areaName ?? '#${a.areaId}')),
                  ),
                ],
                onChanged: (v) {
                  setState(() => _areaFilter = v);
                  _load();
                },
              ),
              const SizedBox(height: 12),
            ],
            _fullWidthDropdown<String?>(
              label: 'Frequency',
              value: _frequencyBand,
              items: [
                const DropdownMenuItem(value: null, child: Text('Any frequency')),
                ..._frequencyBands.map(
                  (b) => DropdownMenuItem(
                    value: b,
                    child: Text(CustomerMetricsFields(frequencyBand: b).frequencyLabel),
                  ),
                ),
              ],
              onChanged: (v) {
                setState(() => _frequencyBand = v);
                _load();
              },
            ),
            const SizedBox(height: 12),
            _fullWidthDropdown<String?>(
              label: 'Payment',
              value: _paymentReliability,
              items: [
                const DropdownMenuItem(value: null, child: Text('Any reliability')),
                ..._paymentReliabilities.map(
                  (p) => DropdownMenuItem(
                    value: p,
                    child: Text(CustomerMetricsFields(paymentReliability: p).paymentLabel),
                  ),
                ),
              ],
              onChanged: (v) {
                setState(() => _paymentReliability = v);
                _load();
              },
            ),
            const SizedBox(height: 12),
            _fullWidthDropdown<int?>(
              label: 'Min rating',
              value: _priorityMin,
              items: [
                const DropdownMenuItem(value: null, child: Text('Any rating')),
                ...List.generate(5, (i) => i + 1)
                    .map((r) => DropdownMenuItem(value: r, child: Text('$r+ stars'))),
              ],
              onChanged: (v) {
                setState(() => _priorityMin = v);
                _load();
              },
            ),
            const SizedBox(height: 12),
            _fullWidthDropdown<int?>(
              label: 'Inactive for',
              value: _inactiveDays,
              items: const [
                DropdownMenuItem(value: null, child: Text('Any')),
                DropdownMenuItem(value: 30, child: Text('30+ days')),
                DropdownMenuItem(value: 60, child: Text('60+ days')),
                DropdownMenuItem(value: 90, child: Text('90+ days')),
              ],
              onChanged: (v) {
                setState(() => _inactiveDays = v);
                _load();
              },
            ),
            const SizedBox(height: 12),
            _fullWidthDropdown<bool?>(
              label: 'Due',
              value: _hasDue,
              items: const [
                DropdownMenuItem(value: null, child: Text('Any')),
                DropdownMenuItem(value: true, child: Text('Has due')),
                DropdownMenuItem(value: false, child: Text('No due')),
              ],
              onChanged: (v) {
                setState(() => _hasDue = v);
                _load();
              },
            ),
            const Divider(height: 32),
            _fullWidthDropdown<_MapSort>(
              label: 'Sort',
              value: _sort,
              items: const [
                DropdownMenuItem(value: _MapSort.name, child: Text('Name')),
                DropdownMenuItem(value: _MapSort.priority, child: Text('Priority rating')),
                DropdownMenuItem(value: _MapSort.distance, child: Text('Nearest first')),
              ],
              onChanged: (v) {
                if (v == null) return;
                if (v == _MapSort.distance) {
                  _sortByDistance();
                } else {
                  setState(() => _sort = v);
                }
              },
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _areaFilter = null;
                  _frequencyBand = null;
                  _priorityMin = null;
                  _paymentReliability = null;
                  _inactiveDays = null;
                  _hasDue = null;
                  _searchController.clear();
                });
                _load();
              },
              icon: const Icon(Icons.clear),
              label: const Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fullWidthDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, isDense: true),
      items: items,
      onChanged: onChanged,
    );
  }
}
