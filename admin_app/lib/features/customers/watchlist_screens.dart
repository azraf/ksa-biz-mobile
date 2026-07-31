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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final result = await ref.read(watchlistRepositoryProvider).list(status: _status);
      setState(() {
        _items = result.items;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch-list (all)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.push('/customers/map'),
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (_, i) {
                  final item = _items[i];
                  return ListTile(
                    title: Text(item.displayTitle),
                    subtitle: Text(
                      '${item.salesPerson?.name ?? 'SP #${item.salesPersonId}'} · ${item.noteText ?? item.gps}',
                    ),
                    trailing: Text(item.status),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminWatchlistDetailScreen(item: item)),
                    ),
                  );
                },
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
