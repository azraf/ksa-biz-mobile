import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/connectivity_provider.dart';
import '../providers/repositories.dart';

export 'package:core/widgets/line_items_editor.dart';

Future<ProductModel?> pickProduct(BuildContext context, WidgetRef ref) async {
  final repo = ref.read(offlineProductRepositoryProvider);
  final online = ref.read(onlineStatusProvider);
  if (!online) {
    final hasProducts = await repo.hasCachedProducts();
    if (!hasProducts) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No products cached. Go online to download product data.')),
        );
      }
      return null;
    }
  }

  if (!context.mounted) return null;

  return showModalBottomSheet<ProductModel>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _ProductPickerSheet(repo: repo),
  );
}

class _ProductPickerSheet extends StatefulWidget {
  const _ProductPickerSheet({required this.repo});

  final OfflineProductRepository repo;

  @override
  State<_ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends State<_ProductPickerSheet> {
  final _searchController = TextEditingController();
  List<ProductModel> _products = [];
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
      final result = await widget.repo.list(search: _searchController.text);
      setState(() => _products = result.items);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      decoration: const InputDecoration(labelText: 'Search products'),
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
                  final p = _products[i];
                  final subtitle = p.allowBreakPack
                      ? 'SAR ${p.price} / CTN · ${p.piecesPerCarton} pcs'
                      : 'SAR ${p.price}';
                  return ListTile(
                    title: Text(p.name),
                    subtitle: Text(subtitle),
                    onTap: () => Navigator.pop(context, p),
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
