import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dhamma_app/data/database/app_database.dart';
import 'package:dhamma_app/data/models/content_pack.dart';
import 'package:dhamma_app/data/services/pack_download_service.dart';
import 'package:dhamma_app/data/services/pack_index_service.dart';
import 'package:dhamma_app/features/downloads/downloads_screen.dart'
    show packDownloadServiceProvider, packIndexServiceProvider;
import 'package:dhamma_app/features/onboarding/onboarding_screen.dart';
import 'package:dhamma_app/shared/providers/database_provider.dart';

class _MockPackIndexService extends Mock implements PackIndexService {}

class _FakePackDownloadService extends Fake implements PackDownloadService {
  final _controller = StreamController<DownloadProgress>.broadcast();

  @override
  Stream<DownloadProgress> progressStream(String packId) => _controller.stream;

  @override
  Future<void> downloadPack(ContentPack pack, {bool wifiOnly = true}) async {}

  @override
  Future<void> cancelDownload(String packId) async {}

  @override
  void dispose() => _controller.close();
}

void main() {
  late AppDatabase db;
  late _MockPackIndexService mockIndexService;
  late _FakePackDownloadService fakeDownloadService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    mockIndexService = _MockPackIndexService();
    fakeDownloadService = _FakePackDownloadService();
  });

  tearDown(() async {
    await db.close();
    fakeDownloadService.dispose();
  });

  Widget buildSubject() {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        packIndexServiceProvider.overrideWithValue(mockIndexService),
        packDownloadServiceProvider.overrideWithValue(fakeDownloadService),
      ],
      child: const MaterialApp(
        home: OnboardingScreen(),
      ),
    );
  }

  testWidgets('starts on Welcome page with Get started button', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('Dhamma App'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
  });

  testWidgets('shows 5 progress dots on first page', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    // 5 dots rendered as AnimatedContainers
    expect(find.byType(AnimatedContainer), findsNWidgets(5));
  });

  testWidgets('tapping Get started navigates to Language page', (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Choose your language'), findsOneWidget);
  });

  testWidgets('Language page shows Skip for now link', (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Skip for now'), findsOneWidget);
  });

  testWidgets('Language page shows English, Pāli, Deutsch chips',
      (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Pāli'), findsOneWidget);
    expect(find.text('Deutsch'), findsOneWidget);
  });

  testWidgets('tapping Continue on Language page shows Download page',
      (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Download your first pack'), findsOneWidget);
  });

  testWidgets('HowTo page shows Library, Search, Daily tips', (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    // Navigate to page 4 (HowTo) via 3 taps
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Skip download step
    await tester.tap(find.text('Skip — download later'));
    await tester.pumpAndSettle();

    expect(find.text('How to navigate'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Daily'), findsOneWidget);
  });

  testWidgets('Done page shows Start reading button', (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip — download later'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();

    expect(find.text("You're ready"), findsOneWidget);
    expect(find.text('Start reading'), findsOneWidget);
  });
}
