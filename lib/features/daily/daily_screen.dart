import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import '../../core/utils/uid_utils.dart';
import '../../data/database/app_database.dart';
import '../../data/models/reading_plan.dart';
import '../../data/database/daos/progress_dao.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/widgets/nikaya_badge.dart';
import '../../shared/widgets/sync_status_banner.dart';

// ── Streak Providers ──────────────────────────────────────────────────────────

final currentStreakProvider = StreamProvider.autoDispose<int>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.streaksDao.watchCurrentStreak();
});

final longestStreakProvider = StreamProvider.autoDispose<int>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.streaksDao.watchLongestStreak();
});

final todayStatsProvider = StreamProvider.autoDispose<ReadingStreak?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.streaksDao.watchToday();
});

// ── Providers ─────────────────────────────────────────────────────────────────

final dailySuttaProvider = FutureProvider.autoDispose<DailySutta?>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final dayOfYear = _dayOfYear(DateTime.now());

  // Try today first, then scan forward up to 365 days to find one whose
  // text has actually been downloaded.
  for (var offset = 0; offset < 365; offset++) {
    final d = ((dayOfYear - 1 + offset) % 365) + 1;
    final result = await db.customSelect(
      'SELECT * FROM daily_suttas WHERE day_of_year = ? LIMIT 1',
      variables: [Variable(d)],
      readsFrom: {db.dailySuttas},
    ).getSingleOrNull();

    if (result == null) continue;

    final uid = result.read<String>('uid');

    // Check if text is available — handle range UIDs like 'dhp1-20'.
    bool available;
    if (isRangeUid(uid)) {
      final expanded = expandRangeUid(uid);
      final sutta =
          await db.textsDao.getSuttaByUidAnyLanguage(expanded.first);
      available = sutta != null;
    } else {
      final sutta = await db.textsDao.getSuttaByUidAnyLanguage(uid);
      available = sutta != null;
    }

    if (available) {
      return DailySutta(
        id: result.read<int>('id'),
        dayOfYear: result.read<int>('day_of_year'),
        uid: uid,
        title: result.read<String>('title'),
        verseExcerpt: result.readNullable<String>('verse_excerpt'),
        nikaya: result.read<String>('nikaya'),
      );
    }
  }
  return null;
});

int _dayOfYear(DateTime dt) {
  return dt.difference(DateTime(dt.year, 1, 1)).inDays + 1;
}

final readingPlansProvider =
    FutureProvider.autoDispose<List<ReadingPlan>>((ref) async {
  final jsonStr =
      await rootBundle.loadString('assets/reading_plans/plans.json');
  final list = json.decode(jsonStr) as List;
  return list
      .map((e) => ReadingPlan.fromJson(e as Map<String, dynamic>))
      .toList();
});

final recentlyReadProvider =
    FutureProvider.autoDispose<List<RecentlyReadItem>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.progressDao.getRecentlyReadWithTitles(limit: 5);
});

// ── Screen ────────────────────────────────────────────────────────────────────

class DailyScreen extends ConsumerWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAsync = ref.watch(dailySuttaProvider);
    final plansAsync = ref.watch(readingPlansProvider);
    final recentAsync = ref.watch(recentlyReadProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    final todayAsync = ref.watch(todayStatsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.dailyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          const SyncStatusBanner(),

          // Reading streak card
          _StreakCard(
            streakAsync: streakAsync,
            todayAsync: todayAsync,
          ),
          const SizedBox(height: AppSizes.sm),

          // Daily sutta card
          dailyAsync.when(
            data: (sutta) => sutta != null
                ? _DailySuttaCard(sutta: sutta)
                : const _NoDailyCard(),
            loading: () => const SizedBox(
                height: 160, child: Center(child: CircularProgressIndicator())),
            error: (e, _) => const _NoDailyCard(),
          ),

          // Continue reading section
          recentAsync.when(
            data: (items) => items.isNotEmpty
                ? _ContinueReadingSection(items: items)
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: AppSizes.lg),

          // Reading plans grouped by category
          plansAsync.when(
            data: (plans) => _GroupedPlans(plans: plans),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Could not load reading plans: $e'),
          ),
        ],
      ),
    );
  }
}

class _DailySuttaCard extends StatelessWidget {
  const _DailySuttaCard({required this.sutta});

