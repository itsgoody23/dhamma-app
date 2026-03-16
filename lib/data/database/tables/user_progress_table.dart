import 'package:drift/drift.dart';

class UserProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textUid => text().named('text_uid')();
  IntColumn get lastPosition => integer().named('last_position').withDefault(
        const Constant(0),
      )();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get userId => text().named('user_id').nullable()();
  DateTimeColumn get lastReadAt =>
      dateTime().named('last_read_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();
  BoolColumn get isDeleted =>
      boolean().named('is_deleted').withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {textUid, userId},
      ];
}
