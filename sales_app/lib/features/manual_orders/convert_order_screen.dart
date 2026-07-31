import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import '../../widgets/line_items_editor.dart';

class ConvertOrderScreen extends ConsumerStatefulWidget {
  const ConvertOrderScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<ConvertOrderScreen> createState() => _ConvertOrderScreenState();
}

class _ConvertOrderScreenState extends ConsumerState<ConvertOrderScreen> {
  ManualOrderRequestModel? _request;
  final _items = <LineItemDraft>[];
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final request = await ref.read(manualOrderRepositoryProvider).get(widget.id);
      setState(() {
        _request = request;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _submit() async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null || _items.isEmpty) return;

    setState(() => _submitting = true);
    try {
      final order = await ref.read(manualOrderRepositoryProvider).convert(widget.id, {
        'sales_person_id': salesPersonId,
        'payment_status': 'pending',
        'items': _items.map((e) => e.toJson()).toList(),
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.salesConvertOrderCreated)));
        context.go('/orders/${order.id}');
      }
    } catch (e) {
      setState(() => _submitting = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) return LoadingView(message: l10n.commonLoading);
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _request?.customerShop?.name ?? l10n.salesConvertShopOrder,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (_request?.notes != null) Text(_request!.notes!),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(l10n.salesConvertOrderItems, style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              TextButton.icon(
                onPressed: () async {
                  final product = await pickProduct(context, ref);
                  if (product != null) {
                    setState(() => _items.add(LineItemDraft(product: product)));
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.salesConvertAddProduct),
              ),
            ],
          ),
          LineItemsEditor(
            items: _items,
            onChanged: () => setState(() {}),
            onRemove: (index) => setState(() => _items.removeAt(index)),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submitting || _items.isEmpty ? null : _submit,
            child: _submitting
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.commonPlaceOrder),
          ),
        ],
    );
  }
}
