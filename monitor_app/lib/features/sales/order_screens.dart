import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  List<OrderModel> _orders = [];
  List<SalesPersonModel> _salesPersons = [];
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  int _currentPage = 1;
  int _lastPage = 1;

  String? _status;
  String? _paymentStatus;
  DateTime? _fromDate;
  DateTime? _toDate;
  Set<int> _salesPersonIds = {};
  bool _archived = false;
  ListSortMode _sortMode = ListSortMode.date;

  @override
  void initState() {
    super.initState();
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

  Future<void> _load({int page = 1, bool reset = false}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
      });
    } else {
      setState(() => _loadingMore = true);
    }
    try {
      final search = _searchController.text.trim();
      final results = await Future.wait([
        ref.read(customerRepositoryProvider).salesPersons().then((r) => r.items),
        ref.read(orderRepositoryProvider).list(
              salesPersonIds: _salesPersonIds,
              status: _status,
              paymentStatus: _paymentStatus,
              archived: _archived,
              search: search.isEmpty ? null : search,
              fromDate: _fromDate?.toIso8601String().split('T').first,
              toDate: _toDate?.toIso8601String().split('T').first,
              sort: _sortMode.orderApiSortParam(),
              page: page,
            ),
      ]);
      final salesPersons = results[0] as List<SalesPersonModel>;
      final result = results[1] as PaginatedResponse<OrderModel>;
      var items = sortByListMode(
        result.items,
        _sortMode,
        dateIso: (o) => o.createdAt,
        name: (o) => o.customerShopName ?? '',
        area: (o) => o.customerShopAreaName,
        salesPerson: (o) => o.salesPerson?.name,
      );
      if (!mounted) return;
      setState(() {
        _salesPersons = salesPersons;
        if (reset) {
          _orders = items;
        } else {
          final existingIds = _orders.map((o) => o.id).toSet();
          _orders = [..._orders, ...items.where((o) => !existingIds.contains(o.id))];
        }
        _currentPage = result.currentPage;
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

  void _clearFilters() {
    setState(() {
      _status = null;
      _paymentStatus = null;
      _fromDate = null;
      _toDate = null;
      _salesPersonIds = {};
      _archived = false;
      _searchController.clear();
    });
    _load(page: 1, reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'SAR ');
    final activeFilterCount = [_status, _paymentStatus, _fromDate, _toDate]
            .where((v) => v != null)
            .length +
        (_salesPersonIds.isEmpty ? 0 : 1) +
        (_archived ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(activeFilterCount == 0 ? 'Orders' : 'Orders ($activeFilterCount)'),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: OrderFiltersDrawer(
        searchController: _searchController,
        onSearchSubmitted: () => _load(page: 1, reset: true),
        status: _status,
        onStatusChanged: (v) {
          setState(() => _status = v);
          _load(page: 1, reset: true);
        },
        paymentStatus: _paymentStatus,
        onPaymentStatusChanged: (v) {
          setState(() => _paymentStatus = v);
          _load(page: 1, reset: true);
        },
        fromDate: _fromDate,
        onFromDateChanged: (v) {
          setState(() => _fromDate = v);
          _load(page: 1, reset: true);
        },
        toDate: _toDate,
        onToDateChanged: (v) {
          setState(() => _toDate = v);
          _load(page: 1, reset: true);
        },
        salesPersons: _salesPersons,
        selectedSalesPersonIds: _salesPersonIds,
        onSalesPersonsChanged: (v) {
          setState(() => _salesPersonIds = v);
          _load(page: 1, reset: true);
        },
        archived: _archived,
        onArchivedChanged: (v) {
          setState(() => _archived = v);
          _load(page: 1, reset: true);
        },
        sort: _sortMode,
        onSortChanged: (mode) {
          setState(() => _sortMode = mode);
          _load(page: 1, reset: true);
        },
        onClear: _clearFilters,
      ),
      body: _loading
          ? const LoadingView()
          : _error != null
              ? ErrorView(message: _error!, onRetry: () => _load(page: 1, reset: true))
              : _orders.isEmpty
                  ? const EmptyView(message: 'No orders found')
                  : RefreshIndicator(
                      onRefresh: () => _load(page: 1, reset: true),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _orders.length + (_loadingMore ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (i >= _orders.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final order = _orders[i];
                          return OrderCard(
                            order: order,
                            currency: currency,
                            showDue: true,
                            subtitle: orderListSubtitle(order, showSalesPerson: true),
                            onTap: () => context.push('/sales/orders/${order.id}'),
                          );
                        },
                      ),
                    ),
    );
  }
}

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  OrderModel? _order;
  List<OrderModificationModel> _mods = [];
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
      final order = await ref.read(orderRepositoryProvider).get(widget.id);
      final mods = await ref.read(orderRepositoryProvider).modifications(widget.id);
      setState(() {
        _order = order;
        _mods = mods;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final order = _order!;
    final currency = NumberFormat.currency(symbol: 'SAR ');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (order.invoiceNumber != null)
          ListTile(
            title: const Text('Invoice'),
            subtitle: Text(order.invoiceNumber!),
          ),
        ListTile(
          title: Text(currency.format(order.totalBill)),
          subtitle: Text('Payment: ${order.paymentStatus}'),
          trailing: StatusChip(label: order.status),
        ),
        ListTile(
          title: const Text('Paid / Due'),
          subtitle: Text('${currency.format(order.amountPaid)} paid · ${currency.format(order.amountDue)} due'),
        ),
        if (order.grandDiscount > 0)
          ListTile(title: const Text('Grand discount'), subtitle: Text(currency.format(order.grandDiscount))),
        if (order.dueDate != null)
          ListTile(title: const Text('Due date'), subtitle: Text(order.dueDate!)),
        if (order.isOverdue)
          ListTile(title: const Text('Overdue'), subtitle: Text('${order.daysOverdue} days')),
        if (order.customerShopName != null)
          ListTile(title: const Text('Shop'), subtitle: Text(order.customerShopName!)),
        if (order.salesPerson != null)
          ListTile(title: const Text('Sales person'), subtitle: Text(order.salesPerson!.name)),
        Text('Items', style: Theme.of(context).textTheme.titleMedium),
        for (final item in order.items)
          ListTile(
            title: Text(item.product?.name ?? 'Product #${item.productId}'),
            subtitle: Text('Qty ${item.quantity}'),
            trailing: Text(currency.format(item.bill)),
          ),
        if (order.payments.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Payments', style: Theme.of(context).textTheme.titleMedium),
          for (final p in order.payments)
            ListTile(
              title: Text(p.paymentReference ?? 'Payment #${p.id}'),
              subtitle: Text(p.paymentMethod ?? ''),
              trailing: Text(currency.format(p.amount)),
            ),
        ],
        const SizedBox(height: 16),
        Text('Modification history', style: Theme.of(context).textTheme.titleMedium),
        if (_mods.isEmpty) const Text('No modifications'),
        for (final mod in _mods)
          ListTile(
            title: Text(mod.action.replaceAll('_', ' ')),
            subtitle: Text(mod.notes ?? mod.createdAt ?? ''),
          ),
      ],
    );
  }
}
