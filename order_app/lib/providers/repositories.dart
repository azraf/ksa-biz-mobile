import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media/media.dart';

export 'package:core/core.dart' show sharedPreferencesProvider;

import '../repositories/product_price_repository.dart';
import 'auth_provider.dart';
import 'connectivity_provider.dart';

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
    db: ref.watch(localDatabaseProvider),
    getAuthToken: () => ref.read(authRepositoryProvider).getAuthToken(),
  );
  ref.onDispose(repo.dispose);
  return repo;
});

final mediaCaptureFacadeProvider = Provider<MediaCaptureFacade>((ref) {
  return MediaCaptureFacade(uploadRepository: ref.watch(mediaUploadRepositoryProvider));
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final service = SyncService(
    db: ref.watch(localDatabaseProvider),
    connectivity: ref.watch(connectivityServiceProvider),
    orderRepository: ref.watch(orderRepositoryProvider),
    expenseRepository: ExpenseRepository(ref.watch(apiClientProvider)),
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
