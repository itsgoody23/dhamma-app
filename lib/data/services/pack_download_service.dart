import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/app_database.dart';
import '../models/content_pack.dart';
import 'background_download_service.dart';
import 'pack_index_service.dart';

// Note: add `crypto: ^3.0.3` to pubspec.yaml dependencies

enum DownloadState { idle, downloading, merging, completed, error, cancelled }

class DownloadProgress {
  const DownloadProgress({
    required this.state,
    required this.received,
    required this.total,
    this.error,
  });

  final DownloadState state;
  final int received;
  final int total;
  final String? error;

  double get fraction => total > 0 ? received / total : 0;
  bool get isDone =>
      state == DownloadState.completed ||
      state == DownloadState.error ||
      state == DownloadState.cancelled;
}

class PackDownloadService {
  PackDownloadService({required this.db, required this.packIndexService});

  final AppDatabase db;
  final PackIndexService packIndexService;

  final _dio = Dio();
  final _progressControllers = <String, StreamController<DownloadProgress>>{};

  Stream<DownloadProgress> progressStream(String packId) {
    _progressControllers[packId] ??=
        StreamController<DownloadProgress>.broadcast();
    return _progressControllers[packId]!.stream;
  }

  void _emit(String packId, DownloadProgress progress) {
    _progressControllers[packId]?.add(progress);
  }

  Future<void> downloadPack(
    ContentPack pack, {
    bool wifiOnly = true,
  }) async {
    final packId = pack.packId;

    // Check connectivity
    final connectivity = await Connectivity().checkConnectivity();
    if (wifiOnly && !connectivity.contains(ConnectivityResult.wifi)) {
      _emit(
          packId,
          const DownloadProgress(
            state: DownloadState.error,
            received: 0,
            total: 0,
            error:
                'Wi-Fi only mode is enabled. Connect to Wi-Fi or disable the setting.',
          ));
      return;
    }

    // Check if already downloaded
    final alreadyDone = await db.packsDao.isPackDownloaded(packId);
    if (alreadyDone) return;

    final docsDir = await getApplicationDocumentsDirectory();
    final packsDir = Directory(p.join(docsDir.path, 'packs'));
    await packsDir.create(recursive: true);

    final gzPath = p.join(packsDir.path, '${packId}_tmp.db.gz');
    final dbPath = p.join(packsDir.path, '${packId}_tmp.db');

    try {
      // ── Schedule background resumption task (mobile only) ─────────────
      if (_isMobile) {
        await BackgroundDownloadService.schedulePackDownload(packId);
      }

      // ── Download ────────────────────────────────────────────────────────
      _emit(
          packId,
          const DownloadProgress(
              state: DownloadState.downloading, received: 0, total: 0));

      final cancelToken = CancelToken();
      _storeCancelToken(packId, cancelToken);

      await _dio.download(
        pack.downloadUrl,
        gzPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          _emit(
              packId,
              DownloadProgress(
                state: DownloadState.downloading,
                received: received,
                total: total,
              ));
        },
      );

      // ── Verify checksum ─────────────────────────────────────────────────
      final gzFile = File(gzPath);
      final checksum = await _sha256(gzFile);
      if (checksum != pack.checksumSha256) {
        await gzFile.delete();
        throw Exception('Checksum mismatch — file may be corrupted');
      }

      // ── Decompress ──────────────────────────────────────────────────────
      _emit(
          packId,
          DownloadProgress(
            state: DownloadState.merging,
            received: await gzFile.length(),
            total: await gzFile.length(),
          ));

      await _decompress(gzPath, dbPath);
      await gzFile.delete();

      // ── Merge into main DB ──────────────────────────────────────────────
      await db.mergePackDatabase(dbPath);
      await File(dbPath).delete();

      // ── Record download ─────────────────────────────────────────────────
      await db.packsDao.insertPack(
        DownloadedPacksCompanion.insert(
          packId: pack.packId,
          packName: pack.packName,
          language: pack.language,
          nikaya: Value(pack.nikaya),
          sizeMb: pack.sizeMb,
        ),
      );

      if (_isMobile) await BackgroundDownloadService.clearPending();
      _emit(
          packId,
          DownloadProgress(
            state: DownloadState.completed,
            received: (pack.compressedSizeMb * 1048576).round(),
            total: (pack.compressedSizeMb * 1048576).round(),
          ));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        if (_isMobile) {
          await BackgroundDownloadService.cancelPackDownload(packId);
        }
        _emit(
            packId,
            const DownloadProgress(
                state: DownloadState.cancelled, received: 0, total: 0));
      } else {
        _emit(
            packId,
            DownloadProgress(
              state: DownloadState.error,
              received: 0,
              total: 0,
              error: e.message,
            ));
      }
      await _cleanup(gzPath, dbPath);
    } catch (e) {
      _emit(
          packId,
          DownloadProgress(
            state: DownloadState.error,
            received: 0,
            total: 0,
            error: e.toString(),
          ));
      await _cleanup(gzPath, dbPath);
    } finally {
      _removeCancelToken(packId);
    }
  }

  Future<void> deletePack(
      String packId, String packNikaya, String packLanguage) async {
    await db.removePackData(packNikaya, packLanguage);
    await db.packsDao.deletePack(packId);
    // VACUUM in background
    db.vacuum();
  }

  Future<void> cancelDownload(String packId) async {
    _cancelTokens[packId]?.cancel('User cancelled');
  }

  static bool get _isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  // ── Internals ─────────────────────────────────────────────────────────────

  final _cancelTokens = <String, CancelToken>{};

  void _storeCancelToken(String packId, CancelToken token) =>
      _cancelTokens[packId] = token;

  void _removeCancelToken(String packId) => _cancelTokens.remove(packId);

  Future<void> _decompress(String gzPath, String outPath) async {
    final gzFile = File(gzPath);
    final outFile = File(outPath);
    final sink = outFile.openWrite();
    try {
      await gzFile.openRead().transform(gzip.decoder).pipe(sink);
    } finally {
      await sink.close();
    }
  }

  Future<String> _sha256(File file) async {
    final bytes = await file.readAsBytes();
    return sha256.convert(bytes).toString();
  }

  Future<void> _cleanup(String gzPath, String dbPath) async {
    for (final path in [gzPath, dbPath]) {
      final f = File(path);
      if (await f.exists()) await f.delete();
    }
  }

  void dispose() {
    for (final controller in _progressControllers.values) {
      controller.close();
    }
  }
}
