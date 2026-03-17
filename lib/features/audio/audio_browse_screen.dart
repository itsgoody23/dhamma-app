import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/routing/routes.dart';

/// Top-level audio tab — browse by category.
class AudioBrowseScreen extends StatelessWidget {
  const AudioBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.audioTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          _CategoryCard(
            icon: Icons.temple_buddhist,
            title: context.l10n.audioChanting,
            subtitle: context.l10n.audioChantingSubtitle,
            color: AppColors.green,
            onTap: () => context.push(Routes.chanting),
          ),
          const SizedBox(height: AppSizes.sm),
          _CategoryCard(
            icon: Icons.self_improvement,
            title: context.l10n.audioGuidedMeditation,
            subtitle: context.l10n.audioGuidedMeditationSubtitle,
            color: Colors.indigo,
            onTap: () => context.push(Routes.meditation),
          ),
          const SizedBox(height: AppSizes.sm),
          _CategoryCard(
            icon: Icons.headphones,
            title: context.l10n.audioDhammaTalks,
            subtitle: context.l10n.audioDhammaTalksSubtitle,
            color: Colors.orange.shade700,
            onTap: () => context.push(Routes.dhammaTalks),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withAlpha(30),
                radius: 28,
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
