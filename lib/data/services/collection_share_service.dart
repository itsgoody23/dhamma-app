import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../database/app_database.dart';

/// JSON-based export/import for collections.
class CollectionShareService {
  CollectionShareService(this._db);
  final AppDatabase _db;

  /// Export a collection as a shareable JSON file and open the share sheet.
  Future<void> exportCollection(int collectionId) async {
    final collection =
        await _db.collectionsDao.getCollection(collectionId);
    if (collection == null) return;

    final items = await _db.collectionsDao.watchItems(collectionId).first;
    final suttaUids = items.map((i) => i.suttaUid).toList();

    final json = {
      'type': 'dhamma_collection',
      'version': 1,
      'name': collection.name,
      'description': collection.description,
      'colour': collection.colour,
      'suttas': suttaUids,
    };

    final dir = await getTemporaryDirectory();
    final safeName = collection.name
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
    final file = File('${dir.path}/collection_$safeName.json');
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(json));

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Dhamma Collection: ${collection.name}',
    );
  }

  /// Import a collection from a JSON string.
  /// Returns the new collection's ID, or null on failure.
  Future<int?> importCollection(String jsonString) async {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      if (json['type'] != 'dhamma_collection') return null;

      final name = json['name'] as String? ?? 'Imported Collection';
      final description = json['description'] as String? ?? '';
      final colour = json['colour'] as String? ?? '#4A7C59';
      final suttas = (json['suttas'] as List?)?.cast<String>() ?? [];

      final dao = _db.collectionsDao;
      final id = await dao.createCollection(
        name: name,
        description: description,
        colour: colour,
      );

      for (final uid in suttas) {
        await dao.addItem(id, uid);
      }

      return id;
    } catch (_) {
      return null;
    }
  }
}
