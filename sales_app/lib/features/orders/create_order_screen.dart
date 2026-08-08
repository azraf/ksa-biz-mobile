import 'dart:async';

import 'package:core/core.dart' hide showQuickCreateCustomerSheet;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/repositories.dart';
import '../../widgets/customer_diary_sheet.dart';
import '../../widgets/customer_picker_sheet.dart';
import '../../widgets/line_items_editor.dart';
import '../../widgets/quick_create_customer.dart';

class CreateOrderScreen extends ConsumerStatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  ConsumerState<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen> {
  List<CustomerTypeModel> _types = [];
  CustomerTypeModel? _selectedType;
  dynamic _selectedCustomer;
  final _items = <LineItemDraft>[];
  final _walkInNoteController = TextEditingController();
  bool _walkInMode = false;
  int? _walkInShopId;
  bool _loadingTypes = true;
  bool _submitting = false;
  String? _catalogError;

  @override
  void dispose() {
    _walkInNoteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadTypes();
  }

  Future<void> _loadTypes() async {
    final online = ref.read(onlineStatusProvider);
    if (!online) {
      final hasCatalog = await ref.read(referenceDataPrefetcherProvider).hasCachedCatalog();
      if (!hasCatalog) {
        setState(() {
          _catalogError = AppLocalizations.of(context).salesOrderGoOnlineCatalog;
          _loadingTypes = false;
        });
        return;
      }
    }

    try {
      final types = await ref.read(offlineCustomerRepositoryProvider).customerTypes();
      final walkInId = await ref.read(offlineCustomerRepositoryProvider).walkInShopId();
      CustomerTypeModel? defaultType;
      if (types.isNotEmpty) {
        defaultType = types.firstWhere(
          (t) => t.typeName == 'customer_shop',
          orElse: () => types.first,
        );
      }
      setState(() {
        _types = types;
        _walkInShopId = walkInId;
        _selectedType = defaultType;
        _loadingTypes = false;
        _catalogError = types.isEmpty ? AppLocalizations.of(context).salesOrderNoCustomerTypes : null;
      });
    } catch (e) {
      setState(() {
        _catalogError = e.toString();
        _loadingTypes = false;
      });
    }
  }

  bool get _supportsQuickAdd {
    final type = _selectedType?.typeName;
    return type == 'customer_shop' || type == 'customer_van' || type == 'customer_importer';
  }

  Future<void> _pickCustomer() async {
    if (_selectedType == null) return;
    final result = await showCustomerPickerSheet(
      context: context,
      ref: ref,
      customerType: _selectedType!.typeName,
      salesPersonId: requireSalesPersonId(ref.read(authProvider)),
    );
    if (result != null) {
      setState(() => _selectedCustomer = result.customer);
    }
  }

  Future<void> _quickCreateCustomer() async {
    if (_selectedType == null) return;
    final created = await showQuickCreateCustomerSheet(
      context: context,
      ref: ref,
      customerType: _selectedType!.typeName,
      salesPersonId: requireSalesPersonId(ref.read(authProvider)),
    );
    if (created != null) setState(() => _selectedCustomer = created);
  }

