import 'package:drift/drift.dart';

import 'collections_table.dart';

class CollectionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get collectionId =>
      integer().named('collection_id').references(UserCollections, #id)();
  TextColumn get suttaUid => text().named('sutta_uid')();
  IntColumn get sortOrder => integer().named('sort_order').withDefault(const Constant(0))();
  TextColumn get userId => text().named('user_id').nullable()();
  DateTimeColumn get addedAt =>
      dateTime().named('added_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();
  BoolColumn get isDeleted =>
      boolean().named('is_deleted').withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {collectionId, suttaUid},
      ];
}
