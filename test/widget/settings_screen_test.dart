import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dhamma_app/features/settings/settings_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: SettingsScreen(),
      ),
    );
  }

  testWidgets('shows Reading, Downloads, and About sections', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('READING'), findsOneWidget);
    expect(find.text('DOWNLOADS'), findsOneWidget);
    expect(find.text('ABOUT'), findsOneWidget);
  });

  testWidgets('shows Theme, Font size, Default language list tiles',
      (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Font size'), findsOneWidget);
    expect(find.text('Default language'), findsOneWidget);
  });

  testWidgets('shows Wi-Fi only downloads switch', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('Wi-Fi only downloads'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);
  });

  testWidgets('shows Licences, SuttaCentral, Version items in About',
      (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    // Scroll down so items below the viewport are rendered.
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pump();

    expect(find.text('Licences'), findsWidgets);
    expect(find.text('SuttaCentral'), findsWidgets);
    expect(find.text('Version'), findsOneWidget);
  });

  testWidgets('tapping Theme opens dialog with theme options', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();

    // Should see the theme picker dialog (System default also appears in subtitle, hence findsWidgets)
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('System default'), findsWidgets);
  });

  testWidgets('selecting Dark theme in dialog dismisses it', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    // Dialog should be gone
    expect(find.text('Light'), findsNothing);
  });

  testWidgets('tapping Font size opens dialog with size options',
      (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    await tester.tap(find.text('Font size'));
    await tester.pumpAndSettle();

    // Labels from AppTypography.readerFontSizeLabels
    expect(find.text('S'), findsOneWidget);
    expect(find.text('M'), findsOneWidget);
    expect(find.text('L'), findsOneWidget);
    expect(find.text('XL'), findsOneWidget);
  });

  testWidgets('tapping Default language opens dialog with language options',
      (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    await tester.tap(find.text('Default language'));
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Pāli'), findsOneWidget);
    expect(find.text('Deutsch'), findsOneWidget);
    expect(find.text('Français'), findsOneWidget);
  });

  testWidgets('Wi-Fi switch defaults to true', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final switchWidget = tester.widget<SwitchListTile>(
      find.byType(SwitchListTile),
    );
    expect(switchWidget.value, isTrue);
  });
}
