import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/repositories.dart';
import '../products/product_screens.dart';

/// The Van tab: what is on this van, and the whole company catalogue beside
/// it. Same shape as PlanHubScreen — the shell supplies the Scaffold.
class VanHubScreen extends StatefulWidget {
  const VanHubScreen({super.key, this.initialTab});

  /// 'products' opens the All Products segment.
  final String? initialTab;

  @override
  State<VanHubScreen> createState() => _VanHubScreenState();
}

class _VanHubScreenState extends State<VanHubScreen> {
  late bool _showProducts = widget.initialTab == 'products';

  /// A products deep link re-uses the mounted hub once the tab was opened;
  /// re-apply the requested segment when the link changes.
  @override
  void didUpdateWidget(VanHubScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      setState(() => _showProducts = widget.initialTab == 'products');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final segments = Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: SegmentedButton<bool>(
        segments: [
          ButtonSegment(
            value: false,
            icon: const Icon(Icons.local_shipping_outlined),
            label: Text(l10n.commonProductsMyVanTab),
          ),
          ButtonSegment(
            value: true,
            icon: const Icon(Icons.inventory_2_outlined),
            label: Text(l10n.commonProductsAllTab),
          ),
        ],
        selected: {_showProducts},
        onSelectionChanged: (selection) =>
            setState(() => _showProducts = selection.first),
      ),
    );

    // All Products hosts the segments itself so its filter drawer covers the
    // whole tab; My Van has no drawer, so a plain Column is enough.
    if (_showProducts) return AllProductsScreen(header: segments);

    return Column(
      children: [segments, const Expanded(child: VanStockScreen())],
    );
  }
}

class VanStockScreen extends ConsumerStatefulWidget {
  const VanStockScreen({super.key});

  @override
  ConsumerState<VanStockScreen> createState() => _VanStockScreenState();
}

/// Serialises a van-stock row for the offline report cache — writes exactly
/// the fields [InventoryStockModel.fromJson] (and its nested
/// [ProductModel.fromJson]) read back.
Map<String, dynamic> vanStockItemToJson(InventoryStockModel item) => {
      'product_id': item.productId,
      'balance': item.balance,
      'balance_pieces': item.balancePieces,
      if (item.balanceDisplay != null) 'balance_display': item.balanceDisplay,
      'pieces_per_carton': item.piecesPerCarton,
      if (item.product != null)
        'product': {
          'id': item.product!.id,
          'name': item.product!.name,
          'alert_quantity': item.product!.alertQuantity,
          'allow_break_pack': item.product!.allowBreakPack,
          'pieces_per_carton': item.product!.piecesPerCarton,
        },
    };

class _VanStockScreenState extends ConsumerState<VanStockScreen> {
  static const _cacheReportType = 'van_stock';

  List<InventoryStockModel> _stock = [];
  bool _loading = true;
  String? _error;

  /// Set only when [_stock] came from the offline cache, for the "as of" stamp.
  DateTime? _cachedAt;

  @override
  void initState() {
    super.initState();
    _load();
  }

  static String _cacheKey(int salesPersonId) => 'van_stock_$salesPersonId';

  /// Best-effort: a failed cache write must never break the online screen.
  Future<void> _cacheStock(int salesPersonId, List<InventoryStockModel> stock) async {
    try {
      await ref.read(localDatabaseProvider).cacheReport(
            cacheKey: _cacheKey(salesPersonId),
            reportType: _cacheReportType,
            data: {'items': stock.map(vanStockItemToJson).toList()},
          );
    } catch (_) {
      // Cache is a convenience; the live fetch already succeeded.
    }
  }

