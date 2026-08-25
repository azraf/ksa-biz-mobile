import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'repositories.dart';

const _cacheKey = 'order_vat_config_cache';

/// Loads the `order_vat` block from GET /config/mobile, falling back to the
/// last cached copy when offline — mirrors [loadZatcaConfig]'s caching so the
/// VAT default survives offline order creation.
Future<MobileOrderVatConfig> loadOrderVatConfig(
  SharedPreferences prefs,
  ApiClient api,
) async {
  try {
    final response = await api.get('/config/mobile');
    final data = response['data'] as Map<String, dynamic>?;
    final config = MobileOrderVatConfig.fromJson(
      data?['order_vat'] as Map<String, dynamic>?,
    );
    await prefs.setString(
      _cacheKey,
      jsonEncode({
        'include_default': config.includeDefault,
        'always_include_ids': config.alwaysIncludeIds,
        'always_exclude_ids': config.alwaysExcludeIds,
      }),
    );
    return config;
  } catch (_) {
    final cached = prefs.getString(_cacheKey);
    if (cached != null) {
      return MobileOrderVatConfig.fromJson(
        jsonDecode(cached) as Map<String, dynamic>,
      );
    }
    return const MobileOrderVatConfig();
  }
}

final orderVatConfigProvider = FutureProvider<MobileOrderVatConfig>((ref) {
  return loadOrderVatConfig(
    ref.watch(sharedPreferencesProvider),
    ref.watch(apiClientProvider),
  );
});
