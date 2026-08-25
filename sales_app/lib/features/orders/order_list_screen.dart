import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/format_providers.dart';
import '../../providers/repositories.dart';

enum _OrderFilter { all, today, week, pendingSync, unpaid, pendingApproval }

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  List<OrderModel> _orders = [];
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  int _currentPage = 1;
  int _lastPage = 1;
  _OrderFilter _filter = _OrderFilter.all;
  ListSortMode _sortMode = ListSortMode.date;
  Timer? _searchDebounce;

  /// Server-side query signature of the last reset load; a change means the
  /// loaded pages no longer match the filters and page 1 must be refetched.
  String? _activeQuerySig;

  static const _listKey = 'sales_orders';

  @override
  void initState() {
    super.initState();
    final prefs = ListSortPreference(ref.read(sharedPreferencesProvider));
    _sortMode = prefs.read(_listKey, defaultMode: ListSortMode.date);
    _scrollController.addListener(_onScroll);
    _load(page: 1, reset: true);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_loadingMore || _loading || _currentPage >= _lastPage) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _load(page: _currentPage + 1);
    }
  }

  static String _dateParam(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Filters expressed as server-side list() params, so matches beyond the
  /// already-loaded pages are found too. The client-side [_filteredOrders]
  /// stays as instant feedback while a reload is in flight.
  ({String? status, bool? archived, String? fromDate, String? toDate, String? search}) _serverQuery() {
    final now = DateTime.now();
    final q = _searchController.text.trim();
    // The server's search param is an exact order-id match — sending a shop
    // name would match nothing, so text queries stay client-side only.
    final numericSearch = int.tryParse(q);
    return (
      status: _filter == _OrderFilter.pendingApproval ? 'draft' : null,
      // "Unpaid" == payment_status != paid, which the API exposes as the
      // archived=false scope (fully paid orders auto-archive).
      archived: _filter == _OrderFilter.unpaid ? false : null,
      fromDate: switch (_filter) {
        _OrderFilter.today => _dateParam(now),
        _OrderFilter.week => _dateParam(now.subtract(const Duration(days: 6))),
        _ => null,
      },
      toDate: _filter == _OrderFilter.today ? _dateParam(now) : null,
      search: numericSearch != null && numericSearch > 0 ? '$numericSearch' : null,
    );
  }

  /// Reloads from page 1 whenever the effective server-side query changed
  /// (filter chips on/off, draft <-> non-draft dataset, search text).
  void _reloadIfQueryChanged() {
    if (_serverQuery().toString() != _activeQuerySig) {
      _load(page: 1, reset: true);
    }
  }

  void _onSearchChanged() {
    setState(() {}); // Instant client-side filtering of loaded pages.
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) _reloadIfQueryChanged();
    });
  }

  List<OrderModel> _filteredOrders() {
    final q = _searchController.text.trim().toLowerCase();
    final now = DateTime.now();
    return _orders.where((order) {
      if (q.isNotEmpty) {
        final shop = order.customerShopName?.toLowerCase() ?? '';
        final idStr = order.id.toString();
        if (!shop.contains(q) && !idStr.contains(q)) return false;
      }
      final created = DateTime.tryParse(order.createdAt ?? '');
      switch (_filter) {
        case _OrderFilter.today:
          if (created == null) return false;
          return created.year == now.year && created.month == now.month && created.day == now.day;
        case _OrderFilter.week:
          if (created == null) return false;
          return now.difference(created).inDays < 7;
        case _OrderFilter.pendingSync:
          return order.id < 0;
        case _OrderFilter.unpaid:
          return order.paymentStatus != 'paid' && order.paymentStatus != 'cancelled';
        case _OrderFilter.pendingApproval:
          return order.isDraft;
        case _OrderFilter.all:
          return true;
      }
    }).toList();
  }

  Future<void> _load({int page = 1, bool reset = false}) async {
    if (!mounted) return;
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    final query = _serverQuery();
    if (reset) {
      _activeQuerySig = query.toString();
      setState(() {
        _loading = true;
        _error = null;
      });
    } else {
      setState(() => _loadingMore = true);
    }

    try {
      if (reset && ref.read(onlineStatusProvider)) {
        unawaited(ref.read(syncServiceProvider).syncIfOnline().timeout(
              const Duration(seconds: 30),
              onTimeout: () {},
            ));
        ref.invalidate(pendingSyncCountProvider);
      }
      final result = await ref.read(offlineOrderRepositoryProvider).list(
            salesPersonId: salesPersonId,
            status: query.status,
            archived: query.archived,
            search: query.search,
            fromDate: query.fromDate,
            toDate: query.toDate,
            sort: _sortMode.orderApiSortParam(),
            page: page,
          );
      var items = result.items;
      items = sortByListMode(
        items,
        _sortMode,
        dateIso: (o) => o.createdAt,
        name: (o) => o.customerShopName ?? '',
        area: (o) => o.customerShopAreaName,
        salesPerson: (o) => o.salesPerson?.name,
      );
      if (!mounted) return;
      setState(() {
        if (reset) {
          _orders = items;
        } else {
          final existingIds = _orders.map((o) => o.id).toSet();
          _orders = [
            ..._orders,
            ...items.where((order) => !existingIds.contains(order.id)),
          ];
        }
        _currentPage = result.currentPage;
        _lastPage = result.lastPage;
        _loading = false;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppErrorMapper.localize(context, e);
        _loading = false;
        _loadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencyFormatProvider);
    final visible = _filteredOrders();

    return Scaffold(
      floatingActionButton: TranslucentFab(
        onOpen: () => context.push('/orders/create'),
        icon: const Icon(Icons.add),
        label: l10n.commonNewOrder,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.salesOrderSearchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => _onSearchChanged(),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _filterChip(l10n.salesOrderFilterToday, _OrderFilter.today),
                _filterChip(l10n.salesOrderFilterWeek, _OrderFilter.week),
                _filterChip(l10n.salesOrderFilterPendingSync, _OrderFilter.pendingSync),
                _filterChip(l10n.salesOrderFilterUnpaid, _OrderFilter.unpaid),
                _filterChip(l10n.statusDraft, _OrderFilter.pendingApproval),
                ListSortButton(
                  modes: const [
                    ListSortMode.date,
                    ListSortMode.name,
                    ListSortMode.area,
                    ListSortMode.salesPerson,
                  ],
                  selected: _sortMode,
                  onSelected: (mode) async {
                    _sortMode = mode;
                    await ListSortPreference(ref.read(sharedPreferencesProvider)).write(_listKey, mode);
                    await _load(page: 1, reset: true);
                  },
                ),
                IconButton(
                  tooltip: 'Update data',
                  icon: const Icon(Icons.sync),
                  onPressed: _loading ? null : () => _load(page: 1, reset: true),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? ListView.builder(
                    padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.fabClearance),
                    itemCount: 6,
                    itemBuilder: (_, _) => const SkeletonListTile(),
                  )
                : _error != null
                    ? ErrorView(message: _error!, onRetry: () => _load(page: 1, reset: true))
                    : visible.isEmpty
                        ? EmptyView(
                            message: l10n.commonNoOrdersYet,
                            actionLabel: l10n.commonCreateOrder,
                            onAction: () => context.push('/orders/create'),
                          )
                        : RefreshIndicator(
                            onRefresh: () => _load(page: 1, reset: true),
                            child: ListView.builder(
                              padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.fabClearance),
                              controller: _scrollController,
                              itemCount: visible.length + (_loadingMore ? 1 : 0),
                              itemBuilder: (_, i) {
                                if (i >= visible.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }
                                final order = visible[i];
                                return OrderCard(
                                  order: order,
                                  currency: currency,
                                  subtitle: orderListSubtitle(order, showSalesPerson: true),
                                  showDue: true,
                                  onTap: () => context.push('/orders/${order.id}'),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, _OrderFilter value) {
    final selected = _filter == value;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          final next = selected ? _OrderFilter.all : value;
          setState(() => _filter = next);
          // Reload whenever the server-side query changed — e.g. leaving the
          // draft-only dataset, or a date/payment filter toggling.
          _reloadIfQueryChanged();
        },
      ),
    );
  }
}
