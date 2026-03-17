import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/user_translations_table.dart';
import '../tables/user_commentary_table.dart';

part 'user_translations_dao.g.dart';

@DriftAccessor(
  tables: [UserTranslations, UserCommentary],
)
class UserTranslationsDao extends DatabaseAccessor<AppDatabase>
    with _$UserTranslationsDaoMixin {
  UserTranslationsDao(super.db);

  // ── User Translations ───────────────────────────────────────────────────

  /// Upsert a user translation for a sutta (optionally at a specific verse).
  Future<void> upsertTranslation({
    required String suttaUid,
    required String content,
    String language = 'en',
    String? verseRef,
  }) async {
    final existing = await (select(userTranslations)
          ..where((t) =>
              t.suttaUid.equals(suttaUid) &
              t.language.equals(language) &
              (verseRef != null
                  ? t.verseRef.equals(verseRef)
                  : t.verseRef.isNull())))
        .getSingleOrNull();

    if (existing != null) {
      await (update(userTranslations)
            ..where((t) => t.id.equals(existing.id)))
          .write(UserTranslationsCompanion(
        content: Value(content),
        isDeleted: const Value(false),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      await into(userTranslations).insert(UserTranslationsCompanion(
        suttaUid: Value(suttaUid),
        language: Value(language),
        verseRef: Value(verseRef),
        content: Value(content),
      ));
    }
  }

  /// Delete a user translation (soft-delete).
  Future<void> deleteTranslation(int id) {
    return (update(userTranslations)..where((t) => t.id.equals(id))).write(
      UserTranslationsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Watch all translations for a sutta.
  Stream<List<UserTranslation>> watchTranslationsForSutta(String suttaUid) {
    return (select(userTranslations)
          ..where((t) =>
              t.suttaUid.equals(suttaUid) & t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.verseRef)]))
        .watch();
  }

  /// Get a single translation for a sutta + verse.
  Future<UserTranslation?> getTranslation(
    String suttaUid, {
    String? verseRef,
    String language = 'en',
  }) {
    return (select(userTranslations)
          ..where((t) =>
              t.suttaUid.equals(suttaUid) &
              t.language.equals(language) &
              t.isDeleted.equals(false) &
              (verseRef != null
                  ? t.verseRef.equals(verseRef)
                  : t.verseRef.isNull())))
        .getSingleOrNull();
  }

  /// Watch the full-sutta translation (verseRef is null).
  Stream<UserTranslation?> watchSuttaTranslation(
    String suttaUid, {
    String language = 'en',
  }) {
    return (select(userTranslations)
          ..where((t) =>
              t.suttaUid.equals(suttaUid) &
              t.language.equals(language) &
              t.verseRef.isNull() &
              t.isDeleted.equals(false)))
        .watchSingleOrNull();
  }

  /// Get all user translations (for export).
  Future<List<UserTranslation>> getAllTranslations() {
    return (select(userTranslations)
          ..where((t) => t.isDeleted.equals(false)))
        .get();
  }

  /// Get translations for a list of sutta UIDs.
  Future<List<UserTranslation>> getTranslationsForUids(List<String> uids) {
    return (select(userTranslations)
          ..where(
              (t) => t.suttaUid.isIn(uids) & t.isDeleted.equals(false)))
        .get();
  }

  // ── User Commentary ─────────────────────────────────────────────────────

  /// Upsert commentary for a verse.
  Future<void> upsertCommentary({
    required String suttaUid,
    required String verseRef,
    required String content,
  }) async {
    final existing = await (select(userCommentary)
          ..where((c) =>
              c.suttaUid.equals(suttaUid) & c.verseRef.equals(verseRef)))
        .getSingleOrNull();

    if (existing != null) {
      await (update(userCommentary)
            ..where((c) => c.id.equals(existing.id)))
          .write(UserCommentaryCompanion(
        content: Value(content),
        isDeleted: const Value(false),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      await into(userCommentary).insert(UserCommentaryCompanion(
        suttaUid: Value(suttaUid),
        verseRef: Value(verseRef),
        content: Value(content),
      ));
    }
  }

  /// Delete a commentary (soft-delete).
  Future<void> deleteCommentary(int id) {
    return (update(userCommentary)..where((c) => c.id.equals(id))).write(
      UserCommentaryCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Watch all commentary for a sutta.
  Stream<List<UserCommentaryData>> watchCommentaryForSutta(String suttaUid) {
    return (select(userCommentary)
          ..where((c) =>
              c.suttaUid.equals(suttaUid) & c.isDeleted.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.verseRef)]))
        .watch();
  }

  /// Get commentary for a specific verse.
  Future<UserCommentaryData?> getCommentary(
    String suttaUid,
    String verseRef,
  ) {
    return (select(userCommentary)
          ..where((c) =>
              c.suttaUid.equals(suttaUid) &
              c.verseRef.equals(verseRef) &
              c.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  /// Get all commentary (for export).
  Future<List<UserCommentaryData>> getAllCommentary() {
    return (select(userCommentary)
          ..where((c) => c.isDeleted.equals(false)))
        .get();
  }
}
