import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/preferences_provider.dart';

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

// ── Screen ────────────────────────────────────────────────────────────────────

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(Routes.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: _nikayas.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
        itemBuilder: (context, index) {
          final info = _nikayas[index];
          return _NikayaCard(info: info);
        },
      ),
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

    return Card(
      child: InkWell(
        onTap: () => context.push(Routes.nikayaPath(info.id)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            children: [
              // Colour indicator bar
              Container(
                width: 4,
                height: 64,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(info.icon, color: color, size: 24),
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
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
