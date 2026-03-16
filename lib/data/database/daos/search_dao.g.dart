// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_dao.dart';

// ignore_for_file: type=lint
mixin _$SearchDaoMixin on DatabaseAccessor<AppDatabase> {
  $TextsTable get texts => attachedDatabase.texts;
  $SearchHistoryTable get searchHistory => attachedDatabase.searchHistory;
  SearchDaoManager get managers => SearchDaoManager(this);
}

class SearchDaoManager {
  final _$SearchDaoMixin _db;
  SearchDaoManager(this._db);
  $$TextsTableTableManager get texts =>
      $$TextsTableTableManager(_db.attachedDatabase, _db.texts);
  $$SearchHistoryTableTableManager get searchHistory =>
      $$SearchHistoryTableTableManager(_db.attachedDatabase, _db.searchHistory);
}
