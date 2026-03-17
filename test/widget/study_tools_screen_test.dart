import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dhamma_app/data/database/app_database.dart';
import 'package:dhamma_app/features/study_tools/study_tools_screen.dart';
import 'package:dhamma_app/shared/providers/database_provider.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

late AppDatabase _db;

Widget _wrap(Widget child) {
  return ProviderScope(
    overrides: [appDatabaseProvider.overrideWithValue(_db)],
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

  group('StudyToolsScreen', () {
    testWidgets('renders 3 tabs: Bookmarks, Highlights, Notes',
        (tester) async {
      await tester.pumpWidget(_wrap(const StudyToolsScreen()));
      await tester.pump();

      expect(find.text('Bookmarks'), findsOneWidget);
      expect(find.text('Highlights'), findsOneWidget);
      expect(find.text('Notes'), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('title is Study', (tester) async {
      await tester.pumpWidget(_wrap(const StudyToolsScreen()));
      await tester.pump();

      expect(find.text('Study'), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('shows empty state for bookmarks initially', (tester) async {
      await tester.pumpWidget(_wrap(const StudyToolsScreen()));
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('No bookmarks yet'), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('shows empty state for highlights when tab selected',
        (tester) async {
      await tester.pumpWidget(_wrap(const StudyToolsScreen()));
      await tester.pump();
      await tester.pump();

      // Tap Highlights tab.
      await tester.tap(find.text('Highlights'));
      await tester.pumpAndSettle();

      expect(find.textContaining('No highlights yet'), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('shows empty state for notes when tab selected',
        (tester) async {
      await tester.pumpWidget(_wrap(const StudyToolsScreen()));
      await tester.pump();
      await tester.pump();

      // Tap Notes tab.
      await tester.tap(find.text('Notes'));
      await tester.pumpAndSettle();

      expect(find.textContaining('No notes yet'), findsOneWidget);
      await _cleanup(tester);
    });
  });
}
