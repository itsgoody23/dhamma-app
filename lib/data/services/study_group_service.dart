import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudyGroup {
  const StudyGroup({
    required this.id,
    required this.name,
    this.description,
    required this.creatorId,
    required this.inviteCode,
    required this.createdAt,
    this.memberCount = 0,
  });

  final int id;
  final String name;
  final String? description;
  final String creatorId;
  final String inviteCode;
  final DateTime createdAt;
  final int memberCount;

  factory StudyGroup.fromJson(Map<String, dynamic> json) {
    return StudyGroup(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      creatorId: json['creator_id'] as String,
      inviteCode: json['invite_code'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class GroupReading {
  const GroupReading({
    required this.id,
    required this.groupId,
    required this.textUid,
    this.dueDate,
    required this.sortOrder,
  });

  final int id;
  final int groupId;
  final String textUid;
  final DateTime? dueDate;
  final int sortOrder;

  factory GroupReading.fromJson(Map<String, dynamic> json) {
    return GroupReading(
      id: json['id'] as int,
      groupId: json['group_id'] as int,
      textUid: json['text_uid'] as String,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

class GroupMember {
  const GroupMember({
    required this.userId,
    required this.joinedAt,
    this.displayName,
  });

  final String userId;
  final DateTime joinedAt;
  final String? displayName;
}

class StudyGroupService {
  StudyGroupService(this._client);

  final SupabaseClient _client;

  String get _userId => _client.auth.currentUser?.id ?? '';

  Future<List<StudyGroup>> getMyGroups() async {
    try {
      final memberRows = await _client
          .from('study_group_members')
          .select('group_id')
          .eq('user_id', _userId);

      final groupIds =
          (memberRows as List).map((r) => r['group_id'] as int).toList();
      if (groupIds.isEmpty) return [];

      final groupRows = await _client
          .from('study_groups')
          .select()
          .inFilter('id', groupIds)
          .order('created_at', ascending: false);

      return (groupRows as List)
          .map((e) => StudyGroup.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<StudyGroup> createGroup(String name, {String? description}) async {
    if (_userId.isEmpty) throw Exception('Sign in to create groups');

    final inviteCode = _generateInviteCode();
    final response = await _client
        .from('study_groups')
        .insert({
          'name': name,
          'description': description,
          'creator_id': _userId,
          'invite_code': inviteCode,
        })
        .select()
        .single();

    final group = StudyGroup.fromJson(response);

    // Auto-join as creator
    await _client.from('study_group_members').insert({
      'group_id': group.id,
      'user_id': _userId,
    });

    return group;
  }

  Future<StudyGroup> joinGroup(String inviteCode) async {
    if (_userId.isEmpty) throw Exception('Sign in to join groups');

    final rows = await _client
        .from('study_groups')
        .select()
        .eq('invite_code', inviteCode.trim().toUpperCase())
        .limit(1);

    if (rows.isEmpty) throw Exception('Invalid invite code');

    final group = StudyGroup.fromJson(rows.first);

    await _client.from('study_group_members').upsert({
      'group_id': group.id,
      'user_id': _userId,
    });

    return group;
  }

  Future<void> leaveGroup(int groupId) async {
    await _client
        .from('study_group_members')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', _userId);
  }

  Future<List<GroupReading>> getGroupReadings(int groupId) async {
    try {
      final rows = await _client
          .from('study_group_readings')
          .select()
          .eq('group_id', groupId)
          .order('sort_order', ascending: true);

      return (rows as List)
          .map((e) => GroupReading.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addReading(
    int groupId,
    String textUid, {
    DateTime? dueDate,
  }) async {
    final maxOrder = await _client
        .from('study_group_readings')
        .select('sort_order')
        .eq('group_id', groupId)
        .order('sort_order', ascending: false)
        .limit(1);

    final nextOrder =
        (maxOrder as List).isNotEmpty ? (maxOrder.first['sort_order'] as int) + 1 : 0;

    await _client.from('study_group_readings').insert({
      'group_id': groupId,
      'text_uid': textUid,
      'assigned_by': _userId,
      'due_date': dueDate?.toIso8601String(),
      'sort_order': nextOrder,
    });
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    return List.generate(6, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
