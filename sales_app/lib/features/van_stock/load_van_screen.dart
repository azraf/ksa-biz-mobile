import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

class _LoadLine {
  _LoadLine({
    required this.productId,
    required this.name,
    required this.available,
    required this.controller,
    this.selected = false,
  });

  final int productId;
  final String name;
  final String available;
  final TextEditingController controller;
  bool selected;
}

class LoadVanScreen extends ConsumerStatefulWidget {
  const LoadVanScreen({super.key});

  @override
  ConsumerState<LoadVanScreen> createState() => _LoadVanScreenState();
}

class _LoadVanScreenState extends ConsumerState<LoadVanScreen> {
  List<_LoadLine> _lines = [];
  bool _loading = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final line in _lines) {
      line.controller.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final stock = await ref.read(inventoryRepositoryProvider).warehouseStock();
      for (final line in _lines) {
        line.controller.dispose();
      }
      setState(() {
        _lines = stock
            .map(
              (s) => _LoadLine(
                productId: s.productId,
                name: s.product?.name ?? 'Product #${s.productId}',
                available: s.displayBalance,
                controller: TextEditingController(text: '${s.balance > 0 ? s.balance : 1}'),
              ),
            )
            .toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _selectAll() {
    setState(() {
      for (final line in _lines) {
        line.selected = true;
      }
    });
  }

  List<BulkLoadLineDraft> _selectedLines() {
    return _lines
        .where((line) => line.selected)
        .map(
          (line) => BulkLoadLineDraft(
            productId: line.productId,
            quantity: int.tryParse(line.controller.text) ?? 0,
          ),
        )
        .where((line) => line.quantity > 0)
        .toList();
  }

  Future<void> _submit({bool loadAll = false}) async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null) return;

    final lines = loadAll ? null : _selectedLines();
    if (!loadAll && (lines == null || lines.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one product')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final result = await ref.read(inventoryRepositoryProvider).bulkLoadVan(
            salesPersonId: salesPersonId,
            lines: lines,
            loadAll: loadAll,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loaded ${result.loaded.length} product(s) to van')),
        );
        context.pop();
      }
    } catch (e) {
      setState(() => _submitting = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Load van'),
        actions: [
          TextButton(onPressed: _lines.isEmpty ? null : _selectAll, child: const Text('Select all')),
        ],
      ),
      body: _lines.isEmpty
          ? const EmptyView(message: 'No warehouse stock available')
          : ListView.builder(
              itemCount: _lines.length,
              itemBuilder: (_, i) {
                final line = _lines[i];
                return CheckboxListTile(
                  value: line.selected,
                  onChanged: (v) => setState(() => line.selected = v ?? false),
                  title: Text(line.name),
                  subtitle: Text('Available: ${line.available}'),
                  secondary: SizedBox(
                    width: 72,
                    child: TextField(
                      controller: line.controller,
                      decoration: const InputDecoration(
                        labelText: 'CTN',
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      enabled: line.selected,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: _submitting || _lines.isEmpty ? null : () => _submit(loadAll: true),
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Load all available'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _submitting ? null : () => _submit(),
                child: const Text('Load selected'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
