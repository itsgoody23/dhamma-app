// Integration test: study tools round-trip (bookmark, highlight, note).
//
// Exercises the full flow: seed a sutta → bookmark it → add highlight →
// add note → verify all persisted → delete each → verify removed.

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dhamma_app/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('full study tools round-trip: bookmark → highlight → note → delete all',
      () async {
    const uid = 'mn10';

    // Seed a sutta
    await db.customStatement('''
      INSERT INTO texts (uid, title, nikaya, language, source, content_html, content_plain)
      VALUES ('mn10', 'Satipaṭṭhāna Sutta', 'mn', 'en', 'sc',
              '<p>There is one way.</p>', 'There is one way.')
    ''');

    // ── Bookmark ──────────────────────────────────────────────────────────

    // Create
    await db.studyToolsDao.toggleBookmark(uid, label: 'Must re-read');
    expect(await db.studyToolsDao.isBookmarked(uid), isTrue);

    final bookmarks = await db.studyToolsDao.watchAllBookmarks().first;
    expect(bookmarks.length, 1);
    expect(bookmarks.first.label, 'Must re-read');

    // ── Highlight ─────────────────────────────────────────────────────────

    await db.studyToolsDao.saveHighlight(
      textUid: uid,
      startOffset: 0,
      endOffset: 18,
      colour: '#FFD700',
    );
    final highlights = await db.studyToolsDao.watchHighlightsForUid(uid).first;
    expect(highlights.length, 1);
    expect(highlights.first.startOffset, 0);
    expect(highlights.first.endOffset, 18);

    // ── Note ──────────────────────────────────────────────────────────────

    await db.studyToolsDao.upsertNote(uid, 'Key sutta on mindfulness');
    final note = await db.studyToolsDao.watchNoteForUid(uid).first;
    expect(note, isNotNull);
    expect(note!.content, 'Key sutta on mindfulness');

    // Update note
    await db.studyToolsDao.upsertNote(uid, 'Updated: very important sutta');
    final updatedNote = await db.studyToolsDao.watchNoteForUid(uid).first;
    expect(updatedNote!.content, 'Updated: very important sutta');

    // ── Cleanup ───────────────────────────────────────────────────────────

    // Remove bookmark
    await db.studyToolsDao.toggleBookmark(uid);
    expect(await db.studyToolsDao.isBookmarked(uid), isFalse);

    // Remove highlight
    final hl = (await db.studyToolsDao.watchHighlightsForUid(uid).first).first;
    await db.studyToolsDao.deleteHighlight(hl.id);
    final afterHl = await db.studyToolsDao.watchHighlightsForUid(uid).first;
    expect(afterHl, isEmpty);

    // Remove note
    final allNotes = await db.studyToolsDao.watchAllNotes().first;
    await db.studyToolsDao.deleteNote(allNotes.first.id);
    final afterNote = await db.studyToolsDao.watchNoteForUid(uid).first;
    expect(afterNote, isNull);
  });

  test('progress tracking persists reading position', () async {
    const uid = 'sn22.59';

    // Seed a sutta
    await db.customStatement('''
      INSERT INTO texts (uid, title, nikaya, language, source, content_plain)
      VALUES ('sn22.59', 'Anattalakkhaṇa Sutta', 'sn', 'en', 'sc', 'Form is not self.')
    ''');

    // Record reading progress
    await db.progressDao.upsertProgress(textUid: uid, lastPosition: 450);
    final progress = await db.progressDao.getProgressForUid(uid);
    expect(progress, isNotNull);
    expect(progress!.lastPosition, 450);

    // Update progress
    await db.progressDao.upsertProgress(textUid: uid, lastPosition: 850);
    final updated = await db.progressDao.getProgressForUid(uid);
    expect(updated!.lastPosition, 850);

    // Mark as completed
    await db.progressDao
        .upsertProgress(textUid: uid, lastPosition: 1000, completed: true);
    final completed = await db.progressDao.getProgressForUid(uid);
    expect(completed!.completed, isTrue);
  });
}
