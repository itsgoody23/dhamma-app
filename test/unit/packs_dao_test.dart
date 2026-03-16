import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dhamma_app/data/database/app_database.dart';

/// Tests for [PacksDao] — insert, lookup, delete, totalStorageMb.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  DownloadedPacksCompanion pack({
    required String packId,
    required String packName,
    required String language,
    String? nikaya,
    double sizeMb = 5.0,
  }) =>
      DownloadedPacksCompanion.insert(
        packId: packId,
        packName: packName,
        language: language,
        nikaya: Value(nikaya),
        sizeMb: sizeMb,
      );

  group('insertPack / isPackDownloaded', () {
    test('inserted pack is found by isPackDownloaded', () async {
      await db.packsDao.insertPack(
        pack(
            packId: 'mn_en',
            packName: 'Majjhima Nikāya — English',
            language: 'en',
            nikaya: 'mn'),
      );
      expect(await db.packsDao.isPackDownloaded('mn_en'), isTrue);
    });

    test('returns false for unknown packId', () async {
      expect(await db.packsDao.isPackDownloaded('dn_en'), isFalse);
    });

    test('insertOnConflictUpdate is idempotent', () async {
      final companion = pack(
          packId: 'mn_en', packName: 'MN English', language: 'en', sizeMb: 8.0);
      await db.packsDao.insertPack(companion);
      // Insert same packId again — should not throw, should upsert
      await db.packsDao.insertPack(companion);
      final all = await db.packsDao.getDownloadedPacks();
      expect(all.where((p) => p.packId == 'mn_en').length, 1);
    });
  });

  group('getPackById', () {
    test('returns pack when found', () async {
      await db.packsDao.insertPack(
        pack(
            packId: 'sn_en',
            packName: 'Saṃyutta Nikāya — English',
            language: 'en',
            nikaya: 'sn'),
      );
      final result = await db.packsDao.getPackById('sn_en');
      expect(result, isNotNull);
      expect(result!.packName, 'Saṃyutta Nikāya — English');
    });

    test('returns null when not found', () async {
      final result = await db.packsDao.getPackById('nonexistent');
      expect(result, isNull);
    });
  });

  group('deletePack', () {
    test('removes the pack', () async {
      await db.packsDao.insertPack(
        pack(packId: 'mn_en', packName: 'MN English', language: 'en'),
      );
      await db.packsDao.deletePack('mn_en');
      expect(await db.packsDao.isPackDownloaded('mn_en'), isFalse);
    });

    test('deleting non-existent pack is a no-op', () async {
      // Should not throw
      await expectLater(db.packsDao.deletePack('missing'), completes);
    });
  });

  group('watchDownloadedPacks', () {
    test('emits packs sorted alphabetically by name', () async {
      await db.packsDao.insertPack(
          pack(packId: 'sn_en', packName: 'Saṃyutta Nikāya', language: 'en'));
      await db.packsDao.insertPack(
          pack(packId: 'mn_en', packName: 'Majjhima Nikāya', language: 'en'));
      await db.packsDao.insertPack(
          pack(packId: 'dn_en', packName: 'Dīgha Nikāya', language: 'en'));

      final packs = await db.packsDao.watchDownloadedPacks().first;
      final names = packs.map((p) => p.packName).toList();
      expect(names, equals([...names]..sort()));
    });
  });

  group('totalStorageMb', () {
    test('returns 0 when no packs installed', () async {
      final total = await db.packsDao.totalStorageMb();
      expect(total, 0.0);
    });

    test('sums sizeMb across all installed packs', () async {
      await db.packsDao.insertPack(
          pack(packId: 'mn_en', packName: 'MN', language: 'en', sizeMb: 8.2));
      await db.packsDao.insertPack(
          pack(packId: 'dn_en', packName: 'DN', language: 'en', sizeMb: 4.5));

      final total = await db.packsDao.totalStorageMb();
      expect(total, closeTo(12.7, 0.01));
    });

    test('updates after pack deletion', () async {
      await db.packsDao.insertPack(
          pack(packId: 'mn_en', packName: 'MN', language: 'en', sizeMb: 8.2));
      await db.packsDao.insertPack(
          pack(packId: 'dn_en', packName: 'DN', language: 'en', sizeMb: 4.5));
      await db.packsDao.deletePack('mn_en');

      final total = await db.packsDao.totalStorageMb();
      expect(total, closeTo(4.5, 0.01));
    });
  });
}
