import 'package:drift/drift.dart';

class Translators extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get tradition => text().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get sourceUrl => text().named('source_url').nullable()();
}
