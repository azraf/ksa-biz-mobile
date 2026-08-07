String formatFetchedAt(String? value) {
  if (value == null || value.isEmpty) return '';
  final parsed = DateTime.tryParse(value);
  if (parsed != null) {
    final local = parsed.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min';
  }
  if (value.length >= 16) return value.substring(0, 16);
  return value;
}

int parseJsonInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is num) return value.round();
  return int.tryParse(value.toString()) ?? defaultValue;
}
