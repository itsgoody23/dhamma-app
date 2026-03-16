import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/auth_provider.dart';
import 'shared/providers/preferences_provider.dart';
import 'shared/providers/sync_provider.dart';

class DhammaApp extends ConsumerStatefulWidget {
  const DhammaApp({super.key});

  @override
  ConsumerState<DhammaApp> createState() => _DhammaAppState();
}

class _DhammaAppState extends ConsumerState<DhammaApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _triggerSync();
    }
  }

  Future<void> _triggerSync() async {
    final syncService = ref.read(syncServiceProvider);
    if (syncService == null) return; // not signed in

    final status = ref.read(syncStatusProvider);
    if (status == SyncStatus.syncing) return; // already in progress

    ref.read(syncStatusProvider.notifier).set(SyncStatus.syncing);
    try {
      await syncService.syncAll();
      ref.read(syncStatusProvider.notifier).set(SyncStatus.success);
      ref.read(lastSyncTimeProvider.notifier).set(DateTime.now());
    } catch (_) {
      ref.read(syncStatusProvider.notifier).set(SyncStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    // Trigger initial sync after sign-in
    ref.listen(currentUserProvider, (prev, next) {
      if (prev == null && next != null) {
        _triggerSync();
      }
    });

    return MaterialApp.router(
      title: 'Dhamma App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
