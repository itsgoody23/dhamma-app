import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/routing/routes.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/progress_dao.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/preferences_provider.dart';
import '../../shared/providers/tabs_provider.dart';
import '../daily/daily_screen.dart';

part 'library_screen.g.dart';

// ── Nikaya metadata ───────────────────────────────────────────────────────────

class _NikayaInfo {
  const _NikayaInfo({
    required this.id,
    required this.abbrev,
    required this.pali,
    required this.english,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String abbrev;
  final String pali;
  final String english;
  final String subtitle;
  final IconData icon;
}

const _nikayas = [
  _NikayaInfo(
    id: 'dn',
    abbrev: 'DN',
    pali: 'Dīgha Nikāya',
    english: 'Long Discourses',
    subtitle: '34 suttas',
    icon: Icons.auto_stories_outlined,
  ),
  _NikayaInfo(
    id: 'mn',
    abbrev: 'MN',
    pali: 'Majjhima Nikāya',
    english: 'Middle-Length Discourses',
    subtitle: '152 suttas',
    icon: Icons.spa_outlined,
  ),
  _NikayaInfo(
    id: 'sn',
    abbrev: 'SN',
    pali: 'Saṃyutta Nikāya',
    english: 'Connected Discourses',
    subtitle: '2,900+ suttas',
    icon: Icons.hub_outlined,
  ),
  _NikayaInfo(
    id: 'an',
    abbrev: 'AN',
    pali: 'Aṅguttara Nikāya',
    english: 'Numerical Discourses',
    subtitle: '8,000+ suttas',
    icon: Icons.format_list_numbered_outlined,
  ),
  _NikayaInfo(
    id: 'kn',
    abbrev: 'KN',
    pali: 'Khuddaka Nikāya',
    english: 'Minor Collection',
    subtitle: 'Dhammapada, Sutta Nipāta & more',
    icon: Icons.collections_bookmark_outlined,
  ),
];

// ── Nikaya progress provider (unchanged — drives .g.dart) ─────────────────────

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

// ── Weekly activity provider (last 7 days for streak bar chart) ───────────────

final _weeklyActivityProvider =
    FutureProvider.autoDispose<Map<String, int>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.streaksDao.getStreakHistory(days: 7);
});

// ── Pinned suttas provider ────────────────────────────────────────────────────

const _pinnedKey = 'pinned_sutta_uids';

final _pinnedSuttasProvider =
    StateNotifierProvider<_PinnedNotifier, List<String>>(
        (ref) => _PinnedNotifier());

class _PinnedNotifier extends StateNotifier<List<String>> {
  _PinnedNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_pinnedKey) ?? [];
    state = raw;
  }

  Future<void> add(String uid) async {
    if (state.contains(uid)) return;
    final next = [...state, uid];
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_pinnedKey, next);
  }

  Future<void> remove(String uid) async {
    final next = state.where((u) => u != uid).toList();
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_pinnedKey, next);
  }
}

// ── Recently opened provider ──────────────────────────────────────────────────

final _recentlyOpenedProvider =
    FutureProvider.autoDispose<List<RecentlyReadItem>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.progressDao.getRecentlyReadWithTitles(limit: 8);
});

