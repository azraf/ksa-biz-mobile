import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';
import '../../widgets/line_items_editor.dart';

class CountriesScreen extends ConsumerWidget {
  const CountriesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(adminRepositoriesProvider).countries;
    return CrudListScreen<CountryModel>(
      title: 'Countries',
      loadItems: repo.list,
      itemTitle: (c) => '${c.name} (${c.code ?? ''})',
      onTap: (c) => _edit(context, ref, c),
      onAdd: () => _edit(context, ref, null),
      onDelete: (c) => repo.delete(c.id),
    );
  }

  void _edit(BuildContext context, WidgetRef ref, CountryModel? item) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Country' : 'Edit Country',
      initialValues: item == null ? {} : {'name': item.name, 'code': item.code},
      fields: const [
        FieldConfig(key: 'name', label: 'Name', required: true),
        FieldConfig(key: 'code', label: 'Code'),
      ],
      onSave: (v) async {
        final repo = ref.read(adminRepositoriesProvider).countries;
        if (item == null) {
          await repo.create(v);
        } else {
          await repo.update(item.id, v);
        }
      },
    )));
  }
}

class SuppliersScreen extends ConsumerWidget {
  const SuppliersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(adminRepositoriesProvider).suppliers;
    return CrudListScreen<SupplierModel>(
      title: 'Suppliers',
      loadItems: () async => (await repo.listPaginated()).items,
      itemTitle: (s) => s.name,
      onTap: (s) => _edit(context, ref, s),
      onAdd: () => _edit(context, ref, null),
      onDelete: (s) => repo.delete(s.id),
    );
  }

  void _edit(BuildContext context, WidgetRef ref, SupplierModel? item) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Supplier' : 'Edit Supplier',
      initialValues: item == null ? {} : item.toJson(),
      fields: const [
        FieldConfig(key: 'name', label: 'Name', required: true),
        FieldConfig(key: 'mobile', label: 'Mobile'),
        FieldConfig(key: 'email', label: 'Email'),
        FieldConfig(key: 'address', label: 'Address', type: FieldType.textarea),
      ],
      onSave: (v) async {
        final repo = ref.read(adminRepositoriesProvider).suppliers;
        if (item == null) {
          await repo.create(v);
        } else {
          await repo.update(item.id, v);
        }
      },
    )));
  }
}

class ContainersScreen extends ConsumerWidget {
  const ContainersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(adminRepositoriesProvider).shippingContainers;
    return CrudListScreen<ShippingContainerModel>(
      title: 'Shipping Containers',
      loadItems: () async => (await repo.listPaginated()).items,
      itemTitle: (c) => '${c.containerNumber ?? 'N/A'} — ${c.status ?? ''}',
      onTap: (c) => _showDetail(context, ref, c),
      onAdd: () => _edit(context, ref, null),
    );
  }

  void _showDetail(BuildContext context, WidgetRef ref, ShippingContainerModel container) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(container.containerNumber ?? 'Container #${container.id}'), subtitle: Text('Status: ${container.status ?? ''}')),
            if (container.status != 'received')
              ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: const Text('Receive container'),
                subtitle: const Text('Creates purchase and adds stock to warehouse'),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    await ref.read(purchaseRepositoryProvider).receiveContainer(container.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Container received. Stock added to warehouse.')));
                    }
                  } catch (e) {
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                  }
                },
              ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(ctx);
                _edit(context, ref, container);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _edit(BuildContext context, WidgetRef ref, ShippingContainerModel? item) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Container' : 'Edit Container',
      initialValues: item == null ? {} : item.toJson(),
      fields: const [
        FieldConfig(key: 'container_number', label: 'Container Number'),
        FieldConfig(key: 'status', label: 'Status'),
        FieldConfig(key: 'notes', label: 'Notes', type: FieldType.textarea),
      ],
      onSave: (v) async {
        final repo = ref.read(adminRepositoriesProvider).shippingContainers;
        if (item == null) {
          await repo.create(v);
        } else {
          await repo.update(item.id, v);
        }
      },
    )));
  }
}

