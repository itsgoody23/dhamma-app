// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaks_dao.dart';

// ignore_for_file: type=lint
mixin _$StreaksDaoMixin on DatabaseAccessor<AppDatabase> {
  $ReadingStreaksTable get readingStreaks => attachedDatabase.readingStreaks;
  StreaksDaoManager get managers => StreaksDaoManager(this);
}

class StreaksDaoManager {
  final _$StreaksDaoMixin _db;
  StreaksDaoManager(this._db);
  $$ReadingStreaksTableTableManager get readingStreaks =>
      $$ReadingStreaksTableTableManager(
          _db.attachedDatabase, _db.readingStreaks);
}
