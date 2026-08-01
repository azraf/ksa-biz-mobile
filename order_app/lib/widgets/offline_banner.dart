import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../providers/connectivity_provider.dart';
import '../providers/repositories.dart';

class OfflineBanner extends ConsumerStatefulWidget {
  const OfflineBanner({super.key});

  @override
  ConsumerState<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends ConsumerState<OfflineBanner> {
  bool _showSuccess = false;

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(onlineStatusProvider);
    final serverReachable = ref.watch(serverReachableProvider).value ?? true;
    final pending = ref.watch(pendingSyncCountProvider);
    final failedMedia = ref.watch(failedMediaCountProvider);
    final progress = ref.watch(syncProgressProvider);
    final mediaProgress = ref.watch(mediaUploadProgressProvider);

    return pending.when(
      data: (count) => failedMedia.when(
        data: (failedCount) => OfflineStatusBanner(
          online: online,
          serverReachable: serverReachable,
          pendingCount: count,
          failedMediaCount: failedCount,
          syncProgress: progress.asData?.value,
          mediaUploadProgress: mediaProgress.asData?.value,
          showSuccess: _showSuccess,
          onSync: () => ref.read(syncServiceProvider).syncIfOnline(),
          onRetryUploads: () async {
            await ref.read(mediaUploadRepositoryProvider).retryFailed();
            await ref.read(syncServiceProvider).syncIfOnline();
          },
          isFullySynced: () async {
            final stores = ref.read(offlineStoresProvider);
            final queue = await stores.outbox.pendingCount();
            final media = await stores.media.pendingCount();
            return queue == 0 && media == 0;
          },
          onShowSuccess: () {
            if (mounted) setState(() => _showSuccess = true);
          },
          onHideSuccess: () {
            if (mounted) setState(() => _showSuccess = false);
          },
        ),
        loading: () => _offlineOnlyBanner(context, online),
        error: (_, __) => const SizedBox.shrink(),
      ),
      loading: () => _offlineOnlyBanner(context, online),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _offlineOnlyBanner(BuildContext context, bool online) {
    if (online) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const Icon(Icons.cloud_off, size: 18),
            const SizedBox(width: 8),
            Text(l10n.salesOfflineMode, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
