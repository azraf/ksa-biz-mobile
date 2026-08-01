import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import 'offline_write_exception.dart';

class AppErrorMapper {
  static String localize(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context);
    if (error is OfflineWriteException) {
      return l10n.adminOfflineWriteBlocked;
    }
    final message = error.toString().toLowerCase();
    if (message.contains('socket') ||
        message.contains('network') ||
        message.contains('connection') ||
        message.contains('offline')) {
      return l10n.salesErrorOffline;
    }
    if (message.contains('timeout')) {
      return l10n.salesErrorTimeout;
    }
    if (message.contains('401') || message.contains('unauthorized')) {
      return l10n.salesErrorUnauthorized;
    }
    return l10n.salesErrorGeneric;
  }
}
