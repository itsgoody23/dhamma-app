// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Singleton audio playback service — kept alive across the app.

@ProviderFor(audioPlaybackService)
final audioPlaybackServiceProvider = AudioPlaybackServiceProvider._();

/// Singleton audio playback service — kept alive across the app.

final class AudioPlaybackServiceProvider extends $FunctionalProvider<
    AudioPlaybackService,
    AudioPlaybackService,
    AudioPlaybackService> with $Provider<AudioPlaybackService> {
  /// Singleton audio playback service — kept alive across the app.
  AudioPlaybackServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'audioPlaybackServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$audioPlaybackServiceHash();

  @$internal
  @override
  $ProviderElement<AudioPlaybackService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AudioPlaybackService create(Ref ref) {
    return audioPlaybackService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioPlaybackService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioPlaybackService>(value),
    );
  }
}

String _$audioPlaybackServiceHash() =>
    r'5bf4580ee434f537f5a0337b4111219ae2f380ac';

/// Current track being played (null if nothing).

@ProviderFor(currentAudioTrack)
final currentAudioTrackProvider = CurrentAudioTrackProvider._();

/// Current track being played (null if nothing).

final class CurrentAudioTrackProvider extends $FunctionalProvider<
        AsyncValue<AudioTrack?>, AudioTrack?, Stream<AudioTrack?>>
    with $FutureModifier<AudioTrack?>, $StreamProvider<AudioTrack?> {
  /// Current track being played (null if nothing).
  CurrentAudioTrackProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currentAudioTrackProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentAudioTrackHash();

  @$internal
  @override
  $StreamProviderElement<AudioTrack?> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AudioTrack?> create(Ref ref) {
    return currentAudioTrack(ref);
  }
}

String _$currentAudioTrackHash() => r'7d41d824b67764403f8de2d18fbf7eeb3ca0fa86';

/// Current playback queue.

@ProviderFor(audioQueue)
final audioQueueProvider = AudioQueueProvider._();

/// Current playback queue.

final class AudioQueueProvider extends $FunctionalProvider<
        AsyncValue<List<AudioTrack>>,
        List<AudioTrack>,
        Stream<List<AudioTrack>>>
    with $FutureModifier<List<AudioTrack>>, $StreamProvider<List<AudioTrack>> {
  /// Current playback queue.
  AudioQueueProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'audioQueueProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$audioQueueHash();

  @$internal
  @override
  $StreamProviderElement<List<AudioTrack>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<AudioTrack>> create(Ref ref) {
    return audioQueue(ref);
  }
}

String _$audioQueueHash() => r'285c331e57e8e4fbbc238e37c5d60f0d1fd494a1';

/// Playback position stream.

@ProviderFor(audioPosition)
final audioPositionProvider = AudioPositionProvider._();

/// Playback position stream.

final class AudioPositionProvider extends $FunctionalProvider<
        AsyncValue<Duration>, Duration, Stream<Duration>>
    with $FutureModifier<Duration>, $StreamProvider<Duration> {
  /// Playback position stream.
  AudioPositionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'audioPositionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$audioPositionHash();

  @$internal
  @override
  $StreamProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Duration> create(Ref ref) {
    return audioPosition(ref);
  }
}

String _$audioPositionHash() => r'39de51848560e1b0bcd4148f07c6ec07d4d7f006';

/// Track duration stream.

@ProviderFor(audioDuration)
final audioDurationProvider = AudioDurationProvider._();

/// Track duration stream.

final class AudioDurationProvider extends $FunctionalProvider<
        AsyncValue<Duration?>, Duration?, Stream<Duration?>>
    with $FutureModifier<Duration?>, $StreamProvider<Duration?> {
  /// Track duration stream.
  AudioDurationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'audioDurationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$audioDurationHash();

  @$internal
  @override
  $StreamProviderElement<Duration?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Duration?> create(Ref ref) {
    return audioDuration(ref);
  }
}

String _$audioDurationHash() => r'fad6332d165484506d4a1f3e90f926fedac9860a';

/// Player state stream (playing, paused, buffering, etc.).

@ProviderFor(audioPlayerState)
final audioPlayerStateProvider = AudioPlayerStateProvider._();

/// Player state stream (playing, paused, buffering, etc.).

final class AudioPlayerStateProvider extends $FunctionalProvider<
        AsyncValue<PlayerState>, PlayerState, Stream<PlayerState>>
    with $FutureModifier<PlayerState>, $StreamProvider<PlayerState> {
  /// Player state stream (playing, paused, buffering, etc.).
  AudioPlayerStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'audioPlayerStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$audioPlayerStateHash();

  @$internal
  @override
  $StreamProviderElement<PlayerState> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<PlayerState> create(Ref ref) {
    return audioPlayerState(ref);
  }
}

String _$audioPlayerStateHash() => r'a1809930f5aa04adf2d4f2ea5dfa1239b89c990f';

/// Whether audio is currently playing.

@ProviderFor(audioPlaying)
final audioPlayingProvider = AudioPlayingProvider._();

/// Whether audio is currently playing.

final class AudioPlayingProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Whether audio is currently playing.
  AudioPlayingProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'audioPlayingProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$audioPlayingHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return audioPlaying(ref);
  }
}

String _$audioPlayingHash() => r'4b057b021e57b434cd20e6a2256009592af04652';
