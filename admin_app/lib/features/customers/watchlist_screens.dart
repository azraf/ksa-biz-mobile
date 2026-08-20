import 'package:core/core.dart' hide sharedPreferencesProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';
import 'package:media/media.dart';

import 'package:maps_ui/maps_ui.dart';

import '../../providers/repositories.dart';

class AdminWatchlistScreen extends ConsumerStatefulWidget {
  const AdminWatchlistScreen({super.key});

  @override
  ConsumerState<AdminWatchlistScreen> createState() => _AdminWatchlistScreenState();
}

class _AdminWatchlistScreenState extends ConsumerState<AdminWatchlistScreen> {
  static const _listKey = 'admin_watchlist';

  bool _loading = true;
  bool _isFuzzy = false;
  List<WatchlistItemModel> _items = [];
  String _status = 'active';
  ListSortMode _sortMode = ListSortMode.date;
  final _searchController = TextEditingController();

  String get _search => _searchController.text.trim();
  bool get _searching => _search.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _sortMode = ListSortPreference(ref.read(sharedPreferencesProvider))
        .read(_listKey, defaultMode: ListSortMode.date);
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      // A search shows both sections (Active, then Archived) unless the
      // status filter was set explicitly to archived.
      final result = await ref.read(watchlistRepositoryProvider).list(
            status: _searching && _status == 'active' ? 'all' : _status,
            sort: _sortMode.watchlistApiSortParam(),
            search: _searching ? _search : null,
            perPage: 100,
          );
      List<WatchlistItemModel> sorted(List<WatchlistItemModel> part) => sortByListMode(
            part,
            _sortMode,
            dateIso: (item) => item.createdAt,
            name: (item) => item.displayTitle,
            salesPerson: (item) => item.salesPerson?.name,
          );
      // Keep the server's active-first order while searching so sections stay
      // contiguous; sort inside each section only.
      final items = _searching
          ? [
              ...sorted(result.items.where((i) => i.isActive).toList()),
              ...sorted(result.items.where((i) => !i.isActive).toList()),
            ]
          : sorted(result.items);
      setState(() {
        _items = items;
        _isFuzzy = result.isFuzzy;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch-list (all)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.push('/customers/map'),
          ),
          FiltersDrawerButton(active: _searching || _status != 'active'),
        ],
      ),
      // Search / status / sort live in the drawer so the list gets the full
      // height; the shell's bottom nav is untouched.
      endDrawer: ListFiltersDrawer(
        searchController: _searchController,
        onSearchChanged: (_) => _load(),
        searchHint: l10n.searchWatchlistHint,
        statusOptions: [
          MapEntry('active', l10n.statusActive),
          MapEntry('archived', l10n.statusArchived),
        ],
        status: _status,
        onStatusChanged: (v) {
          setState(() => _status = v ?? 'active');
          _load();
        },
        sortModes: const [ListSortMode.date, ListSortMode.name, ListSortMode.salesPerson],
        sort: _sortMode,
        onSortChanged: (mode) async {
          _sortMode = mode;
          await ListSortPreference(ref.read(sharedPreferencesProvider)).write(_listKey, mode);
          await _load();
        },
        onClear: () {
          _searchController.clear();
          setState(() => _status = 'active');
          _load();
        },
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                children: sectionedChildren<WatchlistItemModel>(
                  _items,
                  banner: _searching && _isFuzzy ? FuzzyMatchBanner(query: _search) : null,
                  sectionOf: (item) =>
                      _searching ? (item.isActive ? l10n.statusActive : l10n.statusArchived) : null,
                  itemBuilder: (item) => ListTile(
                    title: HighlightText(item.displayTitle, query: _searching ? _search : null),
                    subtitle: HighlightText(
                      [
                        if (item.createdAt != null) formatAppDateTime(item.createdAt),
                        item.salesPerson?.name ?? 'SP #${item.salesPersonId}',
                        item.noteText ?? item.gps,
                      ].where((s) => s.isNotEmpty).join(' · '),
                      query: _searching ? _search : null,
                    ),
                    trailing: Text(item.status),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminWatchlistDetailScreen(item: item)),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class AdminWatchlistDetailScreen extends ConsumerStatefulWidget {
  const AdminWatchlistDetailScreen({super.key, required this.item});

  final WatchlistItemModel item;

  @override
  ConsumerState<AdminWatchlistDetailScreen> createState() => _AdminWatchlistDetailScreenState();
}

class _AdminWatchlistDetailScreenState extends ConsumerState<AdminWatchlistDetailScreen> {
  WatchlistItemModel? _item;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final item = await ref.read(watchlistRepositoryProvider).get(widget.item.id);
      setState(() {
        _item = item;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _item = widget.item;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final item = _item ?? widget.item;
    final allMedia = [...item.images, ...item.recordings];
    return Scaffold(
      appBar: AppBar(title: Text(item.displayTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Salesperson: ${item.salesPerson?.name ?? item.salesPersonId}'),
          GpsLocationRow(gps: item.gps),
          if (item.phone?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: SelectableText(item.phone!)),
                ContactActionButtons(phoneNumber: item.phone!, compact: true),
              ],
            ),
          ],
          if (item.createdAt != null) ...[
            const SizedBox(height: 8),
            Text(formatAppDateTime(item.createdAt), style: Theme.of(context).textTheme.bodySmall),
          ],
          Text('Status: ${item.status}${item.archivedReason != null ? ' (${item.archivedReason})' : ''}'),
          if (item.noteText != null) ...[const SizedBox(height: 12), Text(item.noteText!)],
          if (item.customerShopId != null)
            ListTile(
              title: const Text('Linked shop'),
              subtitle: Text('Shop #${item.customerShopId}'),
            ),
          if (allMedia.isNotEmpty) ...[
            const SizedBox(height: 12),
            MediaGallerySection(remoteItems: allMedia, title: 'Media'),
          ],
        ],
      ),
    );
  }
}
