import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';

/// Physical stock count vs the live ledger, admin-only. The whole admin_app
/// is already gated to the `admin` role at login, so no extra role check is
/// needed here — same pattern as DiscountApprovalScreen.
class InventoryInspectionsListScreen extends ConsumerStatefulWidget {
  const InventoryInspectionsListScreen({super.key});

  @override
  ConsumerState<InventoryInspectionsListScreen> createState() => _InventoryInspectionsListScreenState();
}

class _InventoryInspectionsListScreenState extends ConsumerState<InventoryInspectionsListScreen> {
  List<InventoryInspectionModel> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final items = await ref.read(inventoryRepositoryProvider).inspections();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _startNew() async {
    final persons = await ref.read(customerRepositoryProvider).salesPersons();
    if (!mounted) return;

    int? salesPersonId;
    final started = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start new inspection', style: Theme.of(sheetContext).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Snapshots every product currently tracked at the chosen location.',
                style: Theme.of(sheetContext).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int?>(
                initialValue: salesPersonId,
                decoration: const InputDecoration(labelText: 'Location'),
                items: [
                  const DropdownMenuItem<int?>(value: null, child: Text('Warehouse')),
                  ...persons.items.map((p) => DropdownMenuItem<int?>(value: p.id, child: Text(p.name))),
                ],
                onChanged: (v) => setSheetState(() => salesPersonId = v),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(sheetContext, true),
                child: const Text('Start counting'),
              ),
            ],
          ),
        ),
      ),
    );

    if (started != true || !mounted) return;

    try {
      final inspection = await ref.read(inventoryRepositoryProvider).startInspection(salesPersonId: salesPersonId);
      if (!mounted) return;
      await context.push('/inventory/inspections/${inspection.id}');
      if (mounted) _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Inventory Inspections')),
        body: const LoadingView(),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Inspections')),
      floatingActionButton: TranslucentFab(
        onOpen: _startNew,
        icon: const Icon(Icons.fact_check),
        label: 'Inspect',
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _items.isEmpty
            ? const EmptyView(
                message: 'No inspections yet',
                icon: Icons.fact_check_outlined,
              )
            : ListView.builder(
                padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.fabClearance),
                itemCount: _items.length,
                itemBuilder: (_, i) {
                  final insp = _items[i];
                  return ListTile(
                    title: Text('#${insp.id} · ${insp.locationLabel}'),
                    subtitle: Text(
                      insp.isCompleted
                          ? 'Missing: ${insp.totalMissingQty} pcs'
                          : '${insp.totalProducts} product(s) · started ${insp.startedAt ?? ''}',
                    ),
                    trailing: StatusChip(label: insp.status),
                    onTap: () async {
                      await context.push('/inventory/inspections/${insp.id}');
                      if (mounted) _load();
                    },
                  );
                },
              ),
      ),
    );
  }
}

class InventoryInspectionDetailScreen extends ConsumerStatefulWidget {
  const InventoryInspectionDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<InventoryInspectionDetailScreen> createState() => _InventoryInspectionDetailScreenState();
}

