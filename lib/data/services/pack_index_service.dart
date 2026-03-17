import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/content_pack.dart';

const _manifestUrl =
    'https://difjbtoydrpspabqbndl.supabase.co/storage/v1/object/public/packs/pack_manifest.json';
const _cacheFilename = 'pack_manifest_cache.json';
const _cacheTtlHours = 24;

class PackIndexService {
  final _dio = Dio();
  List<ContentPack>? _cached;

  Future<List<ContentPack>> fetchPacks({bool forceRefresh = false}) async {
    if (!forceRefresh && _cached != null) return _cached!;

    // Try in-memory, then disk cache, then network
    final diskCache = await _loadDiskCache();
    if (!forceRefresh && diskCache != null) {
      _cached = diskCache;
      return _cached!;
    }

    try {
      final response = await _dio.get<String>(_manifestUrl);
      final json = jsonDecode(response.data!) as Map<String, dynamic>;
      final packs = (json['packs'] as List)
          .map((e) => ContentPack.fromJson(e as Map<String, dynamic>))
          .toList();
      _cached = packs;
      await _saveDiskCache(response.data!);
      return packs;
    } catch (e) {
      // Return disk cache even if stale, rather than failing
      if (diskCache != null) return diskCache;
      return [];
    }
  }

  Future<List<ContentPack>?> _loadDiskCache() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, _cacheFilename));
      if (!await file.exists()) return null;

      final stat = await file.stat();
      final age = DateTime.now().difference(stat.modified);
      if (age.inHours > _cacheTtlHours) return null;

      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      return (json['packs'] as List)
          .map((e) => ContentPack.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveDiskCache(String content) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, _cacheFilename));
      await file.writeAsString(content);
    } catch (_) {}
  }

  /// Check if a remote pack has a newer version than what's installed locally.
  bool hasUpdate({
    required ContentPack remotePack,
    required String? installedVersion,
  }) {
    final remoteVersion = remotePack.version;
    if (remoteVersion == null || installedVersion == null) return false;
    return remoteVersion != installedVersion;
  }
}
