import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import '../database/app_database.dart';

/// A translation package bundles user translations into a portable JSON file
/// that can be exported, shared, and imported by other users.
///
/// Package format:
/// ```json
/// {
///   "format": "dhamma_translation_package",
///   "version": 1,
///   "meta": {
///     "author": "...",
///     "description": "...",
///     "language": "en",
///     "created_at": "ISO8601"
///   },
///   "translations": [
///     {"sutta_uid": "mn1", "verse_ref": null, "content": "..."},
///     ...
///   ],
///   "commentary": [
///     {"sutta_uid": "mn1", "verse_ref": "verse 1", "content": "..."},
///     ...
///   ]
/// }
/// ```
class TranslationPackageService {
  TranslationPackageService({required this.db});

  final AppDatabase db;

  /// Export all user translations and commentary as a JSON package.
  /// Returns the file path of the exported package.
  Future<String> exportPackage({
    String author = 'Anonymous',
    String description = '',
    String language = 'en',
    List<String>? filterUids,
  }) async {
    final translations = filterUids != null
        ? await db.userTranslationsDao.getTranslationsForUids(filterUids)
        : await db.userTranslationsDao.getAllTranslations();

    final commentary = await db.userTranslationsDao.getAllCommentary();

    final filteredCommentary = filterUids != null
        ? commentary.where((c) => filterUids.contains(c.suttaUid)).toList()
        : commentary;

    final package = {
      'format': 'dhamma_translation_package',
      'version': 1,
      'meta': {
        'author': author,
        'description': description,
        'language': language,
        'translation_count': translations.length,
        'commentary_count': filteredCommentary.length,
        'created_at': DateTime.now().toIso8601String(),
      },
      'translations': translations
          .map((t) => {
                'sutta_uid': t.suttaUid,
                'verse_ref': t.verseRef,
                'content': t.content,
              })
          .toList(),
      'commentary': filteredCommentary
          .map((c) => {
                'sutta_uid': c.suttaUid,
                'verse_ref': c.verseRef,
                'content': c.content,
              })
          .toList(),
    };

    final dir = await getTemporaryDirectory();
    final timestamp =
        DateTime.now().toIso8601String().replaceAll(RegExp(r'[:]'), '-');
    final fileName = 'dhamma_translations_$timestamp.json';
    final file = File(p.join(dir.path, fileName));
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(package),
    );
    return file.path;
  }

  /// Export and share via system share sheet.
  Future<void> exportAndShare({
    String author = 'Anonymous',
    String description = '',
    String language = 'en',
    List<String>? filterUids,
  }) async {
    final filePath = await exportPackage(
      author: author,
      description: description,
      language: language,
      filterUids: filterUids,
    );
    await Share.shareXFiles(
      [XFile(filePath)],
      subject: 'Dhamma Translation Package',
    );
  }

  /// Import a translation package from a JSON file path.
  /// Returns the number of translations and commentary imported.
  Future<({int translations, int commentary})> importPackage(
      String filePath) async {
    final file = File(filePath);
    final content = await file.readAsString();
    return importPackageFromJson(content);
  }

  /// Import from raw JSON string.
  Future<({int translations, int commentary})> importPackageFromJson(
      String jsonString) async {
    final data = json.decode(jsonString) as Map<String, dynamic>;

    // Validate format
    if (data['format'] != 'dhamma_translation_package') {
      throw FormatException('Invalid package format: ${data['format']}');
    }

    final version = data['version'] as int? ?? 1;
    if (version > 1) {
      throw FormatException('Unsupported package version: $version');
    }

    final translations =
        (data['translations'] as List<dynamic>?) ?? [];
    final commentary =
        (data['commentary'] as List<dynamic>?) ?? [];

    int translationCount = 0;
    int commentaryCount = 0;

    for (final t in translations) {
      final map = t as Map<String, dynamic>;
      await db.userTranslationsDao.upsertTranslation(
        suttaUid: map['sutta_uid'] as String,
        content: map['content'] as String,
        language:
            (data['meta'] as Map<String, dynamic>?)?['language'] as String? ??
                'en',
        verseRef: map['verse_ref'] as String?,
      );
      translationCount++;
    }

    for (final c in commentary) {
      final map = c as Map<String, dynamic>;
      await db.userTranslationsDao.upsertCommentary(
        suttaUid: map['sutta_uid'] as String,
        verseRef: map['verse_ref'] as String,
        content: map['content'] as String,
      );
      commentaryCount++;
    }

    return (translations: translationCount, commentary: commentaryCount);
  }

  /// Preview a package without importing it.
  /// Returns metadata about the package contents.
  static Map<String, dynamic> previewPackage(String jsonString) {
    final data = json.decode(jsonString) as Map<String, dynamic>;
    if (data['format'] != 'dhamma_translation_package') {
      throw const FormatException('Invalid package format');
    }
    return data['meta'] as Map<String, dynamic>? ?? {};
  }
}
