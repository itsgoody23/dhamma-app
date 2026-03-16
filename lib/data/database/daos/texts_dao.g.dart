// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'texts_dao.dart';

// ignore_for_file: type=lint
mixin _$TextsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TextsTable get texts => attachedDatabase.texts;
  $TranslationsTable get translations => attachedDatabase.translations;
  TextsDaoManager get managers => TextsDaoManager(this);
}

class TextsDaoManager {
  final _$TextsDaoMixin _db;
  TextsDaoManager(this._db);
  $$TextsTableTableManager get texts =>
      $$TextsTableTableManager(_db.attachedDatabase, _db.texts);
  $$TranslationsTableTableManager get translations =>
      $$TranslationsTableTableManager(_db.attachedDatabase, _db.translations);
}
