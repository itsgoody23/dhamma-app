// Integration-style test for the pack merge and deletion pipeline.
//
// Unlike true device integration tests, this runs in the standard flutter test
// runner using NativeDatabase — no device or emulator required. It exercises:
//
//   1. mergePackDatabase  — ATTACH → INSERT OR IGNORE → DETACH
//   2. FTS5 query after merge — texts are searchable
//   3. removePackData     — DELETE by nikaya + language
//   4. FTS5 query after removal — texts no longer appear
//   5. vacuum             — runs without error after deletion
//
// This is the closest we can get to a full pack pipeline test in unit/widget
// test infrastructure without Dio or real CDN involvement.

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:dhamma_app/data/database/app_database.dart';

void main() {
  late AppDatabase mainDb;
  late Directory tempDir;

  setUp(() async {
    mainDb = AppDatabase.forTesting(NativeDatabase.memory());
    tempDir = await Directory.systemTemp.createTemp('dhamma_pack_test_');
  });

  tearDown(() async {
    await mainDb.close();
    await tempDir.delete(recursive: true);
  });

  /// Build a pack SQLite file at [path] with the given rows in the texts table.
  Future<void> buildPackDb(
    String path,
    List<Map<String, dynamic>> rows,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase(File(path)));
    await db.customStatement('''
      INSERT INTO texts (uid, title, nikaya, language, source, content_plain)
      VALUES ${rows.map((_) => '(?,?,?,?,?,?)').join(', ')}
    ''', [
      for (final row in rows) ...[
        row['uid'],
        row['title'],
        row['nikaya'],
        row['language'],
        row['source'] ?? 'sc',
        row['content_plain'] ?? '',
      ]
    ]);
    await db.close();
  }

  group('mergePackDatabase', () {
    test('texts from pack appear in main DB after merge', () async {
      final packPath = p.join(tempDir.path, 'mn_en.db');
      await buildPackDb(packPath, [
        {
          'uid': 'mn1',
          'title': 'Root of All Things',
          'nikaya': 'mn',
          'language': 'en',
          'content_plain': 'All things originate from mind.'
        },
        {
          'uid': 'mn2',
          'title': 'All the Taints',
          'nikaya': 'mn',
          'language': 'en',
          'content_plain': 'Seven methods for abandoning the taints.'
        },
      ]);

      await mainDb.mergePackDatabase(packPath);

      final rows = await mainDb.customSelect('SELECT uid FROM texts').get();
      final uids = rows.map((r) => r.read<String>('uid')).toSet();
      expect(uids, containsAll(['mn1', 'mn2']));
    });

    test('merge is idempotent — double merge does not duplicate rows',
        () async {
      final packPath = p.join(tempDir.path, 'mn_en.db');
      await buildPackDb(packPath, [
        {
          'uid': 'mn1',
          'title': 'Root of All Things',
          'nikaya': 'mn',
          'language': 'en'
        },
      ]);

      await mainDb.mergePackDatabase(packPath);
      await mainDb.mergePackDatabase(packPath); // second merge

      final count = await mainDb
          .customSelect("SELECT COUNT(*) as cnt FROM texts WHERE uid='mn1'")
          .getSingle();
      expect(count.read<int>('cnt'), 1);
    });

    test('merged texts are searchable via FTS5', () async {
      final packPath = p.join(tempDir.path, 'mn_en.db');
      await buildPackDb(packPath, [
        {
          'uid': 'mn10',
          'title': 'Satipaṭṭhāna Sutta',
          'nikaya': 'mn',
          'language': 'en',
          'content_plain': 'Mindfulness of body feelings mind phenomena.',
        },
      ]);

      await mainDb.mergePackDatabase(packPath);
      // Rebuild FTS index to include trigger-inserted rows
      await mainDb.customStatement(
          "INSERT INTO texts_fts(texts_fts) VALUES('rebuild')");

      final result = await mainDb
          .customSelect(
            "SELECT COUNT(*) as cnt FROM texts_fts WHERE texts_fts MATCH 'mindfulness'",
          )
          .getSingle();
      expect(result.read<int>('cnt'), greaterThan(0));
    });

    test('texts from different pack do not interfere', () async {
      final mnPath = p.join(tempDir.path, 'mn_en.db');
      final snPath = p.join(tempDir.path, 'sn_en.db');

      await buildPackDb(mnPath, [
        {'uid': 'mn1', 'title': 'MN1', 'nikaya': 'mn', 'language': 'en'},
      ]);
      await buildPackDb(snPath, [
        {'uid': 'sn1', 'title': 'SN1', 'nikaya': 'sn', 'language': 'en'},
      ]);

      await mainDb.mergePackDatabase(mnPath);
      await mainDb.mergePackDatabase(snPath);

      final rows = await mainDb.customSelect('SELECT uid FROM texts').get();
      final uids = rows.map((r) => r.read<String>('uid')).toSet();
      expect(uids, containsAll(['mn1', 'sn1']));
    });
  });

  group('removePackData', () {
    test('removes only the nikaya+language rows after merge', () async {
      final packPath = p.join(tempDir.path, 'mn_en.db');
      await buildPackDb(packPath, [
        {'uid': 'mn1', 'title': 'MN1', 'nikaya': 'mn', 'language': 'en'},
        {'uid': 'mn1p', 'title': 'MN1 Pali', 'nikaya': 'mn', 'language': 'pli'},
      ]);

      await mainDb.mergePackDatabase(packPath);
      await mainDb.removePackData('mn', 'en');

      final remaining =
          await mainDb.customSelect('SELECT uid FROM texts').get();
      final uids = remaining.map((r) => r.read<String>('uid')).toSet();
      expect(uids.contains('mn1'), isFalse);
      expect(uids.contains('mn1p'), isTrue);
    });

    test('FTS5 no longer matches removed texts', () async {
      final packPath = p.join(tempDir.path, 'mn_en.db');
      await buildPackDb(packPath, [
        {
          'uid': 'mn10',
          'title': 'Satipaṭṭhāna Sutta',
          'nikaya': 'mn',
          'language': 'en',
          'content_plain': 'Mindfulness meditation.',
        },
      ]);

      await mainDb.mergePackDatabase(packPath);
      await mainDb.customStatement(
          "INSERT INTO texts_fts(texts_fts) VALUES('rebuild')");

      // Verify it's indexed
      final before = await mainDb
          .customSelect(
            "SELECT COUNT(*) as cnt FROM texts_fts WHERE texts_fts MATCH 'mindfulness'",
          )
          .getSingle();
      expect(before.read<int>('cnt'), greaterThan(0));

      // Remove the pack
      await mainDb.removePackData('mn', 'en');

      final after = await mainDb
          .customSelect(
            "SELECT COUNT(*) as cnt FROM texts_fts WHERE texts_fts MATCH 'mindfulness'",
          )
          .getSingle();
      expect(after.read<int>('cnt'), 0);
    });
  });

  group('vacuum after removal', () {
    test('vacuum completes without error', () async {
      final packPath = p.join(tempDir.path, 'mn_en.db');
      await buildPackDb(packPath, [
        {'uid': 'mn1', 'title': 'MN1', 'nikaya': 'mn', 'language': 'en'},
      ]);

      await mainDb.mergePackDatabase(packPath);
      await mainDb.removePackData('mn', 'en');

      await expectLater(mainDb.vacuum(), completes);
    });
  });
}
