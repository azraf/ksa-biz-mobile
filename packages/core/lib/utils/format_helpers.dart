import 'package:intl/intl.dart';

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

DateTime? parseAppDateTime(String? iso) {
  if (iso == null || iso.isEmpty) return null;
  return DateTime.tryParse(iso)?.toLocal();
}

String formatAppDate(String? iso) {
  final dt = parseAppDateTime(iso);
  if (dt == null) return iso ?? '';
  return DateFormat('d MMM y').format(dt);
}

String formatAppDateTime(String? iso) {
  final dt = parseAppDateTime(iso);
  if (dt == null) return iso ?? '';
  return DateFormat('d MMM y, HH:mm').format(dt);
}

String formatAppRelativeTime(String? iso) {
  final dt = parseAppDateTime(iso);
  if (dt == null) return iso ?? '';
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}

String formatAppDateWithRelative(String? iso) {
  final dt = parseAppDateTime(iso);
  if (dt == null) return iso ?? '';
  final relative = formatAppRelativeTime(iso);
  final absolute = formatAppDateTime(iso);
  if (relative.isEmpty) return absolute;
  if (absolute.isEmpty) return relative;
  return '$relative · $absolute';
}
