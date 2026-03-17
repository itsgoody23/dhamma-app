import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/services/sync_service.dart';
import 'auth_provider.dart';
import 'database_provider.dart';
import 'preferences_provider.dart';

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

/// Errors from the last sync, keyed by table name.
@riverpod
class SyncErrorsNotifier extends _$SyncErrorsNotifier {
  @override
  Map<String, String> build() => {};

  void set(Map<String, String> errors) => state = errors;

  void clear() => state = {};
}

/// Auto-sync timer that runs every 15 minutes when user is signed in.
/// Respects Wi-Fi-only preference on mobile data.
@riverpod
class AutoSyncTimer extends _$AutoSyncTimer {
  Timer? _timer;
  static const _interval = Duration(minutes: 15);

  @override
  bool build() {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      _cancel();
      return false;
    }

    // Start auto-sync when user is signed in
    _scheduleTimer();

    ref.onDispose(_cancel);
    return true;
  }

  void _scheduleTimer() {
    _cancel();
    _timer = Timer.periodic(_interval, (_) => _performSync());
  }

  void _cancel() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _performSync() async {
    final syncService = ref.read(syncServiceProvider);
    if (syncService == null || syncService.isSyncing) return;

    // Check Wi-Fi-only preference
    final wifiOnly = ref.read(wifiOnlyProvider);
    if (wifiOnly) {
      final connectivity = await Connectivity().checkConnectivity();
      if (!connectivity.contains(ConnectivityResult.wifi) &&
          !connectivity.contains(ConnectivityResult.ethernet)) {
        return;
      }
    }

    ref.read(syncStatusProvider.notifier).set(SyncStatus.syncing);
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
