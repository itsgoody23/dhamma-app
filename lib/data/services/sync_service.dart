import 'dart:async';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';

/// Per-table sync result for UI reporting.
class TableSyncResult {
  const TableSyncResult({required this.table, this.error});
  final String table;
  final String? error;
  bool get ok => error == null;
}

/// Pushes dirty local rows to Supabase and pulls remote changes.
/// Uses last-write-wins on `updated_at` for conflict resolution.
/// Each table syncs independently with up to 3 retries + exponential backoff.
class SyncService {
  SyncService({
    required this.db,
    required this.supabase,
    required this.userId,
  });

  final AppDatabase db;
  final SupabaseClient supabase;
  final String userId;

  bool _isSyncing = false;

  /// Whether a sync is currently in progress.
  bool get isSyncing => _isSyncing;

  /// Run a full sync cycle for all user tables.
  /// Returns results per table — continues on individual table failure.
  Future<List<TableSyncResult>> syncAll() async {
    if (_isSyncing) return [];
    _isSyncing = true;
    try {
      final results = <TableSyncResult>[];
      results.add(await _syncWithRetry('user_bookmarks', _syncBookmarks));
      results.add(await _syncWithRetry('user_highlights', _syncHighlights));
      results.add(await _syncWithRetry('user_notes', _syncNotes));
      results.add(await _syncWithRetry('user_progress', _syncProgress));
      results.add(await _syncWithRetry('user_collections', _syncCollections));
      results.add(await _syncWithRetry('collection_items', _syncCollectionItems));
      results.add(await _syncWithRetry('user_translations', _syncUserTranslations));
      results.add(await _syncWithRetry('user_commentary', _syncUserCommentary));
      return results;
    } finally {
      _isSyncing = false;
    }
  }

