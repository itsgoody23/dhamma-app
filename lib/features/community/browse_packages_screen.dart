import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/routing/routes.dart';
import '../../data/services/package_publish_service.dart';
import 'community_providers.dart';

class BrowsePackagesScreen extends ConsumerStatefulWidget {
  const BrowsePackagesScreen({super.key});

  @override
  ConsumerState<BrowsePackagesScreen> createState() =>
      _BrowsePackagesScreenState();
}

class _BrowsePackagesScreenState extends ConsumerState<BrowsePackagesScreen> {
  String? _languageFilter;
  String _orderBy = 'created_at';

  BrowseParams get _params =>
      BrowseParams(language: _languageFilter, orderBy: _orderBy);

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(communityPackagesProvider(_params));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.communityTitle),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) => setState(() => _orderBy = value),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'created_at',
                child: Text(context.l10n.communityNewest),
              ),
              PopupMenuItem(
                value: 'downloads',
                child: Text(context.l10n.communityMostDownloaded),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Language filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            child: Row(
              children: [
                _FilterChip(
                  label: context.l10n.communityAll,
                  selected: _languageFilter == null,
                  onSelected: () =>
                      setState(() => _languageFilter = null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: context.l10n.communityEnglish,
                  selected: _languageFilter == 'en',
                  onSelected: () =>
                      setState(() => _languageFilter = 'en'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: context.l10n.communityGerman,
                  selected: _languageFilter == 'de',
                  onSelected: () =>
                      setState(() => _languageFilter = 'de'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: context.l10n.communitySpanish,
                  selected: _languageFilter == 'es',
                  onSelected: () =>
                      setState(() => _languageFilter = 'es'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Package list
          Expanded(
            child: packagesAsync.when(
              data: (packages) {
                if (packages.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.communityNoPackages,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.md),
                  itemCount: packages.length,
                  itemBuilder: (context, index) =>
                      _PackageCard(package: packages[index]),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});

  final TranslationPackage package;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(Routes.packageDetailPath(package.id)),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      package.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      package.language.toUpperCase(),
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.communityBy(package.authorName),
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              if (package.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  package.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.translate, size: 14,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5)),
                  const SizedBox(width: 4),
                  Text(context.l10n.communityTranslations(package.translationCount),
                      style: theme.textTheme.labelSmall),
                  const SizedBox(width: 16),
                  Icon(Icons.download, size: 14,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5)),
                  const SizedBox(width: 4),
                  Text('${package.downloads}',
                      style: theme.textTheme.labelSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
