import 'package:drift/drift.dart';

/// Pre-seeded table containing one sutta per day of the year.
/// Bundled in the seed DB asset — never modified at runtime.
class DailySuttas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dayOfYear => integer().named('day_of_year').unique()();
  TextColumn get uid => text()();
  TextColumn get title => text()();
  TextColumn get verseExcerpt => text().named('verse_excerpt').nullable()();
  TextColumn get nikaya => text()();
}
