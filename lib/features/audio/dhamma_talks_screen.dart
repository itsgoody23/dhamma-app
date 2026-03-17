import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../data/models/audio_track.dart';
import '../../data/services/content_manifest_service.dart';
import '../../data/services/youtube_service.dart';
import '../../shared/providers/audio_provider.dart';
import '../../shared/providers/database_provider.dart';

part 'dhamma_talks_screen.g.dart';

// ── Models ───────────────────────────────────────────────────────────────────

class TalkCollection {
  const TalkCollection({
    required this.id,
    required this.title,
    required this.teacher,
    required this.description,
    required this.tracks,
  });

  final String id;
  final String title;
  final String teacher;
  final String description;
  final List<AudioTrack> tracks;

  factory TalkCollection.fromJson(Map<String, dynamic> json) {
    final tracksList = (json['tracks'] as List)
        .map((t) => AudioTrack.fromJson(t as Map<String, dynamic>))
        .toList();
    return TalkCollection(
      id: json['id'] as String,
      title: json['title'] as String,
      teacher: json['teacher'] as String,
      description: json['description'] as String,
      tracks: tracksList,
    );
  }
}

// ── Providers ────────────────────────────────────────────────────────────────

@riverpod
YoutubeService youtubeService(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final service = YoutubeService(db);
  ref.onDispose(() => service.dispose());
  return service;
}

@riverpod
Future<List<AudioTrack>> teacherTalks(Ref ref, String channelId) {
  return ref.watch(youtubeServiceProvider).getChannelTalks(channelId);
}

@riverpod
Future<List<AudioTrack>> searchTalks(Ref ref, String query) {
  if (query.isEmpty) return Future.value([]);
  return ref.watch(youtubeServiceProvider).search(query);
}

@riverpod
Future<List<TeacherChannel>> teacherChannels(Ref ref) {
  return ref.watch(youtubeServiceProvider).getChannels();
}

@riverpod
Future<List<TalkCollection>> curatedTalkCollections(Ref ref) async {
  final data = await ContentManifestService.instance
      .loadManifest('talks_manifest.json') as Map<String, dynamic>;
  final list = data['collections'] as List;
  return list
      .map((e) => TalkCollection.fromJson(e as Map<String, dynamic>))
      .toList();
}

// ── Screen ───────────────────────────────────────────────────────────────────

class DhammaTalksScreen extends ConsumerStatefulWidget {
  const DhammaTalksScreen({super.key});

  @override
  ConsumerState<DhammaTalksScreen> createState() => _DhammaTalksScreenState();
}

class _DhammaTalksScreenState extends ConsumerState<DhammaTalksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  final _searchController = TextEditingController();
  String? _selectedChannelId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.audioDhammaTalks),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Curated'),
            Tab(text: 'YouTube'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          // Tab 1: Curated collections from dhammatalks.org
          _CuratedTab(),

          // Tab 2: YouTube search + teacher browse
          _YoutubeTab(
            searchController: _searchController,
            searchQuery: _searchQuery,
            selectedChannelId: _selectedChannelId,
            onSearchChanged: (q) => setState(() => _searchQuery = q),
            onSelectChannel: (id) =>
                setState(() => _selectedChannelId = id),
          ),
        ],
      ),
    );
  }
}

// ── Curated Tab ──────────────────────────────────────────────────────────────

class _CuratedTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(curatedTalkCollectionsProvider);

    return collectionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (collections) => ListView.builder(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final collection = collections[index];
          return _CollectionCard(collection: collection);
        },
      ),
    );
  }
}

class _CollectionCard extends ConsumerWidget {
  const _CollectionCard({required this.collection});
  final TalkCollection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(audioPlaybackServiceProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade50,
          child: Icon(Icons.headphones, color: Colors.orange.shade700),
        ),
        title: Text(collection.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${collection.teacher} · ${collection.tracks.length} talks',
          style: const TextStyle(fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: Row(
              children: [
                Expanded(
                  child: Text(collection.description,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade600)),
                ),
                IconButton(
                  icon: const Icon(Icons.playlist_play),
                  color: AppColors.green,
                  tooltip: 'Play all',
                  onPressed: () => service.playQueue(collection.tracks),
                ),
              ],
            ),
          ),
          const Divider(),
          ...collection.tracks.map((track) => ListTile(
                dense: true,
                leading: const Icon(Icons.play_circle_outline, size: 24),
                title: Text(track.title, style: const TextStyle(fontSize: 14)),
                subtitle: Text(_fmt(track.duration),
                    style: const TextStyle(fontSize: 11)),
                onTap: () => service.play(track),
              )),
          const SizedBox(height: AppSizes.xs),
        ],
      ),
    );
  }

  String _fmt(Duration? d) {
    if (d == null) return '';
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

// ── YouTube Tab ──────────────────────────────────────────────────────────────

class _YoutubeTab extends StatelessWidget {
  const _YoutubeTab({
    required this.searchController,
    required this.searchQuery,
    required this.selectedChannelId,
    required this.onSearchChanged,
    required this.onSelectChannel,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final String? selectedChannelId;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onSelectChannel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search YouTube talks...',
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        searchController.clear;
                        onSearchChanged('');
                      },
                    )
                  : null,
            ),
            onSubmitted: (q) => onSearchChanged(q.trim()),
          ),
        ),
        Expanded(
          child: searchQuery.isNotEmpty
              ? _SearchResults(query: searchQuery)
              : _TeacherBrowse(
                  selectedChannelId: selectedChannelId,
                  onSelectChannel: onSelectChannel,
                ),
        ),
      ],
    );
  }
}

