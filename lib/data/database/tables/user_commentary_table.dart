import 'package:drift/drift.dart';

class UserCommentary extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get suttaUid => text().named('sutta_uid')();
  TextColumn get verseRef => text().named('verse_ref')();
  TextColumn get content => text()();
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
        {suttaUid, verseRef},
      ];
}
