import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';

class WarehouseStockScreen extends ConsumerWidget {
  const WarehouseStockScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<InventoryStockModel>>(
      future: ref.read(inventoryRepositoryProvider).warehouseStock(),
      builder: (context, snap) {
        if (!snap.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        return Scaffold(
          appBar: AppBar(
            title: const Text('Warehouse Stock'),
            actions: [
              IconButton(
                icon: const Icon(Icons.assessment_outlined),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryValuationScreen())),
              ),
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StockMovementsScreen())),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StockAdjustmentScreen())),
            icon: const Icon(Icons.tune),
            label: const Text('Adjust'),
          ),
          body: ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (_, i) {
              final s = snap.data![i];
              final low = (s.product?.alertQuantity ?? 0) > 0 && s.balance <= (s.product?.alertQuantity ?? 0);
              return ListTile(
                title: Text(s.product?.name ?? 'Product #${s.productId}'),
                subtitle: low ? Text('Low stock', style: TextStyle(color: AppColors.warning(context))) : null,
                trailing: Text(s.displayBalance),
              );
            },
          ),
        );
      },
    );
  }
}

class VanStockScreen extends ConsumerStatefulWidget {
  const VanStockScreen({super.key});
  @override
  ConsumerState<VanStockScreen> createState() => _VanStockScreenState();
}

class _VanStockScreenState extends ConsumerState<VanStockScreen> {
  List<SalesPersonModel> _persons = [];
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPersons());
  }

  Future<void> _loadPersons() async {
    final container = ProviderScope.containerOf(context);
    final persons = await container.read(customerRepositoryProvider).salesPersons();
    setState(() {
      _persons = persons.items;
      if (_persons.isNotEmpty) _selectedId = _persons.first.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
        appBar: AppBar(title: const Text('Van Stock')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<int>(
                value: _selectedId,
                decoration: const InputDecoration(labelText: 'Sales Person'),
                items: _persons.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                onChanged: (v) => setState(() => _selectedId = v),
              ),
            ),
            Expanded(
              child: _selectedId == null
                  ? const Center(child: Text('Select a sales person'))
                  : FutureBuilder<List<InventoryStockModel>>(
                      future: ref.read(inventoryRepositoryProvider).vanStock(_selectedId!),
                      builder: (context, snap) {
                        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                        return ListView.builder(
                          itemCount: snap.data!.length,
                          itemBuilder: (_, i) {
                            final s = snap.data![i];
                            return ListTile(
                              title: Text(s.product?.name ?? 'Product #${s.productId}'),
                              trailing: Text(s.displayBalance),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }
}

class LoadVanScreen extends ConsumerStatefulWidget {
  const LoadVanScreen({super.key});
  @override
  ConsumerState<LoadVanScreen> createState() => _LoadVanScreenState();
}

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

class _LoadVanScreenState extends ConsumerState<LoadVanScreen> {
  List<SalesPersonModel> _persons = [];
  int? _selectedPersonId;
  List<_LoadLine> _lines = [];
  bool _loadingPersons = true;
  bool _loadingStock = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPersons());
  }

  @override
  void dispose() {
    for (final line in _lines) {
      line.controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadPersons() async {
    final persons = await ref.read(customerRepositoryProvider).salesPersons();
    setState(() {
      _persons = persons.items;
      _selectedPersonId = _persons.isNotEmpty ? _persons.first.id : null;
      _loadingPersons = false;
    });
    if (_selectedPersonId != null) {
      await _loadWarehouse();
    }
  }

  Future<void> _loadWarehouse() async {
    setState(() => _loadingStock = true);
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
        _loadingStock = false;
      });
    } catch (e) {
      setState(() => _loadingStock = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
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
    if (_selectedPersonId == null) return;
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
            salesPersonId: _selectedPersonId!,
            lines: lines,
            loadAll: loadAll,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loaded ${result.loaded.length} product(s) to van')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _submitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingPersons) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk load van'),
        actions: [
          TextButton(onPressed: _lines.isEmpty ? null : _selectAll, child: const Text('Select all')),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<int>(
              value: _selectedPersonId,
              decoration: const InputDecoration(labelText: 'Sales Person'),
              items: _persons.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
              onChanged: (v) async {
                setState(() => _selectedPersonId = v);
                await _loadWarehouse();
              },
            ),
          ),
          Expanded(
            child: _loadingStock
                ? const Center(child: CircularProgressIndicator())
                : _lines.isEmpty
                    ? const Center(child: Text('No warehouse stock available'))
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
                                decoration: const InputDecoration(labelText: 'CTN', isDense: true),
                                keyboardType: TextInputType.number,
                                enabled: line.selected,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        },
                      ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton(
                    onPressed: _submitting || _lines.isEmpty ? null : () => _submit(loadAll: true),
                    child: _submitting
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
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
        ],
      ),
    );
  }
}

class StockAdjustmentScreen extends ConsumerStatefulWidget {
  const StockAdjustmentScreen({super.key});
  @override
  ConsumerState<StockAdjustmentScreen> createState() => _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends ConsumerState<StockAdjustmentScreen> {
  final _productId = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  final _reason = TextEditingController();
  String _direction = 'out';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Adjustment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _productId, decoration: const InputDecoration(labelText: 'Product ID'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _quantity, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _direction,
              decoration: const InputDecoration(labelText: 'Direction'),
              items: const [
                DropdownMenuItem(value: 'in', child: Text('Stock In')),
                DropdownMenuItem(value: 'out', child: Text('Stock Out')),
              ],
              onChanged: (v) => setState(() => _direction = v ?? 'out'),
            ),
            const SizedBox(height: 12),
            TextField(controller: _reason, decoration: const InputDecoration(labelText: 'Reason'), maxLines: 2),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                try {
                  await ref.read(inventoryRepositoryProvider).createAdjustment(
                        productId: int.parse(_productId.text),
                        quantity: int.parse(_quantity.text),
                        direction: _direction,
                        reason: _reason.text,
                      );
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                }
              },
              child: const Text('Save Adjustment'),
            ),
          ],
        ),
      ),
    );
  }
}

