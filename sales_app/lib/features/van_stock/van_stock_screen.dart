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

class _VanStockScreenState extends ConsumerState<VanStockScreen> {
  List<InventoryStockModel> _stock = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final stock = await ref.read(inventoryRepositoryProvider).vanStock(salesPersonId!);
      setState(() {
        _stock = stock;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = AppErrorMapper.localize(context, e);
        _loading = false;
      });
    }
  }

  Future<void> _unloadProduct(InventoryStockModel item) async {
    final l10n = AppLocalizations.of(context);
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null) return;
    final qtyController = TextEditingController(text: '1');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${l10n.salesVanUnloadBtn} ${item.product?.name ?? ''}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.salesVanUnloadMessage),
            const SizedBox(height: 12),
            TextField(
              controller: qtyController,
              decoration: InputDecoration(labelText: l10n.salesVanUnloadQty),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.salesVanUnloadBtn)),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(inventoryRepositoryProvider).unloadVan(
            productId: item.productId,
            quantity: int.tryParse(qtyController.text) ?? 1,
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
      barrierColor: Colors.transparent,
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
