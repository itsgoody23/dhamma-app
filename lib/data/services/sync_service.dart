import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';

/// Pushes dirty local rows to Supabase and pulls remote changes.
/// Uses last-write-wins on `updated_at` for conflict resolution.
class SyncService {
  SyncService({
    required this.db,
    required this.supabase,
    required this.userId,
  });

  final AppDatabase db;
  final SupabaseClient supabase;
  final String userId;

  /// Run a full sync cycle for all user tables.
  Future<void> syncAll() async {
    await _syncBookmarks();
    await _syncHighlights();
    await _syncNotes();
    await _syncProgress();
  }

  // ── Bookmarks ───────────────────────────────────────────────────────────

  Future<void> _syncBookmarks() async {
    const table = 'user_bookmarks';

    // Push dirty rows
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

    // Pull remote changes
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
