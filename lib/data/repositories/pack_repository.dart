import 'package:drift/drift.dart' show Value;
import '../database/app_database.dart';
import '../models/content_pack.dart';

class PackRepository {
  const PackRepository(this._db);

  final AppDatabase _db;

  Stream<List<DownloadedPack>> watchDownloadedPacks() =>
      _db.packsDao.watchDownloadedPacks();

  Future<DownloadedPack?> getPackById(String packId) =>
      _db.packsDao.getPackById(packId);

  Future<bool> isPackDownloaded(String packId) =>
      _db.packsDao.isPackDownloaded(packId);

  Future<void> insertPack(ContentPack pack) => _db.packsDao.insertPack(
        DownloadedPacksCompanion.insert(
          packId: pack.packId,
          packName: pack.packName,
          language: pack.language,
          nikaya: Value(pack.nikaya),
          sizeMb: pack.sizeMb,
        ),
      );

  Future<void> deletePack(String packId) => _db.packsDao.deletePack(packId);
}
