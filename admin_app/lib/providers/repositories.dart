import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media/media.dart';

import 'auth_provider.dart';
import 'connectivity_provider.dart';

export 'package:core/core.dart' show sharedPreferencesProvider;

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  client.onUnauthorized = () {
    ref.read(authProvider.notifier).handleUnauthorized();
  };
  return client;
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  service.init();
  ref.onDispose(service.dispose);
  return service;
});

final apiReachabilityServiceProvider = Provider<ApiReachabilityService>((ref) {
  final service = ApiReachabilityService();
  ref.onDispose(service.dispose);
  return service;
});

final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).isOnline;
});

final serverReachableProvider = FutureProvider<bool>((ref) async {
  if (!ref.watch(onlineStatusProvider)) return false;
  return ref.watch(apiReachabilityServiceProvider).check();
});

final localDatabaseProvider = Provider<LocalDatabase>((ref) => LocalDatabase.instance);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return createAuthRepository(
    api: ref.watch(apiClientProvider),
    prefs: ref.watch(sharedPreferencesProvider),
    ref: ref,
  );
});

final adminRepositoriesProvider = Provider<AdminRepositories>((ref) {
  return AdminRepositories(ref.watch(apiClientProvider));
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

final offlineExpenseRepositoryProvider = Provider<OfflineExpenseRepository>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return OfflineExpenseRepository(
    remote: ref.watch(expenseRepositoryProvider),
    db: ref.watch(localDatabaseProvider),
    isOnline: () => connectivity.isOnline,
  );
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(ref.watch(apiClientProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(apiClientProvider));
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

final offlineProductRepositoryProvider = Provider<OfflineProductRepository>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return OfflineProductRepository(
    remote: ref.watch(productRepositoryProvider),
    db: ref.watch(localDatabaseProvider),
    isOnline: () => connectivity.isOnline,
  );
});

final referenceDataPrefetcherProvider = Provider<ReferenceDataPrefetcher>((ref) {
  return ReferenceDataPrefetcher(
    customerRepo: ref.watch(offlineCustomerRepositoryProvider),
    productRepo: ref.watch(offlineProductRepositoryProvider),
  );
});


final manualOrderRepositoryProvider = Provider<ManualOrderRepository>((ref) {
  return ManualOrderRepository(ref.watch(apiClientProvider));
});

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(ref.watch(apiClientProvider));
});

final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  return PurchaseRepository(ref.watch(apiClientProvider));
});

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepository(ref.watch(apiClientProvider));
});

final customerDiaryRepositoryProvider = Provider<CustomerDiaryRepository>((ref) {
  return CustomerDiaryRepository(ref.watch(apiClientProvider));
});

final mediaUploadRepositoryProvider = Provider<MediaUploadRepository>((ref) {
  final repo = MediaUploadRepository(
    apiClient: ref.watch(apiClientProvider),
    db: ref.watch(localDatabaseProvider),
    getAuthToken: () => ref.read(authRepositoryProvider).getAuthToken(),
  );
  ref.onDispose(repo.dispose);
  return repo;
});

final mediaCaptureFacadeProvider = Provider<MediaCaptureFacade>((ref) {
  return MediaCaptureFacade(uploadRepository: ref.watch(mediaUploadRepositoryProvider));
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepository(ref.watch(apiClientProvider));
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final service = SyncService(
    db: ref.watch(localDatabaseProvider),
    connectivity: ref.watch(connectivityServiceProvider),
    orderRepository: ref.watch(orderRepositoryProvider),
    expenseRepository: ref.watch(expenseRepositoryProvider),
    syncRepository: ref.watch(syncRepositoryProvider),
    watchlistRepository: ref.watch(watchlistRepositoryProvider),
    diaryRepository: ref.watch(customerDiaryRepositoryProvider),
    mediaUploadRepository: ref.watch(mediaUploadRepositoryProvider),
    apiReachability: ref.watch(apiReachabilityServiceProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

final syncProgressProvider = StreamProvider<SyncProgress>((ref) {
  return ref.watch(syncServiceProvider).progressStream;
});

final mediaUploadProgressProvider = StreamProvider<double?>((ref) {
  final repo = ref.watch(mediaUploadRepositoryProvider);
  return repo.statusStream.map((e) => e.progress);
});

final lastSyncAtProvider = FutureProvider<DateTime?>((ref) async {
  ref.watch(syncServiceProvider);
  return ref.watch(localDatabaseProvider).getLastSyncAt();
});

final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(localDatabaseProvider);
  final queue = await db.pendingCount();
  final media = await db.pendingMediaCount();
  return queue + media;
});

final failedMediaCountProvider = FutureProvider<int>((ref) async {
  return ref.watch(localDatabaseProvider).failedMediaCount();
});
