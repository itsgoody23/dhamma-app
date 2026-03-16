import 'package:drift/drift.dart';

class DownloadedPacks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get packId => text().named('pack_id').unique()();
  TextColumn get packName => text().named('pack_name')();
  TextColumn get language => text()();
  TextColumn get nikaya => text().nullable()();
  RealColumn get sizeMb => real().named('size_mb')();
  DateTimeColumn get downloadedAt =>
      dateTime().named('downloaded_at').withDefault(currentDateAndTime)();
}
