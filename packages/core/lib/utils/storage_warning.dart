import 'dart:io';

import 'package:disk_capacity/disk_capacity.dart';
import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

/// Minimum free bytes before warning user before capture/upload.
const int kLowStorageThresholdBytes = 50 * 1024 * 1024;

Future<bool> ensureStorageForCapture(BuildContext context) async {
  try {
    final free = await _estimateFreeBytes();
    if (free != null && free < kLowStorageThresholdBytes) {
      final l10n = AppLocalizations.of(context);
      if (!context.mounted) return false;
      final continueAnyway = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(l10n.salesStorageLowWarning),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.salesStorageLowContinue),
            ),
          ],
        ),
      );
      return continueAnyway == true;
    }
    return true;
  } catch (_) {
    return true;
  }
}

Future<int?> _estimateFreeBytes() async {
  if (!Platform.isAndroid && !Platform.isIOS) return null;
  try {
    final diskCapacity = DiskCapacity();
    final mb = await diskCapacity.getFreeDiskSpace();
    return (mb * 1024 * 1024).round();
  } catch (_) {
    return null;
  }
}