class DamageWriteoffScreen extends ConsumerStatefulWidget {
  const DamageWriteoffScreen({super.key});
  @override
  ConsumerState<DamageWriteoffScreen> createState() => _DamageWriteoffScreenState();
}

class _DamageWriteoffScreenState extends ConsumerState<DamageWriteoffScreen> {
  final _productId = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  final _reason = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Damage Write-off')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _productId, decoration: const InputDecoration(labelText: 'Product ID'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _quantity, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _reason, decoration: const InputDecoration(labelText: 'Reason'), maxLines: 2),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                try {
                  await ref.read(inventoryRepositoryProvider).createDamageReplacement(
                        replacementType: 'warehouse_writeoff',
                        productId: int.parse(_productId.text),
                        quantity: int.parse(_quantity.text),
                        reason: _reason.text.isEmpty ? null : _reason.text,
                      );
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                }
              },
              child: const Text('Write Off'),
            ),
          ],
        ),
      ),
    );
  }
}

class StockMovementsScreen extends ConsumerWidget {
  const StockMovementsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<StockMovementModel>>(
      future: ref.read(inventoryRepositoryProvider).movements(),
      builder: (context, snap) {
        if (!snap.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        return Scaffold(
          appBar: AppBar(title: const Text('Stock Movements')),
          body: ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (_, i) {
              final m = snap.data![i];
              return ListTile(
                title: Text(m.product?.name ?? 'Product #${m.productId}'),
                subtitle: Text('${m.movementType} · ${m.createdAt ?? ''}'),
                trailing: Text('${m.balance}'),
              );
            },
          ),
        );
      },
    );
  }
}

class InventoryValuationScreen extends ConsumerWidget {
  const InventoryValuationScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<InventoryValuationModel>(
      future: ref.read(inventoryRepositoryProvider).valuation(),
      builder: (context, snap) {
        if (!snap.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final data = snap.data!;
        return Scaffold(
          appBar: AppBar(title: const Text('Inventory Valuation')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('At cost: SAR ${(data.totalCostValue ?? data.totalValue).toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                    if (data.totalRetailValue != null)
                      Text('At retail price: SAR ${data.totalRetailValue!.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleSmall),
                    if (data.totalMarginValue != null)
                      Text('Margin on hand: SAR ${data.totalMarginValue!.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: data.lines.length,
                  itemBuilder: (_, i) {
                    final line = data.lines[i];
                    return ListTile(
                      title: Text(line.product?.name ?? 'Product #${line.productId}'),
                      subtitle: Text('${line.balance} × cost ${line.unitCost.toStringAsFixed(2)} / price ${(line.unitPrice ?? 0).toStringAsFixed(2)}'),
                      trailing: Text((line.costValue ?? line.totalValue).toStringAsFixed(2)),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
