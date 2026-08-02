import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';
import '../inventory/inventory_screens.dart';

void _showOfflineWriteError(BuildContext context, Object e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppErrorMapper.localize(context, e))),
  );
}

class CountriesScreen extends ConsumerWidget {
  const CountriesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = cachedCrud<CountryModel>(
      ref: ref,
      remote: ref.watch(adminRepositoriesProvider).countries,
      cacheKey: 'countries',
      toJson: (c) => c.toJson(),
    );
    return CrudListScreen<CountryModel>(
      title: 'Countries',
      loadItems: () async => (await repo.listParsed(fromJson: CountryModel.fromJson)).items,
      itemTitle: (c) => '${c.name} (${c.code ?? ''})',
      onTap: (c) => _edit(context, ref, c),
      onAdd: () => _edit(context, ref, null),
      onDelete: (c) async {
        try {
          await repo.delete(c.id);
        } catch (e) {
          _showOfflineWriteError(context, e);
          rethrow;
        }
      },
    );
  }

  void _edit(BuildContext context, WidgetRef ref, CountryModel? item) {
    final repo = cachedCrud<CountryModel>(
      ref: ref,
      remote: ref.read(adminRepositoriesProvider).countries,
      cacheKey: 'countries',
      toJson: (c) => c.toJson(),
    );
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Country' : 'Edit Country',
      initialValues: item == null ? {} : {'name': item.name, 'code': item.code},
      fields: const [
        FieldConfig(key: 'name', label: 'Name', required: true),
        FieldConfig(key: 'code', label: 'Code'),
      ],
      onSave: (v) async {
        try {
          if (item == null) await repo.create(v);
          else await repo.update(item.id, v);
        } catch (e) {
          _showOfflineWriteError(context, e);
          rethrow;
        }
      },
    )));
  }
}

class SuppliersScreen extends ConsumerWidget {
  const SuppliersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = cachedCrud<SupplierModel>(
      ref: ref,
      remote: ref.watch(adminRepositoriesProvider).suppliers,
      cacheKey: 'suppliers',
      toJson: (s) => s.toJson(),
    );
    return CrudListScreen<SupplierModel>(
      title: 'Suppliers',
      loadItems: () async => (await repo.listParsed(fromJson: SupplierModel.fromJson)).items,
      itemTitle: (s) => s.name,
      onTap: (s) => _edit(context, ref, s),
      onAdd: () => _edit(context, ref, null),
      onDelete: (s) async {
        try {
          await repo.delete(s.id);
        } catch (e) {
          _showOfflineWriteError(context, e);
          rethrow;
        }
      },
    );
  }

  void _edit(BuildContext context, WidgetRef ref, SupplierModel? item) {
    final repo = cachedCrud<SupplierModel>(
      ref: ref,
      remote: ref.read(adminRepositoriesProvider).suppliers,
      cacheKey: 'suppliers',
      toJson: (s) => s.toJson(),
    );
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
        try {
          if (item == null) await repo.create(v);
          else await repo.update(item.id, v);
        } catch (e) {
          _showOfflineWriteError(context, e);
          rethrow;
        }
      },
    )));
  }
}

