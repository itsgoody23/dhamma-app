import '../database/app_database.dart';
import '../models/search_result.dart';

class SearchRepository {
  const SearchRepository(this._db);

  final AppDatabase _db;

  Future<List<SearchResult>> search(
    String query, {
    String? language,
    String? nikaya,
    String? translator,
  }) =>
      _db.searchDao.search(
        query,
        language: language,
        nikaya: nikaya,
        translator: translator,
      );

  Future<void> saveSearchTerm(String term) =>
      _db.searchDao.saveSearchTerm(term);

  Stream<List<String>> watchSearchHistory() =>
      _db.searchDao.watchSearchHistory().map(
            (rows) => rows.map((r) => r.query).toList(),
          );

  Future<void> clearSearchHistory() => _db.searchDao.clearSearchHistory();
}
