import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Service that loads audio manifests (chanting, meditation, talks) with
/// support for over-the-air (OTA) updates. On each call it checks for a
/// locally-cached updated version first, falling back to the bundled asset.
///
/// Call [fetchUpdates] on app start (or periodically) to pull the latest
/// manifests from a remote URL when connectivity is available.
class ContentManifestService {
  ContentManifestService._();
  static final instance = ContentManifestService._();

  /// Base URL where updated manifests are hosted.
  /// Set to empty string to disable OTA updates.
  static const String _remoteBase = ''; // e.g. 'https://cdn.dhamma.app/audio'

  /// Load a manifest by name. Prefers a locally-cached OTA version,
  /// falls back to the bundled asset.
  Future<dynamic> loadManifest(String filename) async {
    // 1. Try locally-cached OTA version
    final localPath = await _localPath(filename);
    final localFile = File(localPath);
    if (localFile.existsSync()) {
      try {
        final content = await localFile.readAsString();
        return json.decode(content);
      } catch (e) {
        debugPrint('[ContentManifest] Error reading local $filename: $e');
        // Fall through to bundled asset
      }
    }

    // 2. Fall back to bundled asset
    final assetStr = await rootBundle.loadString('assets/audio/$filename');
    return json.decode(assetStr);
  }

  /// Fetch updated manifests from the remote server.
  /// Safe to call without network — failures are silently ignored.
  Future<void> fetchUpdates() async {
    if (_remoteBase.isEmpty) return;

    for (final filename in [
      'chanting_manifest.json',
      'meditation_manifest.json',
      'talks_manifest.json',
    ]) {
      try {
        await _fetchAndCache(filename);
      } catch (e) {
        debugPrint('[ContentManifest] Failed to update $filename: $e');
      }
    }
  }

  Future<void> _fetchAndCache(String filename) async {
    final url = '$_remoteBase/$filename';
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close().timeout(
            const Duration(seconds: 10),
          );
      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        // Validate it's valid JSON before caching
        json.decode(body);
        final localPath = await _localPath(filename);
        await File(localPath).writeAsString(body, flush: true);
        debugPrint('[ContentManifest] Updated $filename');
      }
    } finally {
      client.close();
    }
  }

  Future<String> _localPath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, 'manifests', filename);
  }
}
