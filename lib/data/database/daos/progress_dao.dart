import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/user_progress_table.dart';

part 'progress_dao.g.dart';

@DriftAccessor(tables: [UserProgress])
class ProgressDao extends DatabaseAccessor<AppDatabase>
    with _$ProgressDaoMixin {
  ProgressDao(super.db);

  Future<void> upsertProgress({
    required String textUid,
    required int lastPosition,
    bool completed = false,
  }) async {
    final now = DateTime.now();
    // Can't use ON CONFLICT with nullable userId (SQLite treats NULLs as distinct).
    final existing = await (select(userProgress)
          ..where((p) => p.textUid.equals(textUid) & p.userId.isNull()))
        .getSingleOrNull();
    if (existing != null) {
      await (update(userProgress)..where((p) => p.id.equals(existing.id)))
          .write(UserProgressCompanion(
        lastPosition: Value(lastPosition),
        completed: Value(completed),
        lastReadAt: Value(now),
        updatedAt: Value(now),
      ));
    } else {
      await into(userProgress).insert(
        UserProgressCompanion.insert(
          textUid: textUid,
          lastPosition: Value(lastPosition),
          completed: Value(completed),
          lastReadAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    }
  }

  Stream<UserProgressData?> watchProgressForUid(String textUid) {
    return (select(userProgress)
          ..where((p) => p.textUid.equals(textUid) & p.isDeleted.equals(false)))
        .watchSingleOrNull();
  }

  Future<UserProgressData?> getProgressForUid(String textUid) {
    return (select(userProgress)
          ..where((p) => p.textUid.equals(textUid) & p.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  /// Number of completed suttas in a nikaya — for progress rings on library screen.
  Future<int> countCompletedInNikaya(String nikaya, String language) async {
    final result = await customSelect(
      '''
      SELECT COUNT(*) as cnt
      FROM user_progress up
      JOIN texts t ON t.uid = up.text_uid
      WHERE t.nikaya = ? AND t.language = ? AND up.completed = 1
        AND up.is_deleted = 0
      ''',
      variables: [Variable(nikaya), Variable(language)],
      readsFrom: {userProgress},
    ).getSingle();
    return result.read<int>('cnt');
  }

  Future<List<UserProgressData>> getRecentlyRead({int limit = 10}) {
    return (select(userProgress)
          ..where((p) => p.isDeleted.equals(false))
          ..orderBy([
            (p) => OrderingTerm.desc(p.lastReadAt),
            (p) => OrderingTerm.desc(p.id),
          ])
          ..limit(limit))
        .get();
  }

  /// Recently-read items with sutta title and nikaya (avoids N+1 lookups).
  Future<List<RecentlyReadItem>> getRecentlyReadWithTitles(
      {int limit = 5}) async {
    final rows = await customSelect(
      '''
      SELECT up.text_uid, up.last_position, up.completed,
             t.title, t.nikaya
      FROM user_progress up
      JOIN texts t ON t.uid = up.text_uid
      WHERE up.is_deleted = 0
      GROUP BY up.text_uid
      ORDER BY up.last_read_at DESC
      LIMIT ?
      ''',
      variables: [Variable(limit)],
      readsFrom: {userProgress},
    ).get();
    return rows
        .map((r) => RecentlyReadItem(
              textUid: r.read<String>('text_uid'),
              title: r.read<String>('title'),
              nikaya: r.read<String>('nikaya'),
              lastPosition: r.read<int>('last_position'),
              completed: r.read<bool>('completed'),
            ))
        .toList();
  }
}

class RecentlyReadItem {
  const RecentlyReadItem({
    required this.textUid,
    required this.title,
    required this.nikaya,
    required this.lastPosition,
    required this.completed,
  });

  final String textUid;
  final String title;
  final String nikaya;
  final int lastPosition;
  final bool completed;
}
