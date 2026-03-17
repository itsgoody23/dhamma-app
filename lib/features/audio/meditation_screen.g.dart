// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(meditationTracks)
final meditationTracksProvider = MeditationTracksProvider._();

final class MeditationTracksProvider extends $FunctionalProvider<
        AsyncValue<List<AudioTrack>>,
        List<AudioTrack>,
        FutureOr<List<AudioTrack>>>
    with $FutureModifier<List<AudioTrack>>, $FutureProvider<List<AudioTrack>> {
  MeditationTracksProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'meditationTracksProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$meditationTracksHash();

  @$internal
  @override
  $FutureProviderElement<List<AudioTrack>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<AudioTrack>> create(Ref ref) {
    return meditationTracks(ref);
  }
}

String _$meditationTracksHash() => r'20a8f001b9c3b362a3c445ce94a9205979e024a8';
