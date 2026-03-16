// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packs_dao.dart';

// ignore_for_file: type=lint
mixin _$PacksDaoMixin on DatabaseAccessor<AppDatabase> {
  $DownloadedPacksTable get downloadedPacks => attachedDatabase.downloadedPacks;
  PacksDaoManager get managers => PacksDaoManager(this);
}

class PacksDaoManager {
  final _$PacksDaoMixin _db;
  PacksDaoManager(this._db);
  $$DownloadedPacksTableTableManager get downloadedPacks =>
      $$DownloadedPacksTableTableManager(
          _db.attachedDatabase, _db.downloadedPacks);
}
