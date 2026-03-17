import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/pali_dictionary_table.dart';

part 'dictionary_dao.g.dart';

@DriftAccessor(tables: [PaliDictionary])
class DictionaryDao extends DatabaseAccessor<AppDatabase>
    with _$DictionaryDaoMixin {
  DictionaryDao(super.db);

  /// Exact match on the entry field.
  Future<PaliDictionaryEntry?> lookupWord(String word) async {
    return (select(paliDictionary)
          ..where((t) => t.entry.equals(word.trim().toLowerCase())))
        .getSingleOrNull();
  }

  /// FTS5 prefix search — returns words starting with [prefix].
  Future<List<PaliDictionaryEntry>> searchPrefix(
    String prefix, {
    int limit = 20,
  }) async {
    final query = '${prefix.trim().replaceAll('"', '""')}*';
    const sql = '''
      SELECT d.*
      FROM pali_dictionary_fts
      JOIN pali_dictionary d ON d.id = pali_dictionary_fts.rowid
      WHERE pali_dictionary_fts MATCH ?
      ORDER BY rank
      LIMIT ?
    ''';
    final rows = await customSelect(
      sql,
      variables: [Variable.withString(query), Variable.withInt(limit)],
      readsFrom: {paliDictionary},
    ).get();

    return rows.map((row) => paliDictionary.map(row.data)).toList();
  }

  /// FTS5 fuzzy search across entry and definition fields.
  Future<List<PaliDictionaryEntry>> searchFuzzy(
    String query, {
    int limit = 50,
  }) async {
    final ftsQuery = '${query.trim().replaceAll('"', '""')}*';
    const sql = '''
      SELECT d.*
      FROM pali_dictionary_fts
      JOIN pali_dictionary d ON d.id = pali_dictionary_fts.rowid
      WHERE pali_dictionary_fts MATCH ?
      ORDER BY rank
      LIMIT ?
    ''';
    final rows = await customSelect(
      sql,
      variables: [Variable.withString(ftsQuery), Variable.withInt(limit)],
      readsFrom: {paliDictionary},
    ).get();

    return rows.map((row) => paliDictionary.map(row.data)).toList();
  }
}
