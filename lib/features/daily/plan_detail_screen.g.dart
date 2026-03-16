// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_detail_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(planById)
final planByIdProvider = PlanByIdFamily._();

final class PlanByIdProvider extends $FunctionalProvider<
        AsyncValue<ReadingPlan?>, ReadingPlan?, FutureOr<ReadingPlan?>>
    with $FutureModifier<ReadingPlan?>, $FutureProvider<ReadingPlan?> {
  PlanByIdProvider._(
      {required PlanByIdFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'planByIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$planByIdHash();

  @override
  String toString() {
    return r'planByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ReadingPlan?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ReadingPlan?> create(Ref ref) {
    final argument = this.argument as String;
    return planById(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlanByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$planByIdHash() => r'dbe3ecb519855b4b82f3abb88c0d99d01bbb2cd1';

final class PlanByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ReadingPlan?>, String> {
  PlanByIdFamily._()
      : super(
          retry: null,
          name: r'planByIdProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  PlanByIdProvider call(
    String planId,
  ) =>
      PlanByIdProvider._(argument: planId, from: this);

  @override
  String toString() => r'planByIdProvider';
}

@ProviderFor(planProgress)
final planProgressProvider = PlanProgressFamily._();

final class PlanProgressProvider extends $FunctionalProvider<
        AsyncValue<Map<String, bool>>,
        Map<String, bool>,
        FutureOr<Map<String, bool>>>
    with
        $FutureModifier<Map<String, bool>>,
        $FutureProvider<Map<String, bool>> {
  PlanProgressProvider._(
      {required PlanProgressFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'planProgressProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$planProgressHash();

  @override
  String toString() {
    return r'planProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, bool>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, bool>> create(Ref ref) {
    final argument = this.argument as String;
    return planProgress(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlanProgressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$planProgressHash() => r'e765a16550a3673e18c768b0c4c00cc2e2f8c77f';

final class PlanProgressFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, bool>>, String> {
  PlanProgressFamily._()
      : super(
          retry: null,
          name: r'planProgressProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  PlanProgressProvider call(
    String planId,
  ) =>
      PlanProgressProvider._(argument: planId, from: this);

  @override
  String toString() => r'planProgressProvider';
}
