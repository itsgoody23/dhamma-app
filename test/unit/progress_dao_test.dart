import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dhamma_app/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('ProgressDao', () {
    test('upsertProgress creates a progress row', () async {
      await db.progressDao.upsertProgress(
        textUid: 'mn1',
        lastPosition: 300,
      );
      final progress = await db.progressDao.getProgressForUid('mn1');
      expect(progress, isNotNull);
      expect(progress!.lastPosition, 300);
      expect(progress.completed, isFalse);
    });

    test('upsertProgress updates an existing row (no duplicates)', () async {
      await db.progressDao.upsertProgress(
        textUid: 'mn1',
        lastPosition: 100,
      );
      await db.progressDao.upsertProgress(
        textUid: 'mn1',
        lastPosition: 500,
        completed: true,
      );
      final progress = await db.progressDao.getProgressForUid('mn1');
      expect(progress!.lastPosition, 500);
      expect(progress.completed, isTrue);
    });

    test('watchProgressForUid emits null for unknown uid', () async {
      final progress =
          await db.progressDao.watchProgressForUid('unknown').first;
      expect(progress, isNull);
    });

    test('watchProgressForUid emits after upsert', () async {
      await db.progressDao.upsertProgress(
        textUid: 'dn1',
        lastPosition: 0,
      );
      final progress = await db.progressDao.watchProgressForUid('dn1').first;
      expect(progress, isNotNull);
      expect(progress!.textUid, 'dn1');
    });

    test('getRecentlyRead returns rows sorted by lastReadAt descending',
        () async {
      await db.progressDao.upsertProgress(textUid: 'mn1', lastPosition: 0);
      await Future.delayed(const Duration(milliseconds: 5));
      await db.progressDao.upsertProgress(textUid: 'mn2', lastPosition: 0);
      final recent = await db.progressDao.getRecentlyRead(limit: 10);
      expect(recent.first.textUid, 'mn2');
    });
  });
}
