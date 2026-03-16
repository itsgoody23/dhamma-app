import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Extracts the bundled seed SQLite DB from assets to a known on-disk path.
///
/// The actual row-copy (ATTACH + INSERT + DETACH) is performed inside
/// [AppDatabase.migration.beforeOpen] so it runs within the already-open
/// connection — avoiding a second, conflicting DB handle.
class SeedService {
  static const String assetPath = 'assets/db/dhamma_seed.db';

  /// Returns the destination path for the extracted seed DB.
  /// Does NOT extract — call [extractSeedDb] for that.
  static Future<String> seedDbPath() async {
    final docsDir = await getApplicationDocumentsDirectory();
    return p.join(docsDir.path, 'dhamma_seed.db');
  }

  /// Copies the bundled seed asset to [seedDbPath] if it isn't there yet.
  /// The [AppDatabase] reads this path inside [beforeOpen] to run the merge.
  static Future<String> extractIfNeeded() async {
    final dest = await seedDbPath();
    if (File(dest).existsSync()) return dest; // already extracted

    final bytes = await rootBundle.load(assetPath);
    await File(dest).writeAsBytes(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
      flush: true,
    );
    return dest;
  }

  /// Deletes the extracted seed DB file once the merge is complete.
  /// Call this after [AppDatabase] has successfully imported the rows.
  static Future<void> cleanup() async {
    final dest = await seedDbPath();
    final file = File(dest);
    if (await file.exists()) await file.delete();
  }
}
