import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/routing/routes.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/progress_dao.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/preferences_provider.dart';
import '../../shared/providers/tabs_provider.dart';

part 'library_screen.g.dart';

// ── Nikaya metadata ───────────────────────────────────────────────────────────

class _NikayaInfo {
  const _NikayaInfo({
    required this.id,
    required this.pali,
    required this.english,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String pali;
  final String english;
  final String subtitle;
  final IconData icon;
}

const _nikayas = [
  _NikayaInfo(
    id: 'dn',
    pali: 'Dīgha Nikāya',
    english: 'Long Discourses',
    subtitle: '34 suttas — foundational teachings in depth',
    icon: Icons.auto_stories_outlined,
  ),
  _NikayaInfo(
    id: 'mn',
    pali: 'Majjhima Nikāya',
    english: 'Middle-Length Discourses',
    subtitle: '152 suttas — the heart of Theravāda practice',
    icon: Icons.spa_outlined,
  ),
  _NikayaInfo(
    id: 'sn',
    pali: 'Saṃyutta Nikāya',
    english: 'Connected Discourses',
    subtitle: '2,900+ suttas — grouped by topic',
    icon: Icons.hub_outlined,
  ),
  _NikayaInfo(
    id: 'an',
    pali: 'Aṅguttara Nikāya',
    english: 'Numerical Discourses',
    subtitle: '8,000+ suttas — organised by number',
    icon: Icons.format_list_numbered_outlined,
  ),
  _NikayaInfo(
    id: 'kn',
    pali: 'Khuddaka Nikāya',
    english: 'Minor Collection',
    subtitle: 'Dhammapada, Sutta Nipāta, Jātaka & more',
    icon: Icons.collections_bookmark_outlined,
  ),
];

// ── Progress provider ─────────────────────────────────────────────────────────

@riverpod
Future<double> nikayaProgress(
  Ref ref,
  String nikaya,
) async {
  final db = ref.watch(appDatabaseProvider);
  final lang = ref.watch(readerLanguageProvider);
  final total = await db.textsDao.countSuttasInNikaya(nikaya, lang);
  if (total == 0) return 0;
  final completed = await db.progressDao.countCompletedInNikaya(nikaya, lang);
  return completed / total;
}

// ── Providers for library sections ────────────────────────────────────────────

final _recentlyOpenedProvider =
    FutureProvider.autoDispose<List<RecentlyReadItem>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.progressDao.getRecentlyReadWithTitles(limit: 8);
});

final _allBookmarksProvider =
    StreamProvider.autoDispose<List<UserBookmark>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.studyToolsDao.watchAllBookmarks();
});

final _allCollectionsProvider =
    StreamProvider.autoDispose<List<UserCollection>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.collectionsDao.watchAllCollections();
});

