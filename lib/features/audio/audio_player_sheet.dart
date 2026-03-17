import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../data/models/audio_track.dart';
import '../../data/services/audio_playback_service.dart';
import '../../shared/providers/audio_provider.dart';

// ── Mini Player ──────────────────────────────────────────────────────────────

/// Persistent mini player bar shown above the bottom navigation.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackAsync = ref.watch(currentAudioTrackProvider);
    final track = trackAsync.value;
    if (track == null) return const SizedBox.shrink();

    final playingAsync = ref.watch(audioPlayingProvider);
    final isPlaying = playingAsync.value ?? false;
    final service = ref.watch(audioPlaybackServiceProvider);

    return GestureDetector(
      onTap: () => _showFullPlayer(context),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          border:
              Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress bar
            _MiniProgress(service: service),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Row(
                  children: [
                    Icon(_trackIcon(track.type),
                        color: AppColors.green, size: 24),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(track.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          if (track.teacher != null)
                            Text(track.teacher!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () => service.togglePlayPause(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => service.stop(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullPlayer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const FullAudioPlayerSheet(),
    );
  }
}

class _MiniProgress extends StatelessWidget {
  const _MiniProgress({required this.service});
  final AudioPlaybackService service;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: service.positionStream,
      builder: (context, posSnap) {
        final pos = posSnap.data ?? Duration.zero;
        final dur = service.duration ?? const Duration(seconds: 1);
        final fraction =
            dur.inMilliseconds > 0 ? pos.inMilliseconds / dur.inMilliseconds : 0.0;
        return LinearProgressIndicator(
          value: fraction.clamp(0.0, 1.0),
          minHeight: 2,
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation(AppColors.green),
        );
      },
    );
  }
}

// ── Full Player Sheet ────────────────────────────────────────────────────────

class FullAudioPlayerSheet extends ConsumerWidget {
  const FullAudioPlayerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(audioPlaybackServiceProvider);
    final trackAsync = ref.watch(currentAudioTrackProvider);
    final track = trackAsync.value;

    if (track == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No audio playing')),
      );
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.xl),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppSizes.xl),

                // Album art placeholder
                CircleAvatar(
                  radius: 64,
                  backgroundColor: AppColors.green.withAlpha(30),
                  child: Icon(_trackIcon(track.type),
                      size: 48, color: AppColors.green),
                ),
                const SizedBox(height: AppSizes.lg),

                // Title & teacher
                Text(track.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700)),
                if (track.teacher != null) ...[
                  const SizedBox(height: 4),
                  Text(track.teacher!,
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade600)),
                ],
                const SizedBox(height: AppSizes.xl),

                // Seek bar
                _SeekBar(service: service),
                const SizedBox(height: AppSizes.md),

                // Controls
                _PlaybackControls(service: service),
                const SizedBox(height: AppSizes.lg),

                // Speed & sleep timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SpeedButton(service: service),
                    _SleepTimerButton(service: service),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Seek Bar ──────────────────────────────────────────────────────────────────

class _SeekBar extends StatelessWidget {
  const _SeekBar({required this.service});
  final AudioPlaybackService service;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: service.positionStream,
      builder: (context, posSnap) {
        final pos = posSnap.data ?? Duration.zero;
        final dur = service.duration ?? Duration.zero;
        return Column(
          children: [
            Slider(
              value: dur.inMilliseconds > 0
                  ? pos.inMilliseconds.toDouble().clamp(0, dur.inMilliseconds.toDouble())
                  : 0,
              max: dur.inMilliseconds > 0 ? dur.inMilliseconds.toDouble() : 1,
              activeColor: AppColors.green,
              onChanged: (v) =>
                  service.seek(Duration(milliseconds: v.round())),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    label: 'Elapsed ${_formatDuration(pos)}',
                    child: Text(_formatDuration(pos),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  Semantics(
                    label: 'Total ${_formatDuration(dur)}',
                    child: Text(_formatDuration(dur),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Playback Controls ─────────────────────────────────────────────────────────

class _PlaybackControls extends StatelessWidget {
  const _PlaybackControls({required this.service});
  final AudioPlaybackService service;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: service.playerStateStream,
      builder: (context, snap) {
        final state = snap.data;
        final isPlaying = state?.playing ?? false;
        final isLoading =
            state?.processingState == ProcessingState.loading ||
                state?.processingState == ProcessingState.buffering;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 36,
              icon: const Icon(Icons.skip_previous),
              tooltip: 'Previous track',
              onPressed: () => service.skipPrevious(),
            ),
            const SizedBox(width: AppSizes.md),
            if (isLoading)
              Semantics(
                label: 'Loading audio',
                child: const SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              )
            else
              IconButton.filled(
                iconSize: 36,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(56, 56),
                ),
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                tooltip: isPlaying ? 'Pause' : 'Play',
                onPressed: () => service.togglePlayPause(),
              ),
            const SizedBox(width: AppSizes.md),
            IconButton(
              iconSize: 36,
              icon: const Icon(Icons.skip_next),
              tooltip: 'Next track',
              onPressed: () => service.skipNext(),
            ),
          ],
        );
      },
    );
  }
}

// ── Speed Button ──────────────────────────────────────────────────────────────

class _SpeedButton extends StatelessWidget {
  const _SpeedButton({required this.service});
  final AudioPlaybackService service;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        const speeds = kPlaybackSpeeds;
        final current = service.speed;
        final idx = speeds.indexOf(current);
        final next = speeds[(idx + 1) % speeds.length];
        service.setSpeed(next);
      },
      child: Text('${service.speed}x',
          style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

// ── Sleep Timer Button ────────────────────────────────────────────────────────

class _SleepTimerButton extends StatelessWidget {
  const _SleepTimerButton({required this.service});
  final AudioPlaybackService service;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.bedtime_outlined,
        color: service.sleepDuration != null ? AppColors.green : null,
      ),
      tooltip: 'Sleep timer',
      onSelected: (minutes) {
        if (minutes == 0) {
          service.cancelSleepTimer();
        } else {
          service.setSleepTimer(Duration(minutes: minutes));
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 0, child: Text('Off')),
        const PopupMenuItem(value: 15, child: Text('15 minutes')),
        const PopupMenuItem(value: 30, child: Text('30 minutes')),
        const PopupMenuItem(value: 45, child: Text('45 minutes')),
        const PopupMenuItem(value: 60, child: Text('60 minutes')),
      ],
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

IconData _trackIcon(AudioTrackType type) => switch (type) {
      AudioTrackType.chanting => Icons.temple_buddhist,
      AudioTrackType.meditation => Icons.self_improvement,
      AudioTrackType.talk => Icons.headphones,
    };

String _formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (h > 0) return '$h:$m:$s';
  return '$m:$s';
}