// ── Teacher Browse ───────────────────────────────────────────────────────────

class _TeacherBrowse extends ConsumerWidget {
  const _TeacherBrowse({
    required this.selectedChannelId,
    required this.onSelectChannel,
  });

  final String? selectedChannelId;
  final ValueChanged<String?> onSelectChannel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedChannelId != null) {
      return _ChannelTalksList(
        channelId: selectedChannelId!,
        onBack: () => onSelectChannel(null),
      );
    }

    final channelsAsync = ref.watch(teacherChannelsProvider);

    return channelsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (channels) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('TEACHERS',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline,
                    color: AppColors.green),
                tooltip: 'Add teacher channel',
                onPressed: () => _showAddChannelDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          ...channels.map((ch) => Card(
                margin: const EdgeInsets.only(bottom: AppSizes.xs),
                child: ListTile(
                  leading: ch.thumbnailUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(ch.thumbnailUrl!),
                          onBackgroundImageError: (_, __) {},
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.orange.shade50,
                          child: Icon(Icons.person,
                              color: Colors.orange.shade700),
                        ),
                  title: Text(ch.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!ch.isDefault)
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              size: 20, color: Colors.red),
                          tooltip: 'Remove',
                          onPressed: () async {
                            final ytService =
                                ref.read(youtubeServiceProvider);
                            await ytService.removeChannel(ch.channelId);
                            ref.invalidate(teacherChannelsProvider);
                          },
                        ),
                      const Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
                  onTap: () => onSelectChannel(ch.channelId),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _showAddChannelDialog(
      BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add YouTube Channel'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Channel URL or ID',
            helperText: 'e.g. https://youtube.com/@ChannelName',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final ytService = ref.read(youtubeServiceProvider);
        await ytService.addChannel(result);
        ref.invalidate(teacherChannelsProvider);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not add channel: $e')),
          );
        }
      }
    }
  }
}

// ── Channel Talks List ───────────────────────────────────────────────────────

class _ChannelTalksList extends ConsumerWidget {
  const _ChannelTalksList({
    required this.channelId,
    required this.onBack,
  });

  final String channelId;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talksAsync = ref.watch(teacherTalksProvider(channelId));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.arrow_back), onPressed: onBack),
              const Expanded(
                  child: Text('Talks',
                      style: TextStyle(fontWeight: FontWeight.w600))),
            ],
          ),
        ),
        Expanded(
          child: talksAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: AppSizes.sm),
                  Text('Could not load talks\n$e',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: AppSizes.md),
                  OutlinedButton(
                    onPressed: () =>
                        ref.invalidate(teacherTalksProvider(channelId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (talks) {
              if (talks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.inbox_outlined,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: AppSizes.sm),
                      const Text('No results',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: AppSizes.md),
                      OutlinedButton(
                        onPressed: () =>
                            ref.invalidate(teacherTalksProvider(channelId)),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(AppSizes.md),
                itemCount: talks.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) =>
                    _YtTalkTile(track: talks[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Search Results ───────────────────────────────────────────────────────────

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query});
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchTalksProvider(query));

    return resultsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            const SizedBox(height: AppSizes.sm),
            Text('Could not load results\n$e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: AppSizes.md),
            OutlinedButton(
              onPressed: () => ref.invalidate(searchTalksProvider(query)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (results) {
        if (results.isEmpty) {
          return const Center(
            child: Text('No results found',
                style: TextStyle(color: Colors.grey)),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.md),
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) =>
              _YtTalkTile(track: results[index]),
        );
      },
    );
  }
}

// ── YouTube Talk Tile ────────────────────────────────────────────────────────

class _YtTalkTile extends ConsumerWidget {
  const _YtTalkTile({required this.track});
  final AudioTrack track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(audioPlaybackServiceProvider);
    final ytService = ref.watch(youtubeServiceProvider);

    return ListTile(
      leading: track.thumbnailUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(track.thumbnailUrl!,
                  width: 56, height: 42, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _FallbackThumb()),
            )
          : const _FallbackThumb(),
      title: Text(track.title,
          maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        [
          if (track.teacher != null) track.teacher!,
          if (track.duration != null) _fmt(track.duration!),
        ].join(' · '),
        style: const TextStyle(fontSize: 12),
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 20),
        onSelected: (value) async {
          if (value == 'audio') {
            _playAudioOnly(service, ytService);
          } else if (value == 'video') {
            _showVideoPlayer(context);
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'audio', child: Text('Play audio only')),
          PopupMenuItem(value: 'video', child: Text('Watch video')),
        ],
      ),
      onTap: () => _playAudioOnly(service, ytService),
    );
  }

  Future<void> _playAudioOnly(
    dynamic service,
    YoutubeService ytService,
  ) async {
    final youtubeId = track.id.replaceFirst('yt-', '');
    final audioUrl = await ytService.getAudioStreamUrl(youtubeId);
    final resolved = track.copyWith(url: audioUrl);
    service.play(resolved);
  }

  void _showVideoPlayer(BuildContext context) {
    final youtubeId = track.id.replaceFirst('yt-', '');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _VideoPlayerScreen(youtubeId: youtubeId),
      ),
    );
  }

  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}

class _FallbackThumb extends StatelessWidget {
  const _FallbackThumb();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 42,
      color: Colors.grey.shade200,
      child: const Icon(Icons.headphones, size: 20, color: Colors.grey),
    );
  }
}

// ── Video Player Screen ──────────────────────────────────────────────────────

class _VideoPlayerScreen extends StatefulWidget {
  const _VideoPlayerScreen({required this.youtubeId});
  final String youtubeId;

  @override
  State<_VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<_VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: AppColors.green,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
