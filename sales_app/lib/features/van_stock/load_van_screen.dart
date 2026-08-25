import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

class _LoadLine {
  _LoadLine({
    required this.productId,
    required this.name,
    required this.available,
    required this.quantityDisplay,
    required this.controller,
    this.unitId,
  }) : selected = false;

  final int productId;
  final String name;
  final String available;

  /// The server's own "load all" quantity for this product ("3 CTN"/"5 PCS"),
  /// shown in the load-all confirmation.
  final String quantityDisplay;
  final TextEditingController controller;

  /// Null = whole cartons (the server default); the pieces unit id when the
  /// warehouse balance is pieces-only and must be loaded by the piece.
  final int? unitId;
  bool selected;

  /// Inline parse error for the quantity field.
  String? error;

  String get unitLabel => unitId == null ? 'CTN' : 'PCS';
}

class LoadVanScreen extends ConsumerStatefulWidget {
  const LoadVanScreen({super.key, this.preselectProductId});

  /// Ticked and scrolled to on open, so "Load to my van" on a product page
  /// lands on that product.
  final int? preselectProductId;

  @override
  ConsumerState<LoadVanScreen> createState() => _LoadVanScreenState();
}

class _LoadVanScreenState extends ConsumerState<LoadVanScreen> {
  final _scrollController = ScrollController();
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
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      // The server's bulk-load preview already resolves each product to a
      // loadable quantity and unit: the carton part of the balance, or the
      // pieces count (with the pieces unit id) when the warehouse balance is
      // pieces-only. A blanket "1" default would mean 1 carton and 422 for
      // pieces-only products.
      final preview =
          await ref.read(inventoryRepositoryProvider).bulkLoadVanPreview();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      for (final line in _lines) {
        line.controller.dispose();
      }
      setState(() {
        _lines = preview
            .map(
              (p) => _LoadLine(
                productId: p.productId,
                name: p.productName ?? l10n.commonProductFallback(p.productId),
                available: p.balanceDisplay ?? '',
                quantityDisplay: p.quantityDisplay ?? '${p.quantity}',
                controller: TextEditingController(text: '${p.quantity}'),
                unitId: p.unitId,
              ),
            )
            .toList();
        _loading = false;
      });
      _applyPreselection();
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      showAppErrorSnackBar(context, e);
    }
  }

  void _selectAll() {
    setState(() {
      for (final line in _lines) {
        line.selected = true;
      }
    });
  }

  /// Null when a ticked line has an invalid quantity — the lines carry inline
  /// errors instead of silently substituting a number.
  List<BulkLoadLineDraft>? _selectedLines() {
    final l10n = AppLocalizations.of(context);
    var hasError = false;
    final drafts = <BulkLoadLineDraft>[];
    for (final line in _lines) {
      line.error = null;
      if (!line.selected) continue;
      final qty = int.tryParse(line.controller.text.trim());
      if (qty == null || qty < 1) {
        line.error = l10n.commonEnterOneOrMore;
        hasError = true;
        continue;
      }
      drafts.add(BulkLoadLineDraft(
        productId: line.productId,
        quantity: qty,
        unitId: line.unitId,
      ));
    }
    if (hasError) {
      setState(() {});
      return null;
    }
    return drafts;
  }

  /// "Load all" moves the entire warehouse onto the van — worth a look first.
  Future<bool> _confirmLoadAll() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.salesVanLoadAll),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.salesVanLoadAllConfirm(_lines.length)),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _lines.length,
                  itemBuilder: (_, i) {
                    final line = _lines[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              line.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(line.quantityDisplay),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.salesVanLoadAll),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _submit({bool loadAll = false}) async {
    final l10n = AppLocalizations.of(context);
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.salesSelectSalespersonFirst)),
      );
      return;
    }

    List<BulkLoadLineDraft>? lines;
    if (loadAll) {
      if (!await _confirmLoadAll()) return;
      if (!mounted) return;
    } else {
      lines = _selectedLines();
      if (lines == null) return; // invalid quantities — inline errors shown
      if (lines.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.salesVanLoadSelectOne)),
        );
        return;
      }
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
          SnackBar(content: Text(l10n.salesVanLoadSuccess(result.loaded.length))),
        );
        context.pop();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      showAppErrorSnackBar(context, e);
    }
  }

  /// Tick the product we were sent here for and bring it into view.
  void _applyPreselection() {
    final wanted = widget.preselectProductId;
    if (wanted == null) return;
    final index = _lines.indexWhere((line) => line.productId == wanted);
    if (index < 0) return;
    setState(() => _lines[index].selected = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        (index * 72.0).clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) return LoadingView(message: l10n.commonLoading);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.salesTitleLoadVan),
        actions: [
          TextButton(onPressed: _lines.isEmpty ? null : _selectAll, child: Text(l10n.salesVanLoadSelectAll)),
        ],
      ),
      body: _lines.isEmpty
          ? EmptyView(message: l10n.salesVanLoadNoStock)
          : ListView.builder(
              controller: _scrollController,
              itemCount: _lines.length,
              itemBuilder: (_, i) {
                final line = _lines[i];
                return CheckboxListTile(
                  value: line.selected,
                  onChanged: (v) => setState(() => line.selected = v ?? false),
                  title: Text(line.name),
                  subtitle: Text(l10n.salesVanLoadAvailable(line.available)),
                  secondary: SizedBox(
                    width: 72,
                    child: TextField(
                      controller: line.controller,
                      decoration: InputDecoration(
                        labelText: line.unitLabel,
                        isDense: true,
                        errorText: line.error,
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
                    : Text(l10n.salesVanLoadAll),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _submitting ? null : () => _submit(),
                child: Text(l10n.salesVanLoadSelected),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
