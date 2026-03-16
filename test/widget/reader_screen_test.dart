import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dhamma_app/data/database/app_database.dart';
import 'package:dhamma_app/features/reader/reader_screen.dart';
import 'package:dhamma_app/shared/providers/database_provider.dart';
import 'package:dhamma_app/shared/widgets/loading_shimmer.dart';

/// Minimal router wrapping the reader screen (go_router requires a router
/// for GoRouterState to be available in the widget tree).
GoRouter _makeRouter(String uid, String language) => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => ReaderScreen(uid: uid, language: language),
        ),
      ],
    );

/// Creates an in-memory test DB seeded with one sutta row.
Future<AppDatabase> _seedDb() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await db.customStatement('''
    INSERT INTO texts (uid, title, nikaya, language, source, content_html, content_plain)
    VALUES (
      'mn10', 'Satipaṭṭhāna Sutta', 'mn', 'en', 'sc',
      '<p>There is one way, monks, for the purification of beings.</p>',
      'There is one way, monks, for the purification of beings.'
    )
  ''');
  return db;
}

/// Unmounts ProviderScope inside the test body so Drift stream-cleanup
/// timers (Duration.zero) fire before the test framework's invariant check.
/// FakeAsync.elapse(Duration.zero) is a no-op, so we advance by 1 µs.
Future<void> _cleanup(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(microseconds: 1));
}

void main() {
  late AppDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'seed_applied_v1': true});
    db = await _seedDb();
  });

  tearDown(() async {
    await db.close();
  });

  Widget buildApp(String uid, String language) => ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp.router(
          routerConfig: _makeRouter(uid, language),
        ),
      );

  testWidgets('shows loading indicator while sutta loads', (tester) async {
    await tester.pumpWidget(buildApp('mn10', 'en'));
    // On first frame, the FutureProvider is loading — reader uses LoadingShimmer
    expect(find.byType(LoadingShimmer), findsOneWidget);
    await _cleanup(tester);
  });

  testWidgets('shows sutta title after data loads', (tester) async {
    await tester.pumpWidget(buildApp('mn10', 'en'));
    await tester.pumpAndSettle();

    expect(find.text('Satipaṭṭhāna Sutta'), findsOneWidget);
    await _cleanup(tester);
  });

  testWidgets('shows not-found error for missing UID', (tester) async {
    await tester.pumpWidget(buildApp('nonexistent', 'en'));
    await tester.pumpAndSettle();

    expect(find.textContaining('not found'), findsWidgets);
    await _cleanup(tester);
  });

  testWidgets('shows translator attribution when translator is set',
      (tester) async {
    // Insert a sutta with a translator
    await db.customStatement('''
      INSERT INTO texts (uid, title, nikaya, language, source, content_plain, translator)
      VALUES ('dn2', 'Fruits of the Contemplative Life', 'dn', 'en', 'sc',
              'Plain content here.', 'Bhikkhu Bodhi')
    ''');

    await tester.pumpWidget(buildApp('dn2', 'en'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Bhikkhu Bodhi'), findsWidgets);
    expect(find.textContaining('Creative Commons'), findsOneWidget);
    await _cleanup(tester);
  });

  testWidgets('bookmark icon is present in app bar', (tester) async {
    await tester.pumpWidget(buildApp('mn10', 'en'));
    await tester.pumpAndSettle();

    // The bookmark icon (outline or filled) should be in the app bar
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.bookmark_outline),
      ),
      findsOneWidget,
    );
    await _cleanup(tester);
  });

  testWidgets('overflow menu shows share and export options', (tester) async {
    await tester.pumpWidget(buildApp('mn10', 'en'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    expect(find.text('Share passage'), findsOneWidget);
    expect(find.text('Export PDF'), findsOneWidget);
    await _cleanup(tester);
  });
}
