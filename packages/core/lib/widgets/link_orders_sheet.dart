import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../models/manual_order_request.dart';
import '../models/order.dart';
import '../repositories/manual_order_repository.dart';
import '../repositories/order_repository.dart';

/// Bottom sheet: multi-select the customer's recent orders and link them to a
/// manual order request (instruction). Returns the updated request, or null
/// when dismissed.
Future<ManualOrderRequestModel?> showLinkOrdersSheet(
  BuildContext context, {
  required ManualOrderRequestModel request,
  required OrderRepository orderRepository,
  required ManualOrderRepository manualOrderRepository,
}) {
  return showModalBottomSheet<ManualOrderRequestModel>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _LinkOrdersSheet(
      request: request,
      orderRepository: orderRepository,
      manualOrderRepository: manualOrderRepository,
    ),
  );
}

class _LinkOrdersSheet extends StatefulWidget {
  const _LinkOrdersSheet({
    required this.request,
    required this.orderRepository,
    required this.manualOrderRepository,
  });

  final ManualOrderRequestModel request;
  final OrderRepository orderRepository;
  final ManualOrderRepository manualOrderRepository;

  @override
  State<_LinkOrdersSheet> createState() => _LinkOrdersSheetState();
}

class _LinkOrdersSheetState extends State<_LinkOrdersSheet> {
  List<OrderModel> _orders = [];
  final Set<int> _selected = {};
  bool _loading = true;
  bool _working = false;
  String? _error;

  ({String type, int id})? get _customer {
    final r = widget.request;
    if (r.customerShopId != null) return (type: 'customer_shop', id: r.customerShopId!);
    if (r.customerVanId != null) return (type: 'customer_van', id: r.customerVanId!);
    if (r.customerImporterId != null) return (type: 'customer_importer', id: r.customerImporterId!);
    return null;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final customer = _customer;
    if (customer == null) {
      setState(() {
        _loading = false;
        _orders = [];
      });
      return;
    }
    try {
      final result = await widget.orderRepository.list(
        query: OrderListQuery(
          customerType: customer.type,
          customerId: customer.id,
          perPage: 25,
        ),
      );
      setState(() {
        _orders = result.items;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _link() async {
    setState(() => _working = true);
    try {
      final updated = await widget.manualOrderRepository
          .linkOrders(widget.request.id, _selected.toList());
      if (mounted) Navigator.of(context).pop(updated);
    } catch (e) {
      setState(() {
        _working = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alreadyLinked = widget.request.linkedOrders.map((o) => o.id).toSet();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.commonLinkToOrders, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_orders.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text(l10n.commonNoOrdersForCustomer)),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: _orders.map((order) {
                    final id = order.id;
                    final linked = alreadyLinked.contains(id);
                    return CheckboxListTile(
                      dense: true,
                      value: linked || _selected.contains(id),
                      onChanged: linked || _working
                          ? null
                          : (checked) => setState(() {
                                if (checked == true) {
                                  _selected.add(id);
                                } else {
                                  _selected.remove(id);
                                }
                              }),
                      title: Text('#$id · ${order.status}'),
                      subtitle: Text('${order.totalBill}'),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _selected.isEmpty || _working ? null : _link,
              child: _working
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.commonLinkToOrders),
            ),
          ],
        ),
      ),
    );
  }
}
