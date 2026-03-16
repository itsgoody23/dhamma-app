// Integration test: multi-language pack merge pipeline.
//
// Verifies that the v2 schema (UNIQUE(uid, language)) supports merging
// the same sutta in both English and Pāli without conflicts.

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
    tempDir = await Directory.systemTemp.createTemp('dhamma_multilang_test_');
  });

  tearDown(() async {
    await mainDb.close();
    await tempDir.delete(recursive: true);
  });

  Future<void> buildPackDb(String path, List<Map<String, dynamic>> rows) async {
    final db = AppDatabase.forTesting(NativeDatabase(File(path)));
    for (final row in rows) {
      await db.customStatement('''
        INSERT INTO texts (uid, title, nikaya, language, translator, source, content_html, content_plain)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ''', [
        row['uid'],
        row['title'],
        row['nikaya'],
        row['language'],
        row['translator'],
        row['source'] ?? 'sc',
        row['content_html'] ?? '<p>${row['content_plain'] ?? ''}</p>',
        row['content_plain'] ?? '',
      ]);
    }
    await db.close();
  }

  group('multi-language merge', () {
    test('same uid in EN + PLI both appear after merge', () async {
      final enPath = p.join(tempDir.path, 'mn_en.db');
      final pliPath = p.join(tempDir.path, 'mn_pli.db');

      await buildPackDb(enPath, [
        {
          'uid': 'mn1',
          'title': 'The Root of All Things',
          'nikaya': 'mn',
          'language': 'en',
          'translator': 'sujato',
          'content_plain': 'So I have heard.',
        },
      ]);

      await buildPackDb(pliPath, [
        {
          'uid': 'mn1',
          'title': 'Mūlapariyāyasutta',
          'nikaya': 'mn',
          'language': 'pli',
          'translator': 'ms',
          'content_plain': 'Evaṁ me sutaṁ.',
        },
      ]);

      await mainDb.mergePackDatabase(enPath);
      await mainDb.mergePackDatabase(pliPath);

      final rows = await mainDb
          .customSelect(
              "SELECT uid, language, title FROM texts WHERE uid = 'mn1'")
          .get();
      expect(rows.length, 2);

      final languages = rows.map((r) => r.read<String>('language')).toSet();
      expect(languages, containsAll(['en', 'pli']));

      final enTitle = rows
          .firstWhere((r) => r.read<String>('language') == 'en')
          .read<String>('title');
      expect(enTitle, 'The Root of All Things');

      final pliTitle = rows
          .firstWhere((r) => r.read<String>('language') == 'pli')
          .read<String>('title');
      expect(pliTitle, 'Mūlapariyāyasutta');
    });

    test('double merge of same language is idempotent', () async {
      final path = p.join(tempDir.path, 'mn_en.db');
      await buildPackDb(path, [
        {
          'uid': 'mn1',
          'title': 'MN1',
          'nikaya': 'mn',
          'language': 'en',
          'translator': 'sujato',
        },
      ]);

      await mainDb.mergePackDatabase(path);
      await mainDb.mergePackDatabase(path);

      final count = await mainDb
          .customSelect(
              "SELECT COUNT(*) as cnt FROM texts WHERE uid = 'mn1' AND language = 'en'")
          .getSingle();
      expect(count.read<int>('cnt'), 1);
    });

    test('removing EN pack preserves PLI pack', () async {
      final enPath = p.join(tempDir.path, 'mn_en.db');
      final pliPath = p.join(tempDir.path, 'mn_pli.db');

      await buildPackDb(enPath, [
        {
          'uid': 'mn1',
          'title': 'MN1 EN',
          'nikaya': 'mn',
          'language': 'en',
          'translator': 'sujato',
          'content_plain': 'English content.',
        },
      ]);
      await buildPackDb(pliPath, [
        {
          'uid': 'mn1',
          'title': 'MN1 PLI',
          'nikaya': 'mn',
          'language': 'pli',
          'translator': 'ms',
          'content_plain': 'Pāli content.',
        },
      ]);

      await mainDb.mergePackDatabase(enPath);
      await mainDb.mergePackDatabase(pliPath);

      // Remove only English
      await mainDb.removePackData('mn', 'en');

      final remaining = await mainDb
          .customSelect("SELECT uid, language FROM texts WHERE uid = 'mn1'")
          .get();
      expect(remaining.length, 1);
      expect(remaining.first.read<String>('language'), 'pli');
    });

    test('FTS5 indexes both languages and can search each', () async {
      final enPath = p.join(tempDir.path, 'mn_en.db');
      final pliPath = p.join(tempDir.path, 'mn_pli.db');

      await buildPackDb(enPath, [
        {
          'uid': 'mn10',
          'title': 'Mindfulness Discourse',
          'nikaya': 'mn',
          'language': 'en',
          'translator': 'sujato',
          'content_plain': 'Four foundations of mindfulness.',
        },
      ]);
      await buildPackDb(pliPath, [
        {
          'uid': 'mn10',
          'title': 'Satipaṭṭhānasutta',
          'nikaya': 'mn',
          'language': 'pli',
          'translator': 'ms',
          'content_plain': 'Cattāro satipaṭṭhānā.',
        },
      ]);

      await mainDb.mergePackDatabase(enPath);
      await mainDb.mergePackDatabase(pliPath);
      await mainDb.customStatement(
          "INSERT INTO texts_fts(texts_fts) VALUES('rebuild')");

      // Search English
      final enResults = await mainDb
          .customSelect(
              "SELECT uid FROM texts_fts WHERE texts_fts MATCH 'mindfulness'")
          .get();
      expect(enResults.length, greaterThan(0));

      // Search Pāli (with diacritic removal)
      final pliResults = await mainDb
          .customSelect(
              "SELECT uid FROM texts_fts WHERE texts_fts MATCH 'satipatthana*'")
          .get();
      expect(pliResults.length, greaterThan(0));
    });
  });
}
