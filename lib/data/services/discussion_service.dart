import 'package:supabase_flutter/supabase_flutter.dart';

class DiscussionComment {
  const DiscussionComment({
    required this.id,
    required this.textUid,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.parentId,
    this.displayName,
    this.replies = const [],
  });

  final int id;
  final String textUid;
  final String userId;
  final String content;
  final DateTime createdAt;
  final int? parentId;
  final String? displayName;
  final List<DiscussionComment> replies;

  factory DiscussionComment.fromJson(Map<String, dynamic> json) {
    return DiscussionComment(
      id: json['id'] as int,
      textUid: json['text_uid'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      parentId: json['parent_id'] as int?,
      displayName: json['display_name'] as String?,
    );
  }
}

class DiscussionService {
  DiscussionService(this._client);

  final SupabaseClient _client;

  Future<List<DiscussionComment>> getDiscussions(String textUid) async {
    try {
      final response = await _client
          .from('discussions')
          .select()
          .eq('text_uid', textUid)
          .eq('is_deleted', false)
          .order('created_at', ascending: true)
          .timeout(const Duration(seconds: 10));

      final allComments = (response as List)
          .map((e) => DiscussionComment.fromJson(e as Map<String, dynamic>))
          .toList();

      // Build thread tree
      final topLevel = <DiscussionComment>[];
      final childrenMap = <int, List<DiscussionComment>>{};

      for (final comment in allComments) {
        if (comment.parentId == null) {
          topLevel.add(comment);
        } else {
          (childrenMap[comment.parentId!] ??= []).add(comment);
        }
      }

      return topLevel.map((c) => DiscussionComment(
        id: c.id,
        textUid: c.textUid,
        userId: c.userId,
        content: c.content,
        createdAt: c.createdAt,
        parentId: c.parentId,
        displayName: c.displayName,
        replies: childrenMap[c.id] ?? [],
      )).toList();
    } catch (_) {
      return [];
    }
  }

  Future<int> getCommentCount(String textUid) async {
    try {
      final response = await _client
          .from('discussions')
          .select('id')
          .eq('text_uid', textUid)
          .eq('is_deleted', false)
          .count(CountOption.exact);
      return response.count;
    } catch (_) {
      return 0;
    }
  }

  Future<void> postComment(
    String textUid,
    String content, {
    int? parentId,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Sign in to post comments');

    await _client.from('discussions').insert({
      'text_uid': textUid,
      'user_id': userId,
      'content': content,
      if (parentId != null) 'parent_id': parentId,
      'display_name': _client.auth.currentUser?.userMetadata?['display_name'] ??
          _client.auth.currentUser?.email?.split('@').first ??
          'Anonymous',
    });
  }

  Future<void> deleteComment(int id) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client
        .from('discussions')
        .update({'is_deleted': true})
        .eq('id', id)
        .eq('user_id', userId);
  }
}
