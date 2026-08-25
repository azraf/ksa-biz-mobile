import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../offline/sync_service.dart';

/// Returns true if logout may proceed.
///
/// If there is unsynced data, this attempts one last flush while online,
/// then — if anything is still pending — asks the user to confirm, since a
/// different user logging in on this device wipes it (see
/// AuthRepository._ensureOfflineDataOwner). Returns false if the user
/// cancels or the widget is unmounted before they can answer.
Future<bool> confirmLogoutWithPendingData(
  BuildContext context,
  SyncService syncService,
) async {
  if (await syncService.isFullySynced()) return true;

  try {
    await syncService.syncIfOnline();
  } catch (_) {
    // A transport error mid-flush must not skip the pending-data check
    // below — an exception here would abort the guard and let logout
    // proceed as if everything were synced.
  }
  if (await syncService.isFullySynced()) return true;

  final pending = await syncService.db.pendingCount() + await syncService.db.pendingMediaCount();
  if (!context.mounted) return false;

  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.commonSignOut),
      content: Text(l10n.logoutUnsyncedWarning(pending)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.logoutAnyway),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}
