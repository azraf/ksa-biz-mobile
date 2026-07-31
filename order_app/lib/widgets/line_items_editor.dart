import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../providers/customer_context_provider.dart';
import '../providers/repositories.dart';
import '../repositories/product_price_repository.dart';

export 'package:core/widgets/line_items_editor.dart';

Future<ProductModel?> pickProduct(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final profile = ref.read(customerContextProvider).profile;
  if (profile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.orderCustomerProfileNotLoaded)),
    );
    return null;
  }

  if (!context.mounted) return null;

  return showModalBottomSheet<ProductModel>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _ProductPickerSheet(
      productRepo: ref.read(productRepositoryProvider),
      priceRepo: ref.read(productPriceRepositoryProvider),
      customerTypeId: profile.customerTypeId,
    ),
  );
}

class _ProductPickerSheet extends StatefulWidget {
  const _ProductPickerSheet({
    required this.productRepo,
    required this.priceRepo,
    required this.customerTypeId,
  });

  final ProductRepository productRepo;
  final ProductPriceRepository priceRepo;
  final int customerTypeId;

  @override
  State<_ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends State<_ProductPickerSheet> {
  final _searchController = TextEditingController();
  List<ProductModel> _products = [];
  final Map<int, double> _prices = {};
  String? _error;

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() => _error = null);
    try {
      final result = await widget.productRepo.list(search: _searchController.text);
      final prices = await widget.priceRepo.listByCustomerType(widget.customerTypeId);
      setState(() {
        _products = result.items;
        _prices
          ..clear()
          ..addEntries(prices.map((p) => MapEntry(p.productId, p.price)));
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(labelText: l10n.commonSearchProducts),
                      onSubmitted: (_) => _search(),
                    ),
                  ),
                  IconButton(onPressed: _search, icon: const Icon(Icons.search)),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (_, i) {
                  final product = _products[i];
                  final price = _prices[product.id] ?? product.price;
                  final piecePrice = product.piecesPerCarton > 0 ? price / product.piecesPerCarton : price;
                  final subtitle = product.allowBreakPack
                      ? l10n.commonProductPriceCtn(
                          '$price',
                          'SAR ${piecePrice.toStringAsFixed(2)} /',
                        )
                      : l10n.commonProductPrice('$price');
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(subtitle),
                    onTap: () => Navigator.pop(
                      context,
                      ProductModel(
                        id: product.id,
                        name: product.name,
                        price: price,
                        wholesalePrice: product.wholesalePrice,
                        alertQuantity: product.alertQuantity,
                        description: product.description,
                        allowBreakPack: product.allowBreakPack,
                        piecesPerCarton: product.piecesPerCarton,
                        piecePrice: piecePrice,
                        pcsUnitId: product.pcsUnitId,
                        cartonUnitId: product.cartonUnitId,
                        unitId: product.unitId,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
