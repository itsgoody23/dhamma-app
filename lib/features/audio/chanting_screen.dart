import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/routing/routes.dart';
import '../../data/models/audio_track.dart';
import '../../data/services/audio_playback_service.dart';
import '../../data/services/content_manifest_service.dart';
import '../../shared/providers/audio_provider.dart';
import '../../shared/providers/database_provider.dart';
import 'widgets/chanting_text_view.dart';

part 'chanting_screen.g.dart';

@riverpod
Future<List<AudioTrack>> chantingTracks(Ref ref) async {
  final data = await ContentManifestService.instance
      .loadManifest('chanting_manifest.json');
  final list = data as List;
  return list.map((e) => AudioTrack.fromJson(e as Map<String, dynamic>)).toList();
}

/// Loads sutta plain text for the currently playing chanting track.
final chantingSuttaTextProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, uid) async {
  final db = ref.watch(appDatabaseProvider);
  final sutta = await db.textsDao.getSuttaByUidAnyLanguage(uid);
  return sutta?.contentPlain;
});

class ChantingScreen extends ConsumerWidget {
  const ChantingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(chantingTracksProvider);
    final service = ref.watch(audioPlaybackServiceProvider);
    final currentTrack = ref.watch(currentAudioTrackProvider).value;
    final isPlaying = ref.watch(audioPlayingProvider).value ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.audioChanting)),
      body: Column(
        children: [
          Expanded(
            child: tracksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (tracks) => ListView.separated(
                padding: const EdgeInsets.all(AppSizes.md),
                itemCount: tracks.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final track = tracks[index];
                  final isCurrent = currentTrack?.id == track.id;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isCurrent
                          ? AppColors.green.withValues(alpha: 0.2)
                          : const Color(0x204A7C59),
                      child: isCurrent && isPlaying
                          ? const Icon(Icons.equalizer, color: AppColors.green)
                          : const Icon(Icons.temple_buddhist,
                              color: AppColors.green),
                    ),
                    title: Text(
                      track.title,
                      style: TextStyle(
                        fontWeight:
                            isCurrent ? FontWeight.w700 : FontWeight.normal,
                        color: isCurrent ? AppColors.green : null,
                      ),
                    ),
                    subtitle: Text(_formatDuration(track.duration)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (track.suttaUid != null)
                          IconButton(
                            icon:
                                const Icon(Icons.menu_book_outlined, size: 20),
                            tooltip: context.l10n.audioOpenSutta,
                            onPressed: () =>
                                context.push(Routes.readerPath(track.suttaUid!)),
                          ),
                        IconButton(
                          icon: Icon(
                            isCurrent && isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            size: 32,
                          ),
                          color: AppColors.green,
                          onPressed: () {
                            if (isCurrent) {
                              service.togglePlayPause();
                            } else {
                              service.play(track);
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      if (isCurrent) {
                        service.togglePlayPause();
                      } else {
                        service.play(track);
                      }
                    },
                  );
                },
              ),
            ),
          ),
          // Chanting text auto-scroll when track has suttaUid
          if (currentTrack != null && currentTrack.suttaUid != null)
            _ChantingTextSection(
              suttaUid: currentTrack.suttaUid!,
              service: service,
            ),
          // Inline now-playing bar
          if (currentTrack != null) _InlineNowPlaying(service: service),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: currentTrack != null ? 72 : 0),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.playlist_play),
          label: Text(context.l10n.audioPlayAll),
          onPressed: () {
            final tracks = tracksAsync.value;
            if (tracks != null && tracks.isNotEmpty) {
              service.playQueue(tracks);
            }
          },
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
}

// ── Chanting Text Section ─────────────────────────────────────────────────────

class _ChantingTextSection extends ConsumerWidget {
  const _ChantingTextSection({
    required this.suttaUid,
    required this.service,
  });

  final String suttaUid;
  final AudioPlaybackService service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textAsync = ref.watch(chantingSuttaTextProvider(suttaUid));

    return textAsync.when(
      data: (text) {
        if (text == null || text.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 200,
          child: ChantingTextView(
            text: text,
            positionStream: service.positionStream,
            durationStream: service.durationStream,
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// ── Inline Now Playing ────────────────────────────────────────────────────────

class _InlineNowPlaying extends ConsumerWidget {
  const _InlineNowPlaying({required this.service});
  final AudioPlaybackService service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = ref.watch(currentAudioTrackProvider).value;
    final isPlaying = ref.watch(audioPlayingProvider).value ?? false;
    if (track == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          StreamBuilder<Duration>(
            stream: service.positionStream,
            builder: (context, posSnap) {
              final pos = posSnap.data ?? Duration.zero;
              final dur = service.duration ?? const Duration(seconds: 1);
              final fraction = dur.inMilliseconds > 0
                  ? pos.inMilliseconds / dur.inMilliseconds
                  : 0.0;
              return LinearProgressIndicator(
                value: fraction.clamp(0.0, 1.0),
                minHeight: 2,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation(AppColors.green),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md, vertical: AppSizes.sm),
            child: Row(
              children: [
                const Icon(Icons.temple_buddhist,
                    color: AppColors.green, size: 24),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () => service.togglePlayPause(),
                ),
                IconButton(
                  icon: const Icon(Icons.stop, size: 20),
                  onPressed: () => service.stop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
