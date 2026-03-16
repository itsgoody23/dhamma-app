import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/downloaded_packs_table.dart';

part 'packs_dao.g.dart';

@DriftAccessor(tables: [DownloadedPacks])
class PacksDao extends DatabaseAccessor<AppDatabase> with _$PacksDaoMixin {
  PacksDao(super.db);

  Stream<List<DownloadedPack>> watchDownloadedPacks() {
    return (select(downloadedPacks)
          ..orderBy([(p) => OrderingTerm.asc(p.packName)]))
        .watch();
  }

  Future<List<DownloadedPack>> getDownloadedPacks() {
    return select(downloadedPacks).get();
  }

  Future<DownloadedPack?> getPackById(String packId) =>
      (select(downloadedPacks)..where((p) => p.packId.equals(packId)))
          .getSingleOrNull();

  Future<bool> isPackDownloaded(String packId) async {
    final row = await (select(downloadedPacks)
          ..where((p) => p.packId.equals(packId)))
        .getSingleOrNull();
    return row != null;
  }

  Future<void> insertPack(DownloadedPacksCompanion pack) =>
      into(downloadedPacks).insert(
        pack,
        onConflict: DoUpdate(
          (old) => DownloadedPacksCompanion(
            packName: pack.packName,
            language: pack.language,
            nikaya: pack.nikaya,
            sizeMb: pack.sizeMb,
          ),
          target: [downloadedPacks.packId],
        ),
      );

  Future<void> deletePack(String packId) =>
      (delete(downloadedPacks)..where((p) => p.packId.equals(packId))).go();

  /// Total MB used by all downloaded packs.
  Future<double> totalStorageMb() async {
    final result = await customSelect(
      'SELECT COALESCE(SUM(size_mb), 0) as total FROM downloaded_packs',
      readsFrom: {downloadedPacks},
    ).getSingle();
    return result.read<double>('total');
  }
}
