import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import '../../core/utils/uid_utils.dart';
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

/// Checks which plan UIDs have downloaded text available.
@riverpod
Future<Set<String>> planAvailability(Ref ref, String planId) async {
  final plan = await ref.watch(planByIdProvider(planId).future);
  if (plan == null) return {};
  final db = ref.watch(appDatabaseProvider);

  Future<MapEntry<String, bool>> checkDay(day) async {
    try {
      if (isRangeUid(day.uid)) {
        // For range UIDs like 'dhp1-20', check if ANY individual verse exists.
        final expanded = expandRangeUid(day.uid);
        final sutta =
            await db.textsDao.getSuttaByUidAnyLanguage(expanded.first);
        return MapEntry(day.uid, sutta != null);
      } else {
        final sutta = await db.textsDao.getSuttaByUidAnyLanguage(day.uid);
        return MapEntry(day.uid, sutta != null);
      }
    } catch (_) {
      return MapEntry(day.uid, false);
    }
  }

  final results = await Future.wait(plan.days.map(checkDay));
  return {
    for (final entry in results)
      if (entry.value) entry.key,
  };
}

class PlanDetailScreen extends ConsumerWidget {
  const PlanDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(planByIdProvider(planId));
    final progressAsync = ref.watch(planProgressProvider(planId));
    final availabilityAsync = ref.watch(planAvailabilityProvider(planId));

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
        final available = availabilityAsync.value ?? {};
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
                    final isAvailable = available.contains(day.uid);
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: isDone
                            ? AppColors.green
                            : isAvailable
                                ? AppColors.green.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1),
                        child: isDone
                            ? const Icon(Icons.check,
                                size: 16, color: Colors.white)
                            : Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isAvailable
                                      ? AppColors.green
                                      : Colors.grey,
                                ),
                              ),
                      ),
                      title: Text(
                        day.title,
                        style: TextStyle(
                          color: isAvailable
                              ? null
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.4),
                        ),
                      ),
                      subtitle: !isAvailable
                          ? const Text('Not downloaded',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey))
                          : day.description != null
                              ? Text(day.description!)
                              : null,
                      trailing: isAvailable
                          ? const Icon(Icons.chevron_right, size: 20)
                          : Icon(Icons.download_outlined,
                              size: 20,
                              color: Colors.grey.withValues(alpha: 0.5)),
                      onTap: isAvailable
                          ? () => context.push(Routes.readerPath(day.uid))
                          : () => context.push(Routes.downloads),
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