class ContainersScreen extends ConsumerWidget {
  const ContainersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = cachedCrud<ShippingContainerModel>(
      ref: ref,
      remote: ref.watch(adminRepositoriesProvider).shippingContainers,
      cacheKey: 'shipping_containers',
      toJson: (c) => c.toJson(),
    );
    return CrudListScreen<ShippingContainerModel>(
      title: 'Shipping Containers',
      loadItems: () async => (await repo.listParsed(fromJson: ShippingContainerModel.fromJson)).items,
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
                    if (context.mounted) _showOfflineWriteError(context, e);
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
    final repo = cachedCrud<ShippingContainerModel>(
      ref: ref,
      remote: ref.read(adminRepositoriesProvider).shippingContainers,
      cacheKey: 'shipping_containers',
      toJson: (c) => c.toJson(),
    );
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Container' : 'Edit Container',
      initialValues: item == null ? {} : item.toJson(),
      fields: const [
        FieldConfig(key: 'container_number', label: 'Container Number'),
        FieldConfig(key: 'status', label: 'Status'),
        FieldConfig(key: 'notes', label: 'Notes', type: FieldType.textarea),
      ],
      onSave: (v) async {
        try {
          if (item == null) await repo.create(v);
          else await repo.update(item.id, v);
        } catch (e) {
          _showOfflineWriteError(context, e);
          rethrow;
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
      final list = await ref.read(purchaseRepositoryProvider).list();
      setState(() {
        _purchases = list;
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreatePurchaseScreen()),
        ).then((_) => _load()),
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
            ],
          ),
          Expanded(
            child: _loading
                ? const LoadingView()
                : _error != null
                    ? ErrorView(
                        message: AppErrorMapper.localize(context, _error!),
                        error: _error,
                        onRetry: _load,
                      )
                    : ListView.builder(
                        padding: fabScrollPadding(context, includeBottomNav: true),
                        itemCount: _purchases.length,
                        itemBuilder: (_, i) {
                          final p = _purchases[i];
                          return ListTile(
                            title: Text('#${p.id} — ${p.purchaseType ?? 'local'}'),
                            subtitle: Text(
                              '${p.status ?? 'draft'} · SAR ${(p.totalAmount ?? 0).toStringAsFixed(2)}',
                            ),
                            trailing: p.status == 'draft'
                                ? IconButton(
                                    icon: const Icon(Icons.check_circle_outline),
                                    onPressed: () async {
                                      try {
                                        await ref.read(purchaseRepositoryProvider).post(p.id);
                                        _load();
                                      } catch (e) {
                                        if (mounted) _showOfflineWriteError(context, e);
                                      }
                                    },
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

class CreatePurchaseScreen extends ConsumerStatefulWidget {
  const CreatePurchaseScreen({super.key});
  @override
  ConsumerState<CreatePurchaseScreen> createState() => _CreatePurchaseScreenState();
}

class _CreatePurchaseScreenState extends ConsumerState<CreatePurchaseScreen> {
  final _date = TextEditingController(text: DateTime.now().toIso8601String().split('T').first);
  final _reference = TextEditingController();
  final _notes = TextEditingController();
  String _purchaseType = 'local';
  final List<Map<String, dynamic>> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: _purchaseType,
            decoration: const InputDecoration(labelText: 'Purchase Type', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'local', child: Text('Local')),
              DropdownMenuItem(value: 'import', child: Text('Import')),
            ],
            onChanged: (v) => setState(() => _purchaseType = v ?? 'local'),
          ),
          const SizedBox(height: 12),
          TextField(controller: _date, decoration: const InputDecoration(labelText: 'Date', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _reference, decoration: const InputDecoration(labelText: 'Reference / Invoice #', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _notes, decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          Text('Line items', style: Theme.of(context).textTheme.titleMedium),
          ..._items.asMap().entries.map((e) => ListTile(
                title: Text('Product #${e.value['product_id']} × ${e.value['quantity']}'),
                subtitle: Text('Cost: ${e.value['unit_cost']}'),
                trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _items.removeAt(e.key))),
              )),
          OutlinedButton.icon(
            onPressed: () async {
              final productId = TextEditingController();
              final qty = TextEditingController(text: '1');
              final cost = TextEditingController();
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Add item'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(controller: productId, decoration: const InputDecoration(labelText: 'Product ID'), keyboardType: TextInputType.number),
                      TextField(controller: qty, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
                      TextField(controller: cost, decoration: const InputDecoration(labelText: 'Unit cost'), keyboardType: TextInputType.number),
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
                      'product_id': int.parse(productId.text),
                      'quantity': int.parse(qty.text),
                      'unit_cost': double.parse(cost.text),
                    }));
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Add item'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _items.isEmpty
                ? null
                : () async {
                    try {
                      await ref.read(purchaseRepositoryProvider).create({
                        'purchase_type': _purchaseType,
                        'date': _date.text,
                        'reference_number': _reference.text.isEmpty ? null : _reference.text,
                        'notes': _notes.text.isEmpty ? null : _notes.text,
                        'items': _items,
                        'post_immediately': true,
                      });
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) _showOfflineWriteError(context, e);
                    }
                  },
            child: const Text('Save & Post'),
          ),
        ],
      ),
    );
  }
}
