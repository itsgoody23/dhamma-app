import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dhamma_app/data/database/app_database.dart';
import 'package:dhamma_app/features/daily/daily_screen.dart';
import 'package:dhamma_app/data/models/reading_plan.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _wrap(Widget child, {List<dynamic> overrides = const []}) {
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp(home: child),
  );
}

void main() {
  group('DailyScreen', () {
    testWidgets('shows CircularProgressIndicator while loading',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DailyScreen(),
          overrides: [
            dailySuttaProvider.overrideWith((_) async {
              await Future.delayed(const Duration(seconds: 10));
              return null;
            }),
            readingPlansProvider.overrideWith((_) async {
              await Future.delayed(const Duration(seconds: 10));
              return [];
            }),
          ],
        ),
      );
      // First frame — providers are loading.
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      // Drain the 10-second delayed timers so no pending timers remain.
      await tester.pump(const Duration(seconds: 11));
    });

    testWidgets('shows daily sutta card when data is available',
        (tester) async {
      const sutta = DailySutta(
        id: 1,
        dayOfYear: 74,
        uid: 'mn1',
        title: 'Mūlapariyāya Sutta',
        verseExcerpt: 'The root of all things',
        nikaya: 'mn',
      );

      await tester.pumpWidget(
        _wrap(
          const DailyScreen(),
          overrides: [
            dailySuttaProvider.overrideWith((_) async => sutta),
            readingPlansProvider.overrideWith(
              (_) async => [
                const ReadingPlan(
                  id: 'dhp30',
                  title: '30-Day Dhammapada',
                  description: 'A verse a day',
                  days: [],
                ),
              ],
            ),
          ],
        ),
      );

      await tester.pump(); // trigger Future.
      await tester.pump(); // build with data.

      expect(find.text('Mūlapariyāya Sutta'), findsOneWidget);
      expect(find.text('SUTTA OF THE DAY'), findsOneWidget);
      expect(find.text('30-Day Dhammapada'), findsOneWidget);
    });

    testWidgets('shows no-daily card when sutta is null', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DailyScreen(),
          overrides: [
            dailySuttaProvider.overrideWith((_) async => null),
            readingPlansProvider.overrideWith((_) async => []),
          ],
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(
        find.textContaining('No daily sutta available'),
        findsOneWidget,
      );
    });
  });
}
