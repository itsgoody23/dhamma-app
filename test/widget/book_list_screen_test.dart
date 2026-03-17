import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dhamma_app/data/database/app_database.dart';
import 'package:dhamma_app/features/library/book_list_screen.dart';
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

  group('BookListScreen', () {
    testWidgets('shows empty state when no texts downloaded', (tester) async {
      await tester.pumpWidget(
        _wrap(const BookListScreen(nikaya: 'mn')),
      );
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('No texts found'), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('shows nikaya name in app bar', (tester) async {
      await tester.pumpWidget(
        _wrap(const BookListScreen(nikaya: 'dn')),
      );
      await tester.pump();

      expect(find.text('Dīgha Nikāya'), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('shows book and nikaya when book is provided', (tester) async {
      await tester.pumpWidget(
        _wrap(const BookListScreen(nikaya: 'mn', book: 'Mūlapaṇṇāsa')),
      );
      await tester.pump();

      expect(find.text('Mūlapaṇṇāsa'), findsOneWidget);
      expect(find.text('Majjhima Nikāya'), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('renders sutta list when data is available', (tester) async {
      // Insert test sutta into database.
      await _db.into(_db.texts).insert(TextsCompanion.insert(
            uid: 'mn1',
            title: 'Mūlapariyāya Sutta',
            nikaya: 'mn',
            language: 'en',
          ));

      await tester.pumpWidget(
        _wrap(const BookListScreen(nikaya: 'mn')),
      );
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text('Mūlapariyāya Sutta'), findsOneWidget);
      await _cleanup(tester);
    });
  });
}
