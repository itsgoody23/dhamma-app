import 'package:drift/drift.dart';

class AudioCacheEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get trackId => text().named('track_id').unique()();
  TextColumn get filePath => text().named('file_path')();
  IntColumn get sizeBytes => integer().named('size_bytes')();
  DateTimeColumn get cachedAt =>
      dateTime().named('cached_at').withDefault(currentDateAndTime)();
  DateTimeColumn get lastPlayedAt =>
      dateTime().named('last_played_at').nullable()();
}
