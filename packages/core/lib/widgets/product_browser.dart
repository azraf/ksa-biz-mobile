import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../errors/app_error_mapper.dart';
import '../models/paginated_response.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';
import 'common_widgets.dart';
import 'search_list_widgets.dart';
import 'skeleton_loader.dart';

/// One selectable inventory source. [key] is what the API expects:
/// `warehouse`, `mine`, `other_vans`, or `van:<id>`.
class ProductSourceOption {
  const ProductSourceOption({required this.key, required this.label});

  final String key;
  final String label;
}

enum ProductSort { name, stockDesc, stockAsc, priceAsc, priceDesc }

extension ProductSortX on ProductSort {
  String get apiValue => switch (this) {
        ProductSort.name => 'name',
        ProductSort.stockDesc => 'stock_desc',
        ProductSort.stockAsc => 'stock_asc',
        ProductSort.priceAsc => 'price_asc',
        ProductSort.priceDesc => 'price_desc',
      };

  String label(AppLocalizations l10n) => switch (this) {
        ProductSort.name => l10n.commonProductSortName,
        ProductSort.stockDesc => l10n.commonProductSortStockDesc,
        ProductSort.stockAsc => l10n.commonProductSortStockAsc,
        ProductSort.priceAsc => l10n.commonProductSortPriceAsc,
        ProductSort.priceDesc => l10n.commonProductSortPriceDesc,
      };
}

/// Everything the caller needs to fetch a page. Keeps `core` free of any
/// repository or DI dependency — the host app supplies the fetch.
class ProductQuery {
  const ProductQuery({
    required this.page,
    this.search,
    this.sources = const {},
    this.brandId,
    this.categoryId,
    this.inStock = false,
    this.sort = ProductSort.name,
  });

  final int page;
  final String? search;
  final Set<String> sources;
  final int? brandId;
  final int? categoryId;
  final bool inStock;
  final ProductSort sort;
}

/// Browses the full product catalog — including out-of-stock and never-stocked
/// products — with per-source stock.
///
/// Search, sorting and every filter live in the right end drawer; the body
/// carries only the list, so it gets the full screen height. Same shape as the
/// customer and watchlist lists.
class ProductBrowser extends StatefulWidget {
  const ProductBrowser({
    super.key,
    required this.load,
    required this.onTapProduct,
    required this.imageBuilder,
    required this.sourceOptions,
    this.brands = const [],
    this.categories = const [],
    this.title,
    this.header,
    this.cachedAt,
    this.floatingActionButton,
  });

  /// Fetches one page.
  final Future<PaginatedResponse<ProductModel>> Function(ProductQuery query) load;

  final void Function(ProductModel product) onTapProduct;

  /// Builds a product image. Injected because `core` does not depend on the
  /// `media` package, which owns the image tile and its full-screen viewer.
  final Widget Function(String? url, double height) imageBuilder;

  final List<ProductSourceOption> sourceOptions;
  final List<({int id, String name})> brands;
  final List<({int id, String name})> categories;

  /// When set the browser draws its own AppBar. When null it renders a slim
  /// toolbar row instead, for hosts that already have a header (a tab hub).
  final String? title;

  /// Rendered above the toolbar row when [title] is null — lets a tab host put
  /// its segmented control inside this Scaffold, so the end drawer covers the
  /// whole tab rather than only the area beneath the segments.
  final Widget? header;

  /// Newest cache write, shown as an "as of" stamp while offline.
  final Future<DateTime?> Function()? cachedAt;

  final Widget? floatingActionButton;

  @override
  State<ProductBrowser> createState() => _ProductBrowserState();
}

