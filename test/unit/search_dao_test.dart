import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dhamma_app/data/database/app_database.dart';

/// Tests for SearchDao — covering FTS5 full-text search including
/// diacritic normalisation, prefix matching, and history management.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  // ── Helpers ─────────────────────────────────────────────────────────────

  Future<void> insertTexts() async {
    await db.customStatement('''
      INSERT INTO texts (uid, title, nikaya, language, source, content_plain)
      VALUES
        ('mn10',   'Satipaṭṭhāna Sutta',              'mn', 'en', 'sc', 'Mindfulness of body, feelings, mind, and phenomena.'),
        ('mn118',  'Ānāpānasati Sutta',                'mn', 'en', 'sc', 'Mindfulness of breathing, developed and cultivated.'),
        ('sn56.11','Dhammacakkappavattana Sutta',      'sn', 'en', 'sc', 'The wheel of the Dhamma was set rolling.'),
        ('dn22',   'Mahāsatipaṭṭhāna Sutta',          'dn', 'en', 'sc', 'The great discourse on the foundations of mindfulness.'),
        ('mn1_pli','Mūlapariyāya Sutta',               'mn', 'pli','sc', 'Sabbassa mūlapariyāya kathā.')
    ''');
    // Rebuild FTS5 index
    await db
        .customStatement("INSERT INTO texts_fts(texts_fts) VALUES('rebuild')");
  }

  // ── Basic search ─────────────────────────────────────────────────────────

  test('search returns results for matching query', () async {
    await insertTexts();
    final results = await db.searchDao.search('mindfulness');
    expect(results.isNotEmpty, isTrue);
    expect(
        results
            .any((r) => r.uid.startsWith('mn10') || r.uid.startsWith('dn22')),
        isTrue);
  });

  test('search returns empty list for empty query', () async {
    await insertTexts();
    final results = await db.searchDao.search('');
    expect(results, isEmpty);
  });

  test('search returns empty list for whitespace-only query', () async {
    await insertTexts();
    final results = await db.searchDao.search('   ');
    expect(results, isEmpty);
  });

  // ── Prefix matching ──────────────────────────────────────────────────────

  test('search uses prefix matching (mindful matches mindfulness)', () async {
    await insertTexts();
    final results = await db.searchDao.search('mindful');
    // 'mindful' prefix should match 'mindfulness' in content
    expect(results.isNotEmpty, isTrue);
  });

  // ── Diacritic normalisation ──────────────────────────────────────────────

  test(
      'ASCII search matches Pali with diacritics (unicode61 remove_diacritics)',
      () async {
    await insertTexts();
    // 'satipatthana' should match 'Satipaṭṭhāna' via diacritic removal
    final results = await db.searchDao.search('satipatthana');
    expect(results.isNotEmpty, isTrue,
        reason:
            'remove_diacritics=1 should allow ASCII match for Satipaṭṭhāna');
    expect(results.any((r) => r.uid == 'mn10' || r.uid == 'dn22'), isTrue);
  });

  test('anapanasati matches Ānāpānasati', () async {
    await insertTexts();
    final results = await db.searchDao.search('anapanasati');
    expect(results.isNotEmpty, isTrue);
    expect(results.first.uid, 'mn118');
  });

  // ── Filters ──────────────────────────────────────────────────────────────

  test('search with language filter returns only that language', () async {
    await insertTexts();
    final results = await db.searchDao.search('sutta', language: 'pli');
    expect(results.isNotEmpty, isTrue);
    for (final r in results) {
      expect(r.language, 'pli');
    }
  });

  test('search with nikaya filter returns only that nikaya', () async {
    await insertTexts();
    final results = await db.searchDao.search('mindfulness', nikaya: 'mn');
    expect(results.isNotEmpty, isTrue);
    for (final r in results) {
      expect(r.nikaya, 'mn');
    }
  });

  test('search with both language and nikaya filter', () async {
    await insertTexts();
    final results =
        await db.searchDao.search('sutta', language: 'en', nikaya: 'sn');
    for (final r in results) {
      expect(r.language, 'en');
      expect(r.nikaya, 'sn');
    }
  });

  // ── Limit ────────────────────────────────────────────────────────────────

  test('search respects limit parameter', () async {
    await insertTexts();
    final results = await db.searchDao.search('sutta', limit: 2);
    expect(results.length, lessThanOrEqualTo(2));
  });

  // ── Special characters ───────────────────────────────────────────────────

  test('search sanitises double-quote characters to prevent FTS5 errors',
      () async {
    await insertTexts();
    // Should not throw — the DAO sanitises quotes
    final results = await db.searchDao.search('"mindfulness"');
    // May or may not match; what matters is no exception is thrown
    expect(results, isA<List>());
  });

  // ── Search history ────────────────────────────────────────────────────────

  test('saveSearchTerm persists and watchSearchHistory returns it', () async {
    await db.searchDao.saveSearchTerm('mindfulness');
    final history = await db.searchDao.watchSearchHistory().first;
    expect(history.isNotEmpty, isTrue);
    expect(history.first.query, 'mindfulness');
  });

  test('saveSearchTerm upserts — duplicate term updates timestamp', () async {
    await db.searchDao.saveSearchTerm('mindfulness');
    await db.searchDao.saveSearchTerm('mindfulness');
    final history = await db.searchDao.watchSearchHistory().first;
    final mindfulnessRows = history.where((h) => h.query == 'mindfulness');
    expect(mindfulnessRows.length, 1,
        reason: 'Duplicate terms should be deduped');
  });

  test('search history limited to 20 most recent', () async {
    for (int i = 0; i < 25; i++) {
      await db.searchDao.saveSearchTerm('term_$i');
    }
    final history = await db.searchDao.watchSearchHistory().first;
    expect(history.length, lessThanOrEqualTo(20));
  });

  test('deleteSearchTerm removes the entry', () async {
    await db.searchDao.saveSearchTerm('to_delete');
    final before = await db.searchDao.watchSearchHistory().first;
    final entry = before.firstWhere((h) => h.query == 'to_delete');
    await db.searchDao.deleteSearchTerm(entry.id);
    final after = await db.searchDao.watchSearchHistory().first;
    expect(after.any((h) => h.query == 'to_delete'), isFalse);
  });

  test('clearSearchHistory removes all entries', () async {
    await db.searchDao.saveSearchTerm('a');
    await db.searchDao.saveSearchTerm('b');
    await db.searchDao.clearSearchHistory();
    final history = await db.searchDao.watchSearchHistory().first;
    expect(history, isEmpty);
  });
}
