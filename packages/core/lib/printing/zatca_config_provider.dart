import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../models/zatca_config.dart';

const _cacheKey = 'zatca_config_cache';

/// Loads the ZATCA config from GET /config/mobile, falling back to the last
/// cached copy when offline — the seller header must survive offline printing.
Future<ZatcaConfig> loadZatcaConfig(SharedPreferences prefs, ApiClient api) async {
  try {
    final response = await api.get('/config/mobile');
    final data = response['data'] as Map<String, dynamic>?;
    final config = ZatcaConfig.fromJson(data?['zatca'] as Map<String, dynamic>?);
    await prefs.setString(_cacheKey, jsonEncode(config.toJson()));
    return config;
  } catch (_) {
    final cached = prefs.getString(_cacheKey);
    if (cached != null) {
      return ZatcaConfig.fromJson(jsonDecode(cached) as Map<String, dynamic>);
    }
    return const ZatcaConfig();
  }
}
