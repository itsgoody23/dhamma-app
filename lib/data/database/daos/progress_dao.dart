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
  }) {
    final now = DateTime.now();
    return into(userProgress).insert(
      UserProgressCompanion.insert(
        textUid: textUid,
        lastPosition: Value(lastPosition),
        completed: Value(completed),
        lastReadAt: Value(now),
      ),
      onConflict: DoUpdate(
        (old) => UserProgressCompanion(
          lastPosition: Value(lastPosition),
          completed: Value(completed),
          lastReadAt: Value(now),
        ),
        target: [userProgress.textUid],
      ),
    );
  }

  Stream<UserProgressData?> watchProgressForUid(String textUid) {
    return (select(userProgress)..where((p) => p.textUid.equals(textUid)))
        .watchSingleOrNull();
  }

  Future<UserProgressData?> getProgressForUid(String textUid) {
    return (select(userProgress)..where((p) => p.textUid.equals(textUid)))
        .getSingleOrNull();
  }

  /// Number of completed suttas in a nikaya — for progress rings on library screen.
  Future<int> countCompletedInNikaya(String nikaya, String language) async {
    // We need to join with texts to filter by nikaya.
    // Using a raw query for the join.
    final result = await customSelect(
      '''
      SELECT COUNT(*) as cnt
      FROM user_progress up
      JOIN texts t ON t.uid = up.text_uid
      WHERE t.nikaya = ? AND t.language = ? AND up.completed = 1
      ''',
      variables: [Variable(nikaya), Variable(language)],
      readsFrom: {userProgress},
    ).getSingle();
    return result.read<int>('cnt');
  }

  Future<List<UserProgressData>> getRecentlyRead({int limit = 10}) {
    return (select(userProgress)
          ..orderBy([
            (p) => OrderingTerm.desc(p.lastReadAt),
            (p) => OrderingTerm.desc(p.id),
          ])
          ..limit(limit))
        .get();
  }
}
