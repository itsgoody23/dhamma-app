import '../database/app_database.dart';

class StudyToolsRepository {
  const StudyToolsRepository(this._db);

  final AppDatabase _db;

  // Bookmarks
  Future<void> toggleBookmark(String textUid, {String label = ''}) =>
      _db.studyToolsDao.toggleBookmark(textUid, label: label);

  Future<bool> isBookmarked(String textUid) =>
      _db.studyToolsDao.isBookmarked(textUid);

  Stream<bool> watchIsBookmarked(String textUid) =>
      _db.studyToolsDao.watchIsBookmarked(textUid);

  Stream<List<UserBookmark>> watchAllBookmarks() =>
      _db.studyToolsDao.watchAllBookmarks();

  Future<void> updateBookmarkLabel(int id, String label) =>
      _db.studyToolsDao.updateBookmarkLabel(id, label);

  Future<void> deleteBookmark(int id) => _db.studyToolsDao.deleteBookmark(id);

  // Highlights
  Future<void> saveHighlight({
    required String textUid,
    required int startOffset,
    required int endOffset,
    required String colour,
  }) =>
      _db.studyToolsDao.saveHighlight(
        textUid: textUid,
        startOffset: startOffset,
        endOffset: endOffset,
        colour: colour,
      );

  Stream<List<UserHighlight>> watchHighlightsForUid(String textUid) =>
      _db.studyToolsDao.watchHighlightsForUid(textUid);

  Stream<List<UserHighlight>> watchAllHighlights() =>
      _db.studyToolsDao.watchAllHighlights();

  Future<void> deleteHighlight(int id) => _db.studyToolsDao.deleteHighlight(id);

  // Notes
  Future<void> upsertNote(String textUid, String content) =>
      _db.studyToolsDao.upsertNote(textUid, content);

  Stream<UserNote?> watchNoteForUid(String textUid) =>
      _db.studyToolsDao.watchNoteForUid(textUid);

  Stream<List<UserNote>> watchAllNotes() => _db.studyToolsDao.watchAllNotes();

  Future<void> deleteNote(int id) => _db.studyToolsDao.deleteNote(id);
}
