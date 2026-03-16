import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/services/sync_service.dart';
import 'auth_provider.dart';
import 'database_provider.dart';

part 'sync_provider.g.dart';

enum SyncStatus { idle, syncing, success, error }

/// Sync service — null when user is not authenticated.
@riverpod
SyncService? syncService(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return SyncService(
    db: ref.watch(appDatabaseProvider),
    supabase: ref.watch(supabaseClientProvider),
    userId: user.id,
  );
}

/// Current sync status for UI indicators.
@riverpod
class SyncStatusNotifier extends _$SyncStatusNotifier {
  @override
  SyncStatus build() => SyncStatus.idle;

  void set(SyncStatus status) => state = status;
}

/// Last sync timestamp.
@riverpod
class LastSyncTimeNotifier extends _$LastSyncTimeNotifier {
  @override
  DateTime? build() => null;

  void set(DateTime? time) => state = time;
}
