import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/texts_table.dart';
import '../tables/search_history_table.dart';
import '../../models/search_result.dart';

part 'search_dao.g.dart';

@DriftAccessor(tables: [Texts, SearchHistory])
class SearchDao extends DatabaseAccessor<AppDatabase> with _$SearchDaoMixin {
  SearchDao(super.db);

  /// Full-text search using SQLite FTS5.
  ///
  /// Appends `*` for prefix matching so "mindful" matches "mindfulness".
  /// The `unicode61 remove_diacritics 1` tokenizer (set at DB creation) ensures
  /// "satipatthana" matches "satipaṭṭhāna".
  Future<List<SearchResult>> search(
    String rawQuery, {
    String? language,
    String? nikaya,
    String? translator,
    int limit = 50,
    int offset = 0,
  }) async {
    if (rawQuery.trim().isEmpty) return [];

    // Sanitise and append prefix wildcard
    final query = '${rawQuery.trim().replaceAll('"', '""')}*';

    // Build WHERE clauses for optional filters
    final filterClauses = StringBuffer();
    final args = <Object?>[query];

    if (language != null) {
      filterClauses.write(' AND t.language = ?');
      args.add(language);
    }
    if (nikaya != null) {
      filterClauses.write(' AND t.nikaya = ?');
      args.add(nikaya);
    }
    if (translator != null) {
      filterClauses.write(' AND t.translator = ?');
      args.add(translator);
    }

    args.add(limit);
    args.add(offset);

    final sql = '''
      SELECT
        t.id,
        t.uid,
        t.title,
        t.nikaya,
        t.language,
        t.translator,
        t.book,
        t.chapter,
        snippet(texts_fts, 2, '<b>', '</b>', '…', 20) AS snippet
      FROM texts_fts
      JOIN texts t ON t.id = texts_fts.rowid
      WHERE texts_fts MATCH ?$filterClauses
      ORDER BY rank
      LIMIT ? OFFSET ?
    ''';

    final rows = await customSelect(
      sql,
      variables: args.map(Variable.new).toList(),
      readsFrom: {texts},
    ).get();

    return rows
        .map(
          (row) => SearchResult(
            uid: row.read<String>('uid'),
            title: row.read<String>('title'),
            nikaya: row.read<String>('nikaya'),
            language: row.read<String>('language'),
            translator: row.readNullable<String>('translator'),
            book: row.readNullable<String>('book'),
            chapter: row.readNullable<String>('chapter'),
            snippet: row.readNullable<String>('snippet') ?? '',
          ),
        )
        .toList();
  }

  // ── Search history ────────────────────────────────────────────────────────

  Future<void> saveSearchTerm(String term) async {
    final now = DateTime.now();
    await into(searchHistory).insert(
      SearchHistoryCompanion.insert(
        query: term,
        searchedAt: Value(now),
      ),
      onConflict: DoUpdate(
        (old) => SearchHistoryCompanion(searchedAt: Value(now)),
        target: [searchHistory.query],
      ),
    );
    // Keep only the 20 most recent queries
    await customStatement('''
      DELETE FROM search_history
      WHERE id NOT IN (
        SELECT id FROM search_history ORDER BY searched_at DESC LIMIT 20
      )
    ''');
  }

  Stream<List<SearchHistoryData>> watchSearchHistory() {
    return (select(searchHistory)
          ..orderBy([(t) => OrderingTerm.desc(t.searchedAt)])
          ..limit(20))
        .watch();
  }

  Future<void> deleteSearchTerm(int id) =>
      (delete(searchHistory)..where((t) => t.id.equals(id))).go();

  Future<void> clearSearchHistory() => delete(searchHistory).go();
}
