import 'package:core/core.dart' hide sharedPreferencesProvider, showQuickCreateCustomerSheet, QuickCreateCustomerHost;
import 'package:core/core.dart' as core show QuickCreateCustomerHost, showQuickCreateCustomerSheet;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../providers/connectivity_provider.dart';
import '../../providers/repositories.dart';
import '../../widgets/crud_screens.dart';
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
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
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
        if (!snap.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Customer Types')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
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

core.QuickCreateCustomerHost _quickCreateHost(WidgetRef ref) {
  return core.QuickCreateCustomerHost(
    customerRepository: ref.read(customerRepositoryProvider),
    isOnline: () => ref.read(onlineStatusProvider),
    attachShopPhoto: (file, shopId) =>
        ref.read(mediaCaptureFacadeProvider).attachShopPhoto(file, shopId),
    showSalesPersonPicker: true,
  );
}

class CustomerVansScreen extends ConsumerStatefulWidget {
  const CustomerVansScreen({super.key});

  @override
  ConsumerState<CustomerVansScreen> createState() => _CustomerVansScreenState();
}

class _CustomerVansScreenState extends ConsumerState<CustomerVansScreen> {
  static const _listKey = 'admin_customer_vans';
  int _reloadToken = 0;
  late ListSortMode _sortMode;

  @override
  void initState() {
    super.initState();
    _sortMode = ListSortPreference(ref.read(sharedPreferencesProvider))
        .read(_listKey, defaultMode: ListSortMode.date);
  }

  Future<void> _quickCreate() async {
    final created = await core.showQuickCreateCustomerSheet(
      context: context,
      host: _quickCreateHost(ref),
      customerType: 'customer_van',
      salesPersonId: null,
    );
    if (created is CustomerVanModel && mounted) {
      setState(() => _reloadToken++);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(created.name)),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (created.createdAt != null)
                  ListTile(
                    title: const Text('Created'),
                    subtitle: Text(formatAppDateTime(created.createdAt)),
                  ),
                CustomerDiarySection(customerType: 'customer_van', customerId: created.id),
              ],
            ),
          ),
        ),
      );
    } else if (created != null && mounted) {
      setState(() => _reloadToken++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(customerRepositoryProvider);
    return CrudListScreen<CustomerVanModel>(
      key: ValueKey('$_reloadToken-$_sortMode'),
      title: 'Customer Vans',
      loadItems: () async => (await repo.vans(query: CustomerListQuery(sort: _sortMode.apiSortParam()))).items,
      itemTitle: (v) => v.name,
      itemSubtitle: customerListSubtitle,
      sortModes: const [ListSortMode.date, ListSortMode.name, ListSortMode.area, ListSortMode.salesPerson],
      initialSortMode: _sortMode,
      onSortChanged: (mode) async {
        _sortMode = mode;
        await ListSortPreference(ref.read(sharedPreferencesProvider)).write(_listKey, mode);
        setState(() => _reloadToken++);
      },
      sortItems: (items, mode) => sortByListMode(
        items,
        mode,
        dateIso: customerActivityDateIso,
        name: (v) => v.name,
        area: (v) => v.areaName,
        salesPerson: (v) => v.salesPersonName,
      ),
      emptyMessage: 'No vans',
      emptyActionLabel: l10n.commonCreateCustomer,
      onEmptyAction: _quickCreate,
      onTap: (v) => _openVanDetail(context, ref, v),
      onAdd: _quickCreate,
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

  void _openVanDetail(BuildContext context, WidgetRef ref, CustomerVanModel van) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _AdminCustomerDetailScreen(
          customerType: 'customer_van',
          customerId: van.id,
          title: van.name,
          loadCustomer: () => ref.read(customerRepositoryProvider).getVan(van.id),
        ),
      ),
    );
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

class CustomerImportersScreen extends ConsumerStatefulWidget {
  const CustomerImportersScreen({super.key});

  @override
  ConsumerState<CustomerImportersScreen> createState() => _CustomerImportersScreenState();
}

class _CustomerImportersScreenState extends ConsumerState<CustomerImportersScreen> {
  static const _listKey = 'admin_customer_importers';
  int _reloadToken = 0;
  late ListSortMode _sortMode;

  @override
  void initState() {
    super.initState();
    _sortMode = ListSortPreference(ref.read(sharedPreferencesProvider))
        .read(_listKey, defaultMode: ListSortMode.date);
  }

  Future<void> _quickCreate() async {
    final created = await core.showQuickCreateCustomerSheet(
      context: context,
      host: _quickCreateHost(ref),
      customerType: 'customer_importer',
      salesPersonId: null,
    );
    if (created is CustomerImporterModel && mounted) {
      setState(() => _reloadToken++);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(created.name)),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (created.createdAt != null)
                  ListTile(
                    title: const Text('Created'),
                    subtitle: Text(formatAppDateTime(created.createdAt)),
                  ),
                CustomerDiarySection(customerType: 'customer_importer', customerId: created.id),
              ],
            ),
          ),
        ),
      );
    } else if (created != null && mounted) {
      setState(() => _reloadToken++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(customerRepositoryProvider);
    return CrudListScreen<CustomerImporterModel>(
      key: ValueKey('$_reloadToken-$_sortMode'),
      title: 'Customer Importers',
      loadItems: () async =>
          (await repo.importers(query: CustomerListQuery(sort: _sortMode.apiSortParam()))).items,
      itemTitle: (v) => v.name,
      itemSubtitle: customerListSubtitle,
      sortModes: const [ListSortMode.date, ListSortMode.name, ListSortMode.area, ListSortMode.salesPerson],
      initialSortMode: _sortMode,
      onSortChanged: (mode) async {
        _sortMode = mode;
        await ListSortPreference(ref.read(sharedPreferencesProvider)).write(_listKey, mode);
        setState(() => _reloadToken++);
      },
      sortItems: (items, mode) => sortByListMode(
        items,
        mode,
        dateIso: customerActivityDateIso,
        name: (v) => v.name,
        area: (v) => v.areaName,
        salesPerson: (v) => v.salesPersonName,
      ),
      emptyMessage: 'No importers',
      emptyActionLabel: l10n.commonCreateCustomer,
      onEmptyAction: _quickCreate,
      onTap: (v) => _openImporterDetail(context, ref, v),
      onAdd: _quickCreate,
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

  void _openImporterDetail(BuildContext context, WidgetRef ref, CustomerImporterModel importer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _AdminCustomerDetailScreen(
          customerType: 'customer_importer',
          customerId: importer.id,
          title: importer.name,
          loadCustomer: () => ref.read(customerRepositoryProvider).getImporter(importer.id),
        ),
      ),
    );
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
  static const _listKey = 'admin_customer_shop';
  int _reloadToken = 0;
  late ListSortMode _sortMode;

  @override
  void initState() {
    super.initState();
    _sortMode = ListSortPreference(ref.read(sharedPreferencesProvider))
        .read(_listKey, defaultMode: ListSortMode.date);
  }

  Future<void> _quickAdd() async {
    final created = await core.showQuickCreateCustomerSheet(
      context: context,
      host: _quickCreateHost(ref),
      customerType: 'customer_shop',
      salesPersonId: null,
    );
    if (created is CustomerShopModel && mounted) {
      setState(() => _reloadToken++);
      await _edit(created);
    } else if (created != null && mounted) {
      setState(() => _reloadToken++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(customerRepositoryProvider);
    return CrudListScreen<CustomerShopModel>(
      key: ValueKey('$_reloadToken-$_sortMode'),
      title: 'Customer Shops',
      loadItems: () async =>
          (await repo.shops(query: CustomerListQuery(sort: _sortMode.apiSortParam()))).items,
      itemTitle: (s) => s.name,
      itemSubtitle: customerListSubtitle,
      sortModes: const [
        ListSortMode.date,
        ListSortMode.name,
        ListSortMode.area,
        ListSortMode.salesPerson,
      ],
      initialSortMode: _sortMode,
      onSortChanged: (mode) async {
        _sortMode = mode;
        await ListSortPreference(ref.read(sharedPreferencesProvider)).write(_listKey, mode);
        setState(() => _reloadToken++);
      },
      sortItems: (items, mode) => sortByListMode(
        items,
        mode,
        dateIso: customerActivityDateIso,
        name: (s) => s.name,
        area: (s) => s.areaName,
        salesPerson: (s) => s.salesPersonName,
        distanceKm: (s) => s.distanceKm?.toDouble(),
      ),
      emptyMessage: 'No shops',
      emptyActionLabel: l10n.commonCreateCustomer,
      onEmptyAction: _quickAdd,
      extraActions: [
        IconButton(
          icon: const Icon(Icons.flash_on_outlined),
          tooltip: l10n.adminShopQuickAdd,
          onPressed: _quickAdd,
        ),
      ],
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

class _AdminCustomerDetailScreen extends ConsumerStatefulWidget {
  const _AdminCustomerDetailScreen({
    required this.customerType,
    required this.customerId,
    required this.title,
    required this.loadCustomer,
  });

  final String customerType;
  final int customerId;
  final String title;
  final Future<dynamic> Function() loadCustomer;

  @override
  ConsumerState<_AdminCustomerDetailScreen> createState() => _AdminCustomerDetailScreenState();
}

class _AdminCustomerDetailScreenState extends ConsumerState<_AdminCustomerDetailScreen> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.loadCustomer();
  }

  void _reload() {
    setState(() => _future = widget.loadCustomer());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.title)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError || snap.data == null) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.title)),
            body: Center(child: Text(snap.error?.toString() ?? 'Customer not found')),
          );
        }

        final customer = snap.data!;
        return Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CustomerLoginAccountSection(
                customerType: widget.customerType,
                customerId: widget.customerId,
                customer: customer,
                customerRepository: ref.read(customerRepositoryProvider),
                onUpdated: _reload,
                isAdmin: true,
              ),
              const SizedBox(height: 16),
              CustomerDiarySection(
                customerType: widget.customerType,
                customerId: widget.customerId,
              ),
            ],
          ),
        );
      },
    );
  }
}
