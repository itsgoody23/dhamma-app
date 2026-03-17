import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A community highlight shared by any user.
class CommunityHighlight {
  const CommunityHighlight({
    required this.id,
    required this.userId,
    required this.textUid,
    required this.startOffset,
    required this.endOffset,
    required this.colour,
    this.note,
    required this.createdAt,
  });

  factory CommunityHighlight.fromJson(Map<String, dynamic> json) {
    return CommunityHighlight(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      textUid: json['text_uid'] as String,
      startOffset: json['start_offset'] as int,
      endOffset: json['end_offset'] as int,
      colour: json['colour'] as String,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  final int id;
  final String userId;
  final String textUid;
  final int startOffset;
  final int endOffset;
  final String colour;
  final String? note;
  final DateTime createdAt;
}

/// Service for reading and writing community (public) highlights.
class CommunityService {
  CommunityService(this._client);
  final SupabaseClient _client;

  static const _table = 'public_highlights';

  /// Fetch all community highlights for a given sutta.
  /// Returns an empty list on network errors instead of crashing.
  Future<List<CommunityHighlight>> getHighlights(String textUid) async {
    try {
      final data = await _client
          .from(_table)
          .select()
          .eq('text_uid', textUid)
          .order('start_offset');

      return data.map((e) => CommunityHighlight.fromJson(e)).toList();
    } catch (e) {
      debugPrint('[CommunityService] Failed to fetch highlights: $e');
      return [];
    }
  }

  /// Share a highlight to the community.
  Future<void> shareHighlight({
    required String textUid,
    required int startOffset,
    required int endOffset,
    required String colour,
    String? note,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Must be signed in to share highlights');

    await _client.from(_table).upsert({
      'user_id': userId,
      'text_uid': textUid,
      'start_offset': startOffset,
      'end_offset': endOffset,
      'colour': colour,
      if (note != null) 'note': note,
    }, onConflict: 'user_id,text_uid,start_offset,end_offset');
  }

  /// Remove a community highlight you shared.
  Future<void> removeHighlight(int id) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    await _client.from(_table).delete().eq('id', id).eq('user_id', userId);
  }
}
