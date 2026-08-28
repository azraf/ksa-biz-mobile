import 'dart:async';

import 'package:core/core.dart' hide sharedPreferencesProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/connectivity_provider.dart';
import '../../providers/order_vat_config_provider.dart';
import '../../providers/repositories.dart';
import '../customers/customer_diary_section.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';
import '../../widgets/line_items_editor.dart';
import 'collect_payment_screen.dart';

class SalesPersonsScreen extends ConsumerWidget {
  const SalesPersonsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(customerRepositoryProvider);
    return CrudListScreen<SalesPersonModel>(
      title: 'Sales Persons',
      loadItems: () async => (await repo.salesPersons()).items,
      itemTitle: (s) => '${s.name} ${s.mobile ?? ''}',
      onTap: (s) => _edit(context, ref, s),
      onAdd: () => _edit(context, ref, null),
      trailing: (s) => ContactActionButtons(phoneNumber: s.mobile, compact: true),
    );
  }

  void _edit(BuildContext context, WidgetRef ref, SalesPersonModel? person) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: person == null ? 'New Sales Person' : 'Edit Sales Person',
      initialValues: person == null
          ? {}
          : {
              'name': person.name,
              'mobile': person.mobile,
              'email': person.email,
              'address': person.address,
            },
      fields: const [
        FieldConfig(key: 'name', label: 'Name', required: true),
        FieldConfig(key: 'mobile', label: 'Mobile'),
        FieldConfig(key: 'email', label: 'Email', type: FieldType.email),
        FieldConfig(key: 'address', label: 'Address', type: FieldType.textarea),
      ],
      onSave: (v) async {
        final api = ref.read(apiClientProvider);
        if (person == null) {
          await api.post('/sales-persons', body: v);
        } else {
          await api.put('/sales-persons/${person.id}', body: v);
        }
      },
    )));
  }
}

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  static const _listKey = 'admin_orders';

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
  bool? _archived = false;
  late ListSortMode _sortMode;

  @override
  void initState() {
    super.initState();
    _sortMode = ListSortPreference(ref.read(sharedPreferencesProvider))
        .read(_listKey, defaultMode: ListSortMode.date);
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
      if (reset) {
        unawaited(ref.read(syncServiceProvider).syncIfOnline().timeout(
              const Duration(seconds: 30),
              onTimeout: () {},
            ));
      }
      final search = _searchController.text.trim();
      final results = await Future.wait([
        ref.read(customerRepositoryProvider).salesPersons().then((r) => r.items),
        ref.read(offlineOrderRepositoryProvider).list(
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
    final activeFilterCount = [_status, _paymentStatus, _fromDate, _toDate]
            .where((v) => v != null)
            .length +
        (_salesPersonIds.isEmpty ? 0 : 1) +
        (_archived != false ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(activeFilterCount == 0 ? 'Orders' : 'Orders ($activeFilterCount)'),
        actions: [
          IconButton(
            tooltip: 'Update data',
            icon: const Icon(Icons.sync),
            onPressed: _loading
                ? null
                : () async {
                    await ref.read(syncServiceProvider).syncIfOnline().timeout(
                          const Duration(seconds: 30),
                          onTimeout: () {},
                        );
                    await _load(page: 1, reset: true);
                  },
          ),
          IconButton(icon: const Icon(Icons.add), onPressed: () => context.push('/sales/orders/create')),
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
        onSortChanged: (mode) async {
          setState(() => _sortMode = mode);
          await ListSortPreference(ref.read(sharedPreferencesProvider)).write(_listKey, mode);
          _load(page: 1, reset: true);
        },
        onClear: _clearFilters,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 12),
                      FilledButton(onPressed: () => _load(page: 1, reset: true), child: const Text('Retry')),
                    ],
                  ),
                )
              : _orders.isEmpty
                  ? const Center(child: Text('No orders found'))
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
  const OrderDetailScreen({super.key, required this.orderId});
  final int orderId;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  OrderModel? _order;
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
      final order = await ref.read(offlineOrderRepositoryProvider).get(widget.orderId);
      setState(() {
        _order = order;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _confirmPendingOrder() async {
    final salesPersons = (await ref.read(customerRepositoryProvider).salesPersons()).items;
    var inventorySource = 'van';
    SalesPersonModel? selectedSp = salesPersons.isNotEmpty ? salesPersons.first : null;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final needsSp = inventorySource == 'van' || inventorySource == 'warehouse_deliver';
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Confirm order', style: Theme.of(ctx).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: inventorySource,
                    decoration: const InputDecoration(labelText: 'Inventory source'),
                    items: const [
                      DropdownMenuItem(value: 'van', child: Text('Salesperson van')),
                      DropdownMenuItem(value: 'warehouse', child: Text('Warehouse only')),
                      DropdownMenuItem(value: 'warehouse_deliver', child: Text('Warehouse + delivery')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setSheetState(() => inventorySource = value);
                    },
                  ),
                  if (needsSp) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<SalesPersonModel>(
                      initialValue: selectedSp,
                      decoration: const InputDecoration(labelText: 'Delivery salesperson'),
                      items: salesPersons
                          .map((sp) => DropdownMenuItem(value: sp, child: Text(sp.name)))
                          .toList(),
                      onChanged: (value) => setSheetState(() => selectedSp = value),
                    ),
                  ],
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Confirm order'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (confirmed != true) return;

    // Preview the draft as the printed invoice before shipping it.
    final order = _order;
    if (order != null) {
      final config = await loadZatcaConfig(
        ref.read(sharedPreferencesProvider),
        ref.read(apiClientProvider),
      );
      if (!mounted) return;
      final proceed = await showOrderPreviewConfirmSheet(
        context,
        previewOrder: order,
        config: config,
      );
      if (proceed != true) return;
    }

    try {
      // Confirm deletes the draft and creates a NEW order with a new id —
      // rebuild the screen on that id, never reload the dead draft id.
      final confirmed = await ref.read(offlineOrderRepositoryProvider).confirmDraft(
            widget.orderId,
            salesPersonId: inventorySource == 'warehouse' ? null : selectedSp?.id,
            inventorySource: inventorySource,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order confirmed')));
        context.pushReplacement('/sales/orders/${confirmed.id}');
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _collectPayment() async {
    final order = _order!;
    final due = order.outstandingDue;
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AdminCollectPaymentScreen(orderId: order.id, amountDue: due),
      ),
    );
    if (ok == true) await _load();
  }

  Future<void> _voidPayment(PaymentModel payment) async {
    final reason = await _prompt(context, 'Void payment reason');
    if (reason == null || reason.trim().isEmpty) return;

    try {
      await ref.read(orderRepositoryProvider).voidPayment(payment.id, reason: reason.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment voided')));
        await _load();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order #${widget.orderId}')),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }

    final order = _order!;
    final currency = NumberFormat.currency(symbol: 'SAR ');
    final pendingSync = order.id < 0;
    final awaitingApproval = order.isDraft;
    final canEdit = order.isEditable && !pendingSync && !awaitingApproval;
    final canCancel = order.isEditable && !pendingSync;
    final due = order.outstandingDue;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pendingSync)
          Card(
            color: AppColors.warning(context),
            child: const ListTile(
              leading: Icon(Icons.sync),
              title: Text('Pending sync'),
              subtitle: Text('This order will upload when online'),
            ),
          ),
        if (awaitingApproval)
          Card(
            color: Colors.orange.shade50,
            child: const ListTile(
              leading: Icon(Icons.hourglass_top),
              title: Text('Pending approval'),
              subtitle: Text('Confirm to assign delivery and deduct inventory'),
            ),
          ),
        if (canEdit)
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/sales/orders/${order.id}/edit'),
            ),
          ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.invoiceNumber ?? 'Order #${order.id}',
                        style: Theme.of(context).textTheme.titleMedium),
                    StatusChip(label: order.paymentStatus),
                  ],
                ),
                if (order.invoiceNumber != null) Text('Order #${order.id}'),
                Text('Status: ${order.status}'),
                Text(currency.format(order.totalBill), style: Theme.of(context).textTheme.headlineSmall),
                const Divider(),
                _row('Paid', currency.format(order.amountPaid)),
                _row('Due', currency.format(due), bold: true),
                if (order.createdAt != null) _row('Created', formatAppDateTime(order.createdAt)),
                if (order.dueDate != null) _row('Due date', formatAppDateTime(order.dueDate)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        OrderInvoiceSection(
          order: order,
          repository: ref.read(orderRepositoryProvider),
          api: ref.read(apiClientProvider),
          isOnline: ref.watch(onlineStatusProvider) && !pendingSync,
          onChanged: _load,
          onOpenPrinterSettings: () => context.push('/more/printer-settings'),
        ),
        if (order.customerShopName != null)
          ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: Text(AppLocalizations.of(context).commonCustomer),
            subtitle: Text(order.customerShopName!),
            // Only shops have an admin detail route; vans/importers stay flat.
            onTap: order.customerShopId != null && order.customerShopId! > 0
                ? () => context.push('/customers/shops/${order.customerShopId}')
                : null,
          ),
        if (order.salesPerson != null || order.salesPersonId != null)
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: Text(AppLocalizations.of(context).commonSalesperson),
            subtitle: Text(order.salesPerson?.name ?? '#${order.salesPersonId}'),
          ),
        if (order.manualOrderRequests.isNotEmpty) ...[
          const SizedBox(height: 8),
          SectionHeader(title: AppLocalizations.of(context).salesTitleManualOrders),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: order.manualOrderRequests
                .map((r) => ActionChip(
                      avatar: const Icon(Icons.assignment_outlined, size: 18),
                      label: Text('#${r.id} · ${r.status}'),
                      onPressed: () => context.push('/sales/manual-orders/${r.id}'),
                    ))
                .toList(),
          ),
        ],
        if (order.id > 0 && _diaryTarget(order) != null) ...[
          const SizedBox(height: 8),
          SectionHeader(title: AppLocalizations.of(context).orderDiaryTitle),
          CustomerDiarySection(
            customerType: _diaryTarget(order)!.$1,
            customerId: _diaryTarget(order)!.$2,
            orderId: order.id,
          ),
        ],
        if (awaitingApproval) ...[
          FilledButton.icon(
            onPressed: _confirmPendingOrder,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Confirm order'),
          ),
          const SizedBox(height: 16),
        ],
        if (canEdit && due > 0) ...[
          FilledButton.icon(
            onPressed: _collectPayment,
            icon: const Icon(Icons.payments),
            label: const Text('Collect payment'),
          ),
          const SizedBox(height: 16),
        ],
        const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
        ...order.items.map((i) => ListTile(
              title: Text(i.product?.name ?? 'Product #${i.productId}'),
              trailing: Text('${i.quantity} x ${i.productPrice}'),
            )),
        if (order.payments.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Payments', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final p in order.payments)
            ListTile(
              title: Text(
                p.paymentReference ?? 'Payment #${p.id}',
                style: p.isVoided ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
              ),
              subtitle: Text(
                [
                  if (p.isVoided) 'voided',
                  if (p.paymentMethod != null) p.paymentMethod!,
                  if (p.paidAt != null) formatAppDateTime(p.paidAt),
                ].join(' · '),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currency.format(p.amount)),
                  if (canEdit && !p.isVoided) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.undo),
                      tooltip: 'Void payment',
                      onPressed: () => _voidPayment(p),
                    ),
                  ],
                ],
              ),
            ),
        ],
        if (canCancel) ...[
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () async {
              final reason = await _prompt(context, 'Cancellation reason');
              if (reason == null) return;
              final updated = await ref.read(offlineOrderRepositoryProvider).cancel(order.id, reason);
              ref.invalidate(pendingSyncCountProvider);
              if (context.mounted) {
                final message = updated.status == 'cancellation_pending'
                    ? 'Cancellation submitted for admin approval'
                    : 'Order cancelled';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                Navigator.pop(context);
              }
            },
            child: const Text('Cancel Order'),
          ),
        ],
      ],
    );
  }

  (String, int)? _diaryTarget(OrderModel order) {
    if (order.customerShopId != null) return ('customer_shop', order.customerShopId!);
    if (order.customerVanId != null) return ('customer_van', order.customerVanId!);
    if (order.customerImporterId != null) return ('customer_importer', order.customerImporterId!);
    return null;
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}

