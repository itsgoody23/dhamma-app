import 'package:drift/drift.dart';

class UserNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textUid => text().named('text_uid').unique()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
}
