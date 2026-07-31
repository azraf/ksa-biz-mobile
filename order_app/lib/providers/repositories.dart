import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media/media.dart';

export 'package:core/core.dart' show sharedPreferencesProvider;

import '../repositories/product_price_repository.dart';

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
    expenseRepository: ExpenseRepository(ref.watch(apiClientProvider)),
    mediaUploadRepository: ref.watch(mediaUploadRepositoryProvider),
  );
});

final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(localDatabaseProvider);
  final queue = await db.pendingCount();
  final media = await db.pendingMediaCount();
  return queue + media;
});
