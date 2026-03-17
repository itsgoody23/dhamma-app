import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/sync_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final syncStatus = ref.watch(syncStatusProvider);
    final lastSyncTime = ref.watch(lastSyncTimeProvider);
    final syncErrors = ref.watch(syncErrorsProvider);

    // Initialize auto-sync timer
    ref.watch(autoSyncTimerProvider);

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.pop();
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileTitle)),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.green,
            child: Text(
              (user.email?.substring(0, 1) ?? '?').toUpperCase(),
              style: const TextStyle(fontSize: 32, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.email ?? 'Unknown',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 32),
          const Divider(),

          // Sync section
          ListTile(
            leading: const Icon(Icons.sync_outlined),
            title: Text(context.l10n.profileSyncNow),
            subtitle: Text(_syncStatusText(context, syncStatus, lastSyncTime)),
            trailing: syncStatus == SyncStatus.syncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chevron_right),
            onTap: syncStatus == SyncStatus.syncing
                ? null
                : () => _triggerSync(ref),
          ),

          // Show per-table errors if any
          if (syncErrors.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: syncErrors.entries.map((e) {
                  final tableName = e.key.replaceAll('user_', '');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Failed to sync $tableName',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          const Divider(),

          // Sign out
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(context.l10n.profileSignOut, style: const TextStyle(color: Colors.red)),
            onTap: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) context.pop();
            },
          ),
        ],
      ),
    );
  }

  String _syncStatusText(BuildContext context, SyncStatus status, DateTime? lastSync) {
    final lastSyncStr = lastSync != null
        ? '${lastSync.hour.toString().padLeft(2, '0')}:${lastSync.minute.toString().padLeft(2, '0')}'
        : null;

    return switch (status) {
      SyncStatus.idle => lastSyncStr != null
          ? context.l10n.profileLastSynced(lastSyncStr)
          : context.l10n.profileTapToSync,
      SyncStatus.syncing => context.l10n.profileSyncing,
      SyncStatus.success => lastSyncStr != null
          ? context.l10n.profileLastSynced(lastSyncStr)
          : context.l10n.profileSyncCompleted,
      SyncStatus.error => context.l10n.profileSyncFailed,
    };
  }

  Future<void> _triggerSync(WidgetRef ref) async {
    final syncService = ref.read(syncServiceProvider);
    if (syncService == null) return;
    ref.read(syncStatusProvider.notifier).set(SyncStatus.syncing);
    ref.read(syncErrorsProvider.notifier).clear();
    try {
      final results = await syncService.syncAll();
      final errors = <String, String>{};
      for (final r in results) {
        if (!r.ok) errors[r.table] = r.error!;
      }
      ref.read(syncErrorsProvider.notifier).set(errors);
      ref.read(syncStatusProvider.notifier).set(
            errors.isEmpty ? SyncStatus.success : SyncStatus.error,
          );
      ref.read(lastSyncTimeProvider.notifier).set(DateTime.now());
    } catch (_) {
      ref.read(syncStatusProvider.notifier).set(SyncStatus.error);
    }
  }
}
