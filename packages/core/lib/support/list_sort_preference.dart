import 'package:shared_preferences/shared_preferences.dart';

import '../support/list_sort_mode.dart';

class ListSortPreference {
  ListSortPreference(this._prefs);

  final SharedPreferences _prefs;

  static const _prefix = 'list_sort_';

  ListSortMode read(String listKey, {required ListSortMode defaultMode}) {
    final raw = _prefs.getString('$_prefix$listKey');
    if (raw == null) return defaultMode;
    return ListSortMode.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => defaultMode,
    );
  }

  Future<void> write(String listKey, ListSortMode mode) async {
    await _prefs.setString('$_prefix$listKey', mode.name);
  }

  bool hasSaved(String listKey) => _prefs.containsKey('$_prefix$listKey');

  /// Shops with GPS: default distance; otherwise date.
  ListSortMode defaultForCustomerShop({required bool gpsAvailable}) {
    if (gpsAvailable) return ListSortMode.distance;
    return ListSortMode.date;
  }

  ListSortMode defaultForList(String listKey, {bool gpsAvailable = false}) {
    if (listKey.contains('customer_shop')) {
      return defaultForCustomerShop(gpsAvailable: gpsAvailable);
    }
    return ListSortMode.date;
  }
}
