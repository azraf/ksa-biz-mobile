import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final currencyFormatProvider = Provider<NumberFormat>((ref) {
  final locale = ref.watch(localeNotifierProvider);
  return NumberFormat.currency(locale: locale.languageCode, symbol: 'SAR ');
});

/// Same locale-aware SAR format but without decimals, for compact report
/// figures (performance, collection candidates).
final wholeCurrencyFormatProvider = Provider<NumberFormat>((ref) {
  final locale = ref.watch(localeNotifierProvider);
  return NumberFormat.currency(
    locale: locale.languageCode,
    symbol: 'SAR ',
    decimalDigits: 0,
  );
});
