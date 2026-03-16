import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:dhamma_app/data/database/app_database.dart';

/// Tests that verify the seed DB ATTACH / INSERT OR IGNORE / DETACH flow
/// used by [AppDatabase._applySeedIfNeeded].
///
/// We replicate the exact SQL from _applySeedIfNeeded in each test because
/// the method is private.  This is intentional: we're testing the SQL
/// contract, not the method itself.
void main() {
  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('seed_test_');
  });

  tearDown(() async {
    if (await tmp.exists()) await tmp.delete(recursive: true);
  });

  // ── Helpers ─────────────────────────────────────────────────────────────

  /// Creates a minimal seed SQLite file containing 3 daily_suttas rows.
  Future<String> buildSeedDb() async {
    final seedPath = p.join(tmp.path, 'dhamma_seed.db');
    final seedDb = AppDatabase.forTesting(NativeDatabase(File(seedPath)));
    await seedDb.batch((batch) {
      batch.insertAll(seedDb.dailySuttas, [
        DailySuttasCompanion.insert(
          dayOfYear: 1,
          uid: 'mn10',
          title: 'Satipaṭṭhāna Sutta',
          nikaya: 'mn',
          verseExcerpt: const Value('There is one way, monks.'),
        ),
        DailySuttasCompanion.insert(
          dayOfYear: 2,
          uid: 'sn56.11',
          title: 'Dhammacakkappavattana Sutta',
          nikaya: 'sn',
        ),
        DailySuttasCompanion.insert(
          dayOfYear: 3,
          uid: 'dn22',
          title: 'Mahāsatipaṭṭhāna Sutta',
          nikaya: 'dn',
        ),
      ]);
    });
    await seedDb.close();
    return seedPath;
  }

  Future<void> applySeed(AppDatabase mainDb, String seedPath) async {
    await mainDb.customStatement('ATTACH DATABASE ? AS seed', [seedPath]);
    await mainDb.customStatement('''
      INSERT OR IGNORE INTO main.daily_suttas
        (id, day_of_year, uid, title, verse_excerpt, nikaya)
      SELECT id, day_of_year, uid, title, verse_excerpt, nikaya
      FROM seed.daily_suttas
    ''');
    await mainDb.customStatement('DETACH DATABASE seed');
  }

  // ── Tests ────────────────────────────────────────────────────────────────

  test('ATTACH seed DB and copy daily_suttas rows', () async {
    final seedPath = await buildSeedDb();
    final mainDb = AppDatabase.forTesting(NativeDatabase.memory());

    await applySeed(mainDb, seedPath);

    final rows = await mainDb.select(mainDb.dailySuttas).get();
    expect(rows.length, 3);
    expect(rows.map((r) => r.dayOfYear).toSet(), {1, 2, 3});
    expect(rows.firstWhere((r) => r.dayOfYear == 1).uid, 'mn10');

    await mainDb.close();
  });

  test('Second ATTACH+INSERT is a no-op due to INSERT OR IGNORE', () async {
    final seedPath = await buildSeedDb();
    final mainDb = AppDatabase.forTesting(NativeDatabase.memory());

    await applySeed(mainDb, seedPath);
    await applySeed(mainDb, seedPath); // Duplicate call

    final rows = await mainDb.select(mainDb.dailySuttas).get();
    expect(rows.length, 3, reason: 'No duplicate rows should be inserted');

    await mainDb.close();
  });

  test('Seed file can be deleted after DETACH', () async {
    final seedPath = await buildSeedDb();
    final mainDb = AppDatabase.forTesting(NativeDatabase.memory());

    await applySeed(mainDb, seedPath);

    final seedFile = File(seedPath);
    expect(await seedFile.exists(), isTrue);
    await seedFile.delete();
    expect(await seedFile.exists(), isFalse,
        reason: 'Seed file should be deletable after DETACH');

    await mainDb.close();
  });

  test('Empty daily_suttas on fresh DB without seed', () async {
    final mainDb = AppDatabase.forTesting(NativeDatabase.memory());
    final rows = await mainDb.select(mainDb.dailySuttas).get();
    expect(rows, isEmpty);
    await mainDb.close();
  });

  test('verseExcerpt is nullable — null values round-trip correctly', () async {
    final seedPath = await buildSeedDb();
    final mainDb = AppDatabase.forTesting(NativeDatabase.memory());

    await applySeed(mainDb, seedPath);

    final dayTwo = await (mainDb.select(mainDb.dailySuttas)
          ..where((s) => s.dayOfYear.equals(2)))
        .getSingleOrNull();
    expect(dayTwo, isNotNull);
    expect(dayTwo!.verseExcerpt, isNull,
        reason: 'day=2 was inserted without verse_excerpt');

    await mainDb.close();
  });

  test('mergePackDatabase skips duplicate UIDs', () async {
    final packDbPath = p.join(tmp.path, 'pack.db');
    final packDb = AppDatabase.forTesting(NativeDatabase(File(packDbPath)));
    await packDb.customStatement('''
      INSERT OR IGNORE INTO texts (uid, title, nikaya, language, source)
      VALUES ('mn1', 'Root of All Things', 'mn', 'en', 'sc')
    ''');
    await packDb.close();

    final mainDb = AppDatabase.forTesting(NativeDatabase.memory());
    await mainDb.customStatement('''
      INSERT INTO texts (uid, title, nikaya, language, source)
      VALUES ('mn1', 'Root of All Things', 'mn', 'en', 'sc')
    ''');

    await mainDb.mergePackDatabase(packDbPath);

    final result = await mainDb.customSelect(
      'SELECT COUNT(*) as cnt FROM texts WHERE uid = ?',
      variables: [const Variable('mn1')],
    ).getSingle();
    expect(result.read<int>('cnt'), 1,
        reason: 'mergePackDatabase must not create duplicates');

    await mainDb.close();
  });
}
