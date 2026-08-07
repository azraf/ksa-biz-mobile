import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../offline/sync_queue_item.dart';

String localizedSyncItemTitle(BuildContext context, SyncQueueItem item) {
  final l10n = AppLocalizations.of(context);
  switch (item.entityType) {
    case 'order':
      return item.operation == 'create'
          ? l10n.salesSyncItemOrderCreate
          : l10n.salesSyncItemOrderUpdate;
    case 'expense':
      return l10n.salesSyncItemExpense;
    case 'watchlist':
      return l10n.salesSyncItemWatchlist;
    case 'diary':
      return l10n.salesSyncItemDiary;
    default:
      return '${item.entityType} · ${item.operation}';
  }
}

bool isSyncItemExhausted(SyncQueueItem item) =>
    item.retryCount >= 5 && item.status == 'failed';
