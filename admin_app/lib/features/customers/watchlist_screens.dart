import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media/media.dart';

import 'package:maps_ui/maps_ui.dart';

import '../../providers/repositories.dart';

class AdminWatchlistScreen extends ConsumerStatefulWidget {
  const AdminWatchlistScreen({super.key});

  @override
  ConsumerState<AdminWatchlistScreen> createState() => _AdminWatchlistScreenState();
}

class _AdminWatchlistScreenState extends ConsumerState<AdminWatchlistScreen> {
  bool _loading = true;
  List<WatchlistItemModel> _items = [];
  String _status = 'active';
  Object? _error;

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
      if (ref.read(isOnlineProvider)) {
        final result = await ref.read(watchlistRepositoryProvider).list(status: _status);
        setState(() {
          _items = result.items;
          _loading = false;
        });
      } else {
        setState(() {
          _items = [];
          _loading = false;
          _error = Exception('offline');
        });
      }
    } catch (e) {
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.map_outlined),
                tooltip: 'Shop map',
                onPressed: () => context.go('/customers/map'),
              ),
              PopupMenuButton<String>(
                initialValue: _status,
                onSelected: (v) {
                  setState(() => _status = v);
                  _load();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'active', child: Text('Active')),
                  PopupMenuItem(value: 'archived', child: Text('Archived')),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const LoadingView()
              : _error != null
                  ? ErrorView(
                      message: AppErrorMapper.localize(context, _error!),
                      error: _error,
                      onRetry: _load,
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (_, i) {
                          final item = _items[i];
                          final mediaCount = item.images.length + item.recordings.length;
                          return ListTile(
                            title: Text(item.displayTitle),
                            subtitle: Text(
                              '${item.salesPerson?.name ?? 'SP #${item.salesPersonId}'} · ${item.noteText ?? item.gps}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (mediaCount > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Chip(
                                      visualDensity: VisualDensity.compact,
                                      label: Text('$mediaCount'),
                                      avatar: const Icon(Icons.perm_media, size: 16),
                                    ),
                                  ),
                                Text(item.status),
                              ],
                            ),
                            onTap: () => context.push('/customers/watchlist/${item.id}'),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}

class AdminWatchlistDetailScreen extends ConsumerStatefulWidget {
  const AdminWatchlistDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<AdminWatchlistDetailScreen> createState() => _AdminWatchlistDetailScreenState();
}

class _AdminWatchlistDetailScreenState extends ConsumerState<AdminWatchlistDetailScreen> {
  WatchlistItemModel? _item;
  List<LocalMediaAttachment> _pendingMedia = const [];
  bool _loading = true;
  Object? _error;

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
      final item = await ref.read(offlineWatchlistRepositoryProvider).get(widget.id) ??
          await ref.read(watchlistRepositoryProvider).get(widget.id);
      final pending = await loadWatchlistPendingMedia(
        ref.read(offlineStoresProvider).media,
        item,
      );
      setState(() {
        _item = item;
        _pendingMedia = pending;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();
    if (_error != null || _item == null) {
      return ErrorView(
        message: AppErrorMapper.localize(context, _error ?? Exception('Not found')),
        error: _error,
        onRetry: _load,
      );
    }

    final item = _item!;
    final allMedia = [...item.images, ...item.recordings];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ),
        Text('Salesperson: ${item.salesPerson?.name ?? item.salesPersonId}'),
        GpsLocationRow(gps: item.gps),
        Text('Status: ${item.status}${item.archivedReason != null ? ' (${item.archivedReason})' : ''}'),
        if (item.noteText != null) ...[const SizedBox(height: 12), Text(item.noteText!)],
        if (item.customerShopId != null)
          ListTile(
            title: const Text('Linked shop'),
            subtitle: Text('Shop #${item.customerShopId}'),
          ),
        const SizedBox(height: 12),
        MediaGallerySection(
          remoteItems: allMedia,
          localItems: _pendingMedia,
          title: 'Media',
        ),
        if (allMedia.isEmpty && _pendingMedia.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('No media attached.', style: TextStyle(color: Colors.grey)),
          ),
      ],
    );
  }
}
