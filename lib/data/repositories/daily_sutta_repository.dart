import 'dart:convert';
import 'package:drift/drift.dart' show Variable;
import 'package:flutter/services.dart';
import '../database/app_database.dart';
import '../models/reading_plan.dart';

class DailySuttaRepository {
  const DailySuttaRepository(this._db);

  final AppDatabase _db;

  /// Returns the sutta scheduled for today (1-indexed day of year).
  Future<DailySutta?> getTodaysSutta() async {
    final dayOfYear = _dayOfYear(DateTime.now());
    final result = await _db.customSelect(
      'SELECT * FROM daily_suttas WHERE day_of_year = ? LIMIT 1',
      variables: [Variable(dayOfYear)],
      readsFrom: {_db.dailySuttas},
    ).getSingleOrNull();

    if (result == null) return null;

    return DailySutta(
      id: result.read<int>('id'),
      dayOfYear: result.read<int>('day_of_year'),
      uid: result.read<String>('uid'),
      title: result.read<String>('title'),
      verseExcerpt: result.readNullable<String>('verse_excerpt'),
      nikaya: result.read<String>('nikaya'),
    );
  }

  /// Returns all reading plans from the bundled JSON asset.
  Future<List<ReadingPlan>> getReadingPlans() async {
    final jsonStr =
        await rootBundle.loadString('assets/reading_plans/plans.json');
    final list = json.decode(jsonStr) as List;
    return list
        .map((e) => ReadingPlan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Stable 1-indexed day-of-year — handles leap years correctly.
  static int _dayOfYear(DateTime dt) {
    return dt.difference(DateTime(dt.year, 1, 1)).inDays + 1;
  }
}
