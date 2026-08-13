import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media/media.dart';

import '../../providers/repositories.dart';
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
          if (tag == null) {
            await repo.create(v);
          } else {
            await repo.update(tag.id, v);
          }
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
        if (item == null) {
          await repo.create(v);
        } else {
          await repo.update(item.id, v);
        }
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
        if (item == null) {
          await repo.create(v);
        } else {
          await repo.update(item.id, v);
        }
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

  void _edit(BuildContext context, WidgetRef ref, CategoryModel? item) async {
    final categories = await ref.read(adminRepositoriesProvider).categories.list();
    if (!context.mounted) return;
    final parentOptions = categories
        .where((c) => item == null || c.id != item.id)
        .map((c) => DropdownOption(value: c.id, label: c.name))
        .toList();
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Category' : 'Edit Category',
      initialValues: item == null
          ? {'order': 0}
          : {
              'name': item.name,
              'slug': item.slug,
              'parent_id': item.parentId,
              'order': item.order,
            },
      fields: [
        const FieldConfig(key: 'name', label: 'Name', required: true),
        const FieldConfig(key: 'slug', label: 'Slug'),
        FieldConfig(
          key: 'parent_id',
          label: 'Parent category',
          type: FieldType.dropdown,
          options: parentOptions,
        ),
        const FieldConfig(key: 'order', label: 'Order', type: FieldType.number),
      ],
      onSave: (v) async {
        final repo = ref.read(adminRepositoriesProvider).categories;
        if (item == null) {
          await repo.create(v);
        } else {
          await repo.update(item.id, v);
        }
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
      itemLeading: (p) => SizedBox(
        width: 48,
        height: 48,
        child: MediaImageTile(url: p.featureImageUrl, height: 48),
      ),
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
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _cost = TextEditingController();
  final _description = TextEditingController();
  final _piecesPerCarton = TextEditingController(text: '1');
  final _alertQuantity = TextEditingController(text: '0');
  final _wholesalePrice = TextEditingController();
  final _profitMargin = TextEditingController();
  bool _allowBreakPack = false;
  int? _categoryId;
  int? _brandId;
  int? _tagId;
  int? _unitId;
  int? _stockUnitId;
  List<CategoryModel> _categories = [];
  List<BrandModel> _brands = [];
  List<TagModel> _tags = [];
  List<UnitModel> _units = [];
  bool _loading = true;
  bool _saving = false;
  ProductModel? _product;
  bool _uploadingImage = false;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final admin = ref.read(adminRepositoriesProvider);
    final categories = await admin.categories.list();
    final brands = await admin.brands.list();
    final tags = await admin.tags.list();
    final units = await admin.units.list();
    if (widget.productId != null) {
      final p = await ref.read(productRepositoryProvider).get(widget.productId!);
      _product = p;
      _name.text = p.name;
      _price.text = p.price.toString();
      if (p.cost != null) _cost.text = p.cost.toString();
      _description.text = p.description ?? '';
      _categoryId = p.categoryId;
      _brandId = p.brandId;
      _tagId = p.tagId;
      _unitId = p.unitId;
      _stockUnitId = p.stockUnitId;
      _allowBreakPack = p.allowBreakPack;
      _piecesPerCarton.text = p.piecesPerCarton.toString();
      _alertQuantity.text = p.alertQuantity.toString();
      if (p.wholesalePrice > 0) _wholesalePrice.text = p.wholesalePrice.toString();
      if (p.profitMargin > 0) _profitMargin.text = p.profitMargin.toString();
    }
    if (mounted) {
      setState(() {
        _categories = categories;
        _brands = brands;
        _tags = tags;
        _units = units;
        _loading = false;
      });
    }
  }

  Future<void> _reloadProduct() async {
    final id = widget.productId;
    if (id == null) return;
    try {
      final p = await ref.read(productRepositoryProvider).get(id);
      if (mounted) setState(() => _product = p);
    } catch (_) {}
  }

  Future<XFile?> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return null;
    return _picker.pickImage(source: source, imageQuality: 85, maxWidth: 1600);
  }

  Future<void> _uploadImage({required bool feature}) async {
    final id = widget.productId;
    if (id == null) return;
    final photo = await _pickImage();
    if (photo == null) return;
    setState(() => _uploadingImage = true);
    try {
      final repo = ref.read(productRepositoryProvider);
      final bytes = await photo.readAsBytes();
      if (feature) {
        await repo.uploadFeatureImage(id, bytes, photo.name);
      } else {
        await repo.uploadGalleryImage(id, bytes, photo.name);
      }
      await _reloadProduct();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _uploadingImage = false);
    }
  }

  Future<void> _deleteGalleryImage(int mediaId) async {
    final id = widget.productId;
    if (id == null) return;
    try {
      await ref.read(productRepositoryProvider).deleteGalleryImage(id, mediaId);
      await _reloadProduct();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Widget _imagesSection() {
    final p = _product;
    if (p == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Images', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        MediaImageTile(url: p.featureImageUrl, height: 160),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _uploadingImage ? null : () => _uploadImage(feature: true),
                icon: const Icon(Icons.image_outlined),
                label: Text(p.featureImageUrl == null ? 'Set feature image' : 'Replace feature image'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _uploadingImage ? null : () => _uploadImage(feature: false),
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Add to gallery'),
              ),
            ),
          ],
        ),
        if (_uploadingImage) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
        ],
        if (p.galleryImages.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: p.galleryImages.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final img = p.galleryImages[i];
                return Stack(
                  children: [
                    SizedBox(width: 100, child: MediaImageTile(url: img.url, height: 100)),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.cancel, size: 20),
                        onPressed: () => _deleteGalleryImage(img.id),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Map<String, dynamic> _buildBody() {
    final alertQty = int.tryParse(_alertQuantity.text.trim()) ?? 0;
    final pieces = int.tryParse(_piecesPerCarton.text.trim()) ?? 1;
    return {
      'name': _name.text.trim(),
      'price': double.tryParse(_price.text.trim()) ?? 0,
      if (_cost.text.trim().isNotEmpty) 'cost': double.tryParse(_cost.text.trim()),
      'description': _description.text,
      'category_id': _categoryId,
      'brand_id': _brandId,
      'tag_id': _tagId,
      'unit_id': _unitId,
      'stock_unit_id': _stockUnitId,
      'allow_break_pack': _allowBreakPack,
      'pieces_per_carton': pieces,
      'alert_quantity': alertQty,
      if (_wholesalePrice.text.trim().isNotEmpty) 'wholesale_price': double.tryParse(_wholesalePrice.text.trim()),
      if (_profitMargin.text.trim().isNotEmpty) 'profit_margin': double.tryParse(_profitMargin.text.trim()),
    };
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_allowBreakPack && (int.tryParse(_piecesPerCarton.text.trim()) ?? 1) < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Break-pack requires at least 2 pieces per carton.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final body = _buildBody();
      final repo = ref.read(productRepositoryProvider);
      if (widget.productId == null) {
        await repo.create(body);
      } else {
        await repo.update(widget.productId!, body);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.productId == null ? 'New Product' : 'Edit Product')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId == null ? 'New Product' : 'Edit Product'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.productId != null) ...[
              _imagesSection(),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _price,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cost,
              decoration: const InputDecoration(labelText: 'Cost'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int?>(
              initialValue: _categoryId,
              decoration: const InputDecoration(labelText: 'Category'),
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                ..._categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
              ],
              onChanged: (v) => setState(() => _categoryId = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              initialValue: _brandId,
              decoration: const InputDecoration(labelText: 'Brand'),
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                ..._brands.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))),
              ],
              onChanged: (v) => setState(() => _brandId = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              initialValue: _stockUnitId,
              decoration: const InputDecoration(labelText: 'Stock unit'),
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                ..._units.map((u) => DropdownMenuItem(value: u.id, child: Text(u.shortName))),
              ],
              onChanged: (v) => setState(() => _stockUnitId = v),
            ),
            const SizedBox(height: 16),
            Text('Packaging', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Allow break pack'),
              value: _allowBreakPack,
              onChanged: (v) => setState(() => _allowBreakPack = v),
            ),
            TextFormField(
              controller: _piecesPerCarton,
              decoration: const InputDecoration(labelText: 'Pieces per carton'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 1) return 'Minimum 1';
                if (_allowBreakPack && n < 2) return 'Break-pack needs at least 2';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _alertQuantity,
              decoration: const InputDecoration(
                labelText: 'Alert quantity',
                helperText: '0 = no alert',
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 0) return 'Minimum 0';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int?>(
              initialValue: _tagId,
              decoration: const InputDecoration(labelText: 'Tag'),
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                ..._tags.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name))),
              ],
              onChanged: (v) => setState(() => _tagId = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              initialValue: _unitId,
              decoration: const InputDecoration(labelText: 'Unit'),
              items: [
                const DropdownMenuItem(value: null, child: Text('None')),
                ..._units.map((u) => DropdownMenuItem(value: u.id, child: Text(u.shortName))),
              ],
              onChanged: (v) => setState(() => _unitId = v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _wholesalePrice,
              decoration: const InputDecoration(labelText: 'Wholesale price'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _profitMargin,
              decoration: const InputDecoration(labelText: 'Profit margin'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text('Save'),
            ),
          ],
        ),
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
        if (item == null) {
          await repo.create(v);
        } else {
          await repo.update(item.id, v);
        }
      },
    )));
  }
}
