import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media/media.dart';

import 'auth_provider.dart';

export 'package:core/core.dart' show sharedPreferencesProvider;

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  client.onUnauthorized = () {
    ref.read(authProvider.notifier).handleUnauthorized();
  };
  return client;
});

final apiReachabilityProvider = Provider<ApiReachabilityService>((ref) {
  final service = ApiReachabilityService();
  ref.onDispose(service.dispose);
  return service;
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  service.init();
  ref.onDispose(service.dispose);
  return service;
});

final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).isOnline;
});

final isarServiceProvider = Provider<IsarService>((ref) => IsarService.instance);

final offlineStoresProvider = Provider<OfflineStores>((ref) {
  return OfflineStores(ref.watch(isarServiceProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return createAuthRepository(
    api: ref.watch(apiClientProvider),
    prefs: ref.watch(sharedPreferencesProvider),
    ref: ref,
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
  final stores = ref.watch(offlineStoresProvider);
  return OfflineOrderRepository(
    remote: ref.watch(orderRepositoryProvider),
    orders: stores.orders,
    outbox: stores.outbox,
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
  final stores = ref.watch(offlineStoresProvider);
  return OfflineProductRepository(
    remote: ref.watch(productRepositoryProvider),
    catalog: stores.catalog,
    isOnline: () => connectivity.isOnline,
  );
});

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(ref.watch(apiClientProvider));
});

final offlineCustomerRepositoryProvider = Provider<OfflineCustomerRepository>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  final stores = ref.watch(offlineStoresProvider);
  return OfflineCustomerRepository(
    remote: ref.watch(customerRepositoryProvider),
    customers: stores.customers,
    isOnline: () => connectivity.isOnline,
  );
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(
    ref.watch(apiClientProvider),
    reports: ref.watch(offlineStoresProvider).reports,
  );
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
  final stores = ref.watch(offlineStoresProvider);
  return OfflineWatchlistRepository(
    remote: ref.watch(watchlistRepositoryProvider),
    watchlist: stores.watchlist,
    outbox: stores.outbox,
    isOnline: () => connectivity.isOnline,
  );
});

final offlineDiaryRepositoryProvider = Provider<OfflineDiaryRepository>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  final stores = ref.watch(offlineStoresProvider);
  return OfflineDiaryRepository(
    remote: ref.watch(customerDiaryRepositoryProvider),
    diary: stores.diary,
    outbox: stores.outbox,
    isOnline: () => connectivity.isOnline,
  );
});

final mediaUploadRepositoryProvider = Provider<MediaUploadRepository>((ref) {
  final repo = MediaUploadRepository(
    apiClient: ref.watch(apiClientProvider),
    media: ref.watch(offlineStoresProvider).media,
    getAuthToken: () => ref.read(authRepositoryProvider).getAuthToken(),
  );
  ref.onDispose(repo.dispose);
  return repo;
});

final mediaCaptureFacadeProvider = Provider<MediaCaptureFacade>((ref) {
  return MediaCaptureFacade(uploadRepository: ref.watch(mediaUploadRepositoryProvider));
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    stores: ref.watch(offlineStoresProvider),
    connectivity: ref.watch(connectivityServiceProvider),
    orderRepository: ref.watch(orderRepositoryProvider),
    expenseRepository: ref.watch(expenseRepositoryProvider),
    watchlistRepository: ref.watch(watchlistRepositoryProvider),
    diaryRepository: ref.watch(customerDiaryRepositoryProvider),
    mediaUploadRepository: ref.watch(mediaUploadRepositoryProvider),
    apiReachability: ref.watch(apiReachabilityProvider),
    apiBaseUrl: ref.watch(apiClientProvider).baseUrl,
  );
});

final referenceDataPrefetcherProvider = Provider<ReferenceDataPrefetcher>((ref) {
  return ReferenceDataPrefetcher(
    customerRepo: ref.watch(offlineCustomerRepositoryProvider),
    productRepo: ref.watch(offlineProductRepositoryProvider),
  );
});

final syncProgressProvider = StreamProvider<SyncProgress>((ref) {
  return ref.watch(syncServiceProvider).progressStream;
});

final pendingSyncCountProvider = StreamProvider<int>((ref) async* {
  final stores = ref.watch(offlineStoresProvider);
  await for (final queueCount in stores.outbox.watchPendingCount()) {
    final mediaCount = await stores.media.pendingCount();
    yield queueCount + mediaCount;
  }
});

final failedMediaCountProvider = StreamProvider<int>((ref) {
  return ref.watch(offlineStoresProvider).media.watchFailedCount();
});

final mediaUploadProgressProvider = StreamProvider<double?>((ref) async* {
  final repo = ref.watch(mediaUploadRepositoryProvider);
  await for (final event in repo.statusStream) {
    if (event.status == 'uploading' && event.progress != null) {
      yield event.progress;
    } else if (event.status == 'done' || event.status == 'failed') {
      yield null;
    }
  }
});
