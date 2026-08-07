import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../offline/sync_service.dart';
import '../theme/app_colors.dart';
import '../utils/haptics.dart';

class OfflineStatusBanner extends StatelessWidget {
  const OfflineStatusBanner({
    super.key,
    required this.online,
    required this.serverReachable,
    required this.pendingCount,
    required this.failedMediaCount,
    required this.syncProgress,
    required this.mediaUploadProgress,
    required this.showSuccess,
    required this.onSync,
    required this.onRetryUploads,
    required this.isFullySynced,
    required this.onShowSuccess,
    required this.onHideSuccess,
    this.onOpenSyncIssues,
  });

  final bool online;
  final bool serverReachable;
  final int pendingCount;
  final int failedMediaCount;
  final SyncProgress? syncProgress;
  final double? mediaUploadProgress;
  final bool showSuccess;
  final Future<void> Function() onSync;
  final Future<void> Function() onRetryUploads;
  final Future<bool> Function() isFullySynced;
  final VoidCallback onShowSuccess;
  final VoidCallback onHideSuccess;
  final VoidCallback? onOpenSyncIssues;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    if (showSuccess) {
      return Material(
        color: AppColors.successContainer(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline, size: 18, color: AppColors.success(context)),
              const SizedBox(width: 8),
              Expanded(child: Text(l10n.salesOfflineAllSynced, style: const TextStyle(fontSize: 13))),
            ],
          ),
        ),
      );
    }

    if (online && serverReachable && pendingCount == 0 && failedMediaCount == 0) {
      return const SizedBox.shrink();
    }

    final syncing = syncProgress != null &&
        syncProgress!.total > 0 &&
        syncProgress!.completed < syncProgress!.total;
    final uploadPercent = mediaUploadProgress != null ? (mediaUploadProgress! * 100).round() : null;

    final statusText = !online
        ? l10n.salesOfflineSaved(pendingCount)
        : !serverReachable
            ? l10n.salesOfflineServerUnreachable
            : failedMediaCount > 0 && !syncing && uploadPercent == null
                ? l10n.salesOfflineUploadFailed(failedMediaCount)
                : syncing
                    ? l10n.salesOfflineSyncProgress(syncProgress!.completed, syncProgress!.total)
                    : uploadPercent != null
                        ? l10n.salesOfflineUploading(uploadPercent)
                        : l10n.salesOfflineSyncing(pendingCount);

    return Material(
      color: online && serverReachable ? scheme.tertiaryContainer : scheme.errorContainer,
      child: InkWell(
        onTap: (pendingCount > 0 || failedMediaCount > 0) ? onOpenSyncIssues : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(online ? Icons.sync : Icons.cloud_off, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(statusText, style: const TextStyle(fontSize: 13))),
                  if (onOpenSyncIssues != null && (pendingCount > 0 || failedMediaCount > 0))
                    Icon(Icons.chevron_right, size: 18, color: scheme.onSurfaceVariant),
                  if (online && serverReachable && failedMediaCount > 0)
                    TextButton(
                      onPressed: () => _runAndCelebrate(onRetryUploads),
                      child: Text(l10n.salesOfflineRetryUploads),
                    ),
                  if (online && serverReachable)
                    TextButton(
                      onPressed: () => _runAndCelebrate(onSync),
                      child: Text(l10n.salesOfflineSync),
                    ),
                ],
              ),
              if (syncing && syncProgress != null) ...[
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: syncProgress!.total > 0 ? syncProgress!.completed / syncProgress!.total : null,
                ),
              ],
              if (uploadPercent != null) ...[
                const SizedBox(height: 6),
                LinearProgressIndicator(value: mediaUploadProgress),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _runAndCelebrate(Future<void> Function() action) async {
    await action();
    if (await isFullySynced()) {
      AppHaptics.light();
      onShowSuccess();
      Future.delayed(const Duration(seconds: 2), onHideSuccess);
    }
  }
}
