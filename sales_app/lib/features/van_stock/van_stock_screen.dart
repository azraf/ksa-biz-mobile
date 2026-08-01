import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

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
        _error = e.toString();
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
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget _buildStockList(AppLocalizations l10n) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: fabScrollPadding(context, includeBottomNav: true),
        itemCount: _stock.length,
        itemBuilder: (_, i) {
          final item = _stock[i];
          final low = (item.product?.alertQuantity ?? 0) > 0 &&
              item.balance <= (item.product?.alertQuantity ?? 0);
          return ListTile(
            title: Text(item.product?.name ?? l10n.commonProductFallback(item.productId)),
            subtitle: low
                ? Text(l10n.salesVanLowStock, style: const TextStyle(color: Colors.orange))
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
    );
  }

  Widget _buildActionRail(AppLocalizations l10n) {
    return SafeArea(
      left: false,
      child: SizedBox(
        width: kVanActionRailWidth,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.sm, AppSpacing.sm, AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _VanActionButton(
                icon: Icons.swap_horiz,
                label: l10n.salesVanExchange,
                onPressed: () => context.push('/van-stock/exchange'),
              ),
              const SizedBox(height: AppSpacing.sm),
              _VanActionButton(
                icon: Icons.build_outlined,
                label: l10n.salesVanDamage,
                onPressed: () => context.push('/van-stock/damage'),
              ),
              const SizedBox(height: AppSpacing.sm),
              _VanActionButton(
                icon: Icons.swap_horiz,
                label: l10n.salesVanTransfer,
                onPressed: () => context.push('/van-stock/transfer'),
              ),
              const SizedBox(height: AppSpacing.sm),
              _VanActionButton(
                icon: Icons.download_outlined,
                label: l10n.salesVanLoad,
                onPressed: () => context.push('/van-stock/load'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    Widget body;
    if (_loading) {
      body = LoadingView(message: l10n.commonLoading);
    } else if (_error != null) {
      body = ErrorView(message: _error!, onRetry: _load);
    } else if (_stock.isEmpty) {
      body = EmptyView(message: l10n.salesVanEmpty);
    } else {
      body = _buildStockList(l10n);
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: body),
          _buildActionRail(l10n),
        ],
      ),
    );
  }
}

class _VanActionButton extends StatelessWidget {
  const _VanActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.sm),
          visualDensity: VisualDensity.compact,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
