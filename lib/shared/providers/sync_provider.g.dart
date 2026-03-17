// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sync service — null when user is not authenticated.

@ProviderFor(syncService)
final syncServiceProvider = SyncServiceProvider._();

/// Sync service — null when user is not authenticated.

final class SyncServiceProvider
    extends $FunctionalProvider<SyncService?, SyncService?, SyncService?>
    with $Provider<SyncService?> {
  /// Sync service — null when user is not authenticated.
  SyncServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncServiceHash();

  @$internal
  @override
  $ProviderElement<SyncService?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncService? create(Ref ref) {
    return syncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncService? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncService?>(value),
    );
  }
}

String _$syncServiceHash() => r'76e39ab6630cdc1b345863b215e4e70dfbd6483b';

/// Current sync status for UI indicators.

@ProviderFor(SyncStatusNotifier)
final syncStatusProvider = SyncStatusNotifierProvider._();

/// Current sync status for UI indicators.
final class SyncStatusNotifierProvider
    extends $NotifierProvider<SyncStatusNotifier, SyncStatus> {
  /// Current sync status for UI indicators.
  SyncStatusNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncStatusProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncStatusNotifierHash();

  @$internal
  @override
  SyncStatusNotifier create() => SyncStatusNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncStatus>(value),
    );
  }
}

String _$syncStatusNotifierHash() =>
    r'ae1c6cfb717966084d915c8bd33cc4296066c3a4';

/// Current sync status for UI indicators.

abstract class _$SyncStatusNotifier extends $Notifier<SyncStatus> {
  SyncStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncStatus, SyncStatus>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SyncStatus, SyncStatus>, SyncStatus, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Last sync timestamp.

@ProviderFor(LastSyncTimeNotifier)
final lastSyncTimeProvider = LastSyncTimeNotifierProvider._();

/// Last sync timestamp.
final class LastSyncTimeNotifierProvider
    extends $NotifierProvider<LastSyncTimeNotifier, DateTime?> {
  /// Last sync timestamp.
  LastSyncTimeNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'lastSyncTimeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$lastSyncTimeNotifierHash();

  @$internal
  @override
  LastSyncTimeNotifier create() => LastSyncTimeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$lastSyncTimeNotifierHash() =>
    r'e283bcede93b76f7dc20178b6e2d667499fd170e';

/// Last sync timestamp.

abstract class _$LastSyncTimeNotifier extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<DateTime?, DateTime?>, DateTime?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Errors from the last sync, keyed by table name.

@ProviderFor(SyncErrorsNotifier)
final syncErrorsProvider = SyncErrorsNotifierProvider._();

/// Errors from the last sync, keyed by table name.
final class SyncErrorsNotifierProvider
    extends $NotifierProvider<SyncErrorsNotifier, Map<String, String>> {
  /// Errors from the last sync, keyed by table name.
  SyncErrorsNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncErrorsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncErrorsNotifierHash();

  @$internal
  @override
  SyncErrorsNotifier create() => SyncErrorsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }
}

String _$syncErrorsNotifierHash() =>
    r'204be9fff17b7e240a9aeed8f7902586ec847a0b';

/// Errors from the last sync, keyed by table name.

abstract class _$SyncErrorsNotifier extends $Notifier<Map<String, String>> {
  Map<String, String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, String>, Map<String, String>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Map<String, String>, Map<String, String>>,
        Map<String, String>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Auto-sync timer that runs every 15 minutes when user is signed in.
/// Respects Wi-Fi-only preference on mobile data.

@ProviderFor(AutoSyncTimer)
final autoSyncTimerProvider = AutoSyncTimerProvider._();

/// Auto-sync timer that runs every 15 minutes when user is signed in.
/// Respects Wi-Fi-only preference on mobile data.
final class AutoSyncTimerProvider
    extends $NotifierProvider<AutoSyncTimer, bool> {
  /// Auto-sync timer that runs every 15 minutes when user is signed in.
  /// Respects Wi-Fi-only preference on mobile data.
  AutoSyncTimerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'autoSyncTimerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$autoSyncTimerHash();

  @$internal
  @override
  AutoSyncTimer create() => AutoSyncTimer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$autoSyncTimerHash() => r'8bc54e9d742d6946023c168a46ce5dc40b04ff60';

/// Auto-sync timer that runs every 15 minutes when user is signed in.
/// Respects Wi-Fi-only preference on mobile data.

abstract class _$AutoSyncTimer extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
