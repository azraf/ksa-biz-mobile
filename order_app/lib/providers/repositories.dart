import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media/media.dart';

export 'package:core/core.dart' show sharedPreferencesProvider;

import '../repositories/product_price_repository.dart';
import 'auth_provider.dart';

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

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(ref.watch(apiClientProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(apiClientProvider));
});

final productPriceRepositoryProvider = Provider<ProductPriceRepository>((ref) {
  return ProductPriceRepository(ref.watch(apiClientProvider));
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.watch(apiClientProvider));
});

final manualOrderRepositoryProvider = Provider<ManualOrderRepository>((ref) {
  return ManualOrderRepository(ref.watch(apiClientProvider));
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
    expenseRepository: ExpenseRepository(ref.watch(apiClientProvider)),
    mediaUploadRepository: ref.watch(mediaUploadRepositoryProvider),
    apiReachability: ref.watch(apiReachabilityProvider),
    apiBaseUrl: ref.watch(apiClientProvider).baseUrl,
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
