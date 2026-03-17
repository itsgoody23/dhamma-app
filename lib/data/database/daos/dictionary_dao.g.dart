// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_dao.dart';

// ignore_for_file: type=lint
mixin _$DictionaryDaoMixin on DatabaseAccessor<AppDatabase> {
  $PaliDictionaryTable get paliDictionary => attachedDatabase.paliDictionary;
  DictionaryDaoManager get managers => DictionaryDaoManager(this);
}

class DictionaryDaoManager {
  final _$DictionaryDaoMixin _db;
  DictionaryDaoManager(this._db);
  $$PaliDictionaryTableTableManager get paliDictionary =>
      $$PaliDictionaryTableTableManager(
          _db.attachedDatabase, _db.paliDictionary);
}
