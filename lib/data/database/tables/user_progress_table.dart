import 'package:drift/drift.dart';

class UserProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textUid => text().named('text_uid').unique()();
  IntColumn get lastPosition => integer().named('last_position').withDefault(
        const Constant(0),
      )();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastReadAt =>
      dateTime().named('last_read_at').withDefault(currentDateAndTime)();
}
