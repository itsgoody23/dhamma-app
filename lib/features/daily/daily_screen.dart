import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import '../../data/database/app_database.dart';
import '../../data/models/reading_plan.dart';
import '../../shared/providers/database_provider.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final dailySuttaProvider = FutureProvider.autoDispose<DailySutta?>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final dayOfYear = _dayOfYear(DateTime.now());
  final result = await db.customSelect(
    'SELECT * FROM daily_suttas WHERE day_of_year = ? LIMIT 1',
    variables: [Variable(dayOfYear)],
    readsFrom: {db.dailySuttas},
  ).getSingleOrNull();

  if (result == null) return null;

  return DailySutta(
    id: result.read<int>('id'),
    dayOfYear: result.read<int>('day_of_year'),
    uid: result.read<String>('uid'),
    title: result.read<String>('title'),
    verseExcerpt: result.readNullable<String>('verse_excerpt'),
    nikaya: result.read<String>('nikaya'),
  );
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

// ── Screen ────────────────────────────────────────────────────────────────────

class DailyScreen extends ConsumerWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAsync = ref.watch(dailySuttaProvider);
    final plansAsync = ref.watch(readingPlansProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Daily')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          // Daily sutta card
          dailyAsync.when(
            data: (sutta) => sutta != null
                ? _DailySuttaCard(sutta: sutta)
                : const _NoDailyCard(),
            loading: () => const SizedBox(
                height: 160, child: Center(child: CircularProgressIndicator())),
            error: (e, _) => const _NoDailyCard(),
          ),

          const SizedBox(height: AppSizes.lg),
          const Text(
            'READING PLANS',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          ),
          const SizedBox(height: AppSizes.sm),

          // Reading plans list
          plansAsync.when(
            data: (plans) => Column(
              children: plans.map((plan) => _PlanCard(plan: plan)).toList(),
            ),
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
    return Card(
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
                    child: const Text(
                      'SUTTA OF THE DAY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.green,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.auto_stories_outlined,
                    size: 16,
                    color: AppColors.nikayaColor(sutta.nikaya),
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
                    child: const Text('Read now'),
                  ),
                ],
              ),
            ],
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
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Text(
            'No daily sutta available. Please download the Dhammapada pack to start.'),
      ),
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
                    Text(plan.title,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(
                      '${plan.totalDays} days — ${plan.description}',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
