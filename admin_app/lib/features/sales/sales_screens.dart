import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/repositories.dart';
import '../../providers/screen_providers.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';
import '../../widgets/line_items_editor.dart';
import 'manual_order_detail_screen.dart';
import 'order_edit_screen.dart';

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
      initialValues: person == null ? {} : {'name': person.name, 'mobile': person.mobile, 'email': person.email},
      fields: const [
        FieldConfig(key: 'name', label: 'Name', required: true),
        FieldConfig(key: 'mobile', label: 'Mobile'),
        FieldConfig(key: 'email', label: 'Email', type: FieldType.email),
      ],
      onSave: (v) async {
        final api = ref.read(apiClientProvider);
        if (person == null) await api.post('/sales-persons', body: v);
        else await api.put('/sales-persons/${person.id}', body: v);
      },
    )));
  }
}

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currency = NumberFormat.currency(symbol: 'SAR ');
    final ordersAsync = ref.watch(adminOrdersProvider);

    final listPadding = fabScrollPadding(context, extendedFab: true, includeBottomNav: true);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/sales/orders/create'),
        icon: const Icon(Icons.add),
        label: Text(l10n.commonNewOrder),
      ),
      body: ordersAsync.when(
        loading: () => ListView.builder(
          padding: listPadding,
          itemCount: 8,
          itemBuilder: (_, __) => const SkeletonListTile(),
        ),
        error: (e, _) => ErrorView(
          message: AppErrorMapper.localize(context, e),
          error: e,
          onRetry: () => ref.read(adminOrdersProvider.notifier).refresh(),
        ),
        data: (state) => state.orders.isEmpty
            ? EmptyView(
                message: l10n.commonNoOrdersYet,
                actionLabel: l10n.commonNewOrder,
                onAction: () => context.push('/sales/orders/create'),
              )
            : RefreshIndicator(
                onRefresh: () => ref.read(adminOrdersProvider.notifier).refresh(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n is ScrollEndNotification &&
                        n.metrics.extentAfter < 200 &&
                        state.hasMore &&
                        !state.loadingMore) {
                      ref.read(adminOrdersProvider.notifier).loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: listPadding,
                    itemCount: state.orders.length + (state.loadingMore ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i >= state.orders.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final order = state.orders[i];
                      return OrderCard(
                        order: order,
                        currency: currency,
                        onTap: () => context.push('/sales/orders/${order.id}'),
                      );
                    },
                  ),
                ),
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
  Object? _error;

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
        _error = e;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) return LoadingView(message: l10n.commonLoading);
    if (_error != null) {
      return ErrorView(
        message: AppErrorMapper.localize(context, _error!),
        error: _error,
        onRetry: _load,
      );
    }

    final order = _order!;
    final pending = isPendingSyncOrder(order.id);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pending)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: StatusChip(label: 'pending sync'),
          ),
        if (order.isEditable && order.id > 0 && !pending)
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/sales/orders/${order.id}/edit'),
            ),
          ),
        Text('Status: ${order.status}'),
        Text('Payment: ${order.paymentStatus}'),
        Text('Total: SAR ${order.totalBill.toStringAsFixed(2)}'),
        const Divider(),
        Text(l10n.commonItems, style: const TextStyle(fontWeight: FontWeight.bold)),
        ...order.items.map((i) => ListTile(
              title: Text(i.product?.name ?? l10n.commonProductFallback(i.productId)),
              trailing: Text('${i.quantity} x ${i.productPrice}'),
            )),
        if (order.isEditable && !pending) ...[
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () async {
              final reason = await _prompt(context, 'Cancellation reason');
              if (reason == null) return;
              try {
                await ref.read(offlineOrderRepositoryProvider).cancel(order.id, reason);
                ref.invalidate(pendingSyncCountProvider);
                ref.invalidate(adminOrdersProvider);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppErrorMapper.localize(context, e))),
                  );
                }
              }
            },
            child: Text(l10n.salesOrderCancelOrder),
          ),
        ],
      ],
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
  final _items = <LineItemDraft>[];
  final _walkInNoteController = TextEditingController();
  bool _walkInMode = false;
  int? _walkInShopId;
  int? _salesPersonId;
  List<SalesPersonModel> _salesPersons = [];
  List<CustomerShopModel> _shops = [];
  bool _loading = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _walkInNoteController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final customerRepo = ref.read(offlineCustomerRepositoryProvider);
    final remoteCustomerRepo = ref.read(customerRepositoryProvider);
    _types = await customerRepo.customerTypes();
    _salesPersons = (await remoteCustomerRepo.salesPersons()).items;
    _walkInShopId = await customerRepo.walkInShopId();
    _shops = (await customerRepo.shops(scoped: false)).items.where((s) => !s.isSystem).toList();
    if (_shops.isNotEmpty) _selectedShop = _shops.first;
    if (_salesPersons.isNotEmpty) _salesPersonId = _salesPersons.first.id;
    if (_types.isNotEmpty) {
      _selectedType = _types.firstWhere(
        (t) => t.typeName == 'customer_shop',
        orElse: () => _types.first,
      );
    }
    setState(() => _loading = false);
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
  }

  Future<void> _submit() async {
    if (_selectedType == null || _items.isEmpty) return;
    if (!_walkInMode && _selectedShop == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a shop')));
      return;
    }
    setState(() => _submitting = true);
    try {
      final body = <String, dynamic>{
        if (_salesPersonId != null) 'sales_person_id': _salesPersonId,
        'customer_type_id': _selectedType!.id,
        'customer_shop_id': _walkInMode ? _walkInShopId : _selectedShop?.id,
        'payment_status': 'pending',
        'items': _items.map((e) => e.toJson()).toList(),
      };
      if (_walkInMode && _walkInNoteController.text.trim().isNotEmpty) {
        body['walk_in_note'] = _walkInNoteController.text.trim();
      }
      await ref.read(offlineOrderRepositoryProvider).create(body);
      ref.invalidate(pendingSyncCountProvider);
      ref.invalidate(adminOrdersProvider);
      AppHaptics.success();
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppErrorMapper.localize(context, e))),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();

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
          value: _salesPersonId,
          decoration: const InputDecoration(labelText: 'Sales person', border: OutlineInputBorder()),
          items: _salesPersons.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
          onChanged: (v) => setState(() => _salesPersonId = v),
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
            decoration: const InputDecoration(labelText: 'Note (optional)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
        ] else ...[
          DropdownButtonFormField<CustomerShopModel>(
            value: _selectedShop,
            decoration: const InputDecoration(labelText: 'Shop', border: OutlineInputBorder()),
            items: _shops
                .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                .toList(),
            onChanged: (v) => setState(() => _selectedShop = v),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Text('Items', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: () async {
                final product = await pickProduct(context, ref);
                if (product != null) setState(() => _items.add(LineItemDraft(product: product)));
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
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Create Order'),
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

class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});
  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  late Future<List<InvoiceModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  void _reload() => setState(() => _future = _load());

  Future<List<InvoiceModel>> _load() async {
    final response = await ref.read(apiClientProvider).get('/invoices');
    return (response['data'] as List<dynamic>)
        .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InvoiceModel>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: LoadingView());
        }
        if (snap.hasError) {
          return Scaffold(
            body: ErrorView(
              message: AppErrorMapper.localize(context, snap.error!),
              error: snap.error,
              onRetry: _reload,
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Invoices')),
          body: ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (_, i) {
              final inv = snap.data![i];
              return ListTile(
                title: Text('Invoice #${inv.id}'),
                subtitle: Text('Order: ${inv.orderId ?? '-'}'),
              );
            },
          ),
        );
      },
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
