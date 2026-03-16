import '../database/app_database.dart';

/// Thin repository over [TextsDao] and [TranslationsDao].
/// Features that need sutta data depend on this, not on the DAO directly —
/// making it straightforward to swap the underlying source in tests.
class SuttaRepository {
  const SuttaRepository(this._db);

  final AppDatabase _db;

  Stream<List<String>> watchNikayas() => _db.textsDao.watchNikayas();

  Stream<List<String?>> watchBooksForNikaya(String nikaya) =>
      _db.textsDao.watchBooksForNikaya(nikaya);

  Stream<List<String?>> watchChaptersForBook(String nikaya, String book) =>
      _db.textsDao.watchChaptersForBook(nikaya, book);

  Stream<List<SuttaText>> watchSuttasForChapter({
    required String nikaya,
    String? book,
    String? chapter,
    String language = 'en',
  }) =>
      _db.textsDao.watchSuttasForChapter(
        nikaya: nikaya,
        book: book,
        chapter: chapter,
        language: language,
      );

  Future<SuttaText?> getSuttaByUid(String uid, String language) =>
      _db.textsDao.getSuttaByUid(uid, language);

  Future<SuttaText?> getSuttaByUidFallback(String uid) =>
      _db.textsDao.getSuttaByUidAnyLanguage(uid);

  Future<List<Translation>> getTranslationsForUid(String uid) =>
      _db.textsDao.getTranslationsForUid(uid);

  Future<List<String>> getLanguagesForUid(String uid) =>
      _db.textsDao.getLanguagesForUid(uid);

  Future<int> countSuttasInNikaya(String nikaya, String language) =>
      _db.textsDao.countSuttasInNikaya(nikaya, language);
}
