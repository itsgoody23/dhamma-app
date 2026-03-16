import 'package:drift/drift.dart';

class VideoCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get youtubeId => text().named('youtube_id').unique()();
  TextColumn get title => text()();
  TextColumn get teacher => text().nullable()();
  TextColumn get suttaUid => text().named('sutta_uid').nullable()();
  TextColumn get topicTags => text().named('topic_tags').nullable()();
  IntColumn get durationSeconds =>
      integer().named('duration_seconds').nullable()();
  TextColumn get thumbnailUrl => text().named('thumbnail_url').nullable()();
  DateTimeColumn get cachedAt =>
      dateTime().named('cached_at').withDefault(currentDateAndTime)();
}
