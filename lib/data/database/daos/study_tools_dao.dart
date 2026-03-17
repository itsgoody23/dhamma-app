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
          ..where((b) => b.textUid.equals(textUid) & b.isDeleted.equals(false)))
        .getSingleOrNull();
    if (existing != null) {
      // Soft-delete for sync
      await (update(userBookmarks)..where((b) => b.id.equals(existing.id)))
          .write(UserBookmarksCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      // Check for a soft-deleted row to revive
      final deleted = await (select(userBookmarks)
            ..where(
                (b) => b.textUid.equals(textUid) & b.isDeleted.equals(true)))
          .getSingleOrNull();
      if (deleted != null) {
        await (update(userBookmarks)..where((b) => b.id.equals(deleted.id)))
            .write(UserBookmarksCompanion(
          label: Value(label),
          isDeleted: const Value(false),
          updatedAt: Value(DateTime.now()),
        ));
      } else {
        await into(userBookmarks).insert(
          UserBookmarksCompanion.insert(
            textUid: textUid,
            label: Value(label),
          ),
        );
      }
    }
  }

  Future<bool> isBookmarked(String textUid) async {
    final row = await (select(userBookmarks)
          ..where((b) => b.textUid.equals(textUid) & b.isDeleted.equals(false)))
        .getSingleOrNull();
    return row != null;
  }

  Stream<bool> watchIsBookmarked(String textUid) {
    return (select(userBookmarks)
          ..where((b) => b.textUid.equals(textUid) & b.isDeleted.equals(false)))
        .watchSingleOrNull()
        .map((row) => row != null);
  }

  Stream<List<UserBookmark>> watchAllBookmarks() {
    return (select(userBookmarks)
          ..where((b) => b.isDeleted.equals(false))
          ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
        .watch();
  }

  Future<void> updateBookmarkLabel(int id, String label) {
    return (update(userBookmarks)..where((b) => b.id.equals(id))).write(
      UserBookmarksCompanion(
        label: Value(label),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteBookmark(int id) {
    return (update(userBookmarks)..where((b) => b.id.equals(id))).write(
      UserBookmarksCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ── Highlights ────────────────────────────────────────────────────────────

  Future<void> saveHighlight({
    required String textUid,
    required int startOffset,
    required int endOffset,
    required String colour,
    required String language,
  }) {
    return into(userHighlights).insert(
      UserHighlightsCompanion.insert(
        textUid: textUid,
        startOffset: startOffset,
        endOffset: endOffset,
        colour: colour,
        language: Value(language),
      ),
    );
  }

  Stream<List<UserHighlight>> watchHighlightsForUid(
    String textUid, {
    String? language,
  }) {
    return (select(userHighlights)
          ..where((h) {
            var expr = h.textUid.equals(textUid) & h.isDeleted.equals(false);
            if (language != null) {
              expr = expr & h.language.equals(language);
            }
            return expr;
          })
          ..orderBy([(h) => OrderingTerm.asc(h.startOffset)]))
        .watch();
  }

  Stream<List<UserHighlight>> watchAllHighlights() {
    return (select(userHighlights)
          ..where((h) => h.isDeleted.equals(false))
          ..orderBy([(h) => OrderingTerm.desc(h.createdAt)]))
        .watch();
  }

  Stream<List<UserHighlight>> watchHighlightsWithNotes() {
    return (select(userHighlights)
          ..where((h) =>
              h.isDeleted.equals(false) &
              h.note.isNotNull() &
              h.note.equals('').not())
          ..orderBy([(h) => OrderingTerm.desc(h.updatedAt)]))
        .watch();
  }

  Future<void> updateHighlightNote(int id, String note) {
    return (update(userHighlights)..where((h) => h.id.equals(id))).write(
      UserHighlightsCompanion(
        note: Value(note),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteHighlight(int id) {
    return (update(userHighlights)..where((h) => h.id.equals(id))).write(
      UserHighlightsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ── Notes ─────────────────────────────────────────────────────────────────

  Future<void> upsertNote(String textUid, String content) async {
    final now = DateTime.now();
    // Can't use ON CONFLICT with nullable userId (SQLite treats NULLs as distinct).
    final existing = await (select(userNotes)
          ..where((n) => n.textUid.equals(textUid) & n.userId.isNull()))
        .getSingleOrNull();
    if (existing != null) {
      await (update(userNotes)..where((n) => n.id.equals(existing.id))).write(
        UserNotesCompanion(
          content: Value(content),
          updatedAt: Value(now),
          isDeleted: const Value(false),
        ),
      );
    } else {
      await into(userNotes).insert(
        UserNotesCompanion.insert(
          textUid: textUid,
          content: content,
          updatedAt: Value(now),
        ),
      );
    }
  }

  Stream<UserNote?> watchNoteForUid(String textUid) {
    return (select(userNotes)
          ..where((n) => n.textUid.equals(textUid) & n.isDeleted.equals(false)))
        .watchSingleOrNull();
  }

  Stream<List<UserNote>> watchAllNotes() {
    return (select(userNotes)
          ..where((n) => n.isDeleted.equals(false))
          ..orderBy([
            (n) => OrderingTerm.desc(n.updatedAt),
            (n) => OrderingTerm.desc(n.id),
          ]))
        .watch();
  }

  Future<void> deleteNote(int id) {
    return (update(userNotes)..where((n) => n.id.equals(id))).write(
      UserNotesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
