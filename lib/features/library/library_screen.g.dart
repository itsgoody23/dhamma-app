// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(nikayaProgress)
final nikayaProgressProvider = NikayaProgressFamily._();

final class NikayaProgressProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  NikayaProgressProvider._(
      {required NikayaProgressFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'nikayaProgressProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$nikayaProgressHash();

  @override
  String toString() {
    return r'nikayaProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as String;
    return nikayaProgress(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NikayaProgressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$nikayaProgressHash() => r'06f4f304bad14ca7fde2774f3d0039b5acd59e62';

final class NikayaProgressFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, String> {
  NikayaProgressFamily._()
      : super(
          retry: null,
          name: r'nikayaProgressProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  NikayaProgressProvider call(
    String nikaya,
  ) =>
      NikayaProgressProvider._(argument: nikaya, from: this);

  @override
  String toString() => r'nikayaProgressProvider';
}
