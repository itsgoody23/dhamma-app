import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
import 'tables/collections_table.dart';
import 'tables/collection_items_table.dart';
import 'tables/audio_cache_table.dart';
import 'tables/user_translations_table.dart';
import 'tables/user_commentary_table.dart';
import 'tables/pali_dictionary_table.dart';
import 'tables/reading_streaks_table.dart';
import 'daos/texts_dao.dart';
import 'daos/search_dao.dart';
import 'daos/study_tools_dao.dart';
import 'daos/progress_dao.dart';
import 'daos/packs_dao.dart';
import 'daos/collections_dao.dart';
import 'daos/user_translations_dao.dart';
import 'daos/dictionary_dao.dart';
import 'daos/streaks_dao.dart';

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
    TeacherChannels,
    DownloadedPacks,
    SearchHistory,
    DailySuttas,
    UserCollections,
    CollectionItems,
    AudioCacheEntries,
    UserTranslations,
    UserCommentary,
    PaliDictionary,
    ReadingStreaks,
  ],
  daos: [
    TextsDao,
    SearchDao,
    StudyToolsDao,
    ProgressDao,
    PacksDao,
    CollectionsDao,
    UserTranslationsDao,
    DictionaryDao,
    StreaksDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 12;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createFts5Table();
          await _createDictionaryTable();
          await _createIndexes();
          await _seedDefaultChannels();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 → v2: Add composite index for UNIQUE(uid, language)
            // to support multiple languages per sutta (e.g. English + Pāli).
            // Note: SQLite autoindex constraints cannot be dropped, so we
            // just add the new composite index alongside.
            await customStatement(
              'CREATE UNIQUE INDEX IF NOT EXISTS idx_texts_uid_language '
              'ON texts(uid, language)',
            );
          }
          if (from < 3) {
            // v2 → v3: Add sync columns (user_id, updated_at, synced_at,
            // is_deleted) to all user tables for cloud sync support.
            for (final table in [
              'user_bookmarks',
              'user_highlights',
              'user_progress',
            ]) {
              await customStatement(
                'ALTER TABLE $table ADD COLUMN user_id TEXT',
              );
              await customStatement(
                'ALTER TABLE $table ADD COLUMN updated_at '
                'DATETIME DEFAULT CURRENT_TIMESTAMP',
              );
              await customStatement(
                'ALTER TABLE $table ADD COLUMN synced_at DATETIME',
              );
              await customStatement(
                'ALTER TABLE $table ADD COLUMN is_deleted '
                'INTEGER NOT NULL DEFAULT 0',
              );
            }
            // user_notes already has updated_at
            await customStatement(
              'ALTER TABLE user_notes ADD COLUMN user_id TEXT',
            );
            await customStatement(
              'ALTER TABLE user_notes ADD COLUMN synced_at DATETIME',
            );
            await customStatement(
              'ALTER TABLE user_notes ADD COLUMN is_deleted '
              'INTEGER NOT NULL DEFAULT 0',
            );
            // Backfill updated_at from created_at for existing rows
            for (final table in [
              'user_bookmarks',
              'user_highlights',
              'user_progress',
            ]) {
              await customStatement(
                'UPDATE $table SET updated_at = created_at '
                'WHERE updated_at IS NULL',
              );
            }
            // Note: SQLite autoindex constraints (sqlite_autoindex_*)
            // cannot be dropped. The old single-column unique constraints
            // remain but don't cause issues — new composite uniqueness
            // is enforced by the select-then-insert pattern in DAOs.
          }
          if (from < 4) {
            // v3 → v4: Add language column to highlights so offsets are
            // language-specific (needed for side-by-side Pali/English view).
            await customStatement(
              'ALTER TABLE user_highlights '
              "ADD COLUMN language TEXT NOT NULL DEFAULT 'en'",
            );
          }
          if (from < 5) {
            // v4 → v5: Add note column to highlights for per-highlight annotations.
            await customStatement(
              'ALTER TABLE user_highlights ADD COLUMN note TEXT',
            );
          }
          if (from < 6) {
            // v5 → v6: Add text_type column to texts table for commentary support.
            await customStatement(
              "ALTER TABLE texts ADD COLUMN text_type TEXT NOT NULL DEFAULT 'root'",
            );
            // Add version column to downloaded_packs for update detection.
            await customStatement(
              'ALTER TABLE downloaded_packs ADD COLUMN version TEXT',
            );
          }
          if (from < 7) {
            // v6 → v7: Add collections + collection_items tables.
            await customStatement('''
              CREATE TABLE IF NOT EXISTS user_collections (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                description TEXT NOT NULL DEFAULT '',
                colour TEXT NOT NULL DEFAULT '#4A7C59',
                user_id TEXT,
                created_at DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                updated_at DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                synced_at DATETIME,
                is_deleted INTEGER NOT NULL DEFAULT 0
              )
            ''');
            await customStatement('''
              CREATE TABLE IF NOT EXISTS collection_items (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                collection_id INTEGER NOT NULL REFERENCES user_collections(id),
                sutta_uid TEXT NOT NULL,
                sort_order INTEGER NOT NULL DEFAULT 0,
                user_id TEXT,
                added_at DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                updated_at DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                synced_at DATETIME,
                is_deleted INTEGER NOT NULL DEFAULT 0,
                UNIQUE (collection_id, sutta_uid)
              )
            ''');
          }
          if (from < 8) {
            // v7 → v8: Add audio_cache_entries table for offline audio.
            await customStatement('''
              CREATE TABLE IF NOT EXISTS audio_cache_entries (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                track_id TEXT NOT NULL UNIQUE,
                file_path TEXT NOT NULL,
                size_bytes INTEGER NOT NULL,
                cached_at DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                last_played_at DATETIME
              )
            ''');
          }
          if (from < 9) {
            // v8 → v9: Add user_translations + user_commentary tables.
            await customStatement('''
              CREATE TABLE IF NOT EXISTS user_translations (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                sutta_uid TEXT NOT NULL,
                language TEXT NOT NULL DEFAULT 'en',
                verse_ref TEXT,
                content TEXT NOT NULL,
                user_id TEXT,
                created_at DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                updated_at DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                synced_at DATETIME,
                is_deleted INTEGER NOT NULL DEFAULT 0,
                UNIQUE (sutta_uid, verse_ref, language)
              )
            ''');
            await customStatement('''
              CREATE TABLE IF NOT EXISTS user_commentary (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                sutta_uid TEXT NOT NULL,
                verse_ref TEXT NOT NULL,
                content TEXT NOT NULL,
                user_id TEXT,
                created_at DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                updated_at DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                synced_at DATETIME,
                is_deleted INTEGER NOT NULL DEFAULT 0,
                UNIQUE (sutta_uid, verse_ref)
              )
            ''');
          }
          if (from < 10) {
            // v9 → v10: Add pali_dictionary table + FTS5 for dictionary feature.
            await _createDictionaryTable();
          }
          if (from < 11) {
            // v10 → v11: Add teacher_channels table for configurable YouTube channels.
            await customStatement('''
              CREATE TABLE IF NOT EXISTS teacher_channels (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                channel_id TEXT NOT NULL UNIQUE,
                platform TEXT NOT NULL DEFAULT 'youtube',
                thumbnail_url TEXT,
                is_default INTEGER NOT NULL DEFAULT 0,
                added_at DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                sort_order INTEGER NOT NULL DEFAULT 0
              )
            ''');
            await _seedDefaultChannels();
          }
          if (from < 12) {
            // v11 → v12: Add reading_streaks table for streak tracking.
            await customStatement('''
              CREATE TABLE IF NOT EXISTS reading_streaks (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                date TEXT NOT NULL UNIQUE,
                minutes_read INTEGER NOT NULL DEFAULT 0,
                suttas_read INTEGER NOT NULL DEFAULT 0
              )
            ''');
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA journal_mode=WAL');
          await customStatement('PRAGMA foreign_keys=ON');
          await customStatement('PRAGMA cache_size = -8000');
          await customStatement('PRAGMA journal_size_limit = 1048576');
          await _applySeedIfNeeded();
          await _seedDictionaryIfNeeded();
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

  Future<void> _createDictionaryTable() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS pali_dictionary (
        id          INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        entry       TEXT NOT NULL,
        grammar     TEXT,
        definition  TEXT NOT NULL,
        cross_refs  TEXT
      )
    ''');
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_pali_dictionary_entry '
      'ON pali_dictionary(entry)',
    );
    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS pali_dictionary_fts USING fts5(
        entry,
        definition,
        content='pali_dictionary',
        content_rowid='id',
        tokenize='unicode61 remove_diacritics 1'
      )
    ''');
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS pali_dictionary_ai AFTER INSERT ON pali_dictionary BEGIN
        INSERT INTO pali_dictionary_fts(rowid, entry, definition)
        VALUES (new.id, new.entry, new.definition);
      END
    ''');
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS pali_dictionary_ad AFTER DELETE ON pali_dictionary BEGIN
        INSERT INTO pali_dictionary_fts(pali_dictionary_fts, rowid, entry, definition)
        VALUES ('delete', old.id, old.entry, old.definition);
      END
    ''');
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS pali_dictionary_au AFTER UPDATE ON pali_dictionary BEGIN
        INSERT INTO pali_dictionary_fts(pali_dictionary_fts, rowid, entry, definition)
        VALUES ('delete', old.id, old.entry, old.definition);
        INSERT INTO pali_dictionary_fts(rowid, entry, definition)
        VALUES (new.id, new.entry, new.definition);
      END
    ''');
  }

  /// Seeds the default teacher channels on fresh install or migration.
  Future<void> _seedDefaultChannels() async {
    const channels = [
      ('Ajahn Brahm', 'UCLbSGYbpKcFMbVcBiGQGOBg', 0),
      ('Bhikkhu Bodhi', 'UCCRXOn6Tsrgm9gJR4z3qLZA', 1),
      ('Dhammatalks.org', 'UC6FSq_ptJ-I6ANUS8WjBe0g', 2),
      ('Ajahn Sona', 'UCWrY7DwM1VnFRYzopROQW4Q', 3),
      ('Yuttadhammo Bhikkhu', 'UCQJ6ESCWQotBwtJm0Ff_gyQ', 4),
    ];
    for (final (name, channelId, order) in channels) {
      await customStatement(
        'INSERT OR IGNORE INTO teacher_channels '
        '(name, channel_id, is_default, sort_order) VALUES (?, ?, 1, ?)',
        [name, channelId, order],
      );
    }
  }

  /// Seeds the pali_dictionary table from the bundled asset on first launch.
  Future<void> _seedDictionaryIfNeeded() async {
    const doneKey = 'dictionary_seed_applied_v1';
    try {
      debugPrint('[Dictionary] _seedDictionaryIfNeeded: checking prefs...');
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(doneKey) ?? false) {
        debugPrint('[Dictionary] Seed already applied (pref flag set), skipping.');
        return;
      }

      final count =
          await customSelect('SELECT COUNT(*) AS c FROM pali_dictionary')
              .getSingle();
      final existingRows = count.read<int>('c');
      debugPrint('[Dictionary] Existing pali_dictionary row count: $existingRows');
      if (existingRows > 0) {
        debugPrint('[Dictionary] Table already populated, marking done and skipping.');
        await prefs.setBool(doneKey, true);
        return;
      }

      debugPrint('[Dictionary] Seeding dictionary...');
      final docsDir = await getApplicationDocumentsDirectory();
      final dictDest = p.join(docsDir.path, 'dhamma_dictionary_seed.db');

      ByteData bytes;
      try {
        bytes = await rootBundle.load('assets/db/dhamma_dictionary.db');
      } catch (assetError, assetSt) {
        debugPrint(
          '[Dictionary] ERROR: Failed to load asset '
          '"assets/db/dhamma_dictionary.db": $assetError\n$assetSt',
        );
        rethrow;
      }
      final byteLength = bytes.lengthInBytes;
      debugPrint('[Dictionary] Dictionary asset loaded: $byteLength bytes');

      try {
        await File(dictDest).writeAsBytes(
          bytes.buffer.asUint8List(bytes.offsetInBytes, byteLength),
          flush: true,
        );
        debugPrint('[Dictionary] Asset written to temp file: $dictDest');
      } catch (writeError, writeSt) {
        debugPrint(
          '[Dictionary] ERROR: Failed to write seed file to "$dictDest": '
          '$writeError\n$writeSt',
        );
        rethrow;
      }

      await customStatement('ATTACH DATABASE ? AS dictdb', [dictDest]);
      try {
        await customStatement('''
          INSERT OR IGNORE INTO main.pali_dictionary
            (id, entry, grammar, definition, cross_refs)
          SELECT id, entry, grammar, definition, cross_refs
          FROM dictdb.pali_dictionary
        ''');
      } finally {
        await customStatement('DETACH DATABASE dictdb');
      }

      // Rebuild the FTS5 index so searches work immediately.
      await customStatement(
        "INSERT INTO pali_dictionary_fts(pali_dictionary_fts) VALUES('rebuild')",
      );

      final seededCount =
          await customSelect('SELECT COUNT(*) AS c FROM pali_dictionary')
              .getSingle();
      final seededRows = seededCount.read<int>('c');
      debugPrint('[Dictionary] Dictionary seeded: $seededRows rows (FTS rebuilt)');

      final f = File(dictDest);
      if (await f.exists()) await f.delete();
      await prefs.setBool(doneKey, true);
      debugPrint('[Dictionary] Seeding complete.');
    } catch (e, st) {
      debugPrint('[Dictionary] Dictionary seed failed: $e\n$st');
    }
  }

  /// Seeds the daily_suttas table from the bundled asset DB on first launch.
  Future<void> _applySeedIfNeeded() async {
    const doneKey = 'seed_applied_v1';
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(doneKey) ?? false) return;

      // Check if already seeded (e.g. from a previous partial run).
      final count = await customSelect('SELECT COUNT(*) AS c FROM daily_suttas')
          .getSingle();
      if (count.read<int>('c') > 0) {
        await prefs.setBool(doneKey, true);
        return;
      }

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
    } catch (e, st) {
      // Non-fatal: daily sutta feature degrades gracefully if seed fails.
      debugPrint('Seed failed: $e\n$st');
    }
  }

  /// Claim all orphaned local rows (user_id IS NULL) for [userId].
  /// Called once after the user's first sign-in so existing offline
  /// data gets associated with their account and synced.
  Future<void> claimLocalData(String userId) async {
    for (final table in [
      'user_bookmarks',
      'user_highlights',
      'user_notes',
      'user_progress',
      'user_translations',
      'user_commentary',
    ]) {
      await customStatement(
        'UPDATE $table SET user_id = ? WHERE user_id IS NULL',
        [userId],
      );
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

    // Rebuild FTS index so newly merged texts are searchable immediately.
    await customStatement(
      "INSERT INTO texts_fts(texts_fts) VALUES('rebuild')",
    );

    // Notify Drift stream watchers that tables have changed so providers
    // (e.g. nikaya lists, search) pick up new rows without an app restart.
    markTablesUpdated({texts, translations, translators});
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
