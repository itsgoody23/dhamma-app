// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_tools_dao.dart';

// ignore_for_file: type=lint
mixin _$StudyToolsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserBookmarksTable get userBookmarks => attachedDatabase.userBookmarks;
  $UserHighlightsTable get userHighlights => attachedDatabase.userHighlights;
  $UserNotesTable get userNotes => attachedDatabase.userNotes;
  StudyToolsDaoManager get managers => StudyToolsDaoManager(this);
}

class StudyToolsDaoManager {
  final _$StudyToolsDaoMixin _db;
  StudyToolsDaoManager(this._db);
  $$UserBookmarksTableTableManager get userBookmarks =>
      $$UserBookmarksTableTableManager(_db.attachedDatabase, _db.userBookmarks);
  $$UserHighlightsTableTableManager get userHighlights =>
      $$UserHighlightsTableTableManager(
          _db.attachedDatabase, _db.userHighlights);
  $$UserNotesTableTableManager get userNotes =>
      $$UserNotesTableTableManager(_db.attachedDatabase, _db.userNotes);
}