class _ProductBrowserState extends State<ProductBrowser> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  final List<ProductModel> _items = [];
  Set<String> _sources = {};
  int? _brandId;
  int? _categoryId;
  bool _inStock = false;
  ProductSort _sort = ProductSort.name;
  bool _grid = true;

  int _page = 1;
  bool _hasMore = false;
  bool _loading = true;
  bool _loadingMore = false;
  bool _fuzzy = false;
  String? _error;
  DateTime? _cachedAt;

  bool get _filtersActive =>
      _searchController.text.trim().isNotEmpty ||
      _sources.isNotEmpty ||
      _brandId != null ||
      _categoryId != null ||
      _inStock ||
      _sort != ProductSort.name;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _reload();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _loadingMore || _loading) return;
    if (_scrollController.position.extentAfter < 400) _loadMore();
  }

  ProductQuery _query(int page) => ProductQuery(
        page: page,
        search: _searchController.text.trim(),
        sources: _sources,
        brandId: _brandId,
        categoryId: _categoryId,
        inStock: _inStock,
        sort: _sort,
      );

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await widget.load(_query(1));
      final cachedAt = await widget.cachedAt?.call();
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(page.items);
        _page = 1;
        _hasMore = page.hasMore;
        _fuzzy = page.isFuzzy;
        _cachedAt = cachedAt;
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

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    try {
      final page = await widget.load(_query(_page + 1));
      if (!mounted) return;
      setState(() {
        _items.addAll(page.items);
        _page += 1;
        _hasMore = page.hasMore;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      // A failed "next page" leaves what is already on screen alone.
      setState(() {
        _hasMore = false;
        _loadingMore = false;
      });
    }
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _sources = {};
      _brandId = null;
      _categoryId = null;
      _inStock = false;
      _sort = ProductSort.name;
    });
    _reload();
  }

  // --- stock presentation -------------------------------------------------

  ({String label, Color fg, Color bg}) _stockChip(BuildContext context, ProductModel p) {
    final l10n = AppLocalizations.of(context);
    final stock = p.stock;
    if (stock == null || stock.totalPieces <= 0) {
      return (
        label: l10n.commonProductOutOfStock,
        fg: AppColors.danger(context),
        bg: AppColors.dangerContainer(context),
      );
    }
    final alert = p.alertQuantity;
    if (alert > 0 && stock.totalPieces <= alert) {
      return (
        label: l10n.commonProductLowStock,
        fg: AppColors.warning(context),
        bg: AppColors.warningContainer(context),
      );
    }
    return (
      label: stock.totalDisplay,
      fg: AppColors.success(context),
      bg: AppColors.successContainer(context),
    );
  }

  Widget _stockBadge(BuildContext context, ProductModel p) {
    final chip = _stockChip(context, p);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: chip.bg,
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Text(
        chip.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: chip.fg),
      ),
    );
  }

  /// "Warehouse 10 CTN · My van 1 CTN" — the per-source line under a product.
  String _sourceSummary(ProductModel p) {
    final stock = p.stock;
    if (stock == null) return '';
    return stock.sources
        .where((s) => s.balancePieces != 0)
        .map((s) => '${s.label} ${s.balanceDisplay}')
        .join('  ·  ');
  }

  // --- drawer -------------------------------------------------------------

  Widget _drawer(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListFiltersDrawer(
      searchController: _searchController,
      searchHint: l10n.commonSearchProducts,
      onSearchChanged: (_) => _reload(),
      onClear: _clearFilters,
      extra: [
        if (widget.sourceOptions.isNotEmpty)
          _SourcesTile(
            options: widget.sourceOptions,
            selected: _sources,
            onChanged: (next) {
              setState(() => _sources = next);
              _reload();
            },
          ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(l10n.commonProductInStockOnly),
          value: _inStock,
          onChanged: (v) {
            setState(() => _inStock = v);
            _reload();
          },
        ),
        if (widget.brands.isNotEmpty)
          DropdownButtonFormField<int?>(
            initialValue: _brandId,
            isExpanded: true,
            decoration: InputDecoration(labelText: l10n.commonProductBrand, isDense: true),
            items: [
              DropdownMenuItem<int?>(value: null, child: Text(l10n.commonProductAllBrands)),
              ...widget.brands.map((b) => DropdownMenuItem<int?>(value: b.id, child: Text(b.name))),
            ],
            onChanged: (v) {
              setState(() => _brandId = v);
              _reload();
            },
          ),
        if (widget.categories.isNotEmpty)
          DropdownButtonFormField<int?>(
            initialValue: _categoryId,
            isExpanded: true,
            decoration: InputDecoration(labelText: l10n.commonProductCategory, isDense: true),
            items: [
              DropdownMenuItem<int?>(value: null, child: Text(l10n.commonProductAllCategories)),
              ...widget.categories.map((c) => DropdownMenuItem<int?>(value: c.id, child: Text(c.name))),
            ],
            onChanged: (v) {
              setState(() => _categoryId = v);
              _reload();
            },
          ),
        DropdownButtonFormField<ProductSort>(
          initialValue: _sort,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.commonSort, isDense: true),
          items: ProductSort.values
              .map((s) => DropdownMenuItem(value: s, child: Text(s.label(l10n))))
              .toList(),
          onChanged: (v) {
            if (v == null) return;
            setState(() => _sort = v);
            _reload();
          },
        ),
      ],
    );
  }

  // --- list / grid --------------------------------------------------------

  Widget _gridCell(BuildContext context, ProductModel p) {
    final l10n = AppLocalizations.of(context);
    final search = _searchController.text.trim();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => widget.onTapProduct(p),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.imageBuilder(p.featureImageUrl, 120),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HighlightText(
                    p.name,
                    query: search,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.commonProductPrice('${p.price}'),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _stockBadge(context, p),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listRow(BuildContext context, ProductModel p) {
    final l10n = AppLocalizations.of(context);
    final search = _searchController.text.trim();
    final summary = _sourceSummary(p);
    return ListTile(
      leading: SizedBox(width: 48, height: 48, child: widget.imageBuilder(p.featureImageUrl, 48)),
      title: HighlightText(p.name, query: search),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.allowBreakPack
                ? l10n.commonProductPriceCtn('${p.price}', '${p.piecesPerCarton}')
                : l10n.commonProductPrice('${p.price}'),
          ),
          if (summary.isNotEmpty)
            Text(summary, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
      isThreeLine: summary.isNotEmpty,
      trailing: _stockBadge(context, p),
      onTap: () => widget.onTapProduct(p),
    );
  }

  Widget _body(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return ListView.builder(
        padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.fabClearance),
        itemCount: 6,
        itemBuilder: (_, __) => const SkeletonListTile(),
      );
    }
    if (_error != null) return ErrorView(message: _error!, onRetry: _reload);
    if (_items.isEmpty) {
      return RefreshIndicator(
        onRefresh: _reload,
        child: ListView(children: [
          const SizedBox(height: AppSpacing.xxl),
          EmptyView(message: l10n.commonNoProductsFound),
        ]),
      );
    }

    final search = _searchController.text.trim();
    final banner = <Widget>[
      if (_fuzzy && search.isNotEmpty) FuzzyMatchBanner(query: search),
      if (_cachedAt != null)
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            l10n.commonProductStockAsOf(TimeOfDay.fromDateTime(_cachedAt!).format(context)),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
    ];

    return RefreshIndicator(
      onRefresh: _reload,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          if (banner.isNotEmpty) SliverList(delegate: SliverChildListDelegate(banner)),
          if (_grid)
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: 0.72,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _gridCell(context, _items[i]),
                  childCount: _items.length,
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _listRow(context, _items[i]),
                childCount: _items.length,
              ),
            ),
          if (_loadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.fabClearance)),
        ],
      ),
    );
  }

  List<Widget> _actions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      IconButton(
        tooltip: _grid ? l10n.commonProductViewList : l10n.commonProductViewGrid,
        icon: Icon(_grid ? Icons.view_list_outlined : Icons.grid_view_outlined),
        onPressed: () => setState(() => _grid = !_grid),
      ),
      FiltersDrawerButton(active: _filtersActive),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title == null
          ? null
          : AppBar(title: Text(widget.title!), actions: _actions(context)),
      endDrawer: _drawer(context),
      floatingActionButton: widget.floatingActionButton,
      body: widget.title != null
          ? _body(context)
          : Column(
              children: [
                if (widget.header != null) widget.header!,
                // Host already owns the header, so the two controls sit in a
                // slim row instead of an AppBar.
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Row(mainAxisSize: MainAxisSize.min, children: _actions(context)),
                ),
                Expanded(child: _body(context)),
              ],
            ),
    );
  }
}

/// Expandable checklist of inventory sources — same shape as the salesperson
/// filter used by the order list and the shop map.
class _SourcesTile extends StatelessWidget {
  const _SourcesTile({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<ProductSourceOption> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final count = selected.length;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        initiallyExpanded: true,
        title: Text(
          count == 0 ? l10n.commonProductSources : '${l10n.commonProductSources} ($count)',
        ),
        children: [
          for (final option in options)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(option.label),
              value: selected.contains(option.key),
              onChanged: (checked) {
                final next = Set<String>.from(selected);
                if (checked == true) {
                  next.add(option.key);
                } else {
                  next.remove(option.key);
                }
                onChanged(next);
              },
            ),
        ],
      ),
    );
  }
}
