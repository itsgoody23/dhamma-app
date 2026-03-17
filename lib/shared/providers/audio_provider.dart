import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/audio_track.dart';
import '../../data/services/audio_playback_service.dart';

part 'audio_provider.g.dart';

/// Singleton audio playback service — kept alive across the app.
@Riverpod(keepAlive: true)
AudioPlaybackService audioPlaybackService(Ref ref) {
  final service = AudioPlaybackService();
  ref.onDispose(() => service.dispose());
  return service;
}

/// Current track being played (null if nothing).
@riverpod
Stream<AudioTrack?> currentAudioTrack(Ref ref) {
  final service = ref.watch(audioPlaybackServiceProvider);
  return service.currentTrackStream;
}

/// Current playback queue.
@riverpod
Stream<List<AudioTrack>> audioQueue(Ref ref) {
  final service = ref.watch(audioPlaybackServiceProvider);
  return service.queueStream;
}

/// Playback position stream.
@riverpod
Stream<Duration> audioPosition(Ref ref) {
  return ref.watch(audioPlaybackServiceProvider).positionStream;
}

/// Track duration stream.
@riverpod
Stream<Duration?> audioDuration(Ref ref) {
  return ref.watch(audioPlaybackServiceProvider).durationStream;
}

/// Player state stream (playing, paused, buffering, etc.).
@riverpod
Stream<PlayerState> audioPlayerState(Ref ref) {
  return ref.watch(audioPlaybackServiceProvider).playerStateStream;
}

/// Whether audio is currently playing.
@riverpod
Stream<bool> audioPlaying(Ref ref) {
  return ref.watch(audioPlaybackServiceProvider).playingStream;
}
