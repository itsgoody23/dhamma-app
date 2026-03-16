import 'package:drift/drift.dart';

class UserBookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textUid => text().named('text_uid')();
  TextColumn get label => text().withDefault(const Constant(''))();
  TextColumn get userId => text().named('user_id').nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
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
