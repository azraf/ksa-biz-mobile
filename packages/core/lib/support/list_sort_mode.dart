import '../utils/format_helpers.dart' show parseAppDateTime;

enum ListSortMode {
  date,
  name,
  area,
  salesPerson,
  distance,
}

extension ListSortModeX on ListSortMode {
  String apiSortParam() {
    switch (this) {
      case ListSortMode.date:
        return 'created_at';
      case ListSortMode.name:
        return 'name';
      case ListSortMode.area:
        return 'area';
      case ListSortMode.salesPerson:
        return 'sales_person';
      case ListSortMode.distance:
        return 'distance';
    }
  }

  String customerDateSortParam() => 'created_at';

  String orderApiSortParam() {
    switch (this) {
      case ListSortMode.date:
        return 'created_at';
      case ListSortMode.name:
        return 'customer_name';
      case ListSortMode.area:
        return 'area';
      case ListSortMode.salesPerson:
        return 'sales_person';
      case ListSortMode.distance:
        return 'created_at';
    }
  }

  String watchlistApiSortParam() {
    switch (this) {
      case ListSortMode.date:
        return 'created_at';
      case ListSortMode.name:
        return 'place_name';
      case ListSortMode.salesPerson:
        return 'sales_person';
      case ListSortMode.area:
      case ListSortMode.distance:
        return 'created_at';
    }
  }
}

List<T> sortByListMode<T>(
  List<T> items,
  ListSortMode mode, {
  String? Function(T)? dateIso,
  String Function(T)? name,
  String? Function(T)? area,
  String? Function(T)? salesPerson,
  double? Function(T)? distanceKm,
  double? Function(T)? distanceMeters,
}) {
  final copy = List<T>.from(items);
  int compareNullableString(String? a, String? b) {
    final sa = (a ?? '').trim().toLowerCase();
    final sb = (b ?? '').trim().toLowerCase();
    if (sa.isEmpty && sb.isEmpty) return 0;
    if (sa.isEmpty) return 1;
    if (sb.isEmpty) return -1;
    return sa.compareTo(sb);
  }

  switch (mode) {
    case ListSortMode.date:
      copy.sort((a, b) {
        final da = dateIso != null ? parseAppDateTime(dateIso(a)) : null;
        final db = dateIso != null ? parseAppDateTime(dateIso(b)) : null;
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });
      break;
    case ListSortMode.name:
      copy.sort((a, b) => compareNullableString(name?.call(a), name?.call(b)));
      break;
    case ListSortMode.area:
      copy.sort((a, b) => compareNullableString(area?.call(a), area?.call(b)));
      break;
    case ListSortMode.salesPerson:
      copy.sort((a, b) => compareNullableString(salesPerson?.call(a), salesPerson?.call(b)));
      break;
    case ListSortMode.distance:
      copy.sort((a, b) {
        final da = distanceMeters?.call(a) ?? distanceKm?.call(a) ?? double.infinity;
        final db = distanceMeters?.call(b) ?? distanceKm?.call(b) ?? double.infinity;
        return da.compareTo(db);
      });
      break;
  }
  return copy;
}
