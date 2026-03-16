import 'package:drift/drift.dart';

class UserHighlights extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textUid => text().named('text_uid')();
  IntColumn get startOffset => integer().named('start_offset')();
  IntColumn get endOffset => integer().named('end_offset')();
  // Stored as hex string e.g. '#FFF176'
  TextColumn get colour => text()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
}
