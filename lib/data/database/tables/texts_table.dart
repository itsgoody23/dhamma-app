import 'package:drift/drift.dart';

/// Primary sutta/text table — stores the full text of each sutta.
@DataClassName('SuttaText')
class Texts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uid => text().unique()();
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
}
