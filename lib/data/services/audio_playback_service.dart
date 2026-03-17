import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../models/audio_track.dart';

/// Playback speeds available in the audio player.
const List<double> kPlaybackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5];

/// Wraps [AudioPlayer] with queue management, sleep timer, and playback speed.
class AudioPlaybackService {
  AudioPlaybackService() {
    _init();
  }

  final AudioPlayer _player = AudioPlayer();

  final _currentTrackController = StreamController<AudioTrack?>.broadcast();
  final _queueController = StreamController<List<AudioTrack>>.broadcast();

  List<AudioTrack> _queue = [];
  int _queueIndex = -1;
  Timer? _sleepTimer;
  Duration? _sleepDuration;

  // ── Public getters ──────────────────────────────────────────────────────

  AudioPlayer get player => _player;

  Stream<AudioTrack?> get currentTrackStream => _currentTrackController.stream;
  AudioTrack? get currentTrack =>
      _queueIndex >= 0 && _queueIndex < _queue.length
          ? _queue[_queueIndex]
          : null;

  Stream<List<AudioTrack>> get queueStream => _queueController.stream;
  List<AudioTrack> get queue => List.unmodifiable(_queue);
  int get queueIndex => _queueIndex;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<bool> get playingStream => _player.playingStream;

  Duration get position => _player.position;
  Duration? get duration => _player.duration;
  bool get playing => _player.playing;
  double get speed => _player.speed;
  Duration? get sleepDuration => _sleepDuration;

  // ── Init ─────────────────────────────────────────────────────────────────

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    // Auto-advance to next track when current finishes
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        skipNext();
      }
    });
  }

  // ── Playback controls ────────────────────────────────────────────────────

  Future<void> play(AudioTrack track) async {
    // If track is already in the queue, jump to it
    final idx = _queue.indexWhere((t) => t.id == track.id);
    if (idx >= 0) {
      await _playAtIndex(idx);
    } else {
      // Replace queue with single track
      _queue = [track];
      _queueIndex = 0;
      _queueController.add(_queue);
      await _loadAndPlay(track);
    }
  }

  Future<void> playQueue(List<AudioTrack> tracks, {int startIndex = 0}) async {
    _queue = List.of(tracks);
    _queueController.add(_queue);
    await _playAtIndex(startIndex);
  }

  Future<void> resume() => _player.play();
  Future<void> pause() => _player.pause();

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> skipNext() async {
    if (_queueIndex < _queue.length - 1) {
      await _playAtIndex(_queueIndex + 1);
    } else {
      await _player.pause();
      await _player.seek(Duration.zero);
    }
  }

  Future<void> skipPrevious() async {
    // If more than 3s in, restart current track; otherwise go to previous
    if (_player.position.inSeconds > 3) {
      await _player.seek(Duration.zero);
    } else if (_queueIndex > 0) {
      await _playAtIndex(_queueIndex - 1);
    }
  }

  // ── Speed ────────────────────────────────────────────────────────────────

  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  // ── Queue management ─────────────────────────────────────────────────────

  void addToQueue(AudioTrack track) {
    _queue.add(track);
    _queueController.add(_queue);
  }

  void removeFromQueue(int index) {
    if (index < 0 || index >= _queue.length) return;
    _queue.removeAt(index);
    if (index < _queueIndex) {
      _queueIndex--;
    } else if (index == _queueIndex) {
      // Current track removed — play next or stop
      if (_queue.isEmpty) {
        _queueIndex = -1;
        _player.stop();
        _currentTrackController.add(null);
      } else {
        _queueIndex = _queueIndex.clamp(0, _queue.length - 1);
        _loadAndPlay(_queue[_queueIndex]);
      }
    }
    _queueController.add(_queue);
  }

  void reorderQueue(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final track = _queue.removeAt(oldIndex);
    _queue.insert(newIndex, track);
    // Update current index if it moved
    if (oldIndex == _queueIndex) {
      _queueIndex = newIndex;
    } else if (oldIndex < _queueIndex && newIndex >= _queueIndex) {
      _queueIndex--;
    } else if (oldIndex > _queueIndex && newIndex <= _queueIndex) {
      _queueIndex++;
    }
    _queueController.add(_queue);
  }

  // ── Sleep timer ──────────────────────────────────────────────────────────

  void setSleepTimer(Duration duration) {
    cancelSleepTimer();
    _sleepDuration = duration;
    _sleepTimer = Timer(duration, () {
      _player.pause();
      _sleepDuration = null;
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepDuration = null;
  }

  // ── Stop & dispose ───────────────────────────────────────────────────────

  Future<void> stop() async {
    await _player.stop();
    _queue.clear();
    _queueIndex = -1;
    _currentTrackController.add(null);
    _queueController.add(_queue);
    cancelSleepTimer();
  }

  Future<void> dispose() async {
    cancelSleepTimer();
    await _player.dispose();
    await _currentTrackController.close();
    await _queueController.close();
  }

  // ── Private ──────────────────────────────────────────────────────────────

  Future<void> _playAtIndex(int index) async {
    _queueIndex = index;
    await _loadAndPlay(_queue[index]);
  }

  Future<void> _loadAndPlay(AudioTrack track) async {
    _currentTrackController.add(track);
    try {
      if (track.isLocal) {
        await _player.setFilePath(track.url);
      } else {
        await _player.setUrl(track.url);
      }
      await _player.play();
    } catch (e) {
      debugPrint('Audio playback error: $e');
    }
  }
}