  Future<void> _startWalkInOrder() async {
    final shopType = _types.cast<CustomerTypeModel?>().firstWhere(
          (t) => t?.typeName == 'customer_shop',
          orElse: () => null,
        );
    if (shopType == null || _walkInShopId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).salesOrderWalkInUnavailable)),
        );
      }
      return;
    }
    setState(() {
      _walkInMode = true;
      _selectedType = shopType;
      _selectedCustomer = CustomerShopModel(
        id: _walkInShopId!,
        name: AppLocalizations.of(context).salesOrderWalkInShop,
        isSystem: true,
      );
    });
  }

  Future<void> _submit() async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null || _selectedType == null || _selectedCustomer == null || _items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).salesOrderSelectCustomerItems)));
      return;
    }

    final body = <String, dynamic>{
      'sales_person_id': salesPersonId,
      'customer_type_id': _selectedType!.id,
      'payment_status': 'pending',
      'items': _items.map((e) => e.toJson()).toList(),
    };

    final type = _selectedType!.typeName;
    if (type == 'customer_shop') body['customer_shop_id'] = (_selectedCustomer as CustomerShopModel).id;
    if (type == 'customer_van') body['customer_van_id'] = (_selectedCustomer as CustomerVanModel).id;
    if (type == 'customer_importer') body['customer_importer_id'] = (_selectedCustomer as CustomerImporterModel).id;
    if (_walkInMode && _walkInNoteController.text.trim().isNotEmpty) {
      body['walk_in_note'] = _walkInNoteController.text.trim();
    }

    final online = ref.read(onlineStatusProvider);
    setState(() => _submitting = true);
    try {
      final order = await ref.read(offlineOrderRepositoryProvider).create(body);
      ref.invalidate(pendingSyncCountProvider);
      if (mounted) {
        if (!online) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).salesOrderSavedLocally)),
          );
          AppHaptics.light();
        }
        final type = _selectedType!.typeName;
        final customer = _selectedCustomer!;
        final customerId = switch (type) {
          'customer_shop' => (customer as CustomerShopModel).id,
          'customer_van' => (customer as CustomerVanModel).id,
          _ => (customer as CustomerImporterModel).id,
        };
        final customerName = _customerLabel(AppLocalizations.of(context));
        setState(() => _submitting = false);
        if (online) {
          final customerType = type;
          final customerIdForDiary = customerId;
          final customerNameForDiary = customerName;
          if (mounted) context.go('/orders/${order.id}');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            unawaited(
              promptPostOrderDiaryNote(
                context,
                ref,
                customerType: customerType,
                customerId: customerIdForDiary,
                customerName: customerNameForDiary,
              ),
            );
          });
        } else if (mounted) {
          context.go('/orders/${order.id}');
        }
      }
    } catch (e) {
      setState(() => _submitting = false);
      if (mounted) showAppErrorSnackBar(context, e);
    }
  }

  String _customerLabel(AppLocalizations l10n) {
    if (_selectedCustomer == null) return l10n.salesOrderSelectCustomer;
    if (_selectedCustomer is CustomerShopModel) return (_selectedCustomer as CustomerShopModel).name;
    if (_selectedCustomer is CustomerVanModel) return (_selectedCustomer as CustomerVanModel).name;
    if (_selectedCustomer is CustomerImporterModel) return (_selectedCustomer as CustomerImporterModel).name;
    return l10n.salesOrderSelected;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loadingTypes) return LoadingView(message: l10n.commonLoading);
    if (_catalogError != null) {
      return ErrorView(message: _catalogError!, onRetry: _loadTypes);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FilledButton.icon(
          onPressed: _startWalkInOrder,
          icon: const Icon(Icons.flash_on),
          label: Text(l10n.salesOrderWalkInQuick),
        ),
        const SizedBox(height: 12),
        if (_walkInMode) ...[
          ListTile(
            leading: const Icon(Icons.storefront),
            title: Text(l10n.salesOrderWalkInShop),
            subtitle: Text(l10n.salesOrderWalkInSubtitle),
          ),
          TextField(
            controller: _walkInNoteController,
            decoration: InputDecoration(
              labelText: l10n.salesOrderWalkInNote,
              hintText: l10n.salesOrderWalkInNoteHint,
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (!_walkInMode) ...[
          DropdownButtonFormField<CustomerTypeModel>(
            key: ValueKey(_selectedType?.id),
            initialValue: _selectedType,
            decoration: InputDecoration(labelText: l10n.salesOrderCustomerType),
            items: _types
                .map((t) => DropdownMenuItem(value: t, child: Text(t.typeName)))
                .toList(),
            onChanged: (v) => setState(() {
              _selectedType = v;
              _selectedCustomer = null;
            }),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(onPressed: _pickCustomer, child: Text(_customerLabel(l10n))),
              ),
              if (_supportsQuickAdd)
                IconButton(
                  onPressed: _quickCreateCustomer,
                  icon: const Icon(Icons.person_add),
                  tooltip: l10n.salesOrderAddCustomer,
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Text(l10n.commonItems, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: () async {
                final product = await pickProduct(context, ref);
                if (product != null) setState(() => _items.add(LineItemDraft(product: product)));
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.commonAdd),
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
          child: _submitting ? const CircularProgressIndicator() : Text(l10n.commonCreateOrder),
        ),
      ],
    );
  }
}
