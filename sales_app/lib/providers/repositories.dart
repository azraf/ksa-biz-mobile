import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media/media.dart';

export 'package:core/core.dart' show sharedPreferencesProvider;

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  service.init();
  ref.onDispose(service.dispose);
  return service;
});

final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).isOnline;
});

final localDatabaseProvider = Provider<LocalDatabase>((ref) => LocalDatabase.instance);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(sharedPreferencesProvider),
  );
});

final manualOrderRepositoryProvider = Provider<ManualOrderRepository>((ref) {
  return ManualOrderRepository(ref.watch(apiClientProvider));
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.watch(apiClientProvider));
});

final offlineOrderRepositoryProvider = Provider<OfflineOrderRepository>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return OfflineOrderRepository(
    remote: ref.watch(orderRepositoryProvider),
    db: ref.watch(localDatabaseProvider),
    isOnline: () => connectivity.isOnline,
  );
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository(ref.watch(apiClientProvider));
});

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(ref.watch(apiClientProvider));
});

final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  return PurchaseRepository(ref.watch(apiClientProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(apiClientProvider));
});

final offlineProductRepositoryProvider = Provider<OfflineProductRepository>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return OfflineProductRepository(
    remote: ref.watch(productRepositoryProvider),
    db: ref.watch(localDatabaseProvider),
    isOnline: () => connectivity.isOnline,
  );
});

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(ref.watch(apiClientProvider));
});

final offlineCustomerRepositoryProvider = Provider<OfflineCustomerRepository>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return OfflineCustomerRepository(
    remote: ref.watch(customerRepositoryProvider),
    db: ref.watch(localDatabaseProvider),
    isOnline: () => connectivity.isOnline,
  );
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(ref.watch(apiClientProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(apiClientProvider));
});

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepository(ref.watch(apiClientProvider));
});

final customerDiaryRepositoryProvider = Provider<CustomerDiaryRepository>((ref) {
  return CustomerDiaryRepository(ref.watch(apiClientProvider));
});

final offlineWatchlistRepositoryProvider = Provider<OfflineWatchlistRepository>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return OfflineWatchlistRepository(
    remote: ref.watch(watchlistRepositoryProvider),
    db: ref.watch(localDatabaseProvider),
    isOnline: () => connectivity.isOnline,
  );
});

final offlineDiaryRepositoryProvider = Provider<OfflineDiaryRepository>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return OfflineDiaryRepository(
    remote: ref.watch(customerDiaryRepositoryProvider),
    db: ref.watch(localDatabaseProvider),
    isOnline: () => connectivity.isOnline,
  );
});

final mediaUploadRepositoryProvider = Provider<MediaUploadRepository>((ref) {
  final repo = MediaUploadRepository(
    apiClient: ref.watch(apiClientProvider),
    db: ref.watch(localDatabaseProvider),
    getAuthToken: () async => ref.read(sharedPreferencesProvider).getString(AppConfig.authTokenKey),
  );
  ref.onDispose(repo.dispose);
  return repo;
});

final mediaCaptureFacadeProvider = Provider<MediaCaptureFacade>((ref) {
  return MediaCaptureFacade(uploadRepository: ref.watch(mediaUploadRepositoryProvider));
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    db: ref.watch(localDatabaseProvider),
    connectivity: ref.watch(connectivityServiceProvider),
    orderRepository: ref.watch(orderRepositoryProvider),
    expenseRepository: ref.watch(expenseRepositoryProvider),
    watchlistRepository: ref.watch(watchlistRepositoryProvider),
    diaryRepository: ref.watch(customerDiaryRepositoryProvider),
    mediaUploadRepository: ref.watch(mediaUploadRepositoryProvider),
  );
});

final referenceDataPrefetcherProvider = Provider<ReferenceDataPrefetcher>((ref) {
  return ReferenceDataPrefetcher(
    customerRepo: ref.watch(offlineCustomerRepositoryProvider),
    productRepo: ref.watch(offlineProductRepositoryProvider),
  );
});

final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(localDatabaseProvider);
  final queue = await db.pendingCount();
  final media = await db.pendingMediaCount();
  return queue + media;
});
