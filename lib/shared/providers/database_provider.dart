import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';

/// Global singleton database — kept alive for the lifetime of the app.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Stream providers for study tools — must be top-level for stable identity.
final allBookmarksProvider = StreamProvider<List<UserBookmark>>((ref) {
  return ref.watch(appDatabaseProvider).studyToolsDao.watchAllBookmarks();
});

final allHighlightsProvider = StreamProvider<List<UserHighlight>>((ref) {
  return ref.watch(appDatabaseProvider).studyToolsDao.watchAllHighlights();
});

final allNotesProvider = StreamProvider<List<UserNote>>((ref) {
  return ref.watch(appDatabaseProvider).studyToolsDao.watchAllNotes();
});

final highlightNotesProvider = StreamProvider<List<UserHighlight>>((ref) {
  return ref.watch(appDatabaseProvider).studyToolsDao.watchHighlightsWithNotes();
});
