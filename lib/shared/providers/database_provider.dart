import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';

/// Global singleton database — kept alive for the lifetime of the app.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
