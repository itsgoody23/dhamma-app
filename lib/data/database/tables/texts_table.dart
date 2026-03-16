import 'package:drift/drift.dart';

/// Primary sutta/text table — stores the full text of each sutta.
/// Uses composite unique key (uid, language) to allow the same sutta
/// in multiple languages (e.g. English + Pāli).
@DataClassName('SuttaText')
class Texts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uid => text()();
  TextColumn get title => text()();
  TextColumn get collection => text().nullable()();
  TextColumn get nikaya => text()();
  TextColumn get book => text().nullable()();
  TextColumn get chapter => text().nullable()();
  TextColumn get language => text()();
  TextColumn get translator => text().nullable()();
  TextColumn get source => text().nullable()();
  TextColumn get contentHtml => text().named('content_html').nullable()();
  TextColumn get contentPlain => text().named('content_plain').nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {uid, language},
      ];
}
