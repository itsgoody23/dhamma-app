import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dhamma_app/data/database/app_database.dart';
import 'package:dhamma_app/features/library/library_screen.dart';
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

  group('LibraryScreen', () {
    testWidgets('renders all 5 nikayas', (tester) async {
      await tester.pumpWidget(_wrap(const LibraryScreen()));
      await tester.pump();

      expect(find.text('Dīgha Nikāya'), findsOneWidget);
      expect(find.text('Majjhima Nikāya'), findsOneWidget);
      expect(find.text('Saṃyutta Nikāya'), findsOneWidget);
      expect(find.text('Aṅguttara Nikāya'), findsOneWidget);
      expect(find.text('Khuddaka Nikāya'), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('renders English subtitles', (tester) async {
      await tester.pumpWidget(_wrap(const LibraryScreen()));
      await tester.pump();

      expect(find.text('Long Discourses'), findsOneWidget);
      expect(find.text('Middle-Length Discourses'), findsOneWidget);
      expect(find.text('Connected Discourses'), findsOneWidget);
      expect(find.text('Numerical Discourses'), findsOneWidget);
      expect(find.text('Minor Collection'), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('has settings button in app bar', (tester) async {
      await tester.pumpWidget(_wrap(const LibraryScreen()));
      await tester.pump();

      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('title is Library', (tester) async {
      await tester.pumpWidget(_wrap(const LibraryScreen()));
      await tester.pump();

      expect(find.text('Library'), findsOneWidget);
      await _cleanup(tester);
    });

    testWidgets('shows progress rings for each nikaya', (tester) async {
      await tester.pumpWidget(_wrap(const LibraryScreen()));
      await tester.pump();
      await tester.pump();

      // Progress rings render as CircularProgressIndicator widgets.
      expect(find.byType(CircularProgressIndicator), findsNWidgets(5));
      await _cleanup(tester);
    });
  });
}
