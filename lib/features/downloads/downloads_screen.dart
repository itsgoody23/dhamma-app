import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../data/database/app_database.dart';
import '../../data/models/content_pack.dart';
import '../../data/services/pack_download_service.dart';
import '../../data/services/pack_index_service.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/preferences_provider.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final packIndexServiceProvider = Provider<PackIndexService>(
  (_) => PackIndexService(),
);

final packDownloadServiceProvider = Provider<PackDownloadService>((ref) {
  final service = PackDownloadService(
    db: ref.watch(appDatabaseProvider),
    packIndexService: ref.watch(packIndexServiceProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

final availablePacksProvider =
    FutureProvider.autoDispose<List<ContentPack>>((ref) {
  return ref.watch(packIndexServiceProvider).fetchPacks();
});

final installedPacksProvider =
    StreamProvider.autoDispose<List<DownloadedPack>>((ref) {
  return ref.watch(appDatabaseProvider).packsDao.watchDownloadedPacks();
});

final totalStorageMbProvider = FutureProvider.autoDispose<double>((ref) {
  return ref.watch(appDatabaseProvider).packsDao.totalStorageMb();
});

// ── Screen ────────────────────────────────────────────────────────────────────

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installedAsync = ref.watch(installedPacksProvider);
    final availableAsync = ref.watch(availablePacksProvider);
    final storageAsync = ref.watch(totalStorageMbProvider);
    final wifiOnly = ref.watch(wifiOnlyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          // Storage indicator
          storageAsync.when(
            data: (mb) => _StorageCard(usedMb: mb),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Wi-Fi only toggle
          Card(
            margin: const EdgeInsets.symmetric(vertical: AppSizes.sm),
            child: SwitchListTile(
              title: const Text('Wi-Fi only downloads'),
              subtitle: const Text('Recommended to save mobile data'),
              value: wifiOnly,
              activeTrackColor: AppColors.green,
              onChanged: (v) => ref.read(wifiOnlyProvider.notifier).set(v),
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Installed packs
          installedAsync.when(
            data: (packs) {
              if (packs.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INSTALLED',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  ...packs.map((pack) => _InstalledPackTile(pack: pack)),
                  const SizedBox(height: AppSizes.lg),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Available packs
          const Text(
            'AVAILABLE TO DOWNLOAD',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          ),
          const SizedBox(height: AppSizes.sm),

          availableAsync.when(
            data: (packs) {
              if (packs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(AppSizes.md),
                  child: Text(
                    'No packs available. Check your internet connection.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              return installedAsync.when(
                data: (installed) {
                  final installedIds = installed.map((p) => p.packId).toSet();
                  final notInstalled = packs
                      .where((p) => !installedIds.contains(p.packId))
                      .toList();
                  if (notInstalled.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSizes.md),
                      child: Text(
                        'All available packs are installed.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return Column(
                    children: notInstalled
                        .map((pack) => _AvailablePackTile(pack: pack))
                        .toList(),
                  );
                },
                loading: () => Column(
                  children: packs
                      .map((pack) => _AvailablePackTile(pack: pack))
                      .toList(),
                ),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Could not load packs: $e'),
          ),
        ],
      ),
    );
  }
}

// ── Storage indicator ─────────────────────────────────────────────────────────

class _StorageCard extends StatelessWidget {
  const _StorageCard({required this.usedMb});

  final double usedMb;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            const Icon(Icons.storage_outlined, color: AppColors.green),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Storage used by Dhamma App',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    '${usedMb.toStringAsFixed(1)} MB',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Installed pack tile ───────────────────────────────────────────────────────

class _InstalledPackTile extends ConsumerWidget {
  const _InstalledPackTile({required this.pack});

  final DownloadedPack pack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: AppColors.green),
        title: Text(pack.packName),
        subtitle: Text(
            '${pack.sizeMb.toStringAsFixed(1)} MB · ${pack.language.toUpperCase()}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          tooltip: 'Delete pack',
          onPressed: () => _confirmDelete(context, ref),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete pack?'),
        content: Text(
            'This will remove "${pack.packName}" and free ${pack.sizeMb.toStringAsFixed(1)} MB of storage.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(packDownloadServiceProvider).deletePack(
                    pack.packId,
                    pack.nikaya ?? pack.packId,
                    pack.language,
                  );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Available pack tile ───────────────────────────────────────────────────────

class _AvailablePackTile extends ConsumerWidget {
  const _AvailablePackTile({required this.pack});

  final ContentPack pack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadService = ref.watch(packDownloadServiceProvider);
    final wifiOnly = ref.watch(wifiOnlyProvider);

    return StreamBuilder<DownloadProgress>(
      stream: downloadService.progressStream(pack.packId),
      builder: (context, snapshot) {
        final progress = snapshot.data;

        return Card(
          margin: const EdgeInsets.only(bottom: AppSizes.sm),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pack.packName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                          Text(
                            '${pack.compressedSizeMb.toStringAsFixed(1)} MB compressed · ${pack.suttaCount} suttas',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    if (progress == null || progress.isDone)
                      FilledButton.tonal(
                        onPressed: () => downloadService.downloadPack(pack,
                            wifiOnly: wifiOnly),
                        child: const Text('Download'),
                      )
                    else if (progress.state == DownloadState.downloading)
                      TextButton(
                        onPressed: () =>
                            downloadService.cancelDownload(pack.packId),
                        child: const Text('Cancel'),
                      ),
                  ],
                ),
                if (progress != null && !progress.isDone) ...[
                  const SizedBox(height: AppSizes.sm),
                  LinearProgressIndicator(
                    value: progress.fraction,
                    backgroundColor: AppColors.green.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation(AppColors.green),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    progress.state == DownloadState.merging
                        ? 'Installing…'
                        : '${(progress.received / 1048576).toStringAsFixed(1)} / ${(progress.total / 1048576).toStringAsFixed(1)} MB',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
                if (progress?.state == DownloadState.error)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSizes.sm),
                    child: Text(
                      progress!.error ?? 'Download failed',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