class _InventoryInspectionDetailScreenState extends ConsumerState<InventoryInspectionDetailScreen> {
  InventoryInspectionModel? _inspection;
  bool _loading = true;
  bool _busy = false;
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final inspection = await ref.read(inventoryRepositoryProvider).inspection(widget.id);
      if (!mounted) return;
      for (final c in _controllers.values) {
        c.dispose();
      }
      _controllers.clear();
      for (final item in inspection.items) {
        _controllers[item.productId] = TextEditingController(
          text: item.countedQty != null ? '${item.countedQty}' : '',
        );
      }
      setState(() {
        _inspection = inspection;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  int get _enteredCount => _controllers.values.where((c) => c.text.trim().isNotEmpty).length;

  Future<void> _saveCounts() async {
    final lines = _controllers.entries
        .where((e) => e.value.text.trim().isNotEmpty)
        .map((e) => {'product_id': e.key, 'counted_qty': int.tryParse(e.value.text) ?? 0})
        .toList();
    if (lines.isEmpty) return;

    setState(() => _busy = true);
    try {
      await ref.read(inventoryRepositoryProvider).saveInspectionCounts(widget.id, lines);
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Counts saved')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _complete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Complete this inspection?'),
        content: const Text(
          'This locks the count and posts a stock adjustment for every product whose count '
          'differs from the system balance. This cannot be undone from here.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Complete')),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      final inspection = await ref.read(inventoryRepositoryProvider).completeInspection(widget.id);
      if (!mounted) return;
      setState(() {
        _inspection = inspection;
        _busy = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _cancelInspection() async {
    final reasonController = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel this inspection?'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(labelText: 'Reason'),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Keep it')),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, reasonController.text.trim()),
            child: const Text('Cancel inspection'),
          ),
        ],
      ),
    );
    if (reason == null || reason.isEmpty || !mounted) return;

    setState(() => _busy = true);
    try {
      await ref.read(inventoryRepositoryProvider).cancelInspection(widget.id, reason);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _inspection == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Inspection #${widget.id}')),
        body: const LoadingView(),
      );
    }

    final inspection = _inspection!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspection #${inspection.id}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(child: StatusChip(label: inspection.status)),
          ),
        ],
      ),
      body: inspection.isDraft
          ? _buildDraft(context, inspection)
          : inspection.isCompleted
              ? _buildCompleted(context, inspection)
              : _buildCancelled(context, inspection),
    );
  }

  Widget _buildDraft(BuildContext context, InventoryInspectionModel inspection) {
    final total = inspection.items.length;
    final allCounted = total > 0 && _enteredCount == total;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(inspection.locationLabel, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('$_enteredCount / $total counted'),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.sm),
                child: LinearProgressIndicator(value: total == 0 ? 0 : _enteredCount / total),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.fabClearance),
            itemCount: inspection.items.length,
            itemBuilder: (_, i) {
              final item = inspection.items[i];
              return ListTile(
                title: Text(item.product?.name ?? 'Product #${item.productId}'),
                subtitle: Text('System expects: ${item.expectedQtyStart} pcs'),
                trailing: SizedBox(
                  width: 90,
                  child: TextField(
                    controller: _controllers[item.productId],
                    decoration: const InputDecoration(labelText: 'Counted', isDense: true),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              );
            },
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _busy ? null : _cancelInspection,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _busy ? null : _saveCounts,
                    child: _busy
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Save counts'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: _busy || !allCounted ? null : _complete,
                    child: const Text('Complete'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleted(BuildContext context, InventoryInspectionModel inspection) {
    final currency = NumberFormat.currency(symbol: 'SAR ');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Missing quantity: ${inspection.totalMissingQty} pcs',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Missing @ gross price: ${currency.format(inspection.totalMissingGrossValue ?? 0)}'),
                  Text('Missing @ net (actual) price: ${currency.format(inspection.totalMissingNetValue ?? 0)}'),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: inspection.items.length,
            itemBuilder: (_, i) {
              final item = inspection.items[i];
              if (!item.isShort && !item.isOver) return const SizedBox.shrink();
              return ListTile(
                title: Text(item.product?.name ?? 'Product #${item.productId}'),
                subtitle: Text('Expected ${item.expectedQty ?? 0} · Counted ${item.countedQty ?? 0}'),
                trailing: Text(
                  '${(item.varianceQty ?? 0) > 0 ? '+' : ''}${item.varianceQty ?? 0}',
                  style: TextStyle(
                    color: item.isShort ? AppColors.danger(context) : AppColors.success(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCancelled(BuildContext context, InventoryInspectionModel inspection) {
    return EmptyView(
      message: inspection.cancellationReason ?? 'This inspection was cancelled.',
      icon: Icons.cancel_outlined,
    );
  }
}