// ── Screen ────────────────────────────────────────────────────────────────────

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.libraryTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () => context.push(Routes.downloads),
            tooltip: 'Downloads',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(Routes.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          // ── Recently Opened ──────────────────────────────────────────────
          const _LibSectionHeader('RECENTLY OPENED'),
          const SizedBox(height: 6),
          const _RecentlyOpenedRow(),
          const SizedBox(height: AppSizes.md),

          // ── Bookmarks ────────────────────────────────────────────────────
          Row(
            children: [
              const Expanded(child: _LibSectionHeader('BOOKMARKS')),
              TextButton(
                onPressed: () => context.push(Routes.study),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.green,
                    visualDensity: VisualDensity.compact),
                child: const Text('See all →',
                    style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const _BookmarksSection(),
          const SizedBox(height: AppSizes.md),

          // ── Collections ──────────────────────────────────────────────────
          Row(
            children: [
              const Expanded(child: _LibSectionHeader('COLLECTIONS')),
              IconButton(
                icon: const Icon(Icons.add, size: 18, color: AppColors.green),
                tooltip: 'New collection',
                visualDensity: VisualDensity.compact,
                onPressed: () => context.push(Routes.collections),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const _CollectionsSection(),
          const Divider(height: AppSizes.xl),

          // ── Texts (Nikaya cards) ─────────────────────────────────────────
          const _LibSectionHeader('TEXTS'),
          const SizedBox(height: 8),
          ...List.generate(
            _nikayas.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: _NikayaCard(info: _nikayas[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Library section header ────────────────────────────────────────────────────

class _LibSectionHeader extends StatelessWidget {
  const _LibSectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.green,
      ),
    );
  }
}

// ── Recently opened horizontal row ───────────────────────────────────────────

class _RecentlyOpenedRow extends ConsumerWidget {
  const _RecentlyOpenedRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(_recentlyOpenedProvider);
    return recentAsync.when(
      loading: () => const SizedBox(height: 60),
      error: (_, __) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) {
          return Text(
            'Open a sutta to see it here',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.45),
                ),
          );
        }
        return SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              final color = AppColors.nikayaColor(item.nikaya);
              return GestureDetector(
                onTap: () {
                  ref.read(tabsProvider.notifier).openTab(item.textUid);
                  context.push(Routes.readerPath(item.textUid,
                      scrollTo: item.lastPosition > 0
                          ? item.lastPosition
                          : null));
                },
                child: Container(
                  width: 110,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: color.withValues(alpha: 0.25), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        uidToAbbrev(item.textUid),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.title,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 11),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ── Bookmarks compact list ────────────────────────────────────────────────────

class _BookmarksSection extends ConsumerWidget {
  const _BookmarksSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(_allBookmarksProvider);
    return bookmarksAsync.when(
      loading: () => const SizedBox(height: 40),
      error: (_, __) => const SizedBox.shrink(),
      data: (bookmarks) {
        if (bookmarks.isEmpty) {
          return Text(
            'No bookmarks yet',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.45),
                ),
          );
        }
        final shown = bookmarks.take(5).toList();
        return Column(
          children: shown.map((bk) {
            final color = AppColors.nikayaColor(bk.textUid.length > 2
                ? bk.textUid.substring(0, 2)
                : bk.textUid);
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.bookmark, color: color, size: 18),
              title: Text(
                uidToAbbrev(bk.textUid),
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
              ),
              subtitle: bk.label.isNotEmpty
                  ? Text(bk.label,
                      style: const TextStyle(fontSize: 12))
                  : null,
              onTap: () => context.push(Routes.readerPath(bk.textUid)),
              visualDensity: VisualDensity.compact,
            );
          }).toList(),
        );
      },
    );
  }
}

// ── Collections grid ─────────────────────────────────────────────────────────

class _CollectionsSection extends ConsumerWidget {
  const _CollectionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(_allCollectionsProvider);
    return collectionsAsync.when(
      loading: () => const SizedBox(height: 40),
      error: (_, __) => const SizedBox.shrink(),
      data: (collections) {
        if (collections.isEmpty) {
          return TextButton.icon(
            onPressed: () => context.push(Routes.collections),
            icon: const Icon(Icons.add, size: 16, color: AppColors.green),
            label: const Text('Create your first collection',
                style: TextStyle(color: AppColors.green, fontSize: 13)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
          );
        }
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: collections.map((col) {
            Color colColor;
            try {
              colColor = Color(
                  int.parse('FF${col.colour.replaceFirst('#', '')}',
                      radix: 16));
            } catch (_) {
              colColor = AppColors.green;
            }
            return GestureDetector(
              onTap: () =>
                  context.push(Routes.collectionDetailPath(col.id)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: colColor.withValues(alpha: 0.3), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.folder_outlined,
                        size: 14, color: colColor),
                    const SizedBox(width: 4),
                    Text(
                      col.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _NikayaCard extends ConsumerWidget {
  const _NikayaCard({required this.info});

  final _NikayaInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(nikayaProgressProvider(info.id));
    final color = AppColors.nikayaColor(info.id);

    return Semantics(
      button: true,
      label: '${info.pali}, ${info.english}',
      child: Card(
      child: InkWell(
        onTap: () => context.push(Routes.nikayaPath(info.id)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            children: [
              // Colour indicator bar (decorative)
              ExcludeSemantics(
                child: Container(
                  width: 4,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              // Icon (decorative)
              ExcludeSemantics(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(info.icon, color: color, size: 24),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.pali,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      info.english,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      info.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              // Progress ring
              progressAsync.when(
                data: (progress) => _ProgressRing(
                  progress: progress,
                  color: color,
                ),
                loading: () => const SizedBox(width: 36, height: 36),
                error: (_, __) => const SizedBox(width: 36, height: 36),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${(progress * 100).round()}% complete',
      child: SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation(color),
          ),
          if (progress > 0)
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
        ],
      ),
    ),
    );
  }
}
