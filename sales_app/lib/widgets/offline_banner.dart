import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/connectivity_provider.dart';
import '../providers/repositories.dart';

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(onlineStatusProvider);
    final pending = ref.watch(pendingSyncCountProvider);

    return pending.when(
      data: (count) {
        if (online && count == 0) return const SizedBox.shrink();
        return Material(
          color: online ? Colors.orange.shade100 : Colors.red.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(online ? Icons.sync : Icons.cloud_off, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    online
                        ? 'Syncing $count pending change${count == 1 ? '' : 's'}...'
                        : 'Offline — $count change${count == 1 ? '' : 's'} saved locally',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                if (online)
                  TextButton(
                    onPressed: () {
                      ref.read(syncServiceProvider).syncIfOnline();
                      ref.invalidate(pendingSyncCountProvider);
                    },
                    child: const Text('SYNC'),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => online
          ? const SizedBox.shrink()
          : Material(
              color: Colors.red.shade100,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(Icons.cloud_off, size: 18),
                    SizedBox(width: 8),
                    Text('Offline mode', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
