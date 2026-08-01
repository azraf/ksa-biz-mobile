import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final _controller = StreamController<bool>.broadcast();
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  Stream<bool> get onConnectivityChanged => _controller.stream;

  Future<void> init() async {
    final results = await _connectivity.checkConnectivity();
    _isOnline = _hasConnection(results);
    _controller.add(_isOnline);
    _connectivity.onConnectivityChanged.listen((results) {
      final online = _hasConnection(results);
      if (online != _isOnline) {
        _isOnline = online;
        _controller.add(online);
      }
    });
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  void dispose() => _controller.close();
}
