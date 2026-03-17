import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dhamma_app/data/models/reading_plan.dart';
import 'package:dhamma_app/features/daily/daily_screen.dart';
import 'package:dhamma_app/features/daily/plan_detail_screen.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _wrap(Widget child, {List<dynamic> overrides = const []}) {
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp(home: child),
  );
}

const _testPlan = ReadingPlan(
  id: 'dhp30',
  title: '30-Day Dhammapada',
  description: 'Read the Dhammapada in 30 days',
  days: [
    ReadingPlanDay(day: 1, uid: 'dhp1-20', title: 'Yamakavagga'),
    ReadingPlanDay(day: 2, uid: 'dhp21-32', title: 'Appamādavagga'),
    ReadingPlanDay(day: 3, uid: 'dhp33-43', title: 'Cittavagga'),
  ],
);

void main() {
  group('PlanDetailScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PlanDetailScreen(planId: 'dhp30'),
          overrides: [
            planByIdProvider.overrideWith((ref, planId) async {
              await Future.delayed(const Duration(seconds: 10));
              return null;
            }),
          ],
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 11));
    });

    testWidgets('shows plan not found for invalid ID', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PlanDetailScreen(planId: 'nonexistent'),
          overrides: [
            readingPlansProvider.overrideWith((_) async => [_testPlan]),
          ],
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Plan not found'), findsOneWidget);
    });

    testWidgets('renders plan title and days', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PlanDetailScreen(planId: 'dhp30'),
          overrides: [
            readingPlansProvider.overrideWith((_) async => [_testPlan]),
            planProgressProvider.overrideWith(
                (ref, planId) async => <String, bool>{}),
            planAvailabilityProvider
                .overrideWith((ref, planId) async => <String>{}),
          ],
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('30-Day Dhammapada'), findsOneWidget);
      expect(find.text('Yamakavagga'), findsOneWidget);
      expect(find.text('Appamādavagga'), findsOneWidget);
      expect(find.text('Cittavagga'), findsOneWidget);
    });

    testWidgets('shows progress bar and count', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PlanDetailScreen(planId: 'dhp30'),
          overrides: [
            readingPlansProvider.overrideWith((_) async => [_testPlan]),
            planProgressProvider.overrideWith(
              (ref, planId) async => {'dhp1-20': true},
            ),
            planAvailabilityProvider.overrideWith(
              (ref, planId) async => {'dhp1-20', 'dhp21-32', 'dhp33-43'},
            ),
          ],
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('1/3'), findsOneWidget);
    });

    testWidgets('shows Not downloaded for unavailable days', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PlanDetailScreen(planId: 'dhp30'),
          overrides: [
            readingPlansProvider.overrideWith((_) async => [_testPlan]),
            planProgressProvider.overrideWith(
                (ref, planId) async => <String, bool>{}),
            planAvailabilityProvider
                .overrideWith((ref, planId) async => <String>{}),
          ],
        ),
      );
      await tester.pump();
      await tester.pump();

      // All 3 days should show "Not downloaded".
      expect(find.text('Not downloaded'), findsNWidgets(3));
    });
  });
}
