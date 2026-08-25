import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/repositories.dart';

/// Full order history for one customer: infinite scroll, order-number search,
/// status/payment chips and a native date-range filter.
class CustomerOrdersScreen extends ConsumerStatefulWidget {
  const CustomerOrdersScreen({
    super.key,
    required this.customerType,
    required this.customerId,
  });

  final String customerType;
  final int customerId;

  @override
  ConsumerState<CustomerOrdersScreen> createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends ConsumerState<CustomerOrdersScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounce;

  List<OrderModel> _orders = [];
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  int _page = 1;
  int _lastPage = 1;
  String? _status;
  String? _paymentStatus;
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _load(page: 1));
  }

  void _onScroll() {
    if (_loadingMore || _page >= _lastPage) return;
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      _load(page: _page + 1, append: true);
    }
  }

  static String _iso(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

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
    try {
      final search = _searchController.text.trim();
      final result = await ref.read(orderRepositoryProvider).list(
            query: OrderListQuery(
              customerType: widget.customerType,
              customerId: widget.customerId,
              status: _status,
              paymentStatus: _paymentStatus,
              search: search.isEmpty ? null : search,
              fromDate: _range != null ? _iso(_range!.start) : null,
              toDate: _range != null ? _iso(_range!.end) : null,
              page: _page,
            ),
          );
      if (!mounted) return;
      setState(() {
        _orders = append ? [..._orders, ...result.items] : result.items;
        _lastPage = result.lastPage;
        _loading = false;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
        _loadingMore = false;
      });
    }
  }

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 730)),
      lastDate: DateTime.now(),
      initialDateRange: _range,
    );
    if (picked == null || !mounted) return; // cancelled — keep the active range
    setState(() => _range = picked);
    await _load(page: 1);
  }

  Widget _chip(String label, String value, String? group, void Function(String?) set) {
    return FilterChip(
      label: Text(label),
      selected: group == value,
      onSelected: (on) {
        set(on ? value : null);
        _load(page: 1);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerOrdersTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 0),
            child: TextField(
              controller: _searchController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.commonOrderNumber(0).replaceAll(RegExp(r'\s*0\s*$'), ''),
                isDense: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 0),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _chip(l10n.statusDraft, 'draft', _status, (v) => _status = v),
                _chip(l10n.statusConfirmed, 'confirmed', _status, (v) => _status = v),
                _chip(l10n.statusCancelled, 'cancelled', _status, (v) => _status = v),
                _chip(l10n.statusPaid, 'paid', _paymentStatus, (v) => _paymentStatus = v),
                _chip(l10n.statusPartial, 'partial', _paymentStatus, (v) => _paymentStatus = v),
                _chip(l10n.statusPending, 'pending', _paymentStatus, (v) => _paymentStatus = v),
                ActionChip(
                  avatar: const Icon(Icons.date_range, size: 16),
                  label: Text(_range == null
                      ? l10n.commonDueDate
                      : '${_iso(_range!.start)} – ${_iso(_range!.end)}'),
                  onPressed: _pickRange,
                ),
                if (_range != null)
                  ActionChip(
                    avatar: const Icon(Icons.clear, size: 16),
                    label: Text(l10n.commonCancel),
                    onPressed: () {
                      setState(() => _range = null);
                      _load(page: 1);
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? LoadingView(message: l10n.commonLoading)
                : _error != null
                    ? ErrorView(message: _error!, onRetry: _load)
                    : _orders.isEmpty
                        ? EmptyView(message: l10n.customerOrdersEmpty)
                        : RefreshIndicator(
                            onRefresh: () => _load(page: 1),
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsetsDirectional.all(12),
                              itemCount: _orders.length + (_loadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= _orders.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }
                                final order = _orders[index];
                                return OrderCard(
                                  order: order,
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
}
