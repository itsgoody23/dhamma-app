import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../data/models/audio_track.dart';
import '../../data/services/content_manifest_service.dart';
import '../../shared/providers/audio_provider.dart';

part 'meditation_screen.g.dart';

@riverpod
Future<List<AudioTrack>> meditationTracks(Ref ref) async {
  final data = await ContentManifestService.instance
      .loadManifest('meditation_manifest.json');
  final list = data as List;
  return list.map((e) => AudioTrack.fromJson(e as Map<String, dynamic>)).toList();
}

class MeditationScreen extends ConsumerWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(meditationTracksProvider);
    final service = ref.watch(audioPlaybackServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.audioGuidedMeditation)),
      body: tracksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tracks) => ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            // Guided sessions
            ...tracks.map((track) => Card(
                  margin: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.withAlpha(30),
                      child: const Icon(Icons.self_improvement,
                          color: Colors.indigo),
                    ),
                    title: Text(track.title),
                    subtitle: Text(_formatDuration(track.duration)),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_circle_fill, size: 32),
                      color: Colors.indigo,
                      onPressed: () => service.play(track),
                    ),
                    onTap: () => service.play(track),
                  ),
                )),

            const SizedBox(height: AppSizes.lg),
            const Divider(),
            const SizedBox(height: AppSizes.md),

            // Unguided timer
            Text(context.l10n.audioUnguided,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8)),
            const SizedBox(height: AppSizes.sm),
            Text(
              context.l10n.audioUnguidedDesc,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: AppSizes.md),
            Wrap(
              spacing: AppSizes.sm,
              children: [5, 10, 15, 20, 30, 45]
                  .map((mins) => ActionChip(
                        label: Text(context.l10n.audioMinutes(mins)),
                        avatar: const Icon(Icons.timer_outlined, size: 18),
                        onPressed: () =>
                            _startTimer(context, Duration(minutes: mins)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '';
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _startTimer(BuildContext context, Duration duration) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _MeditationTimerDialog(duration: duration),
    );
  }
}

// ── Meditation Timer Dialog ──────────────────────────────────────────────────

class _MeditationTimerDialog extends StatefulWidget {
  const _MeditationTimerDialog({required this.duration});
  final Duration duration;

  @override
  State<_MeditationTimerDialog> createState() => _MeditationTimerDialogState();
}

class _MeditationTimerDialogState extends State<_MeditationTimerDialog> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 0) {
        _timer?.cancel();
        // Bell sound would play here with just_audio
        return;
      }
      setState(() => _remaining -= const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = _remaining.inSeconds <= 0;
    final m = _remaining.inMinutes.toString().padLeft(2, '0');
    final s = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    final progress = 1.0 -
        (_remaining.inSeconds / widget.duration.inSeconds).clamp(0.0, 1.0);

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSizes.md),
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.green),
                  ),
                ),
                Text(
                  done ? context.l10n.audioDone : '$m:$s',
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          if (done)
            const Icon(Icons.notifications_active,
                size: 32, color: AppColors.green),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(done ? context.l10n.audioClose : context.l10n.audioEndEarly),
        ),
      ],
    );
  }
}
