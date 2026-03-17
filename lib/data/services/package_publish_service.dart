import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Represents a community translation package.
class TranslationPackage {
  const TranslationPackage({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.authorName,
    required this.language,
    required this.translationCount,
    required this.commentaryCount,
    required this.packageJson,
    required this.downloads,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TranslationPackage.fromJson(Map<String, dynamic> json) {
    return TranslationPackage(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      authorName: json['author_name'] as String? ?? 'Anonymous',
      language: json['language'] as String? ?? 'en',
      translationCount: json['translation_count'] as int? ?? 0,
      commentaryCount: json['commentary_count'] as int? ?? 0,
      packageJson: json['package_json'] is String
          ? jsonDecode(json['package_json'] as String) as Map<String, dynamic>
          : json['package_json'] as Map<String, dynamic>,
      downloads: json['downloads'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  final int id;
  final String userId;
  final String title;
  final String description;
  final String authorName;
  final String language;
  final int translationCount;
  final int commentaryCount;
  final Map<String, dynamic> packageJson;
  final int downloads;
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// Service for publishing and browsing community translation packages.
class PackagePublishService {
  PackagePublishService(this._client);
  final SupabaseClient _client;

  static const _table = 'translation_packages';

  /// Publish a translation package to the community.
  Future<void> publishPackage({
    required String title,
    required String description,
    required String authorName,
    required String language,
    required int translationCount,
    required int commentaryCount,
    required Map<String, dynamic> packageJson,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Must be signed in to publish');

    await _client.from(_table).insert({
      'user_id': userId,
      'title': title,
      'description': description,
      'author_name': authorName,
      'language': language,
      'translation_count': translationCount,
      'commentary_count': commentaryCount,
      'package_json': packageJson,
    });
  }

  /// Browse community packages with optional filters.
  Future<List<TranslationPackage>> browsePackages({
    String? language,
    String orderBy = 'created_at',
    bool ascending = false,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = _client.from(_table).select();

    if (language != null) {
      query = query.eq('language', language);
    }

    try {
      final data = await query
          .order(orderBy, ascending: ascending)
          .range(offset, offset + limit - 1)
          .timeout(const Duration(seconds: 10));

      return data.map((e) => TranslationPackage.fromJson(e)).toList();
    } on TimeoutException {
      debugPrint('[PackagePublishService] browsePackages timed out');
      return [];
    }
  }

  /// Get a single package by ID.
  Future<TranslationPackage?> getPackageById(int id) async {
    final data =
        await _client.from(_table).select().eq('id', id).maybeSingle();
    if (data == null) return null;
    return TranslationPackage.fromJson(data);
  }

  /// Get packages published by the current user.
  Future<List<TranslationPackage>> getMyPackages() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final data = await _client
        .from(_table)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return data.map((e) => TranslationPackage.fromJson(e)).toList();
  }

  /// Delete a package (author only — RLS enforced).
  Future<void> deletePackage(int id) async {
    await _client.from(_table).delete().eq('id', id);
  }

  /// Increment the download counter.
  Future<void> incrementDownloads(int id) async {
    await _client.rpc('increment_downloads', params: {'package_id': id});
  }
}
