import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../offline/sync_queue_item.dart';
import '../offline/sync_service.dart';
import '../support/sync_item_labels.dart';

class SyncStatusScreen extends StatefulWidget {
  const SyncStatusScreen({
    super.key,
    required this.syncService,
    required this.loadItems,
  });

  final SyncService syncService;
  final Future<List<SyncQueueItem>> Function() loadItems;

  @override
  State<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends State<SyncStatusScreen> {
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.salesSyncIssuesTitle),
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
            return Center(child: Text(l10n.salesSyncIssuesEmpty));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = items[index];
              final exhausted = isSyncItemExhausted(item);
              return ListTile(
                title: Text(localizedSyncItemTitle(context, item)),
                subtitle: Text(
                  [
                    if (exhausted) l10n.salesSyncExhausted,
                    if (item.errorMessage?.isNotEmpty == true) item.errorMessage!,
                    l10n.salesSyncRetries(item.retryCount),
                  ].join('\n'),
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: l10n.salesSyncDismiss,
                      onPressed: () async {
                        await widget.syncService.dismissDeadItem(item.id);
                        await _reload();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay),
                      tooltip: l10n.salesSyncRetry,
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
        label: Text(l10n.salesSyncRetryAll),
      ),
    );
  }
}
