// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collections_dao.dart';

// ignore_for_file: type=lint
mixin _$CollectionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserCollectionsTable get userCollections => attachedDatabase.userCollections;
  $CollectionItemsTable get collectionItems => attachedDatabase.collectionItems;
  CollectionsDaoManager get managers => CollectionsDaoManager(this);
}

class CollectionsDaoManager {
  final _$CollectionsDaoMixin _db;
  CollectionsDaoManager(this._db);
  $$UserCollectionsTableTableManager get userCollections =>
      $$UserCollectionsTableTableManager(
          _db.attachedDatabase, _db.userCollections);
  $$CollectionItemsTableTableManager get collectionItems =>
      $$CollectionItemsTableTableManager(
          _db.attachedDatabase, _db.collectionItems);
}
