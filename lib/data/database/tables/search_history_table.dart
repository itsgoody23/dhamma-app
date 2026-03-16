import 'package:drift/drift.dart';

class SearchHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get query => text().unique()();
  DateTimeColumn get searchedAt =>
      dateTime().named('searched_at').withDefault(currentDateAndTime)();
}
