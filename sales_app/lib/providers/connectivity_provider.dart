import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories.dart';

class ConnectivityNotifier extends Notifier<bool> {
  @override
  bool build() {
    final service = ref.read(connectivityServiceProvider);
    state = service.isOnline;
    service.onConnectivityChanged.listen((online) async {
      state = online;
      if (online) {
        ref.read(apiReachabilityProvider).resetCache();
        await ref.read(apiReachabilityProvider).check(baseUrl: ref.read(apiClientProvider).baseUrl);
        ref.invalidate(serverReachableProvider);
        ref.read(syncServiceProvider).syncIfOnline();
        ref.invalidate(pendingSyncCountProvider);
      }
    });
    return service.isOnline;
  }
}

final onlineStatusProvider = NotifierProvider<ConnectivityNotifier, bool>(ConnectivityNotifier.new);

final serverReachableProvider = FutureProvider<bool>((ref) async {
  if (!ref.watch(onlineStatusProvider)) return false;
  return ref.read(apiReachabilityProvider).check(baseUrl: ref.read(apiClientProvider).baseUrl);
});
