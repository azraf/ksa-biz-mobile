import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';
import 'customer_diary_section.dart';
import 'shop_edit_screen.dart';

class ShopDetailScreen extends ConsumerWidget {
  const ShopDetailScreen({super.key, required this.shopId});

  final int shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<CustomerShopModel>(
      future: ref.read(customerRepositoryProvider).getShop(shopId),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError || snap.data == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(snap.error?.toString() ?? 'Shop not found')),
          );
        }
        return ShopEditScreen(shop: snap.data);
      },
    );
  }
}

class CustomerTypesScreen extends ConsumerWidget {
  const CustomerTypesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<CustomerTypeModel>>(
      future: ref.read(customerRepositoryProvider).customerTypes(),
      builder: (context, snap) {
        if (!snap.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        return Scaffold(
          appBar: AppBar(title: const Text('Customer Types')),
          body: ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (_, i) => ListTile(title: Text(snap.data![i].typeName)),
          ),
        );
      },
    );
  }
}

class CustomerVansScreen extends ConsumerWidget {
  const CustomerVansScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(customerRepositoryProvider);
    return CrudListScreen<CustomerVanModel>(
      title: 'Customer Vans',
      loadItems: () async => (await repo.vans()).items,
      itemTitle: (v) => '${v.name} ${v.mobile ?? ''}',
      onTap: (v) => _editVan(context, ref, v),
      trailing: (v) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.notes_outlined),
            onPressed: () => _openVanDiary(context, v),
          ),
          ContactActionButtons(phoneNumber: v.mobile, compact: true),
        ],
      ),
    );
  }

  void _editVan(BuildContext context, WidgetRef ref, CustomerVanModel van) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: 'Edit Van',
      initialValues: {'name': van.name, 'mobile': van.mobile},
      fields: const [
        FieldConfig(key: 'name', label: 'Name', required: true),
        FieldConfig(key: 'mobile', label: 'Mobile'),
      ],
      onSave: (v) async => ref.read(apiClientProvider).put('/customer-vans/${van.id}', body: v),
    )));
  }

  void _openVanDiary(BuildContext context, CustomerVanModel van) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
      appBar: AppBar(title: Text('Diary — ${van.name}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [CustomerDiarySection(customerType: 'customer_van', customerId: van.id)],
      ),
    )));
  }
}

class CustomerImportersScreen extends ConsumerWidget {
  const CustomerImportersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(customerRepositoryProvider);
    return CrudListScreen<CustomerImporterModel>(
      title: 'Customer Importers',
      loadItems: () async => (await repo.importers()).items,
      itemTitle: (v) => '${v.name} ${v.mobile ?? ''}',
      onTap: (v) => _editImporter(context, ref, v),
      trailing: (v) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.notes_outlined),
            onPressed: () => _openImporterDiary(context, v),
          ),
          ContactActionButtons(phoneNumber: v.mobile, compact: true),
        ],
      ),
    );
  }

  void _editImporter(BuildContext context, WidgetRef ref, CustomerImporterModel importer) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: 'Edit Importer',
      initialValues: {'name': importer.name, 'mobile': importer.mobile},
      fields: const [
        FieldConfig(key: 'name', label: 'Name', required: true),
        FieldConfig(key: 'mobile', label: 'Mobile'),
      ],
      onSave: (v) async => ref.read(apiClientProvider).put('/customer-importers/${importer.id}', body: v),
    )));
  }

  void _openImporterDiary(BuildContext context, CustomerImporterModel importer) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
      appBar: AppBar(title: Text('Diary — ${importer.name}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [CustomerDiarySection(customerType: 'customer_importer', customerId: importer.id)],
      ),
    )));
  }
}

class CustomerShopsScreen extends ConsumerStatefulWidget {
  const CustomerShopsScreen({super.key});

  @override
  ConsumerState<CustomerShopsScreen> createState() => _CustomerShopsScreenState();
}

class _CustomerShopsScreenState extends ConsumerState<CustomerShopsScreen> {
  int _reloadToken = 0;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(customerRepositoryProvider);
    return CrudListScreen<CustomerShopModel>(
      key: ValueKey(_reloadToken),
      title: 'Customer Shops',
      loadItems: () async => (await repo.shops()).items,
      itemTitle: (s) => s.name,
      onTap: (s) => _edit(s),
      onAdd: () => _edit(null),
    );
  }

  Future<void> _edit(CustomerShopModel? shop) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ShopEditScreen(shop: shop)),
    );
    if (saved == true) setState(() => _reloadToken++);
  }
}
