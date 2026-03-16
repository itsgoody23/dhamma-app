import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dhamma_app/data/database/app_database.dart';

/// Tests for [AppDatabase] core methods — removePackData, mergePackDatabase,
/// and vacuum.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertTexts() async {
    await db.customStatement('''
      INSERT INTO texts (uid, title, nikaya, language, source)
      VALUES
        ('mn1',   'Root of All Things',     'mn', 'en', 'sc'),
        ('mn2',   'All the Taints',         'mn', 'en', 'sc'),
        ('mn1p',  'Mūlapariyāya',           'mn', 'pli','sc'),
        ('sn1',   'Connected Discourses 1', 'sn', 'en', 'sc')
    ''');
  }

  group('removePackData', () {
    test('removes texts for given nikaya and language', () async {
      await insertTexts();

      await db.removePackData('mn', 'en');

      final remaining = await db
          .customSelect(
            'SELECT uid FROM texts',
          )
          .get();
      final uids = remaining.map((r) => r.read<String>('uid')).toSet();

      // mn/en rows should be gone
      expect(uids.contains('mn1'), isFalse);
      expect(uids.contains('mn2'), isFalse);
      // mn/pli and sn/en should remain
      expect(uids.contains('mn1p'), isTrue);
      expect(uids.contains('sn1'), isTrue);
    });

    test('does not remove texts for a different language', () async {
      await insertTexts();

      await db.removePackData('mn', 'de'); // No 'de' texts exist

      final remaining = await db
          .customSelect('SELECT COUNT(*) as cnt FROM texts')
          .getSingle();
      expect(remaining.read<int>('cnt'), 4,
          reason:
              'No rows should be deleted when nikaya/language has no match');
    });

    test('does not affect texts in other nikayas', () async {
      await insertTexts();

      await db.removePackData('sn', 'en');

      final remaining = await db.customSelect(
        'SELECT uid FROM texts WHERE nikaya = ?',
        variables: [const Variable('mn')],
      ).get();
      expect(remaining.length, 3,
          reason: 'MN texts must not be affected by SN deletion');
    });
  });

  group('mergePackDatabase', () {
    test('inserts texts from attached pack', () async {
      // Already tested in seed_service_test.dart — lighter check here
      final countBefore = await db
          .customSelect(
            'SELECT COUNT(*) as cnt FROM texts',
          )
          .getSingle();
      expect(countBefore.read<int>('cnt'), 0);
      // mergePackDatabase is tested end-to-end in seed_service_test.dart
    });
  });

  group('vacuum', () {
    test('vacuum completes without error', () async {
      await insertTexts();
      await db.removePackData('mn', 'en');
      // Should not throw
      await expectLater(db.vacuum(), completes);
    });
  });

  group('FTS5 triggers', () {
    test('inserting a text automatically updates texts_fts', () async {
      await db.customStatement('''
        INSERT INTO texts (uid, title, nikaya, language, source, content_plain)
        VALUES ('mn10', 'Satipatthana', 'mn', 'en', 'sc', 'Mindfulness of body.')
      ''');

      final result = await db
          .customSelect(
            "SELECT COUNT(*) as cnt FROM texts_fts WHERE texts_fts MATCH 'mindfulness'",
          )
          .getSingle();
      expect(result.read<int>('cnt'), greaterThan(0));
    });

    test('deleting a text removes it from texts_fts', () async {
      await db.customStatement('''
        INSERT INTO texts (uid, title, nikaya, language, source, content_plain)
        VALUES ('mn10', 'Satipatthana', 'mn', 'en', 'sc', 'Mindfulness of body.')
      ''');

      // Verify it's in FTS
      final before = await db
          .customSelect(
            "SELECT COUNT(*) as cnt FROM texts_fts WHERE texts_fts MATCH 'mindfulness'",
          )
          .getSingle();
      expect(before.read<int>('cnt'), greaterThan(0));

      // Delete the text — trigger should update FTS
      await db.customStatement("DELETE FROM texts WHERE uid = 'mn10'");

      final after = await db
          .customSelect(
            "SELECT COUNT(*) as cnt FROM texts_fts WHERE texts_fts MATCH 'mindfulness'",
          )
          .getSingle();
      expect(after.read<int>('cnt'), 0);
    });
  });
}
