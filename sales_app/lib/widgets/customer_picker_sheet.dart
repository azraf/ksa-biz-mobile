import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../providers/connectivity_provider.dart';
import '../providers/repositories.dart';
import 'quick_create_customer.dart';
import 'customer_diary_sheet.dart';

typedef CustomerPickerResult = ({
  String typeName,
  dynamic customer,
});

Future<CustomerPickerResult?> showCustomerPickerSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String customerType,
  required int? salesPersonId,
}) {
  return showModalBottomSheet<CustomerPickerResult>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => CustomerPickerSheet(
      customerType: customerType,
      salesPersonId: salesPersonId,
    ),
  );
}

class CustomerPickerSheet extends ConsumerStatefulWidget {
  const CustomerPickerSheet({
    super.key,
    required this.customerType,
    required this.salesPersonId,
  });

  final String customerType;
  final int? salesPersonId;

  @override
  ConsumerState<CustomerPickerSheet> createState() => _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends ConsumerState<CustomerPickerSheet> {
  final _searchController = TextEditingController();
  static const _perPage = 25;

  int? _activityDays;
  int? _areaId;
  String _sort = 'name';
  int _page = 1;
  int _lastPage = 1;
  bool _loading = true;
  String? _error;
  bool _phoneSearchMode = false;
  List<dynamic> _items = [];
  List<AreaModel> _areas = [];
  double? _lat;
  double? _lng;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadAreas();
    _fetch();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _fetch(page: 1));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  String get _title => switch (widget.customerType) {
        'customer_shop' => 'Select shop',
        'customer_van' => 'Select van',
        'customer_importer' => 'Select importer',
        _ => 'Select customer',
      };

  bool _isPhoneQuery(String q) {
    final digits = q.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 7;
  }

