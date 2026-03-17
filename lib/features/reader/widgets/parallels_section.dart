import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routing/routes.dart';
import '../../../data/services/parallels_service.dart';
import '../../../shared/providers/database_provider.dart';

final _parallelsProvider = FutureProvider.autoDispose
    .family<List<({String uid, String? title, String? nikaya})>, String>(
        (ref, uid) async {
  final parallelUids = await ParallelsService.instance.getParallelUids(uid);
  if (parallelUids.isEmpty) return [];

  final db = ref.watch(appDatabaseProvider);
  final results =
      <({String uid, String? title, String? nikaya})>[];

  for (final pUid in parallelUids) {
    final sutta = await db.textsDao.getSuttaByUidAnyLanguage(pUid);
    results.add((
      uid: pUid,
      title: sutta?.title,
      nikaya: sutta?.nikaya,
    ));
  }
  return results;
});

class ParallelsSection extends ConsumerWidget {
  const ParallelsSection({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parallelsAsync = ref.watch(_parallelsProvider(uid));

    return parallelsAsync.when(
      data: (parallels) {
        if (parallels.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.lg),
            const Divider(),
            const SizedBox(height: AppSizes.sm),
            Row(
              children: [
                Icon(Icons.compare_arrows,
                    size: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6)),
                const SizedBox(width: 8),
                Text(
                  'Parallel Suttas',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            ...parallels.map((p) => _ParallelTile(
                  uid: p.uid,
                  title: p.title,
                  nikaya: p.nikaya,
                )),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _ParallelTile extends StatelessWidget {
  const _ParallelTile({
    required this.uid,
    required this.title,
    required this.nikaya,
  });

  final String uid;
  final String? title;
  final String? nikaya;

  @override
  Widget build(BuildContext context) {
    final nikayaColor =
        nikaya != null ? AppColors.nikayaColor(nikaya!) : AppColors.green;

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        dense: true,
        leading: Container(
          width: 4,
          height: 32,
          decoration: BoxDecoration(
            color: nikayaColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          title ?? uid.toUpperCase(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          uid.toUpperCase(),
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: const Icon(Icons.chevron_right, size: 18),
        onTap: () => context.push(Routes.readerPath(uid)),
      ),
    );
  }
}
