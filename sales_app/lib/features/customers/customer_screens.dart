import 'dart:async';

import 'package:core/core.dart' hide showQuickCreateCustomerSheet;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';
import 'package:maps_ui/maps_ui.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import '../../widgets/quick_create_customer.dart';
import '../plan/visit_form_sheet.dart';
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
      return Scaffold(
        appBar: AppBar(title: Text(l10n.salesCustomersTitle)),
        body: ErrorView(message: l10n.salesSelectSalespersonFirst),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.salesCustomersTitle),
      ),
      body: DefaultTabController(
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
                    child: Text(
                      l10n.salesCustomersAssignedOnly,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
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
  late ListSortMode _sortMode;

  String _listKey() => 'sales_${widget.customerType}';

  @override
  void initState() {
    super.initState();
    final prefs = ListSortPreference(ref.read(sharedPreferencesProvider));
    _sortMode = prefs.read(
      _listKey(),
      defaultMode: prefs.defaultForList(_listKey()),
    );
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
    final search = _searchController.text.trim();
    final repo = ref.read(offlineCustomerRepositoryProvider);

    // Cache-first paint: on a cold first load (nothing on screen yet), show
    // the local snapshot instantly instead of waiting on the network — the
    // live fetch below still runs right after and silently replaces it.
    if (!append && _page == 1 && _items.isEmpty) {
      try {
        final cached = await _cachedPage(repo, search);
        if (cached.isNotEmpty && mounted) {
          setState(() {
            _items = _clientSort(cached);
            _loading = false;
          });
        }
      } catch (_) {}
    }

    setState(() {
      if (append) {
        _loadingMore = true;
      } else if (_items.isEmpty) {
        _loading = true;
      }
      _error = null;
    });

    final sortParam = _apiSortParam();

    try {
      PaginatedResponse<dynamic> result;
      if (widget.customerType == 'customer_shop') {
        if (_lat == null && _lng == null) await _captureLocation();
        final prefs = ListSortPreference(ref.read(sharedPreferencesProvider));
        if (_lat != null && _lng != null && !prefs.hasSaved(_listKey())) {
          _sortMode = ListSortMode.distance;
        }
        result = await repo.shops(
          search: search.isEmpty ? null : search,
          salesPersonId: widget.salesPersonId,
          scoped: true,
          sort: sortParam,
          lat: _sortMode == ListSortMode.distance ? _lat : null,
          lng: _sortMode == ListSortMode.distance ? _lng : null,
          page: _page,
          perPage: _perPage,
        );
      } else if (widget.customerType == 'customer_van') {
        result = await repo.vans(
          search: search.isEmpty ? null : search,
          salesPersonId: widget.salesPersonId,
          scoped: true,
          sort: sortParam,
          page: _page,
          perPage: _perPage,
        );
      } else {
        result = await repo.importers(
          search: search.isEmpty ? null : search,
          salesPersonId: widget.salesPersonId,
          scoped: true,
          sort: sortParam,
          page: _page,
          perPage: _perPage,
        );
      }

      var items = result.items;
      items = _clientSort(items);

      if (!mounted) return;
      setState(() {
        if (append) {
          _items = [..._items, ...items];
        } else {
          _items = items;
        }
        _lastPage = result.lastPage;
        _loading = false;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        // A cached page is already on screen (from the fast path above or a
        // prior load) — leave it up rather than replacing it with a full
        // error screen over a background refresh failure.
        if (_items.isEmpty) _error = e.toString();
        _loading = false;
        _loadingMore = false;
      });
    }
  }

  Future<List<dynamic>> _cachedPage(OfflineCustomerRepository repo, String search) async {
    final s = search.isEmpty ? null : search;
    switch (widget.customerType) {
      case 'customer_van':
        return (await repo.cachedVans(search: s, perPage: _perPage)).items;
      case 'customer_importer':
        return (await repo.cachedImporters(search: s, perPage: _perPage)).items;
      default:
        return (await repo.cachedShops(search: s, perPage: _perPage)).items;
    }
  }

  String _apiSortParam() {
    if (widget.customerType == 'customer_shop' &&
        _sortMode == ListSortMode.distance &&
        _lat != null &&
        _lng != null) {
      return 'distance';
    }
    return _sortMode.apiSortParam();
  }

  List<dynamic> _clientSort(List<dynamic> items) {
    return sortByListMode(
      items,
      _sortMode,
      dateIso: customerActivityDateIso,
      name: _itemName,
      area: (item) {
        if (item is CustomerShopModel) return item.areaName;
        if (item is CustomerVanModel) return item.areaName;
        if (item is CustomerImporterModel) return item.areaName;
        return null;
      },
      distanceKm: (item) => item is CustomerShopModel ? item.distanceKm?.toDouble() : null,
    );
  }

  List<ListSortMode> _sortModes() {
    if (widget.customerType == 'customer_shop') {
      return [
        ListSortMode.distance,
        ListSortMode.date,
        ListSortMode.name,
        ListSortMode.area,
      ];
    }
    return [ListSortMode.date, ListSortMode.name, ListSortMode.area];
  }

  Future<void> _onSortChanged(ListSortMode mode) async {
    _sortMode = mode;
    await ListSortPreference(ref.read(sharedPreferencesProvider)).write(_listKey(), mode);
    await _load(page: 1);
  }

  Future<void> _openQuickCreate() async {
    final created = await showQuickCreateCustomerSheet(
      context: context,
      ref: ref,
      customerType: widget.customerType,
      salesPersonId: widget.salesPersonId,
    );
    if (created == null || !mounted) return;
    await _load(page: 1);
    if (!mounted) return;
    context.push(
      _detailPath(created),
      extra: CustomerDetailRouteArgs(
        customerType: widget.customerType,
        customer: created,
      ),
    );
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
              ListSortButton(
                modes: _sortModes(),
                selected: _sortMode,
                onSelected: _onSortChanged,
              ),
              IconButton(
                icon: const Icon(Icons.person_add_outlined),
                tooltip: l10n.commonCreateCustomer,
                onPressed: _openQuickCreate,
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
                      ? EmptyView(
                          message: l10n.salesCustomersEmpty,
                          actionLabel: l10n.commonCreateCustomer,
                          onAction: _openQuickCreate,
                        )
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
                              return _CustomerListTile(
                                customerType: widget.customerType,
                                name: _itemName(item),
                                subtitle: customerListSubtitle(item),
                                metrics: _metrics(item),
                                phoneNumber: _phone(item),
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
}

/// Custom row avoids ListTile.subtitle Column/Wrap layout crashes (blank rows in release).
class _CustomerListTile extends StatelessWidget {
  const _CustomerListTile({
    required this.customerType,
    required this.name,
    required this.subtitle,
    required this.metrics,
    required this.phoneNumber,
    required this.onTap,
  });

  final String customerType;
  final String name;
  final String subtitle;
  final CustomerMetricsFields? metrics;
  final String? phoneNumber;
  final VoidCallback onTap;

  IconData get _leadingIcon => switch (customerType) {
        'customer_shop' => Icons.store,
        'customer_van' => Icons.local_shipping,
        _ => Icons.import_export,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_leadingIcon),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name, style: theme.textTheme.titleMedium),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (metrics != null) ...[
                    const SizedBox(height: 4),
                    CustomerMetricsBadges(metrics: metrics!, compact: true),
                  ],
                ],
              ),
            ),
            ContactActionButtons(phoneNumber: phoneNumber, compact: true),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class CustomerDetailScreen extends ConsumerStatefulWidget {
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
  ConsumerState<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  late dynamic _customer;
  CustomerFinancialSummary? _summary;
  List<OrderModel> _recentOrders = const [];
  bool _ordersLoaded = false;

  @override
  void initState() {
    super.initState();
    _customer = widget.initialCustomer;
    _loadMoney();
  }

  /// Money summary (shops only — the API defines no van/importer summary) and
  /// the first few orders. Server-side data: hidden while absent or offline.
  Future<void> _loadMoney() async {
    if (widget.customerType == 'customer_shop') {
      try {
        final summary = await ref.read(customerRepositoryProvider).shopSummary(widget.customerId);
        if (mounted) setState(() => _summary = summary);
      } catch (_) {}
    }
    try {
      final result = await ref.read(orderRepositoryProvider).list(
            query: OrderListQuery(
              customerType: widget.customerType,
              customerId: widget.customerId,
              perPage: 5,
            ),
          );
      if (mounted) {
        setState(() {
          _recentOrders = result.items;
          _ordersLoaded = true;
        });
      }
    } catch (_) {}
  }

  Future<void> _reloadCustomer() async {
    final repo = ref.read(customerRepositoryProvider);
    setState(() {
      _customer = switch (widget.customerType) {
        'customer_van' => null,
        'customer_importer' => null,
        _ => null,
      };
    });
    final updated = switch (widget.customerType) {
      'customer_van' => await repo.getVan(widget.customerId),
      'customer_importer' => await repo.getImporter(widget.customerId),
      _ => await repo.getShop(widget.customerId),
    };
    if (mounted) setState(() => _customer = updated);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final customer = _customer;
    final name = _name(customer);
    final phone = _phone(customer);
    final area = _area(customer);
    final gps = customer is CustomerShopModel ? customer.gps : null;
    final metrics = _metrics(customer);
    final lastOrder = _lastOrder(customer);
    final createdAt = _createdAt(customer);

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
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
          if (createdAt != null) ...[
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: const Text('Created'),
              subtitle: Text(createdAt),
            ),
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
            InlineMapCard(gps: gps),
            const SizedBox(height: 8),
            OpenInMapsButton(gps: gps),
          ],
          if (_summary != null) ...[
            const SizedBox(height: 16),
            CustomerMoneySummaryCard(summary: _summary!),
          ],
          if (_ordersLoaded) ...[
            const SizedBox(height: 16),
            SectionHeader(
              title: l10n.customerOrdersTitle,
              actionLabel: l10n.commonViewAll,
              onAction: () => context.push(
                '/customers/${_routeSegment()}/${widget.customerId}/orders',
              ),
            ),
            if (_recentOrders.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(l10n.customerOrdersEmpty),
              ),
            for (final order in _recentOrders)
              OrderCard(order: order, onTap: () => context.push('/orders/${order.id}')),
          ],
          const SizedBox(height: 16),
          CustomerLoginAccountSection(
            customerType: widget.customerType,
            customerId: widget.customerId,
            customer: customer,
            customerRepository: ref.read(customerRepositoryProvider),
            onUpdated: _reloadCustomer,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: const Icon(Icons.event_outlined),
            label: Text(l10n.planScheduleVisit),
            onPressed: () => showVisitFormSheet(
              context,
              ref,
              prefill: VisitPrefill(
                customerType: widget.customerType,
                customerId: widget.customerId,
                customerName: _name(customer),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.salesCustomerDiary, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          CustomerDiarySection(customerType: widget.customerType, customerId: widget.customerId),
        ],
      ),
    );
  }

  String _routeSegment() => switch (widget.customerType) {
        'customer_van' => 'van',
        'customer_importer' => 'importer',
        _ => 'shop',
      };

  String _name(dynamic customer) {
    if (customer is CustomerShopModel) return customer.name;
    if (customer is CustomerVanModel) return customer.name;
    if (customer is CustomerImporterModel) return customer.name;
    return '#${widget.customerId}';
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
    return formatAppDateTime(raw);
  }

  String? _createdAt(dynamic customer) {
    String? raw;
    if (customer is CustomerShopModel) raw = customer.createdAt;
    if (customer is CustomerVanModel) raw = customer.createdAt;
    if (customer is CustomerImporterModel) raw = customer.createdAt;
    if (raw == null) return null;
    return formatAppDateTime(raw);
  }
}
