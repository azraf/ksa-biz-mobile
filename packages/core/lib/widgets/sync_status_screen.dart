import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lists failed or dead sync outbox items with retry and dismiss actions.
class SyncStatusScreen extends ConsumerStatefulWidget {
  const SyncStatusScreen({
    super.key,
    required this.syncService,
    required this.loadItems,
  });

  final SyncService syncService;
  final Future<List<SyncQueueItem>> Function() loadItems;

  @override
  ConsumerState<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends ConsumerState<SyncStatusScreen> {
  late Future<List<SyncQueueItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = widget.loadItems();
  }

  Future<void> _reload() async {
    setState(() => _itemsFuture = widget.loadItems());
    await _itemsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync issues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<List<SyncQueueItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No sync issues'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text('${item.entityType} · ${item.operation}'),
                subtitle: Text(
                  [
                    if (item.errorMessage?.isNotEmpty == true) item.errorMessage!,
                    'Retries: ${item.retryCount}',
                    if (item.status == 'dead') 'Needs attention',
                  ].join('\n'),
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.status == 'dead')
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Dismiss',
                        onPressed: () async {
                          await widget.syncService.dismissDeadItem(item.id);
                          await _reload();
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.replay),
                      tooltip: 'Retry',
                      onPressed: () async {
                        await widget.syncService.retryItem(item.id);
                        await _reload();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await widget.syncService.retryFailedItems();
          await _reload();
        },
        icon: const Icon(Icons.sync),
        label: const Text('Retry all'),
      ),
    );
  }
}
