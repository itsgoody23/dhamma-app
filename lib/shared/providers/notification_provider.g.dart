// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DailyReminderEnabledNotifier)
final dailyReminderEnabledProvider = DailyReminderEnabledNotifierProvider._();

final class DailyReminderEnabledNotifierProvider
    extends $NotifierProvider<DailyReminderEnabledNotifier, bool> {
  DailyReminderEnabledNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dailyReminderEnabledProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dailyReminderEnabledNotifierHash();

  @$internal
  @override
  DailyReminderEnabledNotifier create() => DailyReminderEnabledNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$dailyReminderEnabledNotifierHash() =>
    r'ddf8141fc3c7d5a8637cedf2df449ac6e58ae323';

abstract class _$DailyReminderEnabledNotifier extends $Notifier<bool> {
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

@ProviderFor(DailyReminderTimeNotifier)
final dailyReminderTimeProvider = DailyReminderTimeNotifierProvider._();

final class DailyReminderTimeNotifierProvider
    extends $NotifierProvider<DailyReminderTimeNotifier, TimeOfDay> {
  DailyReminderTimeNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dailyReminderTimeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dailyReminderTimeNotifierHash();

  @$internal
  @override
  DailyReminderTimeNotifier create() => DailyReminderTimeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimeOfDay value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimeOfDay>(value),
    );
  }
}

String _$dailyReminderTimeNotifierHash() =>
    r'1c9dc515e9865d407eb16deb9d4759341b350dc7';

abstract class _$DailyReminderTimeNotifier extends $Notifier<TimeOfDay> {
  TimeOfDay build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TimeOfDay, TimeOfDay>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TimeOfDay, TimeOfDay>, TimeOfDay, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
