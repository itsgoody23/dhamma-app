import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/user_bookmarks_table.dart';
import '../tables/user_highlights_table.dart';
import '../tables/user_notes_table.dart';

part 'study_tools_dao.g.dart';

@DriftAccessor(
  tables: [UserBookmarks, UserHighlights, UserNotes],
)
class StudyToolsDao extends DatabaseAccessor<AppDatabase>
    with _$StudyToolsDaoMixin {
  StudyToolsDao(super.db);

  // ── Bookmarks ─────────────────────────────────────────────────────────────

  Future<void> toggleBookmark(String textUid, {String label = ''}) async {
    final existing = await (select(userBookmarks)
          ..where((b) => b.textUid.equals(textUid)))
        .getSingleOrNull();
    if (existing != null) {
      await (delete(userBookmarks)..where((b) => b.textUid.equals(textUid)))
          .go();
    } else {
      await into(userBookmarks).insert(
        UserBookmarksCompanion.insert(textUid: textUid, label: Value(label)),
      );
    }
  }

  Future<bool> isBookmarked(String textUid) async {
    final row = await (select(userBookmarks)
          ..where((b) => b.textUid.equals(textUid)))
        .getSingleOrNull();
    return row != null;
  }

  Stream<bool> watchIsBookmarked(String textUid) {
    return (select(userBookmarks)..where((b) => b.textUid.equals(textUid)))
        .watchSingleOrNull()
        .map((row) => row != null);
  }

  Stream<List<UserBookmark>> watchAllBookmarks() {
    return (select(userBookmarks)
          ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
        .watch();
  }

  Future<void> updateBookmarkLabel(int id, String label) {
    return (update(userBookmarks)..where((b) => b.id.equals(id)))
        .write(UserBookmarksCompanion(label: Value(label)));
  }

  Future<void> deleteBookmark(int id) =>
      (delete(userBookmarks)..where((b) => b.id.equals(id))).go();

  // ── Highlights ────────────────────────────────────────────────────────────

  Future<void> saveHighlight({
    required String textUid,
    required int startOffset,
    required int endOffset,
    required String colour,
  }) {
    return into(userHighlights).insert(
      UserHighlightsCompanion.insert(
        textUid: textUid,
        startOffset: startOffset,
        endOffset: endOffset,
        colour: colour,
      ),
    );
  }

  Stream<List<UserHighlight>> watchHighlightsForUid(String textUid) {
    return (select(userHighlights)
          ..where((h) => h.textUid.equals(textUid))
          ..orderBy([(h) => OrderingTerm.asc(h.startOffset)]))
        .watch();
  }

  Stream<List<UserHighlight>> watchAllHighlights() {
    return (select(userHighlights)
          ..orderBy([(h) => OrderingTerm.desc(h.createdAt)]))
        .watch();
  }

  Future<void> deleteHighlight(int id) =>
      (delete(userHighlights)..where((h) => h.id.equals(id))).go();

  // ── Notes ─────────────────────────────────────────────────────────────────

  Future<void> upsertNote(String textUid, String content) {
    final now = DateTime.now();
    return into(userNotes).insert(
      UserNotesCompanion.insert(
        textUid: textUid,
        content: content,
        updatedAt: Value(now),
      ),
      onConflict: DoUpdate(
        (old) => UserNotesCompanion(
          content: Value(content),
          updatedAt: Value(now),
        ),
        target: [userNotes.textUid],
      ),
    );
  }

  Stream<UserNote?> watchNoteForUid(String textUid) {
    return (select(userNotes)..where((n) => n.textUid.equals(textUid)))
        .watchSingleOrNull();
  }

  Stream<List<UserNote>> watchAllNotes() {
    return (select(userNotes)
          ..orderBy([
            (n) => OrderingTerm.desc(n.updatedAt),
            (n) => OrderingTerm.desc(n.id),
          ]))
        .watch();
  }

  Future<void> deleteNote(int id) =>
      (delete(userNotes)..where((n) => n.id.equals(id))).go();
}
