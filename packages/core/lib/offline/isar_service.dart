import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'isar/enums.dart';
import 'isar/local_admin_list_cache.dart';
import 'isar/local_app_config.dart';
import 'stores/sync_outbox_store.dart';
import 'isar/local_customer.dart';
import 'isar/local_diary.dart';
import 'isar/local_expense.dart';
import 'isar/local_media_blob.dart';
import 'isar/local_order.dart';
import 'isar/local_product.dart';
import 'isar/local_report_cache.dart';
import 'isar/local_watchlist.dart';
import 'isar/sync_outbox_entry.dart';

class IsarService {
  IsarService._();

  static final IsarService instance = IsarService._();

  Isar? _isar;

  Isar get isar {
    final db = _isar;
    if (db == null || !db.isOpen) {
      throw StateError('Isar not opened. Call open() first.');
    }
    return db;
  }

  bool get isOpen => _isar?.isOpen ?? false;

  Future<void> open() async {
    if (_isar?.isOpen ?? false) return;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        LocalOrderSchema,
        LocalProductSchema,
        LocalCustomerTypeSchema,
        LocalCustomerShopSchema,
        LocalCustomerVanSchema,
        LocalCustomerImporterSchema,
        LocalWatchlistItemSchema,
        LocalDiaryNoteSchema,
        SyncOutboxEntrySchema,
        LocalMediaBlobSchema,
        LocalReportCacheSchema,
        LocalAppConfigSchema,
        LocalExpenseSchema,
        LocalAdminListCacheSchema,
      ],
      directory: dir.path,
      name: 'ksa_biz_offline',
    );
    await _runDataUpgradeMigrations();
    await _resetStuckStatuses();
  }

  static const _syncHardeningFlag = 'sync_hardening_v1';

  Future<void> _runDataUpgradeMigrations() async {
    final softenRetries = !await _hasConfigFlag(_syncHardeningFlag);
    await SyncOutboxStore(this).migrateLegacyEntries(softenCappedRetries: softenRetries);
    if (softenRetries) {
      await _setConfigFlag(_syncHardeningFlag);
    }
  }

  Future<bool> _hasConfigFlag(String key) async {
    final row = await isar.localAppConfigs.filter().keyEqualTo(key).findFirst();
    return row != null;
  }

  Future<void> _setConfigFlag(String key) async {
    await writeTxn(() async {
      var row = await isar.localAppConfigs.filter().keyEqualTo(key).findFirst();
      row ??= LocalAppConfig()..key = key;
      row.valueJson = 'true';
      await isar.localAppConfigs.put(row);
    });
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }

  Future<T> writeTxn<T>(Future<T> Function() action) async {
    return isar.writeTxn(action);
  }

  Future<void> _resetStuckStatuses() async {
    await isar.writeTxn(() async {
      final stuckSync = await isar.syncOutboxEntrys
          .filter()
          .statusEqualTo(SyncStatus.syncing)
          .findAll();
      for (final entry in stuckSync) {
        entry.status = SyncStatus.pending;
        await isar.syncOutboxEntrys.put(entry);
      }
      final stuckMedia = await isar.localMediaBlobs
          .filter()
          .statusEqualTo(MediaUploadStatus.uploading)
          .findAll();
      for (final blob in stuckMedia) {
        blob.status = MediaUploadStatus.pending;
        await isar.localMediaBlobs.put(blob);
      }
    });
  }
}
