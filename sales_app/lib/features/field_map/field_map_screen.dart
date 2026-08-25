import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';
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
    final l10n = AppLocalizations.of(context);
    final spId = requireSalesPersonId(ref.watch(authProvider));
    if (spId == null) {
      return Scaffold(body: ErrorView(message: l10n.salesSelectSalespersonFirst));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.fieldMapTitle)),
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
      title: activeFilterCount == 0
          ? l10n.fieldMapTitle
          : l10n.fieldMapTitleFiltered(activeFilterCount),
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
    final l10n = AppLocalizations.of(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.fieldMapFiltersSort, style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.fieldMapSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _load(),
            ),
            const SizedBox(height: 16),
            if (_areas.isNotEmpty) ...[
              _fullWidthDropdown<int?>(
                label: l10n.commonArea,
                value: _areaFilter,
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.commonAllAreas)),
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
              label: l10n.fieldMapFrequency,
              value: _frequencyBand,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.fieldMapAnyFrequency)),
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
              label: l10n.fieldMapPayment,
              value: _paymentReliability,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.fieldMapAnyReliability)),
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
              label: l10n.fieldMapMinRating,
              value: _priorityMin,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.fieldMapAnyRating)),
                ...List.generate(5, (i) => i + 1)
                    .map((r) => DropdownMenuItem(value: r, child: Text(l10n.fieldMapStarsPlus(r)))),
              ],
              onChanged: (v) {
                setState(() => _priorityMin = v);
                _load();
              },
            ),
            const SizedBox(height: 12),
            _fullWidthDropdown<int?>(
              label: l10n.fieldMapInactiveFor,
              value: _inactiveDays,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.commonAny)),
                DropdownMenuItem(value: 30, child: Text(l10n.fieldMapDaysPlus(30))),
                DropdownMenuItem(value: 60, child: Text(l10n.fieldMapDaysPlus(60))),
                DropdownMenuItem(value: 90, child: Text(l10n.fieldMapDaysPlus(90))),
              ],
              onChanged: (v) {
                setState(() => _inactiveDays = v);
                _load();
              },
            ),
            const SizedBox(height: 12),
            _fullWidthDropdown<bool?>(
              label: l10n.commonDue,
              value: _hasDue,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.commonAny)),
                DropdownMenuItem(value: true, child: Text(l10n.fieldMapHasDue)),
                DropdownMenuItem(value: false, child: Text(l10n.fieldMapNoDue)),
              ],
              onChanged: (v) {
                setState(() => _hasDue = v);
                _load();
              },
            ),
            const Divider(height: 32),
            _fullWidthDropdown<_MapSort>(
              label: l10n.commonSort,
              value: _sort,
              items: [
                DropdownMenuItem(value: _MapSort.name, child: Text(l10n.commonName)),
                DropdownMenuItem(value: _MapSort.priority, child: Text(l10n.salesWatchlistPriorityRating)),
                DropdownMenuItem(value: _MapSort.distance, child: Text(l10n.fieldMapNearestFirst)),
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
              label: Text(l10n.commonClearFilters),
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
