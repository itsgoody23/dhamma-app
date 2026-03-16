import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/seed_service.dart';

import 'tables/texts_table.dart';
import 'tables/translations_table.dart';
import 'tables/translators_table.dart';
import 'tables/user_bookmarks_table.dart';
import 'tables/user_highlights_table.dart';
import 'tables/user_notes_table.dart';
import 'tables/user_progress_table.dart';
import 'tables/video_cache_table.dart';
import 'tables/downloaded_packs_table.dart';
import 'tables/search_history_table.dart';
import 'tables/daily_suttas_table.dart';
import 'daos/texts_dao.dart';
import 'daos/search_dao.dart';
import 'daos/study_tools_dao.dart';
import 'daos/progress_dao.dart';
import 'daos/packs_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Texts,
    Translations,
    Translators,
    UserBookmarks,
    UserHighlights,
    UserNotes,
    UserProgress,
    VideoCache,
    DownloadedPacks,
    SearchHistory,
    DailySuttas,
  ],
  daos: [
    TextsDao,
    SearchDao,
    StudyToolsDao,
    ProgressDao,
    PacksDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createFts5Table();
          await _createIndexes();
        },
        onUpgrade: (m, from, to) async {
          // Future migrations go here
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA journal_mode=WAL');
          await customStatement('PRAGMA foreign_keys=ON');
          await _applySeedIfNeeded();
        },
      );

  Future<void> _createFts5Table() async {
    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS texts_fts USING fts5(
        uid      UNINDEXED,
        title,
        content_plain,
        content='texts',
        content_rowid='id',
        tokenize='unicode61 remove_diacritics 1'
      )
    ''');

    // Triggers to keep FTS5 in sync with the texts table
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS texts_ai AFTER INSERT ON texts BEGIN
        INSERT INTO texts_fts(rowid, uid, title, content_plain)
        VALUES (new.id, new.uid, new.title, new.content_plain);
      END
    ''');
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS texts_ad AFTER DELETE ON texts BEGIN
        INSERT INTO texts_fts(texts_fts, rowid, uid, title, content_plain)
        VALUES ('delete', old.id, old.uid, old.title, old.content_plain);
      END
    ''');
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS texts_au AFTER UPDATE ON texts BEGIN
        INSERT INTO texts_fts(texts_fts, rowid, uid, title, content_plain)
        VALUES ('delete', old.id, old.uid, old.title, old.content_plain);
        INSERT INTO texts_fts(rowid, uid, title, content_plain)
        VALUES (new.id, new.uid, new.title, new.content_plain);
      END
    ''');
  }

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_texts_nikaya ON texts(nikaya)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_texts_language ON texts(language)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_texts_uid ON texts(uid)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_texts_nikaya_lang ON texts(nikaya, language)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_progress_uid ON user_progress(text_uid)',
    );
  }

  /// Seeds the daily_suttas table from the bundled asset DB on first launch.
  Future<void> _applySeedIfNeeded() async {
    const doneKey = 'seed_applied_v1';
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(doneKey) ?? false) return;

      // Extract the asset to a temp on-disk file so ATTACH can open it.
      final seedPath = await SeedService.extractIfNeeded();

      await customStatement('ATTACH DATABASE ? AS seed', [seedPath]);
      try {
        await customStatement('''
          INSERT OR IGNORE INTO main.daily_suttas
            (id, day_of_year, uid, title, verse_excerpt, nikaya)
          SELECT id, day_of_year, uid, title, verse_excerpt, nikaya
          FROM seed.daily_suttas
        ''');
      } finally {
        await customStatement('DETACH DATABASE seed');
      }

      await SeedService.cleanup();
      await prefs.setBool(doneKey, true);
    } catch (e) {
      // Non-fatal: daily sutta feature degrades gracefully if seed fails.
      // The extracted file (if any) is cleaned up on next launch.
    }
  }

  /// Merge rows from a downloaded pack database into this database.
  /// [packDbPath] must be the path to an uncompressed, ATTACHED-compatible SQLite file.
  Future<void> mergePackDatabase(String packDbPath) async {
    await customStatement('ATTACH DATABASE ? AS pack', [packDbPath]);
    try {
      // Exclude autoIncrement id to avoid primary key conflicts between packs.
      await customStatement('''
        INSERT OR IGNORE INTO main.texts
          (uid, title, collection, nikaya, book, chapter, language,
           translator, source, content_html, content_plain)
        SELECT uid, title, collection, nikaya, book, chapter, language,
               translator, source, content_html, content_plain
        FROM pack.texts
      ''');
      await customStatement('''
        INSERT OR IGNORE INTO main.translations
          (text_uid, language, translator, source, content_html, content_plain)
        SELECT text_uid, language, translator, source, content_html, content_plain
        FROM pack.translations
      ''');
      await customStatement('''
        INSERT OR IGNORE INTO main.translators
          (name, tradition, bio, source_url)
        SELECT name, tradition, bio, source_url
        FROM pack.translators
      ''');
    } finally {
      await customStatement('DETACH DATABASE pack');
    }
  }

  /// Remove all texts belonging to a given content pack (identified by nikaya + language).
  Future<void> removePackData(String nikaya, String language) async {
    await customStatement(
      'DELETE FROM texts WHERE nikaya = ? AND language = ?',
      [nikaya, language],
    );
    await customStatement(
      'DELETE FROM translations WHERE text_uid IN '
      '(SELECT uid FROM texts WHERE nikaya = ? AND language = ?)',
      [nikaya, language],
    );
  }

  /// Run VACUUM to reclaim space after pack deletion.
  Future<void> vacuum() async {
    await customStatement('VACUUM');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'dhamma_app.db'));
    return NativeDatabase.createInBackground(file, logStatements: false);
  });
}
