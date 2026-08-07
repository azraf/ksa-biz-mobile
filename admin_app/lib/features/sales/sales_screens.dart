import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';
import '../../widgets/line_items_editor.dart';
import 'collect_payment_screen.dart';
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
    final repo = ref.watch(offlineOrderRepositoryProvider);
    return CrudListScreen<OrderModel>(
      title: 'Orders',
      loadItems: () async {
        unawaited(ref.read(syncServiceProvider).syncIfOnline().timeout(
              const Duration(seconds: 30),
              onTimeout: () {},
            ));
        return (await repo.list()).items;
      },
      itemTitle: (o) => '#${o.id} — SAR ${o.totalBill.toStringAsFixed(2)} (${o.paymentStatus})',
      isPending: (o) => o.id < 0,
      onTap: (o) => context.push('/sales/orders/${o.id}'),
      onAdd: () => context.push('/sales/orders/create'),
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

  Future<void> _collectPayment() async {
    final order = _order!;
    final due = order.amountDue > 0 ? order.amountDue : order.totalBill - order.amountPaid;
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
    final pending = order.id < 0;
    final canEdit = order.isEditable && !pending;
    final due = order.amountDue > 0 ? order.amountDue : order.totalBill - order.amountPaid;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pending)
          const Card(
            color: Colors.orange,
            child: ListTile(
              leading: Icon(Icons.sync),
              title: Text('Pending sync'),
              subtitle: Text('This order will upload when online'),
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
                    Text('Order #${order.id}', style: Theme.of(context).textTheme.titleMedium),
                    StatusChip(label: order.paymentStatus),
                  ],
                ),
                Text('Status: ${order.status}'),
                Text(currency.format(order.totalBill), style: Theme.of(context).textTheme.headlineSmall),
                const Divider(),
                _row('Paid', currency.format(order.amountPaid)),
                _row('Due', currency.format(due), bold: true),
              ],
            ),
          ),
        ),
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
                  if (p.paidAt != null) p.paidAt!,
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
        if (canEdit) ...[
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () async {
              final reason = await _prompt(context, 'Cancellation reason');
              if (reason == null) return;
              await ref.read(offlineOrderRepositoryProvider).cancel(order.id, reason);
              ref.invalidate(pendingSyncCountProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Cancel Order'),
          ),
        ],
      ],
    );
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
    final customerRepo = ref.read(customerRepositoryProvider);
    _types = await customerRepo.customerTypes();
    _salesPersons = (await customerRepo.salesPersons()).items;
    _walkInShopId = await customerRepo.walkInShopId();
    _shops = (await customerRepo.shops()).items.where((s) => !s.isSystem).toList();
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
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

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

class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<InvoiceModel>>(
      future: _load(ref),
      builder: (context, snap) {
        if (!snap.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
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

  Future<List<InvoiceModel>> _load(WidgetRef ref) async {
    final response = await ref.read(apiClientProvider).get('/invoices');
    return (response['data'] as List<dynamic>)
        .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
        .toList();
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
