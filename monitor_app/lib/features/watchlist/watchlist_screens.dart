import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:maps_ui/maps_ui.dart';
import 'package:media/media.dart';

import '../../providers/repositories.dart';

class MonitorWatchlistScreen extends ConsumerStatefulWidget {
  const MonitorWatchlistScreen({super.key});

  @override
  ConsumerState<MonitorWatchlistScreen> createState() => _MonitorWatchlistScreenState();
}

class _MonitorWatchlistScreenState extends ConsumerState<MonitorWatchlistScreen> {
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
      final result = await ref.read(watchlistRepositoryProvider).list(status: _status);
      setState(() {
        _items = result.items;
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
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: PopupMenuButton<String>(
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
                      child: _items.isEmpty
                          ? ListView(
                              children: const [
                                SizedBox(height: 120),
                                Center(child: Text('No watch-list items.')),
                              ],
                            )
                          : ListView.builder(
                              itemCount: _items.length,
                              itemBuilder: (_, i) {
                                final item = _items[i];
                                final mediaCount = item.images.length + item.recordings.length;
                                return ListTile(
                                  leading: const Icon(Icons.place_outlined),
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
                                  onTap: () => context.push('/watchlist/${item.id}'),
                                );
                              },
                            ),
                    ),
        ),
      ],
    );
  }
}

class MonitorWatchlistDetailScreen extends ConsumerStatefulWidget {
  const MonitorWatchlistDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<MonitorWatchlistDetailScreen> createState() =>
      _MonitorWatchlistDetailScreenState();
}

class _MonitorWatchlistDetailScreenState extends ConsumerState<MonitorWatchlistDetailScreen> {
  WatchlistItemModel? _item;
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
      final item = await ref.read(watchlistRepositoryProvider).get(widget.id);
      setState(() {
        _item = item;
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
    if (_loading) {
      return const LoadingView();
    }
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
        if (item.noteText != null) ...[
          const SizedBox(height: 12),
          Text(item.noteText!),
        ],
        if (item.customerShopId != null)
          ListTile(
            title: const Text('Linked shop'),
            subtitle: Text('Shop #${item.customerShopId}'),
          ),
        const SizedBox(height: 12),
        MediaGallerySection(remoteItems: allMedia, title: 'Media'),
        if (allMedia.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('No media attached.', style: TextStyle(color: Colors.grey)),
          ),
      ],
    );
  }
}
