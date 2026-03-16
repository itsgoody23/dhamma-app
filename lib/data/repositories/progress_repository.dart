import '../database/app_database.dart';

class ProgressRepository {
  const ProgressRepository(this._db);

  final AppDatabase _db;

  Future<void> upsertProgress({
    required String textUid,
    required int lastPosition,
    bool completed = false,
  }) =>
      _db.progressDao.upsertProgress(
        textUid: textUid,
        lastPosition: lastPosition,
        completed: completed,
      );

  Stream<UserProgressData?> watchProgressForUid(String textUid) =>
      _db.progressDao.watchProgressForUid(textUid);

  Future<UserProgressData?> getProgressForUid(String textUid) =>
      _db.progressDao.getProgressForUid(textUid);

  Future<int> countCompletedInNikaya(String nikaya, String language) =>
      _db.progressDao.countCompletedInNikaya(nikaya, language);

  Future<List<UserProgressData>> getRecentlyRead({int limit = 10}) =>
      _db.progressDao.getRecentlyRead(limit: limit);
}
