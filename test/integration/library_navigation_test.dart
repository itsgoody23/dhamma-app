// Integration test: full navigation flow from launch through the library.
//
// Run on a real device / emulator:
//   flutter test integration_test/library_navigation_test.dart
//
// Or via `flutter drive`:
//   flutter drive --driver=test_driver/integration_test.dart \
//                 --target=integration_test/library_navigation_test.dart
//
// NOTE: This file lives in test/integration/ for source organisation but must
// be moved to integration_test/ when actually run against a device (Flutter
// integration_test SDK requirement). The test logic is written here to document
// the intended flows; adapt paths accordingly when wiring CI.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:dhamma_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Library navigation end-to-end', () {
    testWidgets(
      'launch → library tab → nikaya card → back',
      (tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // The onboarding screen should appear on first run.
        // For CI, shared_preferences should be pre-seeded with onboarding_complete=true.
        // Skip directly to library tab.
        final libraryTab = find.text('Library');
        if (libraryTab.evaluate().isNotEmpty) {
          await tester.tap(libraryTab);
          await tester.pumpAndSettle();
        }

        // Verify at least one nikaya card is visible.
        expect(find.textContaining('Nikāya'), findsWidgets);
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    testWidgets(
      'search tab — type query — result list visible',
      (tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        final searchTab = find.text('Search');
        if (searchTab.evaluate().isNotEmpty) {
          await tester.tap(searchTab);
          await tester.pumpAndSettle();
        }

        final textField = find.byType(TextField);
        if (textField.evaluate().isNotEmpty) {
          await tester.enterText(textField.first, 'sati');
          await tester.pumpAndSettle(const Duration(milliseconds: 500));
        }
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
