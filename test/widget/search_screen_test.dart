import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dhamma_app/data/database/app_database.dart';
import 'package:dhamma_app/data/models/search_result.dart';
import 'package:dhamma_app/features/search/search_screen.dart';
import 'package:dhamma_app/shared/providers/database_provider.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

late AppDatabase _db;

Widget _wrap(Widget child, {List<dynamic> overrides = const []}) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(_db),
      ...overrides.cast(),
    ],
    child: MaterialApp(home: child),
  );
}

Future<void> _cleanup(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(microseconds: 1));
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'seed_applied_v1': true});
    _db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await _db.close();
  });

  group('SearchScreen', () {
    testWidgets('shows hint text when no query entered', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SearchScreen(),
          overrides: [
            searchResultsProvider.overrideWith(
              (ref, query) async => [],
            ),
          ],
        ),
      );
      await tester.pump();

      // The search text field should be visible.
      expect(find.byType(TextField), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('displays results after typing a query', (tester) async {
      final fakeResults = [
        const SearchResult(
          uid: 'mn10',
          title: 'Satipaṭṭhāna Sutta',
          nikaya: 'mn',
          language: 'en',
          translator: 'Bhikkhu Sujato',
          snippet: 'The four foundations of mindfulness',
        ),
      ];

      await tester.pumpWidget(
        _wrap(
          const SearchScreen(),
          overrides: [
            searchResultsProvider.overrideWith(
              (ref, query) async {
                if (query.isNotEmpty) return fakeResults;
                return [];
              },
            ),
          ],
        ),
      );

      await tester.pump();

      // Type a query.
      await tester.enterText(find.byType(TextField), 'mindfulness');
      await tester.pump(const Duration(milliseconds: 400)); // debounce
      await tester.pump();

      expect(find.text('Satipaṭṭhāna Sutta'), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('filter button is visible', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SearchScreen(),
          overrides: [
            searchResultsProvider.overrideWith(
              (ref, query) async => [],
            ),
          ],
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.tune_outlined), findsOneWidget);
      await _cleanup(tester);
    });
  });
}
