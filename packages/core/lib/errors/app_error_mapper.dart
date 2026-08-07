import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../api/api_exception.dart';
import 'offline_write_exception.dart';

class AppErrorMapper {
  static String localize(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context);
    if (error is OfflineWriteException) {
      return l10n.adminOfflineWriteBlocked;
    }
    if (error is ApiException) {
      final code = error.statusCode;
      if (code == 401) return l10n.salesErrorUnauthorized;
      if (code == 408 || code == 504) return l10n.salesErrorTimeout;
      if (code == 413) return l10n.salesErrorPayloadTooLarge;
      if (code == 409) return l10n.salesErrorConflict;
      if (code == 422) {
        final validation = _validationMessage(error.errors);
        if (validation != null) return validation;
      }
      if (error.message.isNotEmpty) return error.message;
    }
    final message = error.toString().toLowerCase();
    if (message.contains('socket') ||
        message.contains('network') ||
        message.contains('connection') ||
        message.contains('offline') ||
        message.contains('host lookup')) {
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

  static String? _validationMessage(Map<String, dynamic>? errors) {
    if (errors == null || errors.isEmpty) return null;
    final parts = <String>[];
    for (final entry in errors.entries) {
      final v = entry.value;
      if (v is List && v.isNotEmpty) {
        parts.add('${entry.key}: ${v.first}');
      } else if (v != null) {
        parts.add('${entry.key}: $v');
      }
    }
    return parts.isEmpty ? null : parts.join('\n');
  }
}

void showAppErrorSnackBar(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppErrorMapper.localize(context, error))),
  );
}
