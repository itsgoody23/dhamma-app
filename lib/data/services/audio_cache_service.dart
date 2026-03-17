import 'dart:io';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../database/app_database.dart';
import '../models/audio_track.dart';

/// Downloads and caches audio files locally with LRU eviction.
class AudioCacheService {
  AudioCacheService(this._db, {int maxCacheMb = 500})
      : _maxCacheBytes = maxCacheMb * 1024 * 1024;

  final AppDatabase _db;
  final int _maxCacheBytes;
  final Dio _dio = Dio();

  /// Returns a local file path for [track], downloading if needed.
  Future<String?> getOrDownload(AudioTrack track) async {
    // Check if already cached
    final existing = await _db.customSelect(
      'SELECT file_path FROM audio_cache_entries WHERE track_id = ?',
      variables: [Variable(track.id)],
    ).getSingleOrNull();

    if (existing != null) {
      final path = existing.read<String>('file_path');
      if (File(path).existsSync()) {
        // Update last_played_at for LRU
        await _db.customStatement(
          'UPDATE audio_cache_entries SET last_played_at = CURRENT_TIMESTAMP '
          'WHERE track_id = ?',
          [track.id],
        );
        return path;
      }
      // File missing — remove stale entry
      await _db.customStatement(
        'DELETE FROM audio_cache_entries WHERE track_id = ?',
        [track.id],
      );
    }

    // Download
    try {
      final dir = await _cacheDir();
      final ext = p.extension(track.url).split('?').first;
      final filePath = p.join(dir.path, '${track.id}$ext');

      await _dio.download(track.url, filePath);

      final file = File(filePath);
      final sizeBytes = await file.length();

      // Insert cache entry
      await _db.customStatement(
        'INSERT OR REPLACE INTO audio_cache_entries '
        '(track_id, file_path, size_bytes, cached_at, last_played_at) '
        'VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
        [track.id, filePath, sizeBytes],
      );

      // Evict if over limit
      await _evictIfNeeded();

      return filePath;
    } catch (_) {
      return null;
    }
  }

  /// Total bytes used by audio cache.
  Future<int> totalCacheSize() async {
    final row = await _db.customSelect(
      'SELECT COALESCE(SUM(size_bytes), 0) AS total FROM audio_cache_entries',
    ).getSingle();
    return row.read<int>('total');
  }

  /// Clear the entire audio cache.
  Future<void> clearCache() async {
    final entries = await _db.customSelect(
      'SELECT file_path FROM audio_cache_entries',
    ).get();
    for (final entry in entries) {
      final path = entry.read<String>('file_path');
      try {
        await File(path).delete();
      } catch (_) {}
    }
    await _db.customStatement('DELETE FROM audio_cache_entries');
  }

  /// Check if a track is cached.
  Future<bool> isCached(String trackId) async {
    final row = await _db.customSelect(
      'SELECT 1 FROM audio_cache_entries WHERE track_id = ? LIMIT 1',
      variables: [Variable(trackId)],
    ).getSingleOrNull();
    return row != null;
  }

  // ── Private ──────────────────────────────────────────────────────────────

  Future<Directory> _cacheDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(appDir.path, 'audio_cache'));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  /// Remove least-recently-played entries until we're under the limit.
  Future<void> _evictIfNeeded() async {
    var total = await totalCacheSize();
    if (total <= _maxCacheBytes) return;

    // Get entries sorted by last_played_at ascending (oldest first)
    final entries = await _db.customSelect(
      'SELECT track_id, file_path, size_bytes FROM audio_cache_entries '
      'ORDER BY last_played_at ASC',
    ).get();

    for (final entry in entries) {
      if (total <= _maxCacheBytes) break;
      final path = entry.read<String>('file_path');
      final size = entry.read<int>('size_bytes');
      final trackId = entry.read<String>('track_id');
      try {
        await File(path).delete();
      } catch (_) {}
      await _db.customStatement(
        'DELETE FROM audio_cache_entries WHERE track_id = ?',
        [trackId],
      );
      total -= size;
    }
  }
}