  Future<({List<InventoryStockModel> items, DateTime? fetchedAt})?> _readCachedStock(
      int salesPersonId) async {
    try {
      final cached =
          await ref.read(localDatabaseProvider).getCachedReport(_cacheKey(salesPersonId));
      if (cached == null) return null;
      final items = (cached.data['items'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(InventoryStockModel.fromJson)
          .toList();
      return (items: items, fetchedAt: DateTime.tryParse(cached.fetchedAt));
    } catch (_) {
      return null;
    }
  }

  Future<void> _load() async {
    final l10n = AppLocalizations.of(context);
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null) {
      // No salesperson selected/attached — show a recoverable error instead
      // of crashing on a null-assert.
      setState(() {
        _loading = false;
        _error = l10n.salesSelectSalespersonFirst;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final stock = await ref.read(inventoryRepositoryProvider).vanStock(salesPersonId);
      await _cacheStock(salesPersonId, stock);
      if (!mounted) return;
      setState(() {
        _stock = stock;
        _cachedAt = null;
        _loading = false;
      });
    } catch (e) {
      // Offline (or server unreachable): fall back to the last cached list so
      // the salesperson can still see roughly what is on the van.
      final cached = await _readCachedStock(salesPersonId);
      if (!mounted) return;
      if (cached != null && cached.items.isNotEmpty) {
        setState(() {
          _stock = cached.items;
          _cachedAt = cached.fetchedAt;
          _loading = false;
        });
      } else {
        setState(() {
          _error = AppErrorMapper.localize(context, e);
          _loading = false;
        });
      }
    }
  }

  Future<void> _unloadProduct(InventoryStockModel item) async {
    final l10n = AppLocalizations.of(context);
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null) return;
    final qtyController = TextEditingController(text: '1');
    String? qtyError;
    // Returns the parsed quantity, so a typo can never silently become "1".
    final quantity = await showDialog<int>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('${l10n.salesVanUnloadBtn} ${item.product?.name ?? ''}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.salesVanUnloadMessage),
              const SizedBox(height: 12),
              TextField(
                controller: qtyController,
                decoration: InputDecoration(
                  labelText: l10n.salesVanUnloadQty,
                  errorText: qtyError,
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonCancel)),
            FilledButton(
              onPressed: () {
                final qty = int.tryParse(qtyController.text.trim());
                if (qty == null || qty < 1) {
                  setDialogState(
                    () => qtyError = l10n.commonEnterQuantityMin,
                  );
                  return;
                }
                Navigator.pop(ctx, qty);
              },
              child: Text(l10n.salesVanUnloadBtn),
            ),
          ],
        ),
      ),
    );
    if (quantity == null) return;
    try {
      await ref.read(inventoryRepositoryProvider).unloadVan(
            productId: item.productId,
            quantity: quantity,
            salesPersonId: salesPersonId,
          );
      AppHaptics.light();
      await _load();
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    }
  }

  Future<void> _showActions() {
    final l10n = AppLocalizations.of(context);
    // Translucent sheet + no scrim so the stock list stays readable behind it.
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor:
          Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
      // Fully transparent scrim, but from the theme token — Colors.* is
      // banned in feature code.
      barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: 0),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: Text(l10n.salesVanLoad),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/van-stock/load');
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(l10n.salesVanTransfer),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/van-stock/transfer');
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(l10n.salesVanExchange),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/van-stock/exchange');
              },
            ),
            ListTile(
              leading: const Icon(Icons.build_outlined),
              title: Text(l10n.salesVanDamage),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/van-stock/damage');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final offline = !ref.watch(onlineStatusProvider);

    return Scaffold(
      body: Column(
        children: [
          if (offline)
            Material(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(Icons.cloud_off, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(l10n.salesVanOfflineBanner, style: const TextStyle(fontSize: 13))),
                  ],
                ),
              ),
            ),
          if (_cachedAt != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xs,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l10n.commonProductStockAsOf(
                    TimeOfDay.fromDateTime(_cachedAt!).format(context),
                  ),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          Expanded(
            child: _loading
                ? ListView.builder(
                    padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.fabClearance),
                    itemCount: 6,
                    itemBuilder: (_, _) => const SkeletonListTile(),
                  )
                : _error != null
                    ? ErrorView(message: _error!, onRetry: _load)
                    : _stock.isEmpty
                        ? EmptyView(message: l10n.salesVanEmpty)
                        : RefreshIndicator(
                            onRefresh: _load,
                            child: ListView.builder(
                              padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.fabClearance),
                              itemCount: _stock.length,
                              itemBuilder: (_, i) {
                                final item = _stock[i];
                                final low = (item.product?.alertQuantity ?? 0) > 0 &&
                                    item.balance <= (item.product?.alertQuantity ?? 0);
                                return ListTile(
                                  title: Text(item.product?.name ?? l10n.commonProductFallback(item.productId)),
                                  subtitle: low
                                      ? Text(l10n.salesVanLowStock, style: TextStyle(color: AppColors.warning(context)))
                                      : null,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(item.displayBalance),
                                      IconButton(
                                        icon: const Icon(Icons.undo_outlined),
                                        tooltip: l10n.salesVanUnloadBtn,
                                        onPressed: () => _unloadProduct(item),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: TranslucentFab(
        onOpen: _showActions,
        icon: const Icon(Icons.add),
        label: l10n.salesVanActionsTitle,
      ),
    );
  }
}
