import '../models/mobile_app_config.dart';

class OrderVatPolicy {
  static bool resolve({
    required MobileOrderVatConfig config,
    int? shopId,
    int? vanId,
    int? importerId,
  }) {
    final customerIds = <int>[
      if (shopId != null) shopId,
      if (vanId != null) vanId,
      if (importerId != null) importerId,
    ];

    if (customerIds.isEmpty) {
      return config.includeDefault;
    }

    for (final id in customerIds) {
      if (config.alwaysExcludeIds.contains(id)) return false;
      if (config.alwaysIncludeIds.contains(id)) return true;
    }

    return config.includeDefault;
  }
}
