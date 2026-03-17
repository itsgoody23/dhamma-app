import 'package:drift/drift.dart';

@DataClassName('PaliDictionaryEntry')
class PaliDictionary extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entry => text()();
  TextColumn get grammar => text().nullable()();
  TextColumn get definition => text()();
  TextColumn get crossRefs => text().named('cross_refs').nullable()();
}
