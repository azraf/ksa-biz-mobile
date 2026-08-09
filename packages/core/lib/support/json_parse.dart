/// Safe parsing for JSON values that may arrive as int, double, or string.
int? parseJsonIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

int parseJsonInt(dynamic value, {int fallback = 0}) {
  return parseJsonIntOrNull(value) ?? fallback;
}

double parseJsonDouble(dynamic value, {double fallback = 0}) {
  if (value == null) return fallback;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? fallback;
}
