import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories.dart';

class ConnectivityNotifier extends Notifier<bool> {
  @override
  bool build() {
    final service = ref.read(connectivityServiceProvider);
    state = service.isOnline;
    service.onConnectivityChanged.listen((online) {
      state = online;
      if (online) {
        ref.read(syncServiceProvider).syncIfOnline();
        ref.invalidate(pendingSyncCountProvider);
      }
    });
    return service.isOnline;
  }
}

final onlineStatusProvider = NotifierProvider<ConnectivityNotifier, bool>(ConnectivityNotifier.new);
