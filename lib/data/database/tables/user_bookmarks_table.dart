import 'package:drift/drift.dart';

class UserBookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textUid => text().named('text_uid')();
  TextColumn get label => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {textUid},
      ];
}