// ── Screen ────────────────────────────────────────────────────────────────────

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good morning,';
    if (hour >= 12 && hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Custom header ──────────────────────────────────────────
                  _LibHeader(),

                  // ── Greeting ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSizes.md, AppSizes.sm, AppSizes.md, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RESTORE FOCUS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _greeting(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w300,
                                height: 1.1,
                              ),
                        ),
                        Text(
                          'Scholar',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                                height: 1.1,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.md),

                  // ── Current journey / streak card ──────────────────────────
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.md),
                    child: _CurrentJourneyCard(),
                  ),

                  const SizedBox(height: AppSizes.sm),

                  // ── Daily verse card ───────────────────────────────────────
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.md),
                    child: _DailyVerseCard(),
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // ── Pinned ─────────────────────────────────────────────────
                  const _PinnedSection(),

                  const SizedBox(height: AppSizes.lg),

                  // ── Recently Opened ────────────────────────────────────────
                  const _RecentlyOpenedSection(),

                  const SizedBox(height: AppSizes.lg),

                  // ── Canonical Collections ──────────────────────────────────
                  const _CanonicalCollectionsSection(),

                  const SizedBox(height: AppSizes.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Custom header ─────────────────────────────────────────────────────────────

class _LibHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md, vertical: AppSizes.sm),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: () => context.push(Routes.settings),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.green.withValues(alpha: 0.15),
              child: const Icon(Icons.person_outline,
                  size: 20, color: AppColors.green),
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          // Title
          Expanded(
            child: Text(
              'THE DIGITAL ALTAR',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          // Settings
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 22),
            onPressed: () => context.push(Routes.settings),
            tooltip: 'Settings',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

// ── Current journey / streak card ────────────────────────────────────────────

class _CurrentJourneyCard extends ConsumerWidget {
  const _CurrentJourneyCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(currentStreakProvider);
    final weeklyAsync = ref.watch(_weeklyActivityProvider);
    final streak = streakAsync.value ?? 0;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outline
              .withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT JOURNEY',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          if (streak > 0)
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(text: 'You have maintained stillness for '),
                  TextSpan(
                    text: '$streak consecutive day${streak == 1 ? '' : 's'}',
                    style: const TextStyle(
                      color: AppColors.green,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            )
          else
            Text(
              'Begin your practice today.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          const SizedBox(height: AppSizes.md),
          // Weekly bar chart
          weeklyAsync.when(
            data: (history) => _WeeklyBars(history: history),
            loading: () => const SizedBox(height: 32),
            error: (_, __) => const SizedBox(height: 32),
          ),
          const SizedBox(height: AppSizes.xs),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'WEEKLY STREAK',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyBars extends StatelessWidget {
  const _WeeklyBars({required this.history});

  final Map<String, int> history;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Build last 7 days oldest → newest
    final days = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      final key =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      return history[key] ?? 0;
    });

    final maxVal = days.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: days.map((count) {
          final ratio = maxVal > 0 ? count / maxVal : 0.0;
          final active = count > 0;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: 8 + (ratio * 24),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.green
                      : AppColors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Daily verse card ──────────────────────────────────────────────────────────

class _DailyVerseCard extends ConsumerWidget {
  const _DailyVerseCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAsync = ref.watch(dailySuttaProvider);

    return dailyAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (sutta) {
        if (sutta == null) return const SizedBox.shrink();
        final excerpt = sutta.verseExcerpt;
        return GestureDetector(
          onTap: () => context.push(Routes.readerPath(sutta.uid)),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.greenDark,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DAILY VERSE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                if (excerpt != null && excerpt.isNotEmpty)
                  Text(
                    '"$excerpt"',
                    style: const TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  )
                else
                  Text(
                    sutta.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                const SizedBox(height: AppSizes.md),
                Text(
                  sutta.title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Pinned section ────────────────────────────────────────────────────────────

class _PinnedSection extends ConsumerStatefulWidget {
  const _PinnedSection();

  @override
  ConsumerState<_PinnedSection> createState() => _PinnedSectionState();
}

class _PinnedSectionState extends ConsumerState<_PinnedSection> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    final pinned = ref.watch(_pinnedSuttasProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Pinned',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _editing = !_editing),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.green,
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(
                  _editing ? 'DONE' : 'EDIT',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            children: [
              ...pinned.map((uid) => _PinnedCard(
                    uid: uid,
                    editing: _editing,
                    onRemove: () => ref
                        .read(_pinnedSuttasProvider.notifier)
                        .remove(uid),
                  )),
              // Add slot
              _PinnedAddSlot(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Long-press any sutta while reading to pin it here.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PinnedCard extends ConsumerWidget {
  const _PinnedCard({
    required this.uid,
    required this.editing,
    required this.onRemove,
  });

  final String uid;
  final bool editing;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = AppColors.nikayaColor(uidPrefix(uid));

    return GestureDetector(
      onTap: editing
          ? null
          : () {
              ref.read(tabsProvider.notifier).openTab(uid);
              context.push(Routes.readerPath(uid));
            },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: AppSizes.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
              color: color.withValues(alpha: 0.25), width: 1),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.bookmark, color: color, size: 16),
                  const Spacer(),
                  Text(
                    uidToAbbrev(uid),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    uid,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (editing)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 12, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PinnedAddSlot extends StatelessWidget {
  const _PinnedAddSlot({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: AppSizes.sm),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .outline
                .withValues(alpha: 0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: const Center(
          child: Icon(Icons.add, size: 28, color: AppColors.textTertiary),
        ),
      ),
    );
  }
}

// ── Recently opened (vertical list) ──────────────────────────────────────────

class _RecentlyOpenedSection extends ConsumerWidget {
  const _RecentlyOpenedSection();

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return 'READ ${diff.inMinutes}M AGO';
    if (diff.inHours < 24) return 'READ ${diff.inHours}H AGO';
    if (diff.inDays == 1) return 'READ YESTERDAY';
    return 'READ ${diff.inDays}D AGO';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(_recentlyOpenedProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Text(
            'Recently Opened',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        recentAsync.when(
          loading: () => const SizedBox(height: 60),
          error: (_, __) => const SizedBox.shrink(),
          data: (items) {
            if (items.isEmpty) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Text(
                  'Open a sutta to see it here.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                ),
              );
            }
            final shown = items.take(5).toList();
            return Column(
              children: shown.map((item) {
                final color = AppColors.nikayaColor(item.nikaya);
                return InkWell(
                  onTap: () {
                    ref.read(tabsProvider.notifier).openTab(item.textUid);
                    context.push(Routes.readerPath(item.textUid,
                        scrollTo: item.lastPosition > 0
                            ? item.lastPosition
                            : null));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md, vertical: 10),
                    child: Row(
                      children: [
                        // Nikaya badge
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSm),
                          ),
                          child: Center(
                            child: Text(
                              item.nikaya.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        // Title + timestamp
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

// ── Canonical Collections ─────────────────────────────────────────────────────

class _CanonicalCollectionsSection extends StatelessWidget {
  const _CanonicalCollectionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Text(
            'Canonical Collections',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        ..._nikayas.map(
          (n) => _CanonicalCollectionRow(info: n),
        ),
      ],
    );
  }
}

class _CanonicalCollectionRow extends ConsumerWidget {
  const _CanonicalCollectionRow({required this.info});

  final _NikayaInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(nikayaProgressProvider(info.id));
    final color = AppColors.nikayaColor(info.id);

    return InkWell(
      onTap: () => context.push(Routes.nikayaPath(info.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  info.abbrev,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                progressAsync.when(
                  data: (p) => Text(
                    '${(p * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              info.pali,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 6),
            progressAsync.when(
              data: (progress) => ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: color.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              loading: () => const SizedBox(height: 3),
              error: (_, __) => const SizedBox(height: 3),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Extracts the nikaya prefix from a UID (e.g. 'mn' from 'mn1').
String uidPrefix(String uid) {
  final match = RegExp(r'^([a-z]+)').firstMatch(uid);
  return match?.group(1) ?? uid;
}
