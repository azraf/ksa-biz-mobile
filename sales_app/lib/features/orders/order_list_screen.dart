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
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (reset) {
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
            status: _filter == _OrderFilter.pendingApproval ? 'draft' : null,
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
              onChanged: (_) => setState(() {}),
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
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          final next = selected ? _OrderFilter.all : value;
          setState(() => _filter = next);
          if (value == _OrderFilter.pendingApproval || selected) {
            _load(page: 1, reset: true);
          }
        },
      ),
    );
  }
}
