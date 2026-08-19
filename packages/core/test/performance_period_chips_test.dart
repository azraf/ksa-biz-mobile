import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('preset chips emit ranges; All time hidden unless asked',
      (tester) async {
    PerformancePeriod? got;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PerformancePeriodChips(
          value: PerformancePeriod.thisMonth,
          onChanged: (p) => got = p,
        ),
      ),
    ));

    expect(find.text('All time'), findsNothing);
    expect(find.text('Last 3 months'), findsOneWidget);

    await tester.tap(find.text('Last month'));
    expect(got?.range, 'last_month');
    expect(got?.isDay, isFalse);
  });

  testWidgets('a week that has not started yet is disabled', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PerformancePeriodChips(
          value: PerformancePeriod.thisMonth,
          onChanged: (_) {},
          showAll: true,
        ),
      ),
    ));

    final day = DateTime.now().day;
    final chip = (String label) => tester.widget<ChoiceChip>(
        find.ancestor(of: find.text(label), matching: find.byType(ChoiceChip)));
    expect(chip('Wk 1').onSelected, isNotNull);
    expect(chip('Wk 4').onSelected, day >= 22 ? isNotNull : isNull);
    expect(find.text('All time'), findsOneWidget);
  });

  test('day period sends the same date as from and to', () {
    const p = PerformancePeriod.day('2026-08-05');
    expect(p.fromDate, p.toDate);
    expect(p.range, isNull);
    expect(p.isDay, isTrue);
  });
}
