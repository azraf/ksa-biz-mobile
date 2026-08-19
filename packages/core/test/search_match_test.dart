import 'package:core/support/search_match.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('matches: AND across tokens, OR across fields, case-insensitive', () {
    expect(SearchMatch.matches('ali MART', ['Ali Super Mart', null]), isTrue);
    expect(SearchMatch.matches('ali karim', ['Ali Bakery', 'Hassan Karim']), isTrue);
    expect(SearchMatch.matches('ali snacks', ['Ali Bakery', 'Hassan Karim']), isFalse);
    expect(SearchMatch.matches('   ', ['x']), isTrue);
    expect(SearchMatch.matches('zz', []), isFalse);
  });

  test('arabic folding', () {
    expect(SearchMatch.matches('مطعم الامل', ['مطعم الأمل']), isTrue);
    expect(SearchMatch.normalize('مكتـــبة'), 'مكتبه');
  });

  test('fuzzy fallback', () {
    final items = ['Beverages', 'Snacks', 'Pharmacy'];
    final r = SearchMatch.filterOrFuzzy(items, 'bevrages', (s) => [s]);
    expect(r.items, ['Beverages']);
    expect(r.isFuzzy, isTrue);

    final none = SearchMatch.filterOrFuzzy(items, 'zzzz', (s) => [s]);
    expect(none.items, isEmpty);
    expect(none.isFuzzy, isFalse);

    final exact = SearchMatch.filterOrFuzzy(items, 'sna', (s) => [s]);
    expect(exact.items, ['Snacks']);
    expect(exact.isFuzzy, isFalse);
  });
}
