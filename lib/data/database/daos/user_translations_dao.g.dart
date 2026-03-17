// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_translations_dao.dart';

// ignore_for_file: type=lint
mixin _$UserTranslationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserTranslationsTable get userTranslations =>
      attachedDatabase.userTranslations;
  $UserCommentaryTable get userCommentary => attachedDatabase.userCommentary;
  UserTranslationsDaoManager get managers => UserTranslationsDaoManager(this);
}

class UserTranslationsDaoManager {
  final _$UserTranslationsDaoMixin _db;
  UserTranslationsDaoManager(this._db);
  $$UserTranslationsTableTableManager get userTranslations =>
      $$UserTranslationsTableTableManager(
          _db.attachedDatabase, _db.userTranslations);
  $$UserCommentaryTableTableManager get userCommentary =>
      $$UserCommentaryTableTableManager(
          _db.attachedDatabase, _db.userCommentary);
}