class PurchasesScreen extends ConsumerStatefulWidget {
  const PurchasesScreen({super.key});
  @override
  ConsumerState<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends ConsumerState<PurchasesScreen> {
  List<PurchaseModel> _purchases = [];
  bool _loading = true;
  String? _status;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await ref.read(purchaseRepositoryProvider).list(status: _status);
      setState(() {
        _purchases = list;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      floatingActionButton: TranslucentFab(
        onOpen: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePurchaseScreen())).then((_) => _load()),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Wrap(
              spacing: 6,
              children: [
                for (final status in const ['draft', 'posted', 'cancelled'])
                  FilterChip(
                    label: Text(status),
                    selected: _status == status,
                    onSelected: (on) {
                      setState(() => _status = on ? status : null);
                      _load();
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.fabClearance),
                    itemCount: _purchases.length,
                    itemBuilder: (_, i) {
                      final p = _purchases[i];
                      return ListTile(
                        title: Text('#${p.id} — ${p.purchaseType ?? 'local'}'),
                        subtitle: Text('${p.status ?? 'draft'} · SAR ${(p.totalAmount ?? 0).toStringAsFixed(2)}'),
                        trailing: p.status == 'draft'
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    tooltip: 'Edit draft',
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => CreatePurchaseScreen(existing: p)),
                                    ).then((_) => _load()),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.check_circle_outline),
                                    tooltip: 'Post — moves stock',
                                    onPressed: () async {
                                      try {
                                        await ref.read(purchaseRepositoryProvider).post(p.id);
                                        _load();
                                      } catch (e) {
                                        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                                      }
                                    },
                                  ),
                                ],
                              )
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Create — or edit an existing draft when [existing] is passed. Posting is
/// the moment stock moves; drafts have no inventory effect.
class CreatePurchaseScreen extends ConsumerStatefulWidget {
  const CreatePurchaseScreen({super.key, this.existing});

  final PurchaseModel? existing;

  @override
  ConsumerState<CreatePurchaseScreen> createState() => _CreatePurchaseScreenState();
}

class _CreatePurchaseScreenState extends ConsumerState<CreatePurchaseScreen> {
  final _date = TextEditingController(text: DateTime.now().toIso8601String().split('T').first);
  final _reference = TextEditingController();
  final _notes = TextEditingController();
  String _purchaseType = 'local';
  final List<Map<String, dynamic>> _items = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _purchaseType = existing.purchaseType ?? 'local';
      if (existing.date != null) _date.text = existing.date!.split('T').first;
      _reference.text = existing.referenceNumber ?? '';
      _notes.text = existing.notes ?? '';
      _items.addAll(existing.items.map((item) => {
            'product_id': item.productId,
            'product_name': item.productName ?? item.product?.name,
            'quantity': item.quantity,
            if ((item.unitPrice ?? item.unitCost) != null) 'unit_price': item.unitPrice ?? item.unitCost,
          }));
    }
  }

  Future<void> _save({required bool post}) async {
    if (post && _items.any((i) => i['unit_price'] == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All items need a price before posting.')),
      );
      return;
    }
    setState(() => _saving = true);
    final body = {
      'purchase_type': _purchaseType,
      'date': _date.text,
      'reference_number': _reference.text.isEmpty ? null : _reference.text,
      'notes': _notes.text.isEmpty ? null : _notes.text,
      'items': _items,
      if (post) 'post_immediately': true,
    };
    try {
      if (widget.existing != null) {
        await ref.read(purchaseRepositoryProvider).update(widget.existing!.id, body);
      } else {
        await ref.read(purchaseRepositoryProvider).create(body);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'New Purchase' : 'Edit Draft #${widget.existing!.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _purchaseType,
            decoration: const InputDecoration(labelText: 'Purchase Type'),
            items: const [
              DropdownMenuItem(value: 'local', child: Text('Local')),
              DropdownMenuItem(value: 'import', child: Text('Import')),
            ],
            onChanged: (v) => setState(() => _purchaseType = v ?? 'local'),
          ),
          const SizedBox(height: 12),
          TextField(controller: _date, decoration: const InputDecoration(labelText: 'Date')),
          const SizedBox(height: 12),
          TextField(controller: _reference, decoration: const InputDecoration(labelText: 'Reference / Invoice #')),
          const SizedBox(height: 12),
          TextField(controller: _notes, decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 16),
          Text('Line items', style: Theme.of(context).textTheme.titleMedium),
          ..._items.asMap().entries.map((e) {
            final price = e.value['unit_price'];
            return ListTile(
              title: Text('${e.value['product_name'] ?? 'Product #${e.value['product_id']}'} × ${e.value['quantity']}'),
              subtitle: Text(price != null ? 'Price: $price' : 'No price set'),
              trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _items.removeAt(e.key))),
            );
          }),
          OutlinedButton.icon(
            onPressed: () async {
              final product = await pickProduct(context, ref);
              if (product == null || !mounted) return;

              final qty = TextEditingController(text: '1');
              final price = TextEditingController(text: product.cost != null ? '${product.cost}' : '');
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(product.name),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(controller: qty, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
                      TextField(
                        controller: price,
                        decoration: const InputDecoration(
                          labelText: 'Purchase price',
                          helperText: 'Defaults to cost price. Leave empty to price later — only allowed for drafts.',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Add')),
                  ],
                ),
              );
              if (ok == true) {
                setState(() => _items.add({
                      'product_id': product.id,
                      'product_name': product.name,
                      'quantity': int.tryParse(qty.text) ?? 1,
                      if (price.text.trim().isNotEmpty) 'unit_price': double.tryParse(price.text.trim()),
                    }));
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Add item'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _items.isEmpty || _saving ? null : () => _save(post: true),
            child: const Text('Save & Post'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _items.isEmpty || _saving ? null : () => _save(post: false),
            icon: const Icon(Icons.edit_note_outlined),
            label: const Text('Save as draft'),
          ),
        ],
      ),
    );
  }
}
