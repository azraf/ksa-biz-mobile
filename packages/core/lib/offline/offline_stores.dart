import 'isar_service.dart';
import 'stores/admin_list_cache_store.dart';
import 'stores/catalog_local_store.dart';
import 'stores/customer_local_store.dart';
import 'stores/diary_local_store.dart';
import 'stores/expense_local_store.dart';
import 'stores/media_outbox_store.dart';
import 'stores/order_local_store.dart';
import 'stores/report_cache_store.dart';
import 'stores/sync_outbox_store.dart';
import 'stores/watchlist_local_store.dart';

/// Bundles all typed Isar local stores for dependency injection.
class OfflineStores {
  OfflineStores(IsarService isar)
      : orders = OrderLocalStore(isar),
        catalog = CatalogLocalStore(isar),
        customers = CustomerLocalStore(isar),
        watchlist = WatchlistLocalStore(isar),
        diary = DiaryLocalStore(isar),
        outbox = SyncOutboxStore(isar),
        media = MediaOutboxStore(isar),
        reports = ReportCacheStore(isar),
        expenses = ExpenseLocalStore(isar),
        adminListCache = AdminListCacheStore(isar),
        isar = isar;

  final IsarService isar;
  final OrderLocalStore orders;
  final CatalogLocalStore catalog;
  final CustomerLocalStore customers;
  final WatchlistLocalStore watchlist;
  final DiaryLocalStore diary;
  final SyncOutboxStore outbox;
  final MediaOutboxStore media;
  final ReportCacheStore reports;
  final ExpenseLocalStore expenses;
  final AdminListCacheStore adminListCache;
}