class CreateOrderScreen extends ConsumerStatefulWidget {
  const CreateOrderScreen({super.key});
  @override
  ConsumerState<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen> {
  List<CustomerTypeModel> _types = [];
  CustomerTypeModel? _selectedType;
  CustomerShopModel? _selectedShop;
  CustomerVanModel? _selectedVan;
  CustomerImporterModel? _selectedImporter;
  final _items = <LineItemDraft>[];
  final _walkInNoteController = TextEditingController();
  final _vatRateController = TextEditingController(text: '15');
  OrderVatSettings _vat = const OrderVatSettings();
  bool _vatTouched = false;
  bool _walkInMode = false;
  int? _walkInShopId;
  int? _salesPersonId;
  List<SalesPersonModel> _salesPersons = [];
  List<CustomerShopModel> _shops = [];
  List<CustomerVanModel> _vans = [];
  List<CustomerImporterModel> _importers = [];
  DateTime _orderDate = DateTime.now();
  bool _asDraft = false;
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _walkInNoteController.dispose();
    _vatRateController.dispose();
    super.dispose();
  }

  void _applyVatToItems() {
    for (final item in _items) {
      item.applyVat(_vat);
    }
  }

  void _setVat(OrderVatSettings vat, {bool touched = true}) {
    setState(() {
      if (touched) _vatTouched = true;
      _vat = vat;
      _applyVatToItems();
    });
  }