  final DailySutta sutta;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Sutta of the day: ${sutta.title}',
      child: Card(
      child: InkWell(
        onTap: () => context.push(Routes.readerPath(sutta.uid)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      context.l10n.dailySuttaOfTheDay,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.green,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ExcludeSemantics(
                    child: Icon(
                      Icons.auto_stories_outlined,
                      size: 16,
                      color: AppColors.nikayaColor(sutta.nikaya),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                sutta.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              if (sutta.verseExcerpt != null) ...[
                const SizedBox(height: AppSizes.sm),
                Text(
                  '"${sutta.verseExcerpt}"',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                    height: 1.6,
                  ),
                ),
              ],
              const SizedBox(height: AppSizes.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton.tonal(
                    onPressed: () => context.push(Routes.readerPath(sutta.uid)),
                    child: Text(context.l10n.dailyReadNow),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _NoDailyCard extends StatelessWidget {
  const _NoDailyCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Text(context.l10n.dailyNoSutta),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.streakAsync, required this.todayAsync});

  final AsyncValue<int> streakAsync;
  final AsyncValue<ReadingStreak?> todayAsync;

  @override
  Widget build(BuildContext context) {
    final streak = streakAsync.value ?? 0;
    final today = todayAsync.value;
    final minutes = today?.minutesRead ?? 0;
    final suttas = today?.suttasRead ?? 0;

    return Card(
      color: streak > 0
          ? AppColors.green.withValues(alpha: 0.08)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Icon(
              streak > 0 ? Icons.local_fire_department : Icons.local_fire_department_outlined,
              color: streak > 0 ? Colors.orange : Colors.grey,
              size: 32,
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    streak > 0
                        ? '$streak day streak!'
                        : 'Start your streak today',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Today: $minutes min · $suttas suttas read',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueReadingSection extends StatelessWidget {
  const _ContinueReadingSection({required this.items});

  final List<RecentlyReadItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSizes.lg),
        Text(
          context.l10n.dailyContinueReading,
          style: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
        ),
        const SizedBox(height: AppSizes.sm),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return SizedBox(
                width: 200,
                child: Card(
                  margin: EdgeInsets.zero,
                  child: InkWell(
                    onTap: () => context.push(Routes.readerPath(item.textUid)),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              NikayaBadge(nikaya: item.nikaya),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              if (item.completed)
                                const Icon(Icons.check_circle,
                                    size: 14, color: AppColors.green)
                              else
                                const Icon(Icons.auto_stories_outlined,
                                    size: 14),
                              const SizedBox(width: 6),
                              Text(
                                item.completed ? context.l10n.dailyCompleted : context.l10n.dailyInProgress,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Category helpers ──────────────────────────────────────────────────────────

Map<String, String> _categoryLabels(BuildContext context) => {
  'classics': context.l10n.dailyCategoryClassics,
  'doctrinal': context.l10n.dailyCategoryDoctrinal,
  'meditation': context.l10n.dailyCategoryMeditation,
  'nikaya_study': context.l10n.dailyCategoryNikayaStudy,
};

const _categoryIcons = <String, IconData>{
  'classics': Icons.auto_stories_outlined,
  'doctrinal': Icons.school_outlined,
  'meditation': Icons.self_improvement_outlined,
  'nikaya_study': Icons.menu_book_outlined,
};

const _categoryOrder = ['classics', 'doctrinal', 'meditation', 'nikaya_study'];

class _GroupedPlans extends StatelessWidget {
  const _GroupedPlans({required this.plans});

  final List<ReadingPlan> plans;

  @override
  Widget build(BuildContext context) {
    // Group plans by category, preserving order.
    final grouped = <String, List<ReadingPlan>>{};
    for (final plan in plans) {
      final cat = plan.category ?? 'classics';
      (grouped[cat] ??= []).add(plan);
    }

    final categories = _categoryOrder.where(grouped.containsKey).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final cat in categories) ...[
          Row(
            children: [
              Icon(_categoryIcons[cat] ?? Icons.calendar_month_outlined,
                  size: 14, color: AppColors.green),
              const SizedBox(width: 6),
              Text(
                _categoryLabels(context)[cat] ?? cat.toUpperCase(),
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          ...grouped[cat]!.map((plan) => _PlanCard(plan: plan)),
          const SizedBox(height: AppSizes.md),
        ],
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan});

  final ReadingPlan plan;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: InkWell(
        onTap: () => context.push(Routes.planDetailPath(plan.id)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            children: [
              const Icon(Icons.calendar_month_outlined, color: AppColors.green),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(plan.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                        ),
                        if (plan.difficulty != null)
                          _DifficultyBadge(difficulty: plan.difficulty!),
                      ],
                    ),
                    Text(
                      context.l10n.dailyDaysCount(plan.totalDays, plan.description),
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final String difficulty;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (difficulty) {
      'beginner' => (context.l10n.dailyBeginner, AppColors.green),
      'intermediate' => (context.l10n.dailyIntermediate, Colors.orange),
      'advanced' => (context.l10n.dailyAdvanced, Colors.red),
      _ => (difficulty, Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
