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

class TeacherChannels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get channelId => text().named('channel_id').unique()();
  TextColumn get platform =>
      text().withDefault(const Constant('youtube'))();
  TextColumn get thumbnailUrl => text().named('thumbnail_url').nullable()();
  BoolColumn get isDefault =>
      boolean().named('is_default').withDefault(const Constant(false))();
  DateTimeColumn get addedAt =>
      dateTime().named('added_at').withDefault(currentDateAndTime)();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
}
