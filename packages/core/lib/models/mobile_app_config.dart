import 'package:equatable/equatable.dart';

import '../utils/format_helpers.dart';

class MobileOrderVatConfig extends Equatable {
  const MobileOrderVatConfig({
    this.includeDefault = false,
    this.alwaysIncludeIds = const [],
    this.alwaysExcludeIds = const [],
  });

  final bool includeDefault;
  final List<int> alwaysIncludeIds;
  final List<int> alwaysExcludeIds;

  factory MobileOrderVatConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MobileOrderVatConfig();
    return MobileOrderVatConfig(
      includeDefault: json['include_default'] == true,
      alwaysIncludeIds: _parseIdList(json['always_include_ids']),
      alwaysExcludeIds: _parseIdList(json['always_exclude_ids']),
    );
  }

  static List<int> _parseIdList(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => parseJsonInt(e)).where((id) => id > 0).toList();
    }
    if (raw is String && raw.trim().isNotEmpty) {
      return raw
          .split(',')
          .map((part) => parseJsonInt(part.trim()))
          .where((id) => id > 0)
          .toList();
    }
    return [];
  }

  @override
  List<Object?> get props => [includeDefault, alwaysIncludeIds, alwaysExcludeIds];
}

class MobileAppConfig extends Equatable {
  const MobileAppConfig({
    this.walkInShopId,
    this.orderVat = const MobileOrderVatConfig(),
  });

  final int? walkInShopId;
  final MobileOrderVatConfig orderVat;

  factory MobileAppConfig.fromJson(Map<String, dynamic> json) {
    final walkIn = json['walk_in_shop_id'];
    return MobileAppConfig(
      walkInShopId: walkIn is int ? walkIn : int.tryParse('$walkIn'),
      orderVat: MobileOrderVatConfig.fromJson(
        json['order_vat'] as Map<String, dynamic>?,
      ),
    );
  }

  Map<String, dynamic> toCacheJson() => {
        'walk_in_shop_id': walkInShopId,
        'order_vat': {
          'include_default': orderVat.includeDefault,
          'always_include_ids': orderVat.alwaysIncludeIds,
          'always_exclude_ids': orderVat.alwaysExcludeIds,
        },
      };

  @override
  List<Object?> get props => [walkInShopId, orderVat];
}
