import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/tts_service.dart';

final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  ref.onDispose(service.dispose);
  return service;
});

final ttsStateProvider = StreamProvider<TtsState>((ref) {
  final service = ref.watch(ttsServiceProvider);
  return service.stateStream;
});
