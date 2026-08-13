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

  void _edit(BuildContext context, WidgetRef ref, SupplierModel? item) async {
    final countries = await ref.read(adminRepositoriesProvider).countries.list();
    if (!context.mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Supplier' : 'Edit Supplier',
      initialValues: item == null
          ? {}
          : {
              'name': item.name,
              'country_id': item.countryId,
              'mobile': item.mobile,
              'email': item.email,
              'address': item.address,
            },
      fields: [
        const FieldConfig(key: 'name', label: 'Name', required: true),
        FieldConfig(
          key: 'country_id',
          label: 'Country',
          type: FieldType.dropdown,
          required: true,
          options: countries.map((c) => DropdownOption(value: c.id, label: c.name)).toList(),
        ),
        const FieldConfig(key: 'mobile', label: 'Mobile'),
        const FieldConfig(key: 'email', label: 'Email'),
        const FieldConfig(key: 'address', label: 'Address', type: FieldType.textarea),
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

  static const _statusOptions = [
    DropdownOption(value: 'pending', label: 'Pending'),
    DropdownOption(value: 'in_transit', label: 'In transit'),
    DropdownOption(value: 'expected', label: 'Expected'),
    DropdownOption(value: 'received', label: 'Received'),
    DropdownOption(value: 'cancelled', label: 'Cancelled'),
  ];

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

  void _showDetail(BuildContext context, WidgetRef ref, ShippingContainerModel container) async {
    final full = await ref.read(adminRepositoriesProvider).shippingContainers.get(container.id);
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          builder: (_, scrollController) => ListView(
            controller: scrollController,
            children: [
              ListTile(
                title: Text(full.containerNumber ?? 'Container #${full.id}'),
                subtitle: Text('Status: ${full.status ?? ''}'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text('Products', style: Theme.of(context).textTheme.titleMedium),
              ),
              if (full.containerProducts.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('No products yet. Add lines before receiving.'),
                ),
              ...full.containerProducts.map((line) => ListTile(
                    title: Text(line.product?.name ?? 'Product #${line.productId}'),
                    subtitle: Text('Qty: ${line.quantity}${line.costPerUnit != null ? ' · Cost: ${line.costPerUnit}' : ''}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        try {
                          await ref.read(adminRepositoriesProvider).containerProducts.delete(line.id);
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (context.mounted) _showDetail(context, ref, full);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                          }
                        }
                      },
                    ),
                  )),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add product line'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _addContainerProduct(context, ref, full);
                },
              ),
              if (full.status != 'received')
                ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: const Text('Receive container'),
                  subtitle: const Text('Creates purchase and adds stock to warehouse'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    try {
                      await ref.read(purchaseRepositoryProvider).receiveContainer(full.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Container received. Stock added to warehouse.')),
                        );
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
                  _edit(context, ref, full);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addContainerProduct(BuildContext context, WidgetRef ref, ShippingContainerModel container) async {
    final product = await pickProduct(context, ref);
    if (product == null || !context.mounted) return;

    final qty = TextEditingController(text: '1');
    final cost = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: qty,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: cost,
              decoration: const InputDecoration(labelText: 'Cost per unit'),
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
    if (ok != true || !context.mounted) return;

    try {
      await ref.read(adminRepositoriesProvider).containerProducts.create({
        'shipping_container_id': container.id,
        'product_id': product.id,
        'quantity': int.tryParse(qty.text) ?? 0,
        if (cost.text.trim().isNotEmpty) 'cost_per_unit': double.tryParse(cost.text.trim()),
      });
      if (context.mounted) {
        final updated = await ref.read(adminRepositoriesProvider).shippingContainers.get(container.id);
        if (context.mounted) _showDetail(context, ref, updated);
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  void _edit(BuildContext context, WidgetRef ref, ShippingContainerModel? item) async {
    final admin = ref.read(adminRepositoriesProvider);
    final countries = await admin.countries.list();
    final suppliers = (await admin.suppliers.listPaginated()).items;
    if (!context.mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Container' : 'Edit Container',
      initialValues: item == null
          ? {'status': 'expected'}
          : {
              'container_number': item.containerNumber,
              'supplier_id': item.supplierId,
              'country_id': item.countryId,
              'status': item.status,
              'notes': item.notes,
            },
      fields: [
        const FieldConfig(key: 'container_number', label: 'Container Number', required: true),
        FieldConfig(
          key: 'supplier_id',
          label: 'Supplier',
          type: FieldType.dropdown,
          options: suppliers.map((s) => DropdownOption(value: s.id, label: s.name)).toList(),
        ),
        FieldConfig(
          key: 'country_id',
          label: 'Country',
          type: FieldType.dropdown,
          options: countries.map((c) => DropdownOption(value: c.id, label: c.name)).toList(),
        ),
        FieldConfig(
          key: 'status',
          label: 'Status',
          type: FieldType.dropdown,
          options: _statusOptions,
        ),
        const FieldConfig(key: 'notes', label: 'Notes', type: FieldType.textarea),
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

  // Detail comes straight from the list payload — index() eager-loads
  // items.product, so no extra request is needed here.
  void _showPurchaseDetail(BuildContext context, PurchaseModel p) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          ListTile(
            title: Text('#${p.id} — ${p.purchaseType ?? 'local'}'),
            subtitle: Text([
              p.status ?? 'draft',
              if (p.date != null) p.date!,
              if (p.referenceNumber != null) 'Ref ${p.referenceNumber}',
              if (p.supplier?.name != null) p.supplier!.name,
            ].join(' · ')),
            trailing: Text(
              'SAR ${(p.totalAmount ?? 0).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(height: 1),
          for (final it in p.items)
            ListTile(
              dense: true,
              title: Text(it.productName ?? it.product?.name ?? 'Product #${it.productId}'),
              subtitle: Text(
                  '${it.quantity} × ${(it.unitCost ?? it.unitPrice ?? 0).toStringAsFixed(2)}'),
              trailing: Text('SAR ${(it.lineTotal ?? 0).toStringAsFixed(2)}'),
            ),
          if (p.notes != null && p.notes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(p.notes!, style: Theme.of(context).textTheme.bodySmall),
            ),
        ],
      ),
    );
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
                        onTap: p.status == 'draft'
                            ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreatePurchaseScreen(existing: p)),
                                ).then((_) => _load())
                            : () => _showPurchaseDetail(context, p),
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
  final _orderDiscount = TextEditingController();
  final _orderTax = TextEditingController();
  String _purchaseType = 'local';
  int? _supplierId;
  int? _shippingContainerId;
  List<SupplierModel> _suppliers = [];
  List<ShippingContainerModel> _containers = [];
  final List<Map<String, dynamic>> _items = [];
  bool _saving = false;
  bool _loadingOptions = true;

  @override
  void initState() {
    super.initState();
    _loadOptions();
    final existing = widget.existing;
    if (existing != null) {
      _purchaseType = existing.purchaseType ?? 'local';
      if (existing.date != null) _date.text = existing.date!.split('T').first;
      _reference.text = existing.referenceNumber ?? '';
      _notes.text = existing.notes ?? '';
      _supplierId = existing.supplierId;
      _shippingContainerId = existing.shippingContainerId;
      if (existing.orderDiscount != null) _orderDiscount.text = existing.orderDiscount.toString();
      if (existing.orderTax != null) _orderTax.text = existing.orderTax.toString();
      _items.addAll(existing.items.map((item) => {
            'product_id': item.productId,
            'product_name': item.productName ?? item.product?.name,
            'quantity': item.quantity,
            if (item.unitId != null) 'unit_id': item.unitId,
            if ((item.unitPrice ?? item.unitCost) != null) 'unit_price': item.unitPrice ?? item.unitCost,
            if (item.discount != null) 'discount': item.discount,
            if (item.tax != null) 'tax': item.tax,
          }));
    }
  }

  Future<void> _loadOptions() async {
    final admin = ref.read(adminRepositoriesProvider);
    final suppliers = (await admin.suppliers.listPaginated()).items;
    final containers = (await admin.shippingContainers.listPaginated()).items;
    if (mounted) {
      setState(() {
        _suppliers = suppliers;
        _containers = containers;
        _loadingOptions = false;
      });
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
      'supplier_id': _supplierId,
      'shipping_container_id': _shippingContainerId,
      if (_orderDiscount.text.trim().isNotEmpty) 'order_discount': double.tryParse(_orderDiscount.text.trim()),
      if (_orderTax.text.trim().isNotEmpty) 'order_tax': double.tryParse(_orderTax.text.trim()),
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
    if (_loadingOptions) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.existing == null ? 'New Purchase' : 'Edit Draft #${widget.existing!.id}')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
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
          DropdownButtonFormField<int?>(
            initialValue: _supplierId,
            decoration: const InputDecoration(labelText: 'Supplier'),
            items: [
              const DropdownMenuItem(value: null, child: Text('None')),
              ..._suppliers.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))),
            ],
            onChanged: (v) => setState(() => _supplierId = v),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int?>(
            initialValue: _shippingContainerId,
            decoration: const InputDecoration(labelText: 'Shipping Container'),
            items: [
              const DropdownMenuItem(value: null, child: Text('None')),
              ..._containers.map((c) => DropdownMenuItem(
                    value: c.id,
                    child: Text(c.containerNumber ?? 'Container #${c.id}'),
                  )),
            ],
            onChanged: (v) => setState(() => _shippingContainerId = v),
          ),
          const SizedBox(height: 12),
          TextField(controller: _date, decoration: const InputDecoration(labelText: 'Date')),
          const SizedBox(height: 12),
          TextField(controller: _reference, decoration: const InputDecoration(labelText: 'Reference / Invoice #')),
          const SizedBox(height: 12),
          TextField(
            controller: _orderDiscount,
            decoration: const InputDecoration(labelText: 'Order discount'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _orderTax,
            decoration: const InputDecoration(labelText: 'Order tax'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          TextField(controller: _notes, decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 16),
          Text('Line items', style: Theme.of(context).textTheme.titleMedium),
          ..._items.asMap().entries.map((e) {
            final price = e.value['unit_price'];
            final discount = e.value['discount'];
            final tax = e.value['tax'];
            final unitId = e.value['unit_id'] as int?;
            final unitLabel = unitId != null && e.value['pcs_unit_id'] == unitId ? 'pcs' : 'CTN';
            return ListTile(
              title: Text('${e.value['product_name'] ?? 'Product #${e.value['product_id']}'} × ${e.value['quantity']} $unitLabel'),
              subtitle: Text([
                if (price != null) 'Price: $price',
                if (discount != null) 'Discount: $discount',
                if (tax != null) 'Tax: $tax',
              ].join(' · ')),
              trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _items.removeAt(e.key))),
            );
          }),
          OutlinedButton.icon(
            onPressed: () async {
              final product = await pickProduct(context, ref);
              if (product == null || !mounted) return;

              final qty = TextEditingController(text: '1');
              final price = TextEditingController(text: product.cost != null ? '${product.cost}' : '');
              final discount = TextEditingController();
              final tax = TextEditingController();
              int unitId = product.defaultCartonUnitId;
              final canPickPiece = product.canPurchaseByPiece;
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => StatefulBuilder(
                  builder: (ctx, setDialogState) {
                    final isPiece = product.pcsUnitId != null && unitId == product.pcsUnitId;
                    final priceHint = isPiece ? 'Price per piece' : 'Price per carton';
                    return AlertDialog(
                      title: Text(product.name),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (canPickPiece)
                            DropdownButtonFormField<int>(
                              value: unitId,
                              decoration: const InputDecoration(labelText: 'Unit'),
                              items: [
                                if (product.defaultCartonUnitId > 0)
                                  DropdownMenuItem(
                                    value: product.defaultCartonUnitId,
                                    child: const Text('Carton (CTN)'),
                                  ),
                                DropdownMenuItem(
                                  value: product.pcsUnitId,
                                  child: Text('Piece (pcs) · ${product.piecesPerCarton} per CTN'),
                                ),
                              ],
                              onChanged: (v) {
                                if (v == null) return;
                                setDialogState(() {
                                  unitId = v;
                                  final nextCost = product.costForUnitId(v);
                                  if (nextCost != null) {
                                    price.text = nextCost.toString();
                                  }
                                });
                              },
                            ),
                          TextField(controller: qty, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
                          TextField(
                            controller: price,
                            decoration: InputDecoration(
                              labelText: 'Purchase price',
                              helperText: '$priceHint. Defaults to cost price. Leave empty to price later — only allowed for drafts.',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                          TextField(
                            controller: discount,
                            decoration: const InputDecoration(labelText: 'Line discount'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                          TextField(
                            controller: tax,
                            decoration: const InputDecoration(labelText: 'Line tax'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Add')),
                      ],
                    );
                  },
                ),
              );
              if (ok == true) {
                setState(() => _items.add({
                      'product_id': product.id,
                      'product_name': product.name,
                      'unit_id': unitId,
                      if (product.pcsUnitId != null) 'pcs_unit_id': product.pcsUnitId,
                      'quantity': int.tryParse(qty.text) ?? 1,
                      if (price.text.trim().isNotEmpty) 'unit_price': double.tryParse(price.text.trim()),
                      if (discount.text.trim().isNotEmpty) 'discount': double.tryParse(discount.text.trim()),
                      if (tax.text.trim().isNotEmpty) 'tax': double.tryParse(tax.text.trim()),
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
