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

  group('StudyToolsDao — bookmarks', () {
    test('toggleBookmark creates a bookmark', () async {
      await db.studyToolsDao.toggleBookmark('mn1', label: 'My favourite');
      expect(await db.studyToolsDao.isBookmarked('mn1'), isTrue);
    });

    test('toggleBookmark removes an existing bookmark', () async {
      await db.studyToolsDao.toggleBookmark('mn1');
      await db.studyToolsDao.toggleBookmark('mn1'); // second call removes it
      expect(await db.studyToolsDao.isBookmarked('mn1'), isFalse);
    });

    test('watchAllBookmarks emits after insert', () async {
      await db.studyToolsDao.toggleBookmark('mn2', label: 'Test');
      final all = await db.studyToolsDao.watchAllBookmarks().first;
      expect(all.length, 1);
      expect(all.first.textUid, 'mn2');
    });

    test('updateBookmarkLabel changes label', () async {
      await db.studyToolsDao.toggleBookmark('mn3', label: 'Old');
      final bookmark = (await db.studyToolsDao.watchAllBookmarks().first).first;
      await db.studyToolsDao.updateBookmarkLabel(bookmark.id, 'New');
      final updated = (await db.studyToolsDao.watchAllBookmarks().first).first;
      expect(updated.label, 'New');
    });

    test('deleteBookmark removes by id', () async {
      await db.studyToolsDao.toggleBookmark('mn4');
      final bookmark = (await db.studyToolsDao.watchAllBookmarks().first).first;
      await db.studyToolsDao.deleteBookmark(bookmark.id);
      expect(await db.studyToolsDao.isBookmarked('mn4'), isFalse);
    });
  });

  group('StudyToolsDao — notes', () {
    test('upsertNote creates a note', () async {
      await db.studyToolsDao.upsertNote('mn1', 'First note');
      final note = await db.studyToolsDao.watchNoteForUid('mn1').first;
      expect(note, isNotNull);
      expect(note!.content, 'First note');
    });

    test('upsertNote does not create duplicates — updates existing', () async {
      await db.studyToolsDao.upsertNote('mn1', 'First note');
      await db.studyToolsDao.upsertNote('mn1', 'Updated note');
      final all = await db.studyToolsDao.watchAllNotes().first;
      expect(all.length, 1);
      expect(all.first.content, 'Updated note');
    });

    test('deleteNote removes the note', () async {
      await db.studyToolsDao.upsertNote('mn1', 'To delete');
      final note = (await db.studyToolsDao.watchAllNotes().first).first;
      await db.studyToolsDao.deleteNote(note.id);
      final afterDelete = await db.studyToolsDao.watchNoteForUid('mn1').first;
      expect(afterDelete, isNull);
    });

    test('watchAllNotes returns notes sorted by updatedAt descending',
        () async {
      await db.studyToolsDao.upsertNote('mn1', 'Note 1');
      await db.studyToolsDao.upsertNote('mn2', 'Note 2');
      final all = await db.studyToolsDao.watchAllNotes().first;
      // mn2 was inserted last, so it should be first
      expect(all.first.textUid, 'mn2');
    });
  });

  group('StudyToolsDao — highlights', () {
    test('saveHighlight stores a highlight', () async {
      await db.studyToolsDao.saveHighlight(
        textUid: 'mn1',
        startOffset: 10,
        endOffset: 50,
        colour: '#FFD700',
        language: 'en',
      );
      final highlights =
          await db.studyToolsDao.watchHighlightsForUid('mn1').first;
      expect(highlights.length, 1);
      expect(highlights.first.colour, '#FFD700');
    });

    test('multiple highlights on same sutta stored independently', () async {
      await db.studyToolsDao.saveHighlight(
        textUid: 'mn1',
        startOffset: 0,
        endOffset: 10,
        colour: '#FFD700',
        language: 'en',
      );
      await db.studyToolsDao.saveHighlight(
        textUid: 'mn1',
        startOffset: 20,
        endOffset: 40,
        colour: '#90EE90',
        language: 'en',
      );
      final highlights =
          await db.studyToolsDao.watchHighlightsForUid('mn1').first;
      expect(highlights.length, 2);
    });

    test('deleteHighlight removes only the specified highlight', () async {
      await db.studyToolsDao.saveHighlight(
        textUid: 'mn1',
        startOffset: 0,
        endOffset: 10,
        colour: '#FFD700',
        language: 'en',
      );
      await db.studyToolsDao.saveHighlight(
        textUid: 'mn1',
        startOffset: 20,
        endOffset: 40,
        colour: '#90EE90',
        language: 'en',
      );
      final before = await db.studyToolsDao.watchHighlightsForUid('mn1').first;
      await db.studyToolsDao.deleteHighlight(before.first.id);
      final after = await db.studyToolsDao.watchHighlightsForUid('mn1').first;
      expect(after.length, 1);
    });
  });
}
