import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/texts_table.dart';
import '../tables/translations_table.dart';

part 'texts_dao.g.dart';

@DriftAccessor(tables: [Texts, Translations])
class TextsDao extends DatabaseAccessor<AppDatabase> with _$TextsDaoMixin {
  TextsDao(super.db);

  /// Distinct nikaya values — drives the library grid.
  Stream<List<String>> watchNikayas() {
    return (selectOnly(texts)
          ..addColumns([texts.nikaya])
          ..orderBy([OrderingTerm.asc(texts.nikaya)])
          ..groupBy([texts.nikaya]))
        .map((row) => row.read(texts.nikaya)!)
        .watch();
  }

  /// All books within a nikaya.
  Stream<List<String?>> watchBooksForNikaya(String nikaya) {
    return (selectOnly(texts)
          ..addColumns([texts.book])
          ..where(texts.nikaya.equals(nikaya))
          ..orderBy([OrderingTerm.asc(texts.book)])
          ..groupBy([texts.book]))
        .map((row) => row.read(texts.book))
        .watch();
  }

  /// All chapters within a book.
  Stream<List<String?>> watchChaptersForBook(String nikaya, String book) {
    return (selectOnly(texts)
          ..addColumns([texts.chapter])
          ..where(
            texts.nikaya.equals(nikaya) & texts.book.equals(book),
          )
          ..orderBy([OrderingTerm.asc(texts.chapter)])
          ..groupBy([texts.chapter]))
        .map((row) => row.read(texts.chapter))
        .watch();
  }

  /// All suttas in a chapter for a given language.
  Stream<List<SuttaText>> watchSuttasForChapter({
    required String nikaya,
    String? book,
    String? chapter,
    String language = 'en',
  }) {
    final query = select(texts)
      ..where(
        (t) =>
            t.nikaya.equals(nikaya) &
            t.language.equals(language) &
            (book != null ? t.book.equals(book) : const Constant(true)) &
            (chapter != null
                ? t.chapter.equals(chapter)
                : const Constant(true)),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.uid)]);
    return query.watch();
  }

  /// Fetch a single sutta by UID and language.
  Future<SuttaText?> getSuttaByUid(String uid, String language) {
    return (select(texts)
          ..where((t) => t.uid.equals(uid) & t.language.equals(language))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Fallback: any language for a given UID (used if preferred language missing).
  Future<SuttaText?> getSuttaByUidAnyLanguage(String uid) {
    return (select(texts)
          ..where((t) => t.uid.equals(uid))
          ..limit(1))
        .getSingleOrNull();
  }

  /// All translations available for a UID (for the translation picker).
  Future<List<Translation>> getTranslationsForUid(String uid) {
    return (select(translations)..where((t) => t.textUid.equals(uid))).get();
  }

  /// Available languages for a UID — used for the language selector.
  Future<List<String>> getLanguagesForUid(String uid) async {
    final rows = await (selectOnly(texts)
          ..addColumns([texts.language])
          ..where(texts.uid.equals(uid))
          ..groupBy([texts.language]))
        .map((row) => row.read(texts.language)!)
        .get();
    return rows;
  }

  /// Count of suttas per nikaya for a language — used for progress rings.
  Future<int> countSuttasInNikaya(String nikaya, String language) async {
    final count = texts.id.count();
    final query = selectOnly(texts)
      ..addColumns([count])
      ..where(texts.nikaya.equals(nikaya) & texts.language.equals(language));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }
}
