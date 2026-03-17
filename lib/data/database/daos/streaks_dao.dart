import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/reading_streaks_table.dart';

part 'streaks_dao.g.dart';

@DriftAccessor(tables: [ReadingStreaks])
class StreaksDao extends DatabaseAccessor<AppDatabase>
    with _$StreaksDaoMixin {
  StreaksDao(super.db);

  /// Record reading activity for today (upserts).
  Future<void> recordReading({
    required int additionalMinutes,
    required int additionalSuttas,
  }) async {
    final today = _todayString();
    final existing = await (select(readingStreaks)
          ..where((r) => r.date.equals(today)))
        .getSingleOrNull();

    if (existing != null) {
      await (update(readingStreaks)..where((r) => r.id.equals(existing.id)))
          .write(ReadingStreaksCompanion(
        minutesRead: Value(existing.minutesRead + additionalMinutes),
        suttasRead: Value(existing.suttasRead + additionalSuttas),
      ));
    } else {
      await into(readingStreaks).insert(ReadingStreaksCompanion.insert(
        date: today,
        minutesRead: Value(additionalMinutes),
        suttasRead: Value(additionalSuttas),
      ));
    }
  }

  /// Watch the current streak (consecutive days ending today or yesterday).
  Stream<int> watchCurrentStreak() {
    return customSelect(
      'SELECT date FROM reading_streaks WHERE suttas_read > 0 ORDER BY date DESC',
      readsFrom: {readingStreaks},
    ).watch().map((rows) {
      if (rows.isEmpty) return 0;

      final dates = rows
          .map((r) => DateTime.parse(r.read<String>('date')))
          .toList();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Streak must start from today or yesterday
      final firstDate = dates.first;
      final diff = today.difference(firstDate).inDays;
      if (diff > 1) return 0;

      int streak = 1;
      for (int i = 1; i < dates.length; i++) {
        final dayDiff = dates[i - 1].difference(dates[i]).inDays;
        if (dayDiff == 1) {
          streak++;
        } else {
          break;
        }
      }
      return streak;
    });
  }

  /// Watch today's reading stats.
  Stream<ReadingStreak?> watchToday() {
    final today = _todayString();
    return (select(readingStreaks)..where((r) => r.date.equals(today)))
        .watchSingleOrNull();
  }

  /// Get reading history for the last N days (for heatmap).
  Future<Map<String, int>> getStreakHistory({int days = 30}) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final cutoffStr =
        '${cutoff.year}-${cutoff.month.toString().padLeft(2, '0')}-${cutoff.day.toString().padLeft(2, '0')}';

    final rows = await (select(readingStreaks)
          ..where((r) => r.date.isIn([cutoffStr]) | r.date.isBiggerThanValue(cutoffStr))
          ..orderBy([(r) => OrderingTerm.asc(r.date)]))
        .get();

    return {for (final r in rows) r.date: r.suttasRead};
  }

  /// Watch longest streak ever.
  Stream<int> watchLongestStreak() {
    return customSelect(
      'SELECT date FROM reading_streaks WHERE suttas_read > 0 ORDER BY date ASC',
      readsFrom: {readingStreaks},
    ).watch().map((rows) {
      if (rows.isEmpty) return 0;

      final dates = rows
          .map((r) => DateTime.parse(r.read<String>('date')))
          .toList();

      int longest = 1;
      int current = 1;
      for (int i = 1; i < dates.length; i++) {
        if (dates[i].difference(dates[i - 1]).inDays == 1) {
          current++;
          if (current > longest) longest = current;
        } else {
          current = 1;
        }
      }
      return longest;
    });
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
