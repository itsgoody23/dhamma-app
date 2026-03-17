import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/l10n_extension.dart';
import '../providers/sync_provider.dart';

/// Small banner that appears when sync has errors, with a retry button.
class SyncStatusBanner extends ConsumerWidget {
  const SyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(syncStatusProvider);
    final errors = ref.watch(syncErrorsProvider);

    if (status != SyncStatus.error || errors.isEmpty) {
      return const SizedBox.shrink();
    }

    final failedTables = errors.keys.join(', ');

    return MaterialBanner(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: const Icon(Icons.sync_problem, color: Colors.orange, size: 20),
      content: Text(
        'Sync failed for: $failedTables',
        style: const TextStyle(fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => ref.read(syncErrorsProvider.notifier).clear(),
          child: Text(context.l10n.audioClose),
        ),
        TextButton(
          onPressed: () async {
            final syncService = ref.read(syncServiceProvider);
            if (syncService == null) return;
            ref.read(syncErrorsProvider.notifier).clear();
            ref.read(syncStatusProvider.notifier).set(SyncStatus.syncing);
            try {
              final results = await syncService.syncAll();
              final newErrors = <String, String>{};
              for (final r in results) {
                if (!r.ok) newErrors[r.table] = r.error!;
              }
              ref.read(syncErrorsProvider.notifier).set(newErrors);
              ref.read(syncStatusProvider.notifier).set(
                    newErrors.isEmpty ? SyncStatus.success : SyncStatus.error,
                  );
              ref.read(lastSyncTimeProvider.notifier).set(DateTime.now());
            } catch (e) {
              ref.read(syncErrorsProvider.notifier).set({'sync': e.toString()});
              ref.read(syncStatusProvider.notifier).set(SyncStatus.error);
            }
          },
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
