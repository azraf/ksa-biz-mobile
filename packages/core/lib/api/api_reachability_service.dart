import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// Verifies the API server responds, not just that Wi‑Fi/cellular is up.
class ApiReachabilityService {
  ApiReachabilityService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  bool _reachable = true;
  DateTime? _lastCheck;
  static const _cacheDuration = Duration(seconds: 15);

  bool get isReachable => _reachable;

  Future<bool> check({String? baseUrl}) async {
    final now = DateTime.now();
    if (_lastCheck != null && now.difference(_lastCheck!) < _cacheDuration) {
      return _reachable;
    }

    final root = baseUrl ?? AppConfig.defaultApiBaseUrl;
    final normalized = root.endsWith('/') ? root.substring(0, root.length - 1) : root;
    final healthUrl = normalized.endsWith('/health') ? normalized : '$normalized/health';

    try {
      _reachable = await _probeReachable(healthUrl);
    } catch (_) {
      _reachable = false;
    }
    if (!_reachable) {
      try {
        // Legacy servers without /health still respond on the API base URL.
        _reachable = await _probeReachable(normalized);
      } catch (_) {
        _reachable = false;
      }
    }
    _lastCheck = now;
    return _reachable;
  }

  void resetCache() {
    _lastCheck = null;
  }

  Future<bool> _probeReachable(String url) async {
    final response = await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
    // Any HTTP response means the host is up; 404 only means this path is missing.
    return response.statusCode >= 200 && response.statusCode < 500;
  }

  void dispose() => _client.close();
}
