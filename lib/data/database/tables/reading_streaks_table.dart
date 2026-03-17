import 'package:drift/drift.dart';

class ReadingStreaks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().unique()(); // ISO date e.g. '2026-03-17'
  IntColumn get minutesRead => integer().withDefault(const Constant(0))();
  IntColumn get suttasRead => integer().withDefault(const Constant(0))();
}
