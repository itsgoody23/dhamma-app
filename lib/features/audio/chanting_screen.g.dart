// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chanting_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chantingTracks)
final chantingTracksProvider = ChantingTracksProvider._();

final class ChantingTracksProvider extends $FunctionalProvider<
        AsyncValue<List<AudioTrack>>,
        List<AudioTrack>,
        FutureOr<List<AudioTrack>>>
    with $FutureModifier<List<AudioTrack>>, $FutureProvider<List<AudioTrack>> {
  ChantingTracksProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chantingTracksProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chantingTracksHash();

  @$internal
  @override
  $FutureProviderElement<List<AudioTrack>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<AudioTrack>> create(Ref ref) {
    return chantingTracks(ref);
  }
}

String _$chantingTracksHash() => r'0d925918e86417c431900307632099787da1c53e';
