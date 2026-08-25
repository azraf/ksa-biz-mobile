import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';
import 'package:media/media.dart';

import '../../providers/connectivity_provider.dart';
import '../../providers/repositories.dart';

/// Every product the company sells — warehouse, own van, and (anonymously)
/// whatever is on other vans — including the ones with no stock at all.
class AllProductsScreen extends ConsumerStatefulWidget {
  const AllProductsScreen({super.key, this.header});

  /// The Van tab's segmented control, drawn inside this screen's Scaffold so
  /// the filter drawer covers the whole tab.
  final Widget? header;

  @override
  ConsumerState<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends ConsumerState<AllProductsScreen> {
  List<({int id, String name})> _brands = [];
  List<({int id, String name})> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadLookups();
  }

  /// Brand and category names for the filter drawer. Best-effort: the browser
  /// simply hides a filter whose list never arrived.
  Future<void> _loadLookups() async {
    final repos = AdminRepositories(ref.read(apiClientProvider));
    try {
      final brands = await repos.brands.list();
      final categories = await repos.categories.list();
      if (!mounted) return;
      setState(() {
        _brands = brands.map((b) => (id: b.id, name: b.name)).toList();
        _categories = categories.map((c) => (id: c.id, name: c.name)).toList();
      });
    } catch (_) {
      // Offline or unreachable — leave the two dropdowns out.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(offlineProductRepositoryProvider);
    final offline = !ref.watch(onlineStatusProvider);

    return ProductBrowser(
      header: widget.header,
      brands: _brands,
      categories: _categories,
      // The "as of" stamp only means something when the list came from cache.
      cachedAt: offline ? repo.cachedAt : null,
      // A salesperson gets three buckets. `other_vans` is deliberately not
      // broken down by van — the server refuses to name them.
      sourceOptions: [
        ProductSourceOption(key: 'warehouse', label: l10n.commonProductSourceWarehouse),
        ProductSourceOption(key: 'mine', label: l10n.commonProductSourceMyVan),
        ProductSourceOption(key: 'other_vans', label: l10n.commonProductSourceOtherVans),
      ],
      imageBuilder: (url, height) =>
          MediaImageTile(url: url, height: height, tapToView: false),
      load: (query) => repo.list(
        page: query.page,
        search: query.search,
        brandId: query.brandId,
        categoryId: query.categoryId,
        sources: query.sources,
        inStock: query.inStock,
        sort: query.sort.apiValue,
        withStock: true,
      ),
      onTapProduct: (p) => context.push('/van-stock/products/${p.id}'),
    );
  }
}

/// Read-only product page: full-size images, price, and where the stock is.
class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  ProductModel? _product;
  ProductStock? _stock;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // One call: the gallery and the per-source stock block together.
      final product = await ref
          .read(productRepositoryProvider)
          .get(widget.productId, withStock: true);
      if (!mounted) return;
      setState(() {
        _product = product;
        _stock = product.stock;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppErrorMapper.localize(context, e);
        _loading = false;
      });
    }
  }

  /// Every image on the product, so the viewer can page through them.
  List<MediaViewerItem> _gallery(ProductModel p) => [
        if (p.featureImageUrl != null && p.featureImageUrl!.isNotEmpty)
          MediaViewerItem(url: p.featureImageUrl),
        ...p.galleryImages.map((g) => MediaViewerItem(url: g.url)),
      ];

  Widget _images(ProductModel p) {
    final gallery = _gallery(p);
    final hasFeature = p.featureImageUrl != null && p.featureImageUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediaImageTile(
          url: p.featureImageUrl,
          height: 240,
          fit: BoxFit.contain,
          gallery: gallery.isEmpty ? null : gallery,
        ),
        if (p.galleryImages.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: p.galleryImages.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) => SizedBox(
                width: 72,
                child: MediaImageTile(
                  url: p.galleryImages[i].url,
                  height: 72,
                  gallery: gallery,
                  // Feature image sits first in the gallery when present.
                  galleryIndex: hasFeature ? i + 1 : i,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _stockSection(BuildContext context, ProductModel p) {
    final l10n = AppLocalizations.of(context);
    final stock = _stock;
    if (stock == null) return const SizedBox.shrink();

    final low = p.alertQuantity > 0 && stock.totalPieces <= p.alertQuantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.commonProductStockBreakdown),
        for (final source in stock.sources)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(source.label),
            trailing: Text(
              source.balanceDisplay,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        const Divider(),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            l10n.commonProductTotalStock,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          subtitle: stock.totalPieces <= 0
              ? Text(
                  l10n.commonProductOutOfStock,
                  style: TextStyle(color: AppColors.danger(context)),
                )
              : low
                  ? Text(
                      l10n.commonProductLowStock,
                      style: TextStyle(color: AppColors.warning(context)),
                    )
                  : null,
          trailing: Text(
            stock.totalDisplay,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = _product;

    return Scaffold(
      appBar: AppBar(title: Text(p?.name ?? l10n.salesProductDetailTitle)),
      body: _loading
          ? const LoadingView()
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    _images(p!),
                    const SizedBox(height: AppSpacing.lg),
                    Text(p.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      p.allowBreakPack
                          ? l10n.commonProductPriceCtn('${p.price}', '${p.piecesPerCarton}')
                          : l10n.commonProductPrice('${p.price}'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (p.brandName != null || p.categoryName != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        [p.brandName, p.categoryName].whereType<String>().join('  ·  '),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                    if ((p.description ?? '').isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(p.description!),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    _stockSection(context, p),
                    if ((_stock?.warehousePieces ?? 0) > 0) ...[
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton.icon(
                        icon: const Icon(Icons.download_outlined),
                        label: Text(l10n.salesProductLoadToVan),
                        onPressed: () =>
                            context.push('/van-stock/load?product=${p.id}'),
                      ),
                    ],
                  ],
                ),
    );
  }
}
