import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';
import 'package:maps_ui/maps_ui.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import 'customer_diary_section.dart';

class CustomerDetailRouteArgs {
  const CustomerDetailRouteArgs({required this.customerType, required this.customer});

  final String customerType;
  final dynamic customer;
}

class CustomersHubScreen extends ConsumerWidget {
  const CustomersHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spId = requireSalesPersonId(ref.watch(authProvider));
    if (spId == null) {
      return ErrorView(message: l10n.salesSelectSalespersonFirst);
    }

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(l10n.salesCustomersAssignedOnly, style: Theme.of(context).textTheme.bodySmall),
                ),
                TabBar(
                  tabs: [
                    Tab(text: l10n.salesCustomersShops),
                    Tab(text: l10n.salesCustomersVans),
                    Tab(text: l10n.salesCustomersImporters),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _CustomerTypeList(customerType: 'customer_shop', salesPersonId: spId),
                _CustomerTypeList(customerType: 'customer_van', salesPersonId: spId),
                _CustomerTypeList(customerType: 'customer_importer', salesPersonId: spId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerTypeList extends ConsumerStatefulWidget {
  const _CustomerTypeList({
    required this.customerType,
    required this.salesPersonId,
  });

  final String customerType;
  final int salesPersonId;

  @override
  ConsumerState<_CustomerTypeList> createState() => _CustomerTypeListState();
}

class _CustomerTypeListState extends ConsumerState<_CustomerTypeList> {
  static const _perPage = 25;

  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _loading = true;
  String? _error;
  List<dynamic> _items = [];
  int _page = 1;
  int _lastPage = 1;
  bool _loadingMore = false;
  double? _lat;
  double? _lng;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _load(page: 1));
  }

  Future<void> _captureLocation() async {
    if (!await AppPermissions.requestLocation()) return;
    if (!await Geolocator.isLocationServiceEnabled()) return;
    final pos = await Geolocator.getCurrentPosition();
    _lat = pos.latitude;
    _lng = pos.longitude;
  }

  Future<void> _load({int? page, bool append = false}) async {
    if (page != null) _page = page;
    setState(() {
      if (append) {
        _loadingMore = true;
      } else {
        _loading = true;
        _error = null;
      }
    });

    final search = _searchController.text.trim();
    final repo = ref.read(offlineCustomerRepositoryProvider);

    try {
      PaginatedResponse<dynamic> result;
      if (widget.customerType == 'customer_shop') {
        if (_lat == null && _lng == null) await _captureLocation();
        result = await repo.shops(
          search: search.isEmpty ? null : search,
          salesPersonId: widget.salesPersonId,
          scoped: true,
          sort: _lat != null ? 'distance' : 'name',
          lat: _lat,
          lng: _lng,
          page: _page,
          perPage: _perPage,
        );
      } else if (widget.customerType == 'customer_van') {
        result = await repo.vans(
          search: search.isEmpty ? null : search,
          salesPersonId: widget.salesPersonId,
          scoped: true,
          page: _page,
          perPage: _perPage,
        );
      } else {
        result = await repo.importers(
          search: search.isEmpty ? null : search,
          salesPersonId: widget.salesPersonId,
          scoped: true,
          page: _page,
          perPage: _perPage,
        );
      }

      if (!mounted) return;
      setState(() {
        if (append) {
          _items = [..._items, ...result.items];
        } else {
          _items = result.items;
        }
        _lastPage = result.lastPage;
        _loading = false;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
        _loadingMore = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _page >= _lastPage) return;
    _page++;
    await _load(append: true);
  }

  String _itemName(dynamic item) {
    if (item is CustomerShopModel) return item.name;
    if (item is CustomerVanModel) return item.name;
    if (item is CustomerImporterModel) return item.name;
    return '';
  }

  String? _phone(dynamic item) {
    if (item is CustomerShopModel) return item.primaryContact?.contactMobile;
    if (item is CustomerVanModel) return item.mobile;
    if (item is CustomerImporterModel) return item.mobile;
    return null;
  }

  CustomerMetricsFields? _metrics(dynamic item) {
    if (item is CustomerShopModel) return item.metrics;
    if (item is CustomerVanModel) return item.metrics;
    if (item is CustomerImporterModel) return item.metrics;
    return null;
  }

  String _detailPath(dynamic item) {
    final id = switch (item) {
      CustomerShopModel(:final id) => id,
      CustomerVanModel(:final id) => id,
      CustomerImporterModel(:final id) => id,
      _ => 0,
    };
    final segment = switch (widget.customerType) {
      'customer_shop' => 'shop',
      'customer_van' => 'van',
      _ => 'importer',
    };
    return '/customers/$segment/$id';
  }

  void _openMap() {
    final l10n = AppLocalizations.of(context);
    final pins = <MapPin>[];
    for (final shop in _items.whereType<CustomerShopModel>()) {
      if (GpsParser.parseGps(shop.gps) == null) continue;
      pins.add(MapPin.fromCustomerShop(shop));
    }
    if (pins.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LocationMapScreen(
          title: l10n.salesCustomersNearby,
          pins: pins,
          initialFilter: MapLayerFilter.shops,
          onPinTap: (pin) => context.push('/customers/shop/${pin.id}'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: l10n.salesPickerSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                  ),
                ),
              ),
              if (widget.customerType == 'customer_shop' && _items.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.map_outlined),
                  tooltip: l10n.salesCustomersNearby,
                  onPressed: _openMap,
                ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? LoadingView(message: l10n.commonLoading)
              : _error != null
                  ? ErrorView(message: _error!, onRetry: () => _load(page: 1))
                  : _items.isEmpty
                      ? EmptyView(message: l10n.salesCustomersEmpty)
                      : RefreshIndicator(
                          onRefresh: () => _load(page: 1),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: _items.length + (_page < _lastPage ? 1 : 0),
                            itemBuilder: (_, index) {
                              if (index >= _items.length) {
                                if (!_loadingMore) _loadMore();
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              final item = _items[index];
                              final metrics = _metrics(item);
                              return ListTile(
                                leading: Icon(
                                  switch (widget.customerType) {
                                    'customer_shop' => Icons.store,
                                    'customer_van' => Icons.local_shipping,
                                    _ => Icons.import_export,
                                  },
                                ),
                                title: Text(_itemName(item)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_subtitle(item) != null) Text(_subtitle(item)!),
                                    if (metrics != null) CustomerMetricsBadges(metrics: metrics, compact: true),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ContactActionButtons(phoneNumber: _phone(item), compact: true),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                                onTap: () => context.push(
                                  _detailPath(item),
                                  extra: CustomerDetailRouteArgs(
                                    customerType: widget.customerType,
                                    customer: item,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }

  String? _subtitle(dynamic item) {
    if (item is CustomerShopModel) {
      final parts = <String>[];
      if (item.areaName != null) parts.add(item.areaName!);
      if (item.distanceKm != null) parts.add('${item.distanceKm} km');
      if (item.lastOrderAt != null) parts.add(_formatLastOrder(item.lastOrderAt!));
      return parts.isEmpty ? null : parts.join(' · ');
    }
    if (item is CustomerVanModel || item is CustomerImporterModel) {
      final area = item is CustomerVanModel ? item.areaName : (item as CustomerImporterModel).areaName;
      final mobile = item is CustomerVanModel ? item.mobile : (item as CustomerImporterModel).mobile;
      final parts = [mobile, area, if (item.lastOrderAt != null) _formatLastOrder(item.lastOrderAt!)];
      return parts.whereType<String>().where((s) => s.isNotEmpty).join(' · ');
    }
    return null;
  }

  String _formatLastOrder(String iso) {
    final date = DateTime.tryParse(iso);
    if (date == null) return iso;
    return DateFormat('d MMM y').format(date.toLocal());
  }
}

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({
    super.key,
    required this.customerType,
    required this.customerId,
    this.initialCustomer,
  });

  final String customerType;
  final int customerId;
  final dynamic initialCustomer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final customer = initialCustomer;
    final name = _name(customer);
    final phone = _phone(customer);
    final area = _area(customer);
    final gps = customer is CustomerShopModel ? customer.gps : null;
    final metrics = _metrics(customer);
    final lastOrder = _lastOrder(customer);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(name, style: Theme.of(context).textTheme.headlineSmall),
        if (area != null) ...[
          const SizedBox(height: 4),
          Text(area, style: Theme.of(context).textTheme.bodyMedium),
        ],
        if (phone != null && phone.isNotEmpty) ...[
          const SizedBox(height: 8),
          ContactActionButtons(phoneNumber: phone),
        ],
        if (metrics != null) ...[
          const SizedBox(height: 12),
          CustomerMetricsBadges(metrics: metrics),
        ],
        if (lastOrder != null) ...[
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.history),
            title: Text(l10n.salesCustomerActivity),
            subtitle: Text(lastOrder),
          ),
        ],
        if (gps != null && gps.isNotEmpty) ...[
          const SizedBox(height: 8),
          GpsLocationRow(gps: gps),
          const SizedBox(height: 8),
          OpenInMapsButton(gps: gps),
        ],
        const SizedBox(height: 16),
        Text(l10n.salesCustomerDiary, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        CustomerDiarySection(customerType: customerType, customerId: customerId),
      ],
    );
  }

  String _name(dynamic customer) {
    if (customer is CustomerShopModel) return customer.name;
    if (customer is CustomerVanModel) return customer.name;
    if (customer is CustomerImporterModel) return customer.name;
    return '#$customerId';
  }

  String? _phone(dynamic customer) {
    if (customer is CustomerShopModel) return customer.primaryContact?.contactMobile;
    if (customer is CustomerVanModel) return customer.mobile;
    if (customer is CustomerImporterModel) return customer.mobile;
    return null;
  }

  String? _area(dynamic customer) {
    if (customer is CustomerShopModel) return customer.areaName;
    if (customer is CustomerVanModel) return customer.areaName;
    if (customer is CustomerImporterModel) return customer.areaName;
    return null;
  }

  CustomerMetricsFields? _metrics(dynamic customer) {
    if (customer is CustomerShopModel) return customer.metrics;
    if (customer is CustomerVanModel) return customer.metrics;
    if (customer is CustomerImporterModel) return customer.metrics;
    return null;
  }

  String? _lastOrder(dynamic customer) {
    String? raw;
    if (customer is CustomerShopModel) raw = customer.lastOrderAt;
    if (customer is CustomerVanModel) raw = customer.lastOrderAt;
    if (customer is CustomerImporterModel) raw = customer.lastOrderAt;
    if (raw == null) return null;
    final date = DateTime.tryParse(raw);
    if (date == null) return raw;
    return DateFormat('d MMM y, HH:mm').format(date.toLocal());
  }
}
