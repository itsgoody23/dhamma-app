import 'package:drift/drift.dart';

class UserHighlights extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textUid => text().named('text_uid')();
  IntColumn get startOffset => integer().named('start_offset')();
  IntColumn get endOffset => integer().named('end_offset')();
  // Stored as hex string e.g. '#FFF176'
  TextColumn get colour => text()();
  // Language the highlight applies to (offsets are language-specific).
  TextColumn get language =>
      text().withDefault(const Constant('en'))();
  TextColumn get note => text().nullable()();
  TextColumn get userId => text().named('user_id').nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();
  BoolColumn get isDeleted =>
      boolean().named('is_deleted').withDefault(const Constant(false))();
}
