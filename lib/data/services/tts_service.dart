import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, paused, stopped }

class TtsService {
  TtsService() {
    _init();
  }

  final FlutterTts _tts = FlutterTts();
  final _stateController = StreamController<TtsState>.broadcast();
  TtsState _state = TtsState.stopped;
  String _currentText = '';
  int _currentPosition = 0;

  Stream<TtsState> get stateStream => _stateController.stream;
  TtsState get state => _state;

  Future<void> _init() async {
    await _tts.setSharedInstance(true);
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      _state = TtsState.playing;
      _stateController.add(_state);
    });

    _tts.setCompletionHandler(() {
      _state = TtsState.stopped;
      _stateController.add(_state);
      _currentPosition = 0;
    });

    _tts.setCancelHandler(() {
      _state = TtsState.stopped;
      _stateController.add(_state);
    });

    _tts.setPauseHandler(() {
      _state = TtsState.paused;
      _stateController.add(_state);
    });

    _tts.setContinueHandler(() {
      _state = TtsState.playing;
      _stateController.add(_state);
    });

    _tts.setProgressHandler((text, start, end, word) {
      _currentPosition = start;
    });
  }

  Future<void> speak(String text, {String language = 'en'}) async {
    _currentText = text;
    _currentPosition = 0;

    // Set language — Pali falls back to English voice
    final lang = language == 'pli' ? 'en-US' : _langCode(language);
    await _tts.setLanguage(lang);

    _state = TtsState.playing;
    _stateController.add(_state);
    await _tts.speak(text);
  }

  Future<void> pause() async {
    await _tts.pause();
  }

  Future<void> resume() async {
    // flutter_tts doesn't have a clean resume on all platforms,
    // so we restart from approximate position if needed
    if (_state == TtsState.paused) {
      await _tts.speak(_currentText.substring(_currentPosition));
    }
  }

  Future<void> stop() async {
    await _tts.stop();
    _state = TtsState.stopped;
    _stateController.add(_state);
    _currentPosition = 0;
  }

  Future<void> setSpeed(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  String _langCode(String code) {
    return switch (code) {
      'en' => 'en-US',
      'de' => 'de-DE',
      'fr' => 'fr-FR',
      'es' => 'es-ES',
      'si' => 'si-LK',
      _ => 'en-US',
    };
  }

  void dispose() {
    _tts.stop();
    _stateController.close();
  }
}