  /// Retry a table sync up to [maxAttempts] with exponential backoff.
  Future<TableSyncResult> _syncWithRetry(
    String table,
    Future<void> Function() syncFn, {
    int maxAttempts = 3,
  }) async {
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        await syncFn();
        return TableSyncResult(table: table);
      } catch (e) {
        if (attempt == maxAttempts) {
          return TableSyncResult(table: table, error: e.toString());
        }
        // Exponential backoff: 1s, 2s, 4s...
        await Future<void>.delayed(Duration(seconds: 1 << (attempt - 1)));
      }
    }
    return TableSyncResult(table: table, error: 'Unknown error');
  }

  // ── Bookmarks ───────────────────────────────────────────────────────────

  Future<void> _syncBookmarks() async {
    const table = 'user_bookmarks';

    final dirty = await db.customSelect(
      'SELECT * FROM $table WHERE user_id = ? '
      'AND (synced_at IS NULL OR updated_at > synced_at)',
      variables: [Variable(userId)],
    ).get();

    for (final row in dirty) {
      await supabase.from(table).upsert({
        'user_id': userId,
        'text_uid': row.read<String>('text_uid'),
        'label': row.read<String>('label'),
        'is_deleted': row.read<bool>('is_deleted'),
        'created_at': row.read<DateTime>('created_at').toIso8601String(),
        'updated_at': row.read<DateTime>('updated_at').toIso8601String(),
      }, onConflict: 'user_id,text_uid');

      await db.customStatement(
        'UPDATE $table SET synced_at = ? WHERE id = ?',
        [DateTime.now().toIso8601String(), row.read<int>('id')],
      );
    }

    final lastSync = await _lastSyncTime(table);
    final remote = await supabase
        .from(table)
        .select()
        .eq('user_id', userId)
        .gt('updated_at', lastSync.toIso8601String())
        .order('updated_at');

    for (final r in remote) {
      final remoteUpdated = DateTime.parse(r['updated_at'] as String);
      final local = await db.customSelect(
        'SELECT * FROM $table WHERE user_id = ? AND text_uid = ?',
        variables: [Variable(userId), Variable(r['text_uid'] as String)],
      ).getSingleOrNull();

      if (local == null) {
        await db.customStatement(
          'INSERT INTO $table (user_id, text_uid, label, is_deleted, '
          'created_at, updated_at, synced_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
          [
            userId,
            r['text_uid'],
            r['label'],
            (r['is_deleted'] as bool) ? 1 : 0,
            r['created_at'],
            r['updated_at'],
            DateTime.now().toIso8601String(),
          ],
        );
      } else {
        final localUpdated = local.read<DateTime>('updated_at');
        if (remoteUpdated.isAfter(localUpdated)) {
          await db.customStatement(
            'UPDATE $table SET label = ?, is_deleted = ?, updated_at = ?, '
            'synced_at = ? WHERE id = ?',
            [
              r['label'],
              (r['is_deleted'] as bool) ? 1 : 0,
              r['updated_at'],
              DateTime.now().toIso8601String(),
              local.read<int>('id'),
            ],
          );
        }
      }
    }
  }

  // ── Highlights ──────────────────────────────────────────────────────────

  Future<void> _syncHighlights() async {
    const table = 'user_highlights';

    final dirty = await db.customSelect(
      'SELECT * FROM $table WHERE user_id = ? '
      'AND (synced_at IS NULL OR updated_at > synced_at)',
      variables: [Variable(userId)],
    ).get();

    for (final row in dirty) {
      await supabase.from(table).upsert({
        'user_id': userId,
        'text_uid': row.read<String>('text_uid'),
        'start_offset': row.read<int>('start_offset'),
        'end_offset': row.read<int>('end_offset'),
        'colour': row.read<String>('colour'),
        'is_deleted': row.read<bool>('is_deleted'),
        'created_at': row.read<DateTime>('created_at').toIso8601String(),
        'updated_at': row.read<DateTime>('updated_at').toIso8601String(),
      }, onConflict: 'user_id,text_uid,start_offset,end_offset');

      await db.customStatement(
        'UPDATE $table SET synced_at = ? WHERE id = ?',
        [DateTime.now().toIso8601String(), row.read<int>('id')],
      );
    }

    final lastSync = await _lastSyncTime(table);
    final remote = await supabase
        .from(table)
        .select()
        .eq('user_id', userId)
        .gt('updated_at', lastSync.toIso8601String())
        .order('updated_at');

    for (final r in remote) {
      final remoteUpdated = DateTime.parse(r['updated_at'] as String);
      final local = await db.customSelect(
        'SELECT * FROM $table WHERE user_id = ? AND text_uid = ? '
        'AND start_offset = ? AND end_offset = ?',
        variables: [
          Variable(userId),
          Variable(r['text_uid'] as String),
          Variable(r['start_offset'] as int),
          Variable(r['end_offset'] as int),
        ],
      ).getSingleOrNull();

      if (local == null) {
        await db.customStatement(
          'INSERT INTO $table (user_id, text_uid, start_offset, end_offset, '
          'colour, is_deleted, created_at, updated_at, synced_at) '
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            userId,
            r['text_uid'],
            r['start_offset'],
            r['end_offset'],
            r['colour'],
            (r['is_deleted'] as bool) ? 1 : 0,
            r['created_at'],
            r['updated_at'],
            DateTime.now().toIso8601String(),
          ],
        );
      } else {
        final localUpdated = local.read<DateTime>('updated_at');
        if (remoteUpdated.isAfter(localUpdated)) {
          await db.customStatement(
            'UPDATE $table SET colour = ?, is_deleted = ?, updated_at = ?, '
            'synced_at = ? WHERE id = ?',
            [
              r['colour'],
              (r['is_deleted'] as bool) ? 1 : 0,
              r['updated_at'],
              DateTime.now().toIso8601String(),
              local.read<int>('id'),
            ],
          );
        }
      }
    }
  }

  // ── Notes ───────────────────────────────────────────────────────────────

  Future<void> _syncNotes() async {
    const table = 'user_notes';

    final dirty = await db.customSelect(
      'SELECT * FROM $table WHERE user_id = ? '
      'AND (synced_at IS NULL OR updated_at > synced_at)',
      variables: [Variable(userId)],
    ).get();

    for (final row in dirty) {
      await supabase.from(table).upsert({
        'user_id': userId,
        'text_uid': row.read<String>('text_uid'),
        'content': row.read<String>('content'),
        'is_deleted': row.read<bool>('is_deleted'),
        'created_at': row.read<DateTime>('created_at').toIso8601String(),
        'updated_at': row.read<DateTime>('updated_at').toIso8601String(),
      }, onConflict: 'user_id,text_uid');

      await db.customStatement(
        'UPDATE $table SET synced_at = ? WHERE id = ?',
        [DateTime.now().toIso8601String(), row.read<int>('id')],
      );
    }

    final lastSync = await _lastSyncTime(table);
    final remote = await supabase
        .from(table)
        .select()
        .eq('user_id', userId)
        .gt('updated_at', lastSync.toIso8601String())
        .order('updated_at');

    for (final r in remote) {
      final remoteUpdated = DateTime.parse(r['updated_at'] as String);
      final local = await db.customSelect(
        'SELECT * FROM $table WHERE user_id = ? AND text_uid = ?',
        variables: [Variable(userId), Variable(r['text_uid'] as String)],
      ).getSingleOrNull();

      if (local == null) {
        await db.customStatement(
          'INSERT INTO $table (user_id, text_uid, content, is_deleted, '
          'created_at, updated_at, synced_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
          [
            userId,
            r['text_uid'],
            r['content'],
            (r['is_deleted'] as bool) ? 1 : 0,
            r['created_at'],
            r['updated_at'],
            DateTime.now().toIso8601String(),
          ],
        );
      } else {
        final localUpdated = local.read<DateTime>('updated_at');
        if (remoteUpdated.isAfter(localUpdated)) {
          await db.customStatement(
            'UPDATE $table SET content = ?, is_deleted = ?, updated_at = ?, '
            'synced_at = ? WHERE id = ?',
            [
              r['content'],
              (r['is_deleted'] as bool) ? 1 : 0,
              r['updated_at'],
              DateTime.now().toIso8601String(),
              local.read<int>('id'),
            ],
          );
        }
      }
    }
  }

  // ── Progress ────────────────────────────────────────────────────────────

  Future<void> _syncProgress() async {
    const table = 'user_progress';

    final dirty = await db.customSelect(
      'SELECT * FROM $table WHERE user_id = ? '
      'AND (synced_at IS NULL OR updated_at > synced_at)',
      variables: [Variable(userId)],
    ).get();

    for (final row in dirty) {
      await supabase.from(table).upsert({
        'user_id': userId,
        'text_uid': row.read<String>('text_uid'),
        'last_position': row.read<int>('last_position'),
        'completed': row.read<bool>('completed'),
        'is_deleted': row.read<bool>('is_deleted'),
        'last_read_at': row.read<DateTime>('last_read_at').toIso8601String(),
        'updated_at': row.read<DateTime>('updated_at').toIso8601String(),
      }, onConflict: 'user_id,text_uid');

      await db.customStatement(
        'UPDATE $table SET synced_at = ? WHERE id = ?',
        [DateTime.now().toIso8601String(), row.read<int>('id')],
      );
    }

    final lastSync = await _lastSyncTime(table);
    final remote = await supabase
        .from(table)
        .select()
        .eq('user_id', userId)
        .gt('updated_at', lastSync.toIso8601String())
        .order('updated_at');

    for (final r in remote) {
      final remoteUpdated = DateTime.parse(r['updated_at'] as String);
      final local = await db.customSelect(
        'SELECT * FROM $table WHERE user_id = ? AND text_uid = ?',
        variables: [Variable(userId), Variable(r['text_uid'] as String)],
      ).getSingleOrNull();

      if (local == null) {
        await db.customStatement(
          'INSERT INTO $table (user_id, text_uid, last_position, completed, '
          'is_deleted, last_read_at, updated_at, synced_at) '
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
          [
            userId,
            r['text_uid'],
            r['last_position'],
            (r['completed'] as bool) ? 1 : 0,
            (r['is_deleted'] as bool) ? 1 : 0,
            r['last_read_at'],
            r['updated_at'],
            DateTime.now().toIso8601String(),
          ],
        );
      } else {
        final localUpdated = local.read<DateTime>('updated_at');
        if (remoteUpdated.isAfter(localUpdated)) {
          await db.customStatement(
            'UPDATE $table SET last_position = ?, completed = ?, '
            'is_deleted = ?, last_read_at = ?, updated_at = ?, '
            'synced_at = ? WHERE id = ?',
            [
              r['last_position'],
              (r['completed'] as bool) ? 1 : 0,
              (r['is_deleted'] as bool) ? 1 : 0,
              r['last_read_at'],
              r['updated_at'],
              DateTime.now().toIso8601String(),
              local.read<int>('id'),
            ],
          );
        }
      }
    }
  }

  // ── Collections ──────────────────────────────────────────────────────────

  Future<void> _syncCollections() async {
    const table = 'user_collections';

    final dirty = await db.customSelect(
      'SELECT * FROM $table WHERE user_id = ? '
      'AND (synced_at IS NULL OR updated_at > synced_at)',
      variables: [Variable(userId)],
    ).get();

    for (final row in dirty) {
      await supabase.from(table).upsert({
        'user_id': userId,
        'id': row.read<int>('id'),
        'name': row.read<String>('name'),
        'description': row.read<String>('description'),
        'colour': row.read<String>('colour'),
        'is_deleted': row.read<bool>('is_deleted'),
        'created_at': row.read<DateTime>('created_at').toIso8601String(),
        'updated_at': row.read<DateTime>('updated_at').toIso8601String(),
      }, onConflict: 'user_id,id');

      await db.customStatement(
        'UPDATE $table SET synced_at = ? WHERE id = ?',
        [DateTime.now().toIso8601String(), row.read<int>('id')],
      );
    }

    final lastSync = await _lastSyncTime(table);
    final remote = await supabase
        .from(table)
        .select()
        .eq('user_id', userId)
        .gt('updated_at', lastSync.toIso8601String())
        .order('updated_at');

    for (final r in remote) {
      final remoteUpdated = DateTime.parse(r['updated_at'] as String);
      final remoteId = r['id'] as int;
      final local = await db.customSelect(
        'SELECT * FROM $table WHERE user_id = ? AND id = ?',
        variables: [Variable(userId), Variable(remoteId)],
      ).getSingleOrNull();

      if (local == null) {
        await db.customStatement(
          'INSERT OR REPLACE INTO $table (id, user_id, name, description, '
          'colour, is_deleted, created_at, updated_at, synced_at) '
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            remoteId,
            userId,
            r['name'],
            r['description'],
            r['colour'],
            (r['is_deleted'] as bool) ? 1 : 0,
            r['created_at'],
            r['updated_at'],
            DateTime.now().toIso8601String(),
          ],
        );
      } else {
        final localUpdated = local.read<DateTime>('updated_at');
        if (remoteUpdated.isAfter(localUpdated)) {
          await db.customStatement(
            'UPDATE $table SET name = ?, description = ?, colour = ?, '
            'is_deleted = ?, updated_at = ?, synced_at = ? WHERE id = ?',
            [
              r['name'],
              r['description'],
              r['colour'],
              (r['is_deleted'] as bool) ? 1 : 0,
              r['updated_at'],
              DateTime.now().toIso8601String(),
              remoteId,
            ],
          );
        }
      }
    }
  }

  // ── Collection Items ────────────────────────────────────────────────────

  Future<void> _syncCollectionItems() async {
    const table = 'collection_items';

    final dirty = await db.customSelect(
      'SELECT * FROM $table WHERE user_id = ? '
      'AND (synced_at IS NULL OR updated_at > synced_at)',
      variables: [Variable(userId)],
    ).get();

    for (final row in dirty) {
      await supabase.from(table).upsert({
        'user_id': userId,
        'collection_id': row.read<int>('collection_id'),
        'sutta_uid': row.read<String>('sutta_uid'),
        'sort_order': row.read<int>('sort_order'),
        'is_deleted': row.read<bool>('is_deleted'),
        'added_at': row.read<DateTime>('added_at').toIso8601String(),
        'updated_at': row.read<DateTime>('updated_at').toIso8601String(),
      }, onConflict: 'collection_id,sutta_uid');

      await db.customStatement(
        'UPDATE $table SET synced_at = ? WHERE id = ?',
        [DateTime.now().toIso8601String(), row.read<int>('id')],
      );
    }

    final lastSync = await _lastSyncTime(table);
    final remote = await supabase
        .from(table)
        .select()
        .eq('user_id', userId)
        .gt('updated_at', lastSync.toIso8601String())
        .order('updated_at');

    for (final r in remote) {
      final remoteUpdated = DateTime.parse(r['updated_at'] as String);
      final local = await db.customSelect(
        'SELECT * FROM $table WHERE collection_id = ? AND sutta_uid = ?',
        variables: [
          Variable(r['collection_id'] as int),
          Variable(r['sutta_uid'] as String),
        ],
      ).getSingleOrNull();

      if (local == null) {
        await db.customStatement(
          'INSERT INTO $table (collection_id, sutta_uid, sort_order, user_id, '
          'is_deleted, added_at, updated_at, synced_at) '
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
          [
            r['collection_id'],
            r['sutta_uid'],
            r['sort_order'],
            userId,
            (r['is_deleted'] as bool) ? 1 : 0,
            r['added_at'],
            r['updated_at'],
            DateTime.now().toIso8601String(),
          ],
        );
      } else {
        final localUpdated = local.read<DateTime>('updated_at');
        if (remoteUpdated.isAfter(localUpdated)) {
          await db.customStatement(
            'UPDATE $table SET sort_order = ?, is_deleted = ?, updated_at = ?, '
            'synced_at = ? WHERE id = ?',
            [
              r['sort_order'],
              (r['is_deleted'] as bool) ? 1 : 0,
              r['updated_at'],
              DateTime.now().toIso8601String(),
              local.read<int>('id'),
            ],
          );
        }
      }
    }
  }

  // ── User Translations ──────────────────────────────────────────────────

  Future<void> _syncUserTranslations() async {
    const table = 'user_translations';

    final dirty = await db.customSelect(
      'SELECT * FROM $table WHERE user_id = ? '
      'AND (synced_at IS NULL OR updated_at > synced_at)',
      variables: [Variable(userId)],
    ).get();

    for (final row in dirty) {
      await supabase.from(table).upsert({
        'user_id': userId,
        'sutta_uid': row.read<String>('sutta_uid'),
        'language': row.read<String>('language'),
        'verse_ref': row.read<String?>('verse_ref'),
        'content': row.read<String>('content'),
        'is_deleted': row.read<bool>('is_deleted'),
        'created_at': row.read<DateTime>('created_at').toIso8601String(),
        'updated_at': row.read<DateTime>('updated_at').toIso8601String(),
      }, onConflict: 'user_id,sutta_uid,verse_ref,language');

      await db.customStatement(
        'UPDATE $table SET synced_at = ? WHERE id = ?',
        [DateTime.now().toIso8601String(), row.read<int>('id')],
      );
    }

    final lastSync = await _lastSyncTime(table);
    final remote = await supabase
        .from(table)
        .select()
        .eq('user_id', userId)
        .gt('updated_at', lastSync.toIso8601String())
        .order('updated_at');

    for (final r in remote) {
      final remoteUpdated = DateTime.parse(r['updated_at'] as String);
      final local = await db.customSelect(
        'SELECT * FROM $table WHERE user_id = ? AND sutta_uid = ? '
        'AND language = ? AND verse_ref IS ?',
        variables: [
          Variable(userId),
          Variable(r['sutta_uid'] as String),
          Variable(r['language'] as String),
          Variable(r['verse_ref'] as String?),
        ],
      ).getSingleOrNull();

      if (local == null) {
        await db.customStatement(
          'INSERT INTO $table (user_id, sutta_uid, language, verse_ref, '
          'content, is_deleted, created_at, updated_at, synced_at) '
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            userId,
            r['sutta_uid'],
            r['language'],
            r['verse_ref'],
            r['content'],
            (r['is_deleted'] as bool) ? 1 : 0,
            r['created_at'],
            r['updated_at'],
            DateTime.now().toIso8601String(),
          ],
        );
      } else {
        final localUpdated = local.read<DateTime>('updated_at');
        if (remoteUpdated.isAfter(localUpdated)) {
          await db.customStatement(
            'UPDATE $table SET content = ?, is_deleted = ?, updated_at = ?, '
            'synced_at = ? WHERE id = ?',
            [
              r['content'],
              (r['is_deleted'] as bool) ? 1 : 0,
              r['updated_at'],
              DateTime.now().toIso8601String(),
              local.read<int>('id'),
            ],
          );
        }
      }
    }
  }

  // ── User Commentary ───────────────────────────────────────────────────

  Future<void> _syncUserCommentary() async {
    const table = 'user_commentary';

    final dirty = await db.customSelect(
      'SELECT * FROM $table WHERE user_id = ? '
      'AND (synced_at IS NULL OR updated_at > synced_at)',
      variables: [Variable(userId)],
    ).get();

    for (final row in dirty) {
      await supabase.from(table).upsert({
        'user_id': userId,
        'sutta_uid': row.read<String>('sutta_uid'),
        'verse_ref': row.read<String>('verse_ref'),
        'content': row.read<String>('content'),
        'is_deleted': row.read<bool>('is_deleted'),
        'created_at': row.read<DateTime>('created_at').toIso8601String(),
        'updated_at': row.read<DateTime>('updated_at').toIso8601String(),
      }, onConflict: 'user_id,sutta_uid,verse_ref');

      await db.customStatement(
        'UPDATE $table SET synced_at = ? WHERE id = ?',
        [DateTime.now().toIso8601String(), row.read<int>('id')],
      );
    }

    final lastSync = await _lastSyncTime(table);
    final remote = await supabase
        .from(table)
        .select()
        .eq('user_id', userId)
        .gt('updated_at', lastSync.toIso8601String())
        .order('updated_at');

    for (final r in remote) {
      final remoteUpdated = DateTime.parse(r['updated_at'] as String);
      final local = await db.customSelect(
        'SELECT * FROM $table WHERE user_id = ? AND sutta_uid = ? '
        'AND verse_ref = ?',
        variables: [
          Variable(userId),
          Variable(r['sutta_uid'] as String),
          Variable(r['verse_ref'] as String),
        ],
      ).getSingleOrNull();

      if (local == null) {
        await db.customStatement(
          'INSERT INTO $table (user_id, sutta_uid, verse_ref, content, '
          'is_deleted, created_at, updated_at, synced_at) '
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
          [
            userId,
            r['sutta_uid'],
            r['verse_ref'],
            r['content'],
            (r['is_deleted'] as bool) ? 1 : 0,
            r['created_at'],
            r['updated_at'],
            DateTime.now().toIso8601String(),
          ],
        );
      } else {
        final localUpdated = local.read<DateTime>('updated_at');
        if (remoteUpdated.isAfter(localUpdated)) {
          await db.customStatement(
            'UPDATE $table SET content = ?, is_deleted = ?, updated_at = ?, '
            'synced_at = ? WHERE id = ?',
            [
              r['content'],
              (r['is_deleted'] as bool) ? 1 : 0,
              r['updated_at'],
              DateTime.now().toIso8601String(),
              local.read<int>('id'),
            ],
          );
        }
      }
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  Future<DateTime> _lastSyncTime(String table) async {
    final result = await db.customSelect(
      'SELECT MAX(synced_at) as last_sync FROM $table WHERE user_id = ?',
      variables: [Variable(userId)],
    ).getSingleOrNull();
    final value = result?.read<DateTime?>('last_sync');
    return value ?? DateTime.utc(2000);
  }
}
