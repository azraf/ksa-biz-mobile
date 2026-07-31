import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/customer_context_provider.dart';
import '../../providers/repositories.dart';

class CatalogProduct {
  CatalogProduct({required this.product, required this.unitPrice});

  final ProductModel product;
  final double unitPrice;
}

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final _searchController = TextEditingController();
  List<CatalogProduct> _products = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final customer = ref.read(customerContextProvider).profile;
    if (customer == null) {
      setState(() {
        _loading = false;
        _error = 'Customer profile not loaded yet.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final productRepo = ref.read(productRepositoryProvider);
      final priceRepo = ref.read(productPriceRepositoryProvider);
      final search = _searchController.text.trim();

      final result = await productRepo.list(search: search.isEmpty ? null : search);
      final prices = await priceRepo.listByCustomerType(customer.customerTypeId);
      final priceByProduct = {for (final p in prices) p.productId: p.price};

      setState(() {
        _products = result.items
            .map(
              (product) => CatalogProduct(
                product: product,
                unitPrice: priceByProduct[product.id] ?? product.price,
              ),
            )
            .toList()
          ..sort((a, b) => a.product.name.compareTo(b.product.name));
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerContextProvider);
    final currency = NumberFormat.currency(symbol: 'SAR ');

    if (customerState.isLoading) return const LoadingView();
    if (customerState.error != null) {
      return ErrorView(message: customerState.error!, onRetry: () => ref.read(customerContextProvider.notifier).load());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search products',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) => _load(),
                ),
              ),
              IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const LoadingView()
              : _error != null
                  ? ErrorView(message: _error!, onRetry: _load)
                  : _products.isEmpty
                      ? const EmptyView(message: 'No products found')
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _products.length,
                            itemBuilder: (_, i) {
                              final item = _products[i];
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(child: Text('${i + 1}')),
                                  title: Text(item.product.name),
                                  subtitle: Text(
                                    item.product.description?.isNotEmpty == true
                                        ? item.product.description!
                                        : 'SKU ${item.product.id}',
                                  ),
                                  trailing: Text(
                                    currency.format(item.unitPrice),
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}