  Future<void> _loadAreas() async {
    if (!ref.read(onlineStatusProvider)) return;
    try {
      _areas = await ref.read(customerRepositoryProvider).areas();
      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _fetch({int? page}) async {
    setState(() {
      _loading = true;
      _error = null;
      if (page != null) _page = page;
    });

    final search = _searchController.text.trim();
    _phoneSearchMode = _isPhoneQuery(search);
    final online = ref.read(onlineStatusProvider);
    final repo = ref.read(offlineCustomerRepositoryProvider);
    final spId = widget.salesPersonId;

    try {
      if (_phoneSearchMode && online) {
        final result = await repo.salesCustomersPhoneSearch(
          search: search,
          page: _page,
          customerType: widget.customerType,
        );
        if (!mounted) return;
        setState(() {
          _items = result.items;
          _lastPage = result.lastPage;
          _loading = false;
        });
        return;
      }

      if (!online && (_activityDays != null || _areaId != null)) {
        setState(() {
          _error = 'Activity and area filters require internet.';
          _loading = false;
        });
        return;
      }

      if (widget.customerType == 'customer_shop') {
        if (_sort == 'distance' && _lat == null) await _captureLocation();
        final result = await repo.shops(
          search: search.isEmpty ? null : search,
          salesPersonId: spId,
          scoped: !_phoneSearchMode,
          lastOrderWithinDays: _activityDays,
          areaId: _areaId,
          sort: _sort,
          lat: _lat,
          lng: _lng,
          page: _page,
          perPage: _perPage,
        );
        if (!mounted) return;
        setState(() {
          _items = result.items;
          _lastPage = result.lastPage;
          _loading = false;
        });
      } else if (widget.customerType == 'customer_van') {
        final result = await repo.vans(
          search: search.isEmpty ? null : search,
          salesPersonId: spId,
          scoped: !_phoneSearchMode,
          lastOrderWithinDays: _activityDays,
          areaId: _areaId,
          page: _page,
          perPage: _perPage,
        );
        if (!mounted) return;
        setState(() {
          _items = result.items;
          _lastPage = result.lastPage;
          _loading = false;
        });
      } else {
        final result = await repo.importers(
          search: search.isEmpty ? null : search,
          salesPersonId: spId,
          scoped: !_phoneSearchMode,
          lastOrderWithinDays: _activityDays,
          areaId: _areaId,
          page: _page,
          perPage: _perPage,
        );
        if (!mounted) return;
        setState(() {
          _items = result.items;
          _lastPage = result.lastPage;
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _captureLocation() async {
    if (!await AppPermissions.requestLocation()) return;
    if (!await Geolocator.isLocationServiceEnabled()) return;
    final pos = await Geolocator.getCurrentPosition();
    _lat = pos.latitude;
    _lng = pos.longitude;
  }

  Future<void> _quickCreate() async {
    final created = await showQuickCreateCustomerSheet(
      context: context,
      ref: ref,
      customerType: widget.customerType,
      salesPersonId: widget.salesPersonId,
    );
    if (created != null && mounted) {
      Navigator.pop(context, (typeName: widget.customerType, customer: created));
    }
  }

  void _selectItem(dynamic item) {
    if (item is SalesCustomerRow) {
      dynamic customer;
      if (item.type == 'customer_shop') {
        customer = CustomerShopModel(id: item.id, name: item.name);
      } else if (item.type == 'customer_van') {
        customer = CustomerVanModel(id: item.id, name: item.name, mobile: item.phone);
      } else {
        customer = CustomerImporterModel(id: item.id, name: item.name, mobile: item.phone);
      }
      Navigator.pop(context, (typeName: item.type, customer: customer));
      return;
    }
    Navigator.pop(context, (typeName: widget.customerType, customer: item));
  }

  Widget _buildSubtitle(dynamic item) {
    if (item is SalesCustomerRow) {
      return Text([item.phone, item.areaName].where((e) => e != null && e.isNotEmpty).join(' · '));
    }
    if (item is CustomerShopModel) {
      final parts = <String>[];
      final pc = item.primaryContact;
      if (pc?.contactName != null && pc!.contactName!.isNotEmpty) parts.add(pc.contactName!);
      if (pc?.contactMobile != null && pc!.contactMobile!.isNotEmpty) parts.add(pc.contactMobile!);
      if (item.areaName != null) parts.add(item.areaName!);
      if (item.distanceKm != null) parts.add('${item.distanceKm} km');
      return Text(parts.join(' · '));
    }
    if (item is CustomerVanModel || item is CustomerImporterModel) {
      final mobile = item is CustomerVanModel ? item.mobile : (item as CustomerImporterModel).mobile;
      final area = item is CustomerVanModel ? item.areaName : (item as CustomerImporterModel).areaName;
      return Text([mobile, area].where((e) => e != null && e.isNotEmpty).join(' · '));
    }
    return const SizedBox.shrink();
  }

  bool _isInactive(dynamic item) {
    if (item is SalesCustomerRow) return item.isInactive;
    if (item is CustomerShopModel) return item.isInactive;
    if (item is CustomerVanModel) return item.isInactive;
    if (item is CustomerImporterModel) return item.isInactive;
    return false;
  }

  String _itemName(dynamic item) {
    if (item is SalesCustomerRow) return item.name;
    if (item is CustomerShopModel) return item.name;
    if (item is CustomerVanModel) return item.name;
    if (item is CustomerImporterModel) return item.name;
    return '';
  }

  CustomerMetricsFields? _metrics(dynamic item) {
    if (item is CustomerShopModel) return item.metrics;
    if (item is CustomerVanModel) return item.metrics;
    if (item is CustomerImporterModel) return item.metrics;
    return null;
  }

  ({String type, int id, String name})? _diaryTarget(dynamic item) {
    if (item is CustomerShopModel) {
      return (type: 'customer_shop', id: item.id, name: item.name);
    }
    if (item is CustomerVanModel) {
      return (type: 'customer_van', id: item.id, name: item.name);
    }
    if (item is CustomerImporterModel) {
      return (type: 'customer_importer', id: item.id, name: item.name);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.85;
    final online = ref.watch(onlineStatusProvider);
    final needsNetwork = !online && (_activityDays != null || _areaId != null || _phoneSearchMode);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            ListTile(
              title: Text(_title, style: Theme.of(context).textTheme.titleMedium),
              trailing: IconButton(
                icon: const Icon(Icons.person_add),
                tooltip: 'Add customer',
                onPressed: _quickCreate,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search name, phone, contact',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (_) => _fetch(page: 1),
                    ),
                  ),
                  IconButton(onPressed: () => _fetch(page: 1), icon: const Icon(Icons.search)),
                ],
              ),
            ),
            if (needsNetwork)
              MaterialBanner(
                content: const Text('Some filters require internet. Showing cached customers only.'),
                actions: [TextButton(onPressed: () {}, child: const SizedBox.shrink())],
              ),
            if (_phoneSearchMode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  'Searching all customers by phone',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  DropdownButton<int?>(
                    value: _activityDays,
                    hint: const Text('Order placed'),
                    items: customerActivityFilterOptions
                        .map((e) => DropdownMenuItem(value: e.$1, child: Text(e.$2)))
                        .toList(),
                    onChanged: (v) {
                      setState(() => _activityDays = v);
                      _fetch(page: 1);
                    },
                  ),
                  const SizedBox(width: 8),
                  if (_areas.isNotEmpty)
                    DropdownButton<int?>(
                      value: _areaId,
                      hint: const Text('Area'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All areas')),
                        ..._areas.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))),
                      ],
                      onChanged: (v) {
                        setState(() => _areaId = v);
                        _fetch(page: 1);
                      },
                    ),
                  if (widget.customerType == 'customer_shop') ...[
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _sort,
                      items: const [
                        DropdownMenuItem(value: 'name', child: Text('A–Z')),
                        DropdownMenuItem(value: 'distance', child: Text('Nearest')),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _sort = v);
                        _fetch(page: 1);
                      },
                    ),
                  ],
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? const Center(child: Text('No customers found'))
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final item = _items[i];
                            return ListTile(
                              title: Text(_itemName(item)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSubtitle(item),
                                  if (_metrics(item) != null) ...[
                                    const SizedBox(height: 4),
                                    CustomerMetricsBadges(metrics: _metrics(item)!, compact: true),
                                  ],
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_diaryTarget(item) case final target?)
                                    IconButton(
                                      icon: const Icon(Icons.notes_outlined),
                                      tooltip: 'Diary',
                                      onPressed: () => showCustomerDiarySheet(
                                        context: context,
                                        ref: ref,
                                        customerType: target.type,
                                        customerId: target.id,
                                        customerName: target.name,
                                      ),
                                    ),
                                  if (_isInactive(item))
                                    const Chip(
                                      label: Text('Inactive 60d+', style: TextStyle(fontSize: 10)),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                ],
                              ),
                              onTap: () => _selectItem(item),
                            );
                          },
                        ),
            ),
            if (_lastPage > 1)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _page > 1 ? () => _fetch(page: _page - 1) : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text('Page $_page of $_lastPage'),
                    IconButton(
                      onPressed: _page < _lastPage ? () => _fetch(page: _page + 1) : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
