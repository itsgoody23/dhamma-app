import 'dart:async';

import 'package:drift/drift.dart' show Value;
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
import 'package:dhamma_app/features/downloads/downloads_screen.dart';
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
  Future<void> deletePack(
      String packId, String packNikaya, String packLanguage) async {}

  @override
  void dispose() => _controller.close();
}

void main() {
  late AppDatabase db;
  late _MockPackIndexService mockIndexService;
  late _FakePackDownloadService fakeDownloadService;

  setUp(() {
    // seed_applied_v1=true prevents _applySeedIfNeeded from calling
    // getApplicationDocumentsDirectory() (a platform channel that hangs in fake_async).
    SharedPreferences.setMockInitialValues({'seed_applied_v1': true});
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
        home: DownloadsScreen(),
      ),
    );
  }

  /// Unmounts the widget tree inside the test body so that any Drift
  /// stream-cleanup timers (Duration.zero) created during ProviderScope
  /// disposal fire before the test framework checks for pending timers.
  ///
  /// NOTE: FakeAsync.elapse(Duration.zero) is a no-op, so we must advance
  /// the clock by at least 1 µs to fire Duration.zero timers.
  Future<void> cleanup(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(microseconds: 1));
  }

  testWidgets('shows "AVAILABLE TO DOWNLOAD" section heading', (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('AVAILABLE TO DOWNLOAD'), findsOneWidget);
    await cleanup(tester);
  });

  testWidgets('shows Wi-Fi only toggle defaulting to true', (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    final toggle = tester.widget<SwitchListTile>(
      find.byType(SwitchListTile),
    );
    expect(toggle.value, isTrue);
    await cleanup(tester);
  });

  testWidgets('shows "No packs available" when fetchPacks returns empty',
      (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.textContaining('No packs available'), findsOneWidget);
    await cleanup(tester);
  });

  testWidgets('shows available packs when fetchPacks returns data',
      (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => [
          const ContentPack(
            packId: 'mn_en',
            packName: 'Majjhima Nikāya — English',
            language: 'en',
            nikaya: 'mn',
            sizeMb: 8.2,
            compressedSizeMb: 3.1,
            suttaCount: 152,
            downloadUrl: 'https://cdn.dhamma.app/packs/mn_en.db.gz',
            checksumSha256: 'abc123',
          ),
        ]);

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Majjhima Nikāya — English'), findsOneWidget);
    expect(find.text('Download'), findsOneWidget);
    await cleanup(tester);
  });

  testWidgets('shows INSTALLED section when packs are in DB', (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await db.packsDao.insertPack(DownloadedPacksCompanion.insert(
      packId: 'mn_en',
      packName: 'Majjhima Nikāya — English',
      language: 'en',
      nikaya: const Value('mn'),
      sizeMb: 8.2,
    ));

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('INSTALLED'), findsOneWidget);
    expect(find.text('Majjhima Nikāya — English'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    await cleanup(tester);
  });

  testWidgets('storage card shows total MB from installed packs',
      (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await db.packsDao.insertPack(DownloadedPacksCompanion.insert(
      packId: 'mn_en',
      packName: 'MN English',
      language: 'en',
      nikaya: const Value('mn'),
      sizeMb: 8.2,
    ));

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.textContaining('8.2 MB'), findsWidgets);
    await cleanup(tester);
  });

  testWidgets('delete icon shows confirmation dialog', (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await db.packsDao.insertPack(DownloadedPacksCompanion.insert(
      packId: 'mn_en',
      packName: 'MN English',
      language: 'en',
      nikaya: const Value('mn'),
      sizeMb: 8.2,
    ));

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.text('Delete pack?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    await cleanup(tester);
  });

  testWidgets('tapping Cancel in delete dialog dismisses it', (tester) async {
    when(() => mockIndexService.fetchPacks()).thenAnswer((_) async => []);

    await db.packsDao.insertPack(DownloadedPacksCompanion.insert(
      packId: 'mn_en',
      packName: 'MN English',
      language: 'en',
      nikaya: const Value('mn'),
      sizeMb: 8.2,
    ));

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Delete pack?'), findsNothing);
    await cleanup(tester);
  });
}