  /// Resolves the VAT default from the server policy for the currently
  /// selected customer; stops once the admin touches the VAT controls.
  Future<void> _resolveVatDefault() async {
    if (_vatTouched) return;
    try {
      final config = await ref.read(orderVatConfigProvider.future);
      int? shopId;
      int? vanId;
      int? importerId;
      if (_walkInMode) {
        shopId = _walkInShopId;
      } else {
        switch (_selectedType?.typeName) {
          case 'customer_van':
            vanId = _selectedVan?.id;
          case 'customer_importer':
            importerId = _selectedImporter?.id;
          default:
            shopId = _selectedShop?.id;
        }
      }
      final enabled = OrderVatPolicy.resolve(
        config: config,
        shopId: shopId,
        vanId: vanId,
        importerId: importerId,
      );
      if (!mounted || _vatTouched || enabled == _vat.enabled) return;
      _setVat(
        OrderVatSettings(enabled: enabled, inclusive: _vat.inclusive, rate: _vat.rate),
        touched: false,
      );
    } catch (_) {
      // Config unavailable → keep VAT off.
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final customerRepo = ref.read(customerRepositoryProvider);
      final types = await customerRepo.customerTypes();
      final salesPersons = (await customerRepo.salesPersons()).items;
      final walkInShopId = await customerRepo.walkInShopId();
      final shops = (await customerRepo.shops()).items.where((s) => !s.isSystem).toList();
      final vans = (await customerRepo.vans()).items;
      final importers = (await customerRepo.importers()).items;
      setState(() {
        _types = types;
        _salesPersons = salesPersons;
        _walkInShopId = walkInShopId;
        _shops = shops;
        _vans = vans;
        _importers = importers;
        if (_shops.isNotEmpty) _selectedShop = _shops.first;
        if (_salesPersons.isNotEmpty) _salesPersonId = _salesPersons.first.id;
        if (_types.isNotEmpty) {
          _selectedType = _types.firstWhere(
            (t) => t.typeName == 'customer_shop',
            orElse: () => _types.first,
          );
        }
        _loading = false;
      });
      unawaited(_resolveVatDefault());
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _startWalkIn() async {
    final shopType = _types.cast<CustomerTypeModel?>().firstWhere(
          (t) => t?.typeName == 'customer_shop',
          orElse: () => null,
        );
    if (shopType == null || _walkInShopId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Walk-in shop not configured on server.')),
      );
      return;
    }
    setState(() {
      _walkInMode = true;
      _selectedType = shopType;
      _selectedShop = CustomerShopModel(id: _walkInShopId!, name: 'Walk-in Shop', isSystem: true);
    });
    unawaited(_resolveVatDefault());
  }

  Future<void> _pickOrderDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _orderDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_orderDate),
    );
    if (time == null) return;
    setState(() {
      _orderDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    if (_selectedType == null || _items.isEmpty) return;
    if (!_walkInMode) {
      final missingCustomer = switch (_selectedType!.typeName) {
        'customer_van' => _selectedVan == null,
        'customer_importer' => _selectedImporter == null,
        _ => _selectedShop == null,
      };
      if (missingCustomer) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a customer')));
        return;
      }
    }
    _applyVatToItems();
    setState(() => _submitting = true);
    try {
      final body = <String, dynamic>{
        if (_salesPersonId != null) 'sales_person_id': _salesPersonId,
        'customer_type_id': _selectedType!.id,
        'created_at': _orderDate.toIso8601String(),
        // Always create as a draft — the non-draft flow previews the invoice,
        // then confirms the draft.
        'as_draft': true,
        'include_vat': _vat.enabled,
        if (_vat.enabled) 'vat_inclusive': _vat.inclusive,
        if (_vat.enabled) 'vat_rate': _vat.rate,
        'items': _items.map((e) => e.toJson()).toList(),
      };
      if (_walkInMode) {
        body['customer_shop_id'] = _walkInShopId;
      } else {
        switch (_selectedType!.typeName) {
          case 'customer_van':
            body['customer_van_id'] = _selectedVan?.id;
          case 'customer_importer':
            body['customer_importer_id'] = _selectedImporter?.id;
          default:
            body['customer_shop_id'] = _selectedShop?.id;
        }
      }
      if (_walkInMode && _walkInNoteController.text.trim().isNotEmpty) {
        body['walk_in_note'] = _walkInNoteController.text.trim();
      }
      final order = await ref.read(offlineOrderRepositoryProvider).create(body);
      ref.invalidate(pendingSyncCountProvider);
      if (!mounted) return;
      if (_asDraft) {
        context.pop();
        return;
      }
      await _previewAndConfirm(order);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// Non-draft flow: preview the just-created draft as the printed invoice,
  /// then confirm it (server or local queue) or keep it as a draft.
  Future<void> _previewAndConfirm(OrderModel order) async {
    final walkInNote = _walkInNoteController.text.trim();
    final String? customerName;
    if (_walkInMode) {
      customerName = walkInNote.isNotEmpty ? walkInNote : 'Walk-in Shop';
    } else {
      customerName = switch (_selectedType?.typeName) {
        'customer_van' => _selectedVan?.name,
        'customer_importer' => _selectedImporter?.name,
        _ => _selectedShop?.name,
      };
    }
    final salesPersonName = _salesPersons
        .cast<SalesPersonModel?>()
        .firstWhere((sp) => sp?.id == _salesPersonId, orElse: () => null)
        ?.name;
    final config = await loadZatcaConfig(
      ref.read(sharedPreferencesProvider),
      ref.read(apiClientProvider),
    );
    if (!mounted) return;

    final previewOrder = buildPreviewOrder(
      items: _items,
      vat: _vat,
      customerName: customerName,
      salesPersonName: salesPersonName,
      createdAt: _orderDate,
    );
    final result = await showOrderPreviewConfirmSheet(
      context,
      previewOrder: previewOrder,
      config: config,
    );
    if (!mounted) return;

    // Confirming a server draft deletes it and creates a NEW order with a new
    // id — navigate with that id, never the dead draft id.
    var targetId = order.id;
    if (result == true) {
      try {
        if (order.id > 0) {
          // The draft's own lines carry fulfillment — no overrides needed.
          targetId =
              (await ref.read(offlineOrderRepositoryProvider).confirmDraft(order.id)).id;
        } else {
          await ref.read(offlineOrderRepositoryProvider).confirmLocalDraft(order.id);
          ref.invalidate(pendingSyncCountProvider);
        }
      } on StateError {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connect to confirm from the order page')),
          );
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved as draft')),
      );
    }
    if (!mounted) return;
    context.pushReplacement('/sales/orders/$targetId');
  }

  ({String type, int id, String name})? _noteTarget() {
    if (_walkInMode) {
      final id = _walkInShopId;
      return id == null ? null : (type: 'customer_shop', id: id, name: 'Walk-in Shop');
    }
    switch (_selectedType?.typeName) {
      case 'customer_van':
        final van = _selectedVan;
        return van == null ? null : (type: 'customer_van', id: van.id, name: van.name);
      case 'customer_importer':
        final importer = _selectedImporter;
        return importer == null
            ? null
            : (type: 'customer_importer', id: importer.id, name: importer.name);
      default:
        final shop = _selectedShop;
        return shop == null ? null : (type: 'customer_shop', id: shop.id, name: shop.name);
    }
  }

  Future<void> _openCustomerNote() async {
    final target = _noteTarget();
    if (target == null) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, controller) => Material(
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(16),
            children: [
              Text('Notes — ${target.name}', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 8),
              CustomerDiarySection(customerType: target.type, customerId: target.id),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Order')),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FilledButton.icon(
          onPressed: _startWalkIn,
          icon: const Icon(Icons.flash_on),
          label: const Text('Walk-in quick order'),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _salesPersonId,
          decoration: const InputDecoration(labelText: 'Sales person'),
          items: _salesPersons.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
          onChanged: (v) => setState(() => _salesPersonId = v),
        ),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.event),
          title: const Text('Order date & time'),
          subtitle: Text(DateFormat('yMMMd – h:mm a').format(_orderDate)),
          trailing: const Icon(Icons.edit),
          onTap: _pickOrderDate,
        ),
        const SizedBox(height: 12),
        if (_walkInMode) ...[
          const ListTile(
            leading: Icon(Icons.storefront),
            title: Text('Walk-in Shop'),
            subtitle: Text('Anonymous quick sale'),
          ),
          TextField(
            controller: _walkInNoteController,
            decoration: const InputDecoration(labelText: 'Note (optional)'),
          ),
          const SizedBox(height: 12),
        ] else ...[
          DropdownButtonFormField<CustomerTypeModel>(
            initialValue: _selectedType,
            decoration: const InputDecoration(labelText: 'Customer type'),
            items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t.typeName))).toList(),
            onChanged: (v) => setState(() => _selectedType = v),
          ),
          const SizedBox(height: 12),
          switch (_selectedType?.typeName) {
            'customer_van' => DropdownButtonFormField<CustomerVanModel>(
                initialValue: _selectedVan,
                decoration: const InputDecoration(labelText: 'Van customer'),
                items: _vans.map((v) => DropdownMenuItem(value: v, child: Text(v.name))).toList(),
                onChanged: (v) {
                  setState(() => _selectedVan = v);
                  unawaited(_resolveVatDefault());
                },
              ),
            'customer_importer' => DropdownButtonFormField<CustomerImporterModel>(
                initialValue: _selectedImporter,
                decoration: const InputDecoration(labelText: 'Importer customer'),
                items: _importers.map((i) => DropdownMenuItem(value: i, child: Text(i.name))).toList(),
                onChanged: (v) {
                  setState(() => _selectedImporter = v);
                  unawaited(_resolveVatDefault());
                },
              ),
            _ => DropdownButtonFormField<CustomerShopModel>(
                initialValue: _selectedShop,
                decoration: const InputDecoration(labelText: 'Shop'),
                items: _shops
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                    .toList(),
                onChanged: (v) {
                  setState(() => _selectedShop = v);
                  unawaited(_resolveVatDefault());
                },
              ),
          },
          const SizedBox(height: 12),
        ],
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Save as draft'),
          subtitle: const Text('Draft orders skip inventory/credit checks until confirmed'),
          value: _asDraft,
          onChanged: (v) => setState(() => _asDraft = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Apply VAT'),
          value: _vat.enabled,
          onChanged: (v) => _setVat(
            OrderVatSettings(enabled: v, inclusive: _vat.inclusive, rate: _vat.rate),
          ),
        ),
        if (_vat.enabled) ...[
          Row(
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Included')),
                  ButtonSegment(value: false, label: Text('Excluded')),
                ],
                selected: {_vat.inclusive},
                onSelectionChanged: (selection) => _setVat(
                  OrderVatSettings(enabled: true, inclusive: selection.first, rate: _vat.rate),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _vatRateController,
                  decoration: const InputDecoration(labelText: 'VAT %'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    final rate = double.tryParse(value.trim());
                    if (rate == null || rate < 0 || rate > 100) return;
                    _setVat(
                      OrderVatSettings(enabled: true, inclusive: _vat.inclusive, rate: rate),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Text('Items', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: () async {
                final product = await pickProduct(context, ref);
                if (product != null) {
                  setState(() => _items.add(LineItemDraft(product: product)..applyVat(_vat)));
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        LineItemsEditor(
          items: _items,
          onChanged: () => setState(() {}),
          onRemove: (i) => setState(() => _items.removeAt(i)),
          vat: _vat,
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _noteTarget() == null ? null : _openCustomerNote,
          icon: const Icon(Icons.note_add),
          label: const Text('Add note'),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(_asDraft ? 'Save Draft' : 'Create Order'),
        ),
      ],
    );
  }
}

class ManualOrdersScreen extends ConsumerWidget {
  const ManualOrdersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(manualOrderRepositoryProvider);
    return CrudListScreen<ManualOrderRequestModel>(
      title: 'Manual Orders',
      loadItems: () async => (await repo.list()).items,
      itemTitle: (m) => '#${m.id} — ${m.status} (${m.source})',
      onTap: (m) => context.push('/sales/manual-orders/${m.id}'),
    );
  }
}

Future<String?> _prompt(BuildContext context, String label) async {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(label),
      content: TextField(controller: controller),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('OK')),
      ],
    ),
  );
}
