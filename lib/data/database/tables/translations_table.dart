import 'package:drift/drift.dart';

/// Additional translations of texts — one row per translation per sutta.
class Translations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get textUid => text().named('text_uid')();
  TextColumn get language => text()();
  TextColumn get translator => text().nullable()();
  TextColumn get source => text().nullable()();
  TextColumn get contentHtml => text().named('content_html').nullable()();
  TextColumn get contentPlain => text().named('content_plain').nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {textUid, language, translator},
      ];
}
