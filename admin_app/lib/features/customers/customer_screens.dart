import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';
import 'customer_diary_section.dart';
import 'shop_edit_screen.dart';

class CustomerTypesScreen extends ConsumerWidget {
  const CustomerTypesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<CustomerTypeModel>>(
      future: ref.read(offlineCustomerRepositoryProvider).customerTypes(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: LoadingView());
        }
        if (snap.hasError) {
          return Scaffold(
            body: ErrorView(
              message: AppErrorMapper.localize(context, snap.error!),
              error: snap.error,
            ),
          );
        }
        return Scaffold(
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
    final repo = ref.watch(offlineCustomerRepositoryProvider);
    return CrudListScreen<CustomerVanModel>(
      title: 'Customer Vans',
      loadItems: () async => (await repo.vans(scoped: false)).items,
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
    final repo = ref.watch(offlineCustomerRepositoryProvider);
    return CrudListScreen<CustomerImporterModel>(
      title: 'Customer Importers',
      loadItems: () async => (await repo.importers(scoped: false)).items,
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
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = _searchController.text.trim();
    final repo = ref.watch(offlineCustomerRepositoryProvider);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search shops',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => setState(() => _reloadToken++),
                ),
              ),
              onSubmitted: (_) => setState(() => _reloadToken++),
            ),
          ),
          Expanded(
            child: CrudListScreen<CustomerShopModel>(
              key: ValueKey('$_reloadToken-$search'),
              title: 'Customer Shops',
              embedded: true,
              loadItems: () async => (await repo.shops(
                search: search.isEmpty ? null : search,
                scoped: false,
              )).items,
              itemTitle: (s) => s.name,
              onTap: (s) => _edit(s),
              onAdd: () => _edit(null),
            ),
          ),
        ],
      ),
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
