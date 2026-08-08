import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';

// --- Tags ---
class TagsScreen extends ConsumerWidget {
  const TagsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(adminRepositoriesProvider).tags;
    return CrudListScreen<TagModel>(
      title: 'Tags',
      loadItems: repo.list,
      itemTitle: (t) => t.name,
      onTap: (t) => _editTag(context, ref, t),
      onAdd: () => _editTag(context, ref, null),
      onDelete: (t) => repo.delete(t.id),
    );
  }

  void _editTag(BuildContext context, WidgetRef ref, TagModel? tag) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => CrudFormScreen(
        title: tag == null ? 'New Tag' : 'Edit Tag',
        initialValues: tag == null ? {} : {'name': tag.name, 'slug': tag.slug},
        fields: const [
          FieldConfig(key: 'name', label: 'Name', required: true),
          FieldConfig(key: 'slug', label: 'Slug'),
        ],
        onSave: (v) async {
          final repo = ref.read(adminRepositoriesProvider).tags;
          if (tag == null) await repo.create(v);
          else await repo.update(tag.id, v);
        },
      ),
    ));
  }
}

// --- Brands ---
class BrandsScreen extends ConsumerWidget {
  const BrandsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(adminRepositoriesProvider).brands;
    return CrudListScreen<BrandModel>(
      title: 'Brands',
      loadItems: repo.list,
      itemTitle: (b) => b.name,
      onTap: (b) => _edit(context, ref, b),
      onAdd: () => _edit(context, ref, null),
      onDelete: (b) => repo.delete(b.id),
    );
  }

  void _edit(BuildContext context, WidgetRef ref, BrandModel? item) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Brand' : 'Edit Brand',
      initialValues: item == null ? {} : {'name': item.name},
      fields: const [FieldConfig(key: 'name', label: 'Name', required: true)],
      onSave: (v) async {
        final repo = ref.read(adminRepositoriesProvider).brands;
        if (item == null) await repo.create(v); else await repo.update(item.id, v);
      },
    )));
  }
}

// --- Units ---
class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(adminRepositoriesProvider).units;
    return CrudListScreen<UnitModel>(
      title: 'Units',
      loadItems: repo.list,
      itemTitle: (u) => '${u.shortName} (${u.longName ?? ''})',
      onTap: (u) => _edit(context, ref, u),
      onAdd: () => _edit(context, ref, null),
      onDelete: (u) => repo.delete(u.id),
    );
  }

  void _edit(BuildContext context, WidgetRef ref, UnitModel? item) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Unit' : 'Edit Unit',
      initialValues: item == null ? {} : {'short_name': item.shortName, 'long_name': item.longName},
      fields: const [
        FieldConfig(key: 'short_name', label: 'Short Name', required: true),
        FieldConfig(key: 'long_name', label: 'Long Name'),
      ],
      onSave: (v) async {
        final repo = ref.read(adminRepositoriesProvider).units;
        if (item == null) await repo.create(v); else await repo.update(item.id, v);
      },
    )));
  }
}

// --- Categories ---
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(adminRepositoriesProvider).categories;
    return CrudListScreen<CategoryModel>(
      title: 'Categories',
      loadItems: () => repo.list(query: {'with_children': '1'}),
      itemTitle: (c) => c.name,
      onTap: (c) => _edit(context, ref, c),
      onAdd: () => _edit(context, ref, null),
      onDelete: (c) => repo.delete(c.id),
    );
  }

  void _edit(BuildContext context, WidgetRef ref, CategoryModel? item) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Category' : 'Edit Category',
      initialValues: item == null ? {} : {'name': item.name, 'slug': item.slug},
      fields: const [
        FieldConfig(key: 'name', label: 'Name', required: true),
        FieldConfig(key: 'slug', label: 'Slug'),
      ],
      onSave: (v) async {
        final repo = ref.read(adminRepositoriesProvider).categories;
        if (item == null) await repo.create(v); else await repo.update(item.id, v);
      },
    )));
  }
}

// --- Products ---
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(productRepositoryProvider);
    return CrudListScreen<ProductModel>(
      title: 'Products',
      loadItems: () async => (await repo.list()).items,
      itemTitle: (p) => '${p.name} — ${p.price}',
      onTap: (p) => context.push('/catalog/products/${p.id}'),
      onAdd: () => context.push('/catalog/products/create'),
    );
  }
}

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({super.key, this.productId});
  final int? productId;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _cost = TextEditingController();
  final _description = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) _load();
    else _loading = false;
  }

  Future<void> _load() async {
    final p = await ref.read(productRepositoryProvider).get(widget.productId!);
    _name.text = p.name;
    _price.text = p.price.toString();
    _description.text = p.description ?? '';
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: Text(widget.productId == null ? 'New Product' : 'Edit Product')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 12),
          TextField(controller: _price, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          TextField(controller: _cost, decoration: const InputDecoration(labelText: 'Cost'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          TextField(controller: _description, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              final body = {
                'name': _name.text,
                'price': double.tryParse(_price.text) ?? 0,
                if (_cost.text.isNotEmpty) 'cost': double.tryParse(_cost.text),
                'description': _description.text,
              };
              final repo = ref.read(productRepositoryProvider);
              if (widget.productId == null) await repo.create(body);
              else await repo.update(widget.productId!, body);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// --- Promotions ---
class PromotionsScreen extends ConsumerWidget {
  const PromotionsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(adminRepositoriesProvider).promotions;
    return CrudListScreen<PromotionModel>(
      title: 'Promotions',
      loadItems: () async => (await repo.listPaginated()).items,
      itemTitle: (p) => '${p.name} (${p.startDate} - ${p.endDate})',
      onTap: (p) => _edit(context, ref, p),
      onAdd: () => _edit(context, ref, null),
      onDelete: (p) => repo.delete(p.id),
    );
  }

  void _edit(BuildContext context, WidgetRef ref, PromotionModel? item) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Promotion' : 'Edit Promotion',
      initialValues: item?.toJson() ?? {},
      fields: const [
        FieldConfig(key: 'name', label: 'Name', required: true),
        FieldConfig(key: 'description', label: 'Description', type: FieldType.textarea),
        FieldConfig(key: 'start_date', label: 'Start Date (YYYY-MM-DD)', required: true),
        FieldConfig(key: 'end_date', label: 'End Date (YYYY-MM-DD)', required: true),
        FieldConfig(key: 'percent_discount', label: '% Discount', type: FieldType.number),
        FieldConfig(key: 'flat_discount', label: 'Flat Discount', type: FieldType.number),
        FieldConfig(key: 'active', label: 'Active', type: FieldType.boolean),
      ],
      onSave: (v) async {
        final repo = ref.read(adminRepositoriesProvider).promotions;
        if (item == null) await repo.create(v); else await repo.update(item.id, v);
      },
    )));
  }
}
