import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import '../../data/models/reading_plan.dart';
import '../../shared/providers/database_provider.dart';
import 'daily_screen.dart';

part 'plan_detail_screen.g.dart';

@riverpod
Future<ReadingPlan?> planById(Ref ref, String planId) async {
  final plans = await ref.watch(readingPlansProvider.future);
  try {
    return plans.firstWhere((p) => p.id == planId);
  } catch (_) {
    return null;
  }
}

@riverpod
Future<Map<String, bool>> planProgress(Ref ref, String planId) async {
  final plan = await ref.watch(planByIdProvider(planId).future);
  if (plan == null) return {};
  final db = ref.watch(appDatabaseProvider);
  final result = <String, bool>{};
  for (final day in plan.days) {
    final progress = await db.progressDao.getProgressForUid(day.uid);
    result[day.uid] = progress?.completed ?? false;
  }
  return result;
}

class PlanDetailScreen extends ConsumerWidget {
  const PlanDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(planByIdProvider(planId));
    final progressAsync = ref.watch(planProgressProvider(planId));

    return planAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $e'))),
      data: (plan) {
        if (plan == null) {
          return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Plan not found')));
        }

        final progress = progressAsync.value ?? {};
        final completed = progress.values.where((v) => v).length;

        return Scaffold(
          appBar: AppBar(title: Text(plan.title)),
          body: Column(
            children: [
              // Progress header
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.description,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: plan.totalDays > 0
                                ? completed / plan.totalDays
                                : 0,
                            backgroundColor:
                                AppColors.green.withValues(alpha: 0.15),
                            valueColor:
                                const AlwaysStoppedAnimation(AppColors.green),
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Text(
                          '$completed/${plan.totalDays}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.md),
                  itemCount: plan.days.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final day = plan.days[index];
                    final isDone = progress[day.uid] ?? false;
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: isDone
                            ? AppColors.green
                            : AppColors.green.withValues(alpha: 0.1),
                        child: isDone
                            ? const Icon(Icons.check,
                                size: 16, color: Colors.white)
                            : Text(
                                '${day.day}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.green,
                                ),
                              ),
                      ),
                      title: Text(day.title),
                      subtitle: day.description != null
                          ? Text(day.description!)
                          : null,
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () => context.push(Routes.readerPath(day.uid)),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
