import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';

class VanStockScreen extends ConsumerStatefulWidget {
  const VanStockScreen({super.key});

  @override
  ConsumerState<VanStockScreen> createState() => _VanStockScreenState();
}

class _VanStockScreenState extends ConsumerState<VanStockScreen> {
  List<SalesPersonModel> _persons = [];
  int? _selectedId;
  List<InventoryStockModel> _stock = [];
  bool _loadingPersons = true;
  bool _loadingStock = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPersons();
  }

  Future<void> _loadPersons() async {
    setState(() {
      _loadingPersons = true;
      _error = null;
    });
    try {
      final persons = await ref.read(customerRepositoryProvider).salesPersons();
      setState(() {
        _persons = persons.items;
        _selectedId = _persons.isNotEmpty ? _persons.first.id : null;
        _loadingPersons = false;
      });
      if (_selectedId != null) await _loadStock();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loadingPersons = false;
      });
    }
  }

  Future<void> _loadStock() async {
    final salesPersonId = _selectedId;
    if (salesPersonId == null) return;

    setState(() {
      _loadingStock = true;
      _error = null;
    });
    try {
      final stock = await ref.read(inventoryRepositoryProvider).vanStock(salesPersonId);
      setState(() {
        _stock = stock;
        _loadingStock = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loadingStock = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingPersons) return const LoadingView(message: 'Loading sales persons...');
    if (_error != null && _persons.isEmpty) {
      return ErrorView(message: _error!, onRetry: _loadPersons);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: DropdownButtonFormField<int>(
            initialValue: _selectedId,
            decoration: const InputDecoration(labelText: 'Sales person'),
            items: _persons
                .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
                .toList(),
            onChanged: (value) {
              setState(() => _selectedId = value);
              _loadStock();
            },
          ),
        ),
        Expanded(
          child: _loadingStock
              ? const LoadingView()
              : _error != null
                  ? ErrorView(message: _error!, onRetry: _loadStock)
                  : _stock.isEmpty
                      ? const EmptyView(message: 'Van is empty')
                      : RefreshIndicator(
                          onRefresh: _loadStock,
                          child: ListView.builder(
                            itemCount: _stock.length,
                            itemBuilder: (_, i) {
                              final item = _stock[i];
                              final low = (item.product?.alertQuantity ?? 0) > 0 &&
                                  item.balance <= (item.product?.alertQuantity ?? 0);
                              return ListTile(
                                title: Text(item.product?.name ?? 'Product #${item.productId}'),
                                subtitle: low
                                    ? Text('Low stock', style: TextStyle(color: AppColors.warning(context)))
                                    : null,
                                trailing: Text(item.displayBalance),
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}
