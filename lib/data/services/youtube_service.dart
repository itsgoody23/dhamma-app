import 'dart:async';

import 'package:drift/drift.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../database/app_database.dart';
import '../models/audio_track.dart';

/// A saved teacher channel from the database.
class TeacherChannel {
  const TeacherChannel({
    required this.id,
    required this.name,
    required this.channelId,
    required this.isDefault,
    this.thumbnailUrl,
    required this.sortOrder,
  });

  final int id;
  final String name;
  final String channelId;
  final bool isDefault;
  final String? thumbnailUrl;
  final int sortOrder;
}

/// Service for browsing and extracting audio from YouTube Dhamma talks.
class YoutubeService {
  YoutubeService(this._db);

  final AppDatabase _db;
  final YoutubeExplode _yt = YoutubeExplode();

  // ── Channel management ──────────────────────────────────────────────────

  /// Get all teacher channels from the database, ordered by sort_order.
  Future<List<TeacherChannel>> getChannels() async {
    final rows = await _db.customSelect(
      'SELECT * FROM teacher_channels ORDER BY sort_order ASC',
    ).get();
    return rows
        .map((row) => TeacherChannel(
              id: row.read<int>('id'),
              name: row.read<String>('name'),
              channelId: row.read<String>('channel_id'),
              isDefault: row.read<bool>('is_default'),
              thumbnailUrl: row.read<String?>('thumbnail_url'),
              sortOrder: row.read<int>('sort_order'),
            ))
        .toList();
  }

  /// Resolve a YouTube channel URL or ID and add it to the database.
  /// Returns the new [TeacherChannel], or throws if the channel can't be resolved.
  Future<TeacherChannel> addChannel(String channelInput) async {
    // Strip query parameters (e.g. ?si=...) that break channel resolution.
    var cleanInput = channelInput.trim();
    final uri = Uri.tryParse(cleanInput);
    if (uri != null && uri.hasScheme) {
      cleanInput = uri.replace(query: '', fragment: '').toString();
      // Remove trailing '?' left after clearing the query string.
      if (cleanInput.endsWith('?')) {
        cleanInput = cleanInput.substring(0, cleanInput.length - 1);
      }
    }

    final channel = await _yt.channels.get(cleanInput);
    final name = channel.title;
    final channelId = channel.id.value;
    final thumbUrl = channel.logoUrl;

    final maxRow = await _db
        .customSelect('SELECT MAX(sort_order) AS m FROM teacher_channels')
        .getSingle();
    final nextOrder = (maxRow.read<int?>('m') ?? -1) + 1;

    await _db.customStatement(
      'INSERT OR IGNORE INTO teacher_channels '
      '(name, channel_id, thumbnail_url, is_default, sort_order) '
      'VALUES (?, ?, ?, 0, ?)',
      [name, channelId, thumbUrl, nextOrder],
    );

    return TeacherChannel(
      id: 0,
      name: name,
      channelId: channelId,
      isDefault: false,
      thumbnailUrl: thumbUrl,
      sortOrder: nextOrder,
    );
  }

  /// Remove a user-added channel (not a default).
  Future<void> removeChannel(String channelId) async {
    await _db.customStatement(
      'DELETE FROM teacher_channels WHERE channel_id = ? AND is_default = 0',
      [channelId],
    );
  }

  // ── Search & browse ─────────────────────────────────────────────────────

  /// Search YouTube for Dhamma talks.
  Future<List<AudioTrack>> search(String query, {int limit = 20}) async {
    final results = await _yt.search.search('$query Buddhist Dhamma');
    final tracks = <AudioTrack>[];
    for (final video in results.take(limit)) {
      final track = _videoToTrack(video);
      tracks.add(track);
      await _cacheVideoMeta(video);
    }
    return tracks;
  }

  /// Get talks from a specific teacher's channel.
  Future<List<AudioTrack>> getChannelTalks(String channelId,
      {int limit = 20}) async {
    final tracks = <AudioTrack>[];
    var count = 0;
    try {
      await for (final video in _yt.channels
          .getUploads(ChannelId(channelId))
          .timeout(const Duration(seconds: 10))) {
        if (count >= limit) break;
        tracks.add(_videoToTrack(video));
        await _cacheVideoMeta(video);
        count++;
      }
    } on TimeoutException {
      // Stream stalled – return whatever was collected.
    }
    return tracks;
  }

  /// Get the audio-only stream URL for a video.
  Future<String> getAudioStreamUrl(String youtubeId) async {
    final manifest = await _yt.videos.streamsClient.getManifest(youtubeId);
    final audioStream = manifest.audioOnly.withHighestBitrate();
    return audioStream.url.toString();
  }

  /// Get cached talks from the local database.
  Future<List<AudioTrack>> getCachedTalks({String? teacher}) async {
    final whereClause = teacher != null ? 'WHERE teacher = ?' : '';
    final variables =
        teacher != null ? [Variable<String>(teacher)] : <Variable<Object>>[];
    final rows = await _db.customSelect(
      'SELECT * FROM video_cache $whereClause ORDER BY cached_at DESC',
      variables: variables,
    ).get();

    return rows
        .map((row) => AudioTrack(
              id: 'yt-${row.read<String>('youtube_id')}',
              title: row.read<String>('title'),
              url: '',
              type: AudioTrackType.talk,
              teacher: row.read<String?>('teacher'),
              duration: row.read<int?>('duration_seconds') != null
                  ? Duration(seconds: row.read<int>('duration_seconds'))
                  : null,
              suttaUid: row.read<String?>('sutta_uid'),
              thumbnailUrl: row.read<String?>('thumbnail_url'),
            ))
        .toList();
  }

  void dispose() => _yt.close();

  // ── Private ──────────────────────────────────────────────────────────────

  AudioTrack _videoToTrack(Video video) => AudioTrack(
        id: 'yt-${video.id.value}',
        title: video.title,
        url: '',
        type: AudioTrackType.talk,
        teacher: video.author,
        duration: video.duration,
        thumbnailUrl: video.thumbnails.mediumResUrl,
      );

  Future<void> _cacheVideoMeta(Video video) async {
    await _db.customStatement(
      'INSERT OR REPLACE INTO video_cache '
      '(youtube_id, title, teacher, duration_seconds, thumbnail_url, cached_at) '
      'VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)',
      [
        video.id.value,
        video.title,
        video.author,
        video.duration?.inSeconds,
        video.thumbnails.mediumResUrl,
      ],
    );
  }
}
