import 'dart:async';

import 'package:core/core.dart' hide showQuickCreateCustomerSheet;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/order_vat_config_provider.dart';
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
  final _vatRateController = TextEditingController(text: '15');
  OrderVatSettings _vat = const OrderVatSettings();
  bool _vatTouched = false;
  bool _walkInMode = false;
  int? _walkInShopId;
  bool _loadingTypes = true;
  bool _submitting = false;
  String? _catalogError;

  @override
  void dispose() {
    _walkInNoteController.dispose();
    _vatRateController.dispose();
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
      if (!mounted) return;
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
      if (!mounted) return;
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
      unawaited(_resolveVatDefault());
    } catch (e) {
      if (!mounted) return;
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

  void _applyVatToItems() {
    for (final item in _items) {
      item.applyVat(_vat);
    }
  }

  void _setVat(OrderVatSettings vat, {bool touched = true}) {
    setState(() {
      if (touched) _vatTouched = true;
      _vat = vat;
      _applyVatToItems();
    });
  }

  /// Resolves the VAT default from the server policy for the currently
  /// selected customer. Stops as soon as the user touches the VAT controls;
  /// leaves VAT off when the config is unavailable.
  Future<void> _resolveVatDefault() async {
    if (_vatTouched) return;
    try {
      final config = await ref.read(orderVatConfigProvider.future);
      final customer = _selectedCustomer;
      final enabled = OrderVatPolicy.resolve(
        config: config,
        shopId: customer is CustomerShopModel ? customer.id : null,
        vanId: customer is CustomerVanModel ? customer.id : null,
        importerId: customer is CustomerImporterModel ? customer.id : null,
      );
      if (!mounted || _vatTouched || enabled == _vat.enabled) return;
      _setVat(
        OrderVatSettings(enabled: enabled, inclusive: _vat.inclusive, rate: _vat.rate),
        touched: false,
      );
    } catch (_) {
      // Config unavailable → keep VAT off.
    }
  }

  Future<void> _pickCustomer() async {
    if (_selectedType == null) return;
    final result = await showCustomerPickerSheet(
      context: context,
      ref: ref,
      customerType: _selectedType!.typeName,
      salesPersonId: requireSalesPersonId(ref.read(authProvider)),
    );
    if (!mounted) return;
    if (result != null) {
      setState(() => _selectedCustomer = result.customer);
      unawaited(_resolveVatDefault());
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
    if (!mounted) return;
    if (created != null) {
      setState(() => _selectedCustomer = created);
      unawaited(_resolveVatDefault());
    }
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
    unawaited(_resolveVatDefault());
  }

  /// Way back out of walk-in mode to normal customer selection.
  void _exitWalkInMode() {
    setState(() {
      _walkInMode = false;
      _selectedCustomer = null;
      _walkInNoteController.clear();
    });
  }

  /// Friendly dropdown labels for the raw API type identifiers.
  String _customerTypeLabel(AppLocalizations l10n, String typeName) =>
      switch (typeName) {
        'customer_shop' => l10n.customerTypeShop,
        'customer_van' => l10n.customerTypeVan,
        'customer_importer' => l10n.customerTypeImporter,
        _ => typeName.replaceAll('_', ' '),
      };

  Future<void> _submit({bool asDraft = false}) async {
    final l10n = AppLocalizations.of(context);
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null || _selectedType == null || _selectedCustomer == null || _items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.salesOrderSelectCustomerItems)));
      return;
    }

    _applyVatToItems();

    final body = <String, dynamic>{
      'sales_person_id': salesPersonId,
      'customer_type_id': _selectedType!.id,
      'payment_status': 'pending',
      // Always create as a draft — no stock moves until confirmed. The
      // "Create order" flow previews the invoice, then confirms the draft.
      'as_draft': true,
      'include_vat': _vat.enabled,
      if (_vat.enabled) 'vat_inclusive': _vat.inclusive,
      if (_vat.enabled) 'vat_rate': _vat.rate,
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
      if (!mounted) return;
      if (!online) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.salesOrderSavedLocally)),
        );
        AppHaptics.light();
      }

      if (asDraft) {
        setState(() => _submitting = false);
        context.go('/orders/${order.id}');
        return;
      }

      await _previewAndConfirm(order, l10n);
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        showAppErrorSnackBar(context, e);
      }
    }
  }

  /// "Create order" flow: preview the just-created draft as the printed
  /// invoice, then confirm it (server or local queue) or keep it as a draft.
  Future<void> _previewAndConfirm(OrderModel order, AppLocalizations l10n) async {
    final walkInNote = _walkInNoteController.text.trim();
    final customerName = _walkInMode && walkInNote.isNotEmpty ? walkInNote : _customerLabel(l10n);
    final auth = ref.read(authProvider);
    final salesPersonName = auth.activeSalesPerson?.name ?? auth.salesPerson?.name;
    final zatcaConfig = await loadZatcaConfig(
      ref.read(sharedPreferencesProvider),
      ref.read(apiClientProvider),
    );
    if (!mounted) return;

    final previewOrder = buildPreviewOrder(
      items: _items,
      vat: _vat,
      customerName: customerName,
      salesPersonName: salesPersonName,
    );
    final result = await showOrderPreviewConfirmSheet(
      context,
      previewOrder: previewOrder,
      config: zatcaConfig,
      confirmLabel: l10n.commonConfirm,
      keepDraftLabel: l10n.orderKeepAsDraft,
    );
    if (!mounted) return;

    if (result == true) {
      try {
        if (order.id > 0) {
          await ref.read(orderRepositoryProvider).confirmOrder(order.id);
        } else {
          await ref.read(offlineOrderRepositoryProvider).confirmLocalDraft(order.id);
          ref.invalidate(pendingSyncCountProvider);
        }
      } on StateError {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.orderConnectToConfirm)),
          );
        }
      } catch (e) {
        if (mounted) showAppErrorSnackBar(context, e);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.orderSavedAsDraft)),
      );
    }
    if (!mounted) return;
    setState(() => _submitting = false);
    context.go('/orders/${order.id}');
  }

  Future<void> _openCustomerNote() async {
    final type = _selectedType?.typeName;
    final customer = _selectedCustomer;
    if (type == null || customer == null) return;
    final customerId = switch (type) {
      'customer_shop' => (customer as CustomerShopModel).id,
      'customer_van' => (customer as CustomerVanModel).id,
      _ => (customer as CustomerImporterModel).id,
    };
    await showCustomerDiarySheet(
      context: context,
      ref: ref,
      customerType: type,
      customerId: customerId,
      customerName: _customerLabel(AppLocalizations.of(context)),
    );
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
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: _exitWalkInMode,
              icon: const Icon(Icons.arrow_back),
              label: Text(l10n.salesOrderChooseCustomerInstead),
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
                .map((t) => DropdownMenuItem(value: t, child: Text(_customerTypeLabel(l10n, t.typeName))))
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
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.orderApplyVat),
          value: _vat.enabled,
          onChanged: (v) => _setVat(
            OrderVatSettings(enabled: v, inclusive: _vat.inclusive, rate: _vat.rate),
          ),
        ),
        if (_vat.enabled) ...[
          Row(
            children: [
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: true, label: Text(l10n.orderVatIncluded)),
                  ButtonSegment(value: false, label: Text(l10n.orderVatExcluded)),
                ],
                selected: {_vat.inclusive},
                onSelectionChanged: (selection) => _setVat(
                  OrderVatSettings(enabled: true, inclusive: selection.first, rate: _vat.rate),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _vatRateController,
                  decoration: InputDecoration(labelText: l10n.orderVatRateLabel),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    final rate = double.tryParse(value.trim());
                    if (rate == null || rate < 0 || rate > 100) return;
                    _setVat(
                      OrderVatSettings(enabled: true, inclusive: _vat.inclusive, rate: rate),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Text(l10n.commonItems, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: () async {
                final product = await pickProduct(context, ref);
                if (product != null) {
                  setState(() => _items.add(LineItemDraft(product: product)..applyVat(_vat)));
                }
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
          vat: _vat,
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _selectedCustomer == null ? null : _openCustomerNote,
          icon: const Icon(Icons.note_add),
          label: Text(l10n.commonAddNote),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting ? const CircularProgressIndicator() : Text(l10n.commonCreateOrder),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _submitting ? null : () => _submit(asDraft: true),
          icon: const Icon(Icons.edit_note_outlined),
          label: Text(l10n.orderSaveAsDraft),
        ),
      ],
    );
  }
}
