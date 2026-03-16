import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/sync_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final syncStatus = ref.watch(syncStatusProvider);

    if (user == null) {
      // Redirect handled by router, but just in case
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.pop();
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
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
            title: const Text('Sync Now'),
            subtitle: Text(_syncStatusText(syncStatus)),
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
          const Divider(),

          // Sign out
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) context.pop();
            },
          ),
        ],
      ),
    );
  }

  String _syncStatusText(SyncStatus status) {
    return switch (status) {
      SyncStatus.idle => 'Tap to sync your data',
      SyncStatus.syncing => 'Syncing...',
      SyncStatus.success => 'Last sync completed',
      SyncStatus.error => 'Sync failed — tap to retry',
    };
  }

  Future<void> _triggerSync(WidgetRef ref) async {
    final syncService = ref.read(syncServiceProvider);
    if (syncService == null) return;
    ref.read(syncStatusProvider.notifier).set(SyncStatus.syncing);
    try {
      await syncService.syncAll();
      ref.read(syncStatusProvider.notifier).set(SyncStatus.success);
    } catch (_) {
      ref.read(syncStatusProvider.notifier).set(SyncStatus.error);
    }
  }
}
