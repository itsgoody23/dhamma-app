import 'dart:io';
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/routing/routes.dart';
import '../../data/database/app_database.dart';
import '../../data/services/translation_package_service.dart';
import '../../shared/providers/database_provider.dart';
import '../community/community_providers.dart';

/// Provider that watches all user translations.
final allTranslationsProvider =
    StreamProvider.autoDispose<List<UserTranslation>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.userTranslationsDao.select(db.userTranslationsDao.userTranslations)
        ..where((t) => t.isDeleted.equals(false))
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
      .watch();
});

/// Provider that watches all user commentary.
final allCommentaryProvider =
    StreamProvider.autoDispose<List<UserCommentaryData>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.userTranslationsDao.select(db.userTranslationsDao.userCommentary)
        ..where((c) => c.isDeleted.equals(false))
        ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
      .watch();
});

class MyTranslationsScreen extends ConsumerWidget {
  const MyTranslationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translationsAsync = ref.watch(allTranslationsProvider);
    final commentaryAsync = ref.watch(allCommentaryProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.translationsTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: context.l10n.translationsTab),
              Tab(text: context.l10n.annotationsTab),
            ],
            indicatorColor: AppColors.green,
            labelColor: AppColors.green,
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'export') _exportAll(context, ref);
                if (value == 'import') _importPackage(context, ref);
                if (value == 'publish') _publishToCommunity(context, ref);
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                    value: 'export', child: Text(context.l10n.translationsExportAll)),
                PopupMenuItem(
                    value: 'import', child: Text(context.l10n.translationsImport)),
                PopupMenuItem(
                    value: 'publish', child: Text(context.l10n.translationsPublish)),
              ],
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Translations tab
            translationsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (translations) {
                if (translations.isEmpty) {
                  return _buildEmptyState(
                    context,
                    icon: Icons.translate,
                    title: context.l10n.translationsEmpty,
                    subtitle: context.l10n.translationsEmptySubtitle,
                  );
                }

                // Group by sutta UID
                final grouped = <String, List<UserTranslation>>{};
                for (final t in translations) {
                  grouped.putIfAbsent(t.suttaUid, () => []).add(t);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  itemCount: grouped.length,
                  itemBuilder: (ctx, i) {
                    final uid = grouped.keys.elementAt(i);
                    final items = grouped[uid]!;
                    final preview = items.first.content;
                    return _TranslationTile(
                      suttaUid: uid,
                      translationCount: items.length,
                      preview: preview,
                      onTap: () =>
                          context.push(Routes.readerPath(uid)),
                    );
                  },
                );
              },
            ),
            // Annotations tab
            commentaryAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (commentary) {
                if (commentary.isEmpty) {
                  return _buildEmptyState(
                    context,
                    icon: Icons.comment_outlined,
                    title: context.l10n.annotationsEmpty,
                    subtitle: context.l10n.annotationsEmptySubtitle,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  itemCount: commentary.length,
                  itemBuilder: (ctx, i) {
                    final c = commentary[i];
                    return ListTile(
                      leading: Container(
                        width: 3,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      title: Text(c.suttaUid.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(
                        '${c.verseRef}: ${c.content}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => context.push(Routes.readerPath(c.suttaUid)),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.green.withValues(alpha: 0.3)),
            const SizedBox(height: AppSizes.md),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: AppSizes.xs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportAll(BuildContext context, WidgetRef ref) async {
    try {
      final db = ref.read(appDatabaseProvider);
      final service = TranslationPackageService(db: db);
      await service.exportAndShare(
        author: 'My Translations',
        description: 'All personal translations and annotations',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.exportFailed('$e'))),
        );
      }
    }
  }

  Future<void> _importPackage(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null || result.files.isEmpty) return;

      final filePath = result.files.single.path;
      if (filePath == null) return;

      final db = ref.read(appDatabaseProvider);
      final service = TranslationPackageService(db: db);

      // Preview first
      final content = await File(filePath).readAsString();
      final meta = TranslationPackageService.previewPackage(content);

      if (!context.mounted) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(context.l10n.translationsImportTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.translationsAuthor(meta['author'] ?? 'Unknown')),
              if (meta['description'] != null &&
                  (meta['description'] as String).isNotEmpty)
                Text(context.l10n.translationsDescription(meta['description'] as String)),
              Text(context.l10n.translationsCount(meta['translation_count'] ?? 0)),
              Text(context.l10n.annotationsCount(meta['commentary_count'] ?? 0)),
              const SizedBox(height: 12),
              Text(
                context.l10n.translationsMergeNote,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(context.l10n.import_),
            ),
          ],
        ),
      );

      if (confirmed != true || !context.mounted) return;

      final counts = await service.importPackageFromJson(content);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                context.l10n.translationsImported(counts.translations, counts.commentary)),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.importFailed('$e'))),
        );
      }
    }
  }

  Future<void> _publishToCommunity(
      BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final authorController = TextEditingController(text: 'Anonymous');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.translationsPublishTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: context.l10n.translationsPublishTitleLabel,
                hintText: context.l10n.translationsPublishTitleHint,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: authorController,
              decoration: InputDecoration(
                labelText: context.l10n.translationsPublishAuthorLabel,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: context.l10n.translationsPublishDescLabel,
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.publish),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.translationsPublishTitleRequired)),
      );
      return;
    }

    try {
      final db = ref.read(appDatabaseProvider);
      final service = TranslationPackageService(db: db);
      final filePath = await service.exportPackage(
        author: authorController.text.trim(),
        description: descController.text.trim(),
      );
      final content = await File(filePath).readAsString();
      final packageData =
          TranslationPackageService.previewPackage(content);

      final publishService = ref.read(packagePublishServiceProvider);
      await publishService.publishPackage(
        title: titleController.text.trim(),
        description: descController.text.trim(),
        authorName: authorController.text.trim(),
        language: packageData['language'] as String? ?? 'en',
        translationCount: packageData['translation_count'] as int? ?? 0,
        commentaryCount: packageData['commentary_count'] as int? ?? 0,
        packageJson: {
          ...packageData,
          'translations': (await db.userTranslationsDao.getAllTranslations())
              .map((t) => {
                    'sutta_uid': t.suttaUid,
                    'verse_ref': t.verseRef,
                    'content': t.content,
                  })
              .toList(),
          'commentary': (await db.userTranslationsDao.getAllCommentary())
              .map((c) => {
                    'sutta_uid': c.suttaUid,
                    'verse_ref': c.verseRef,
                    'content': c.content,
                  })
              .toList(),
        },
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.translationsPublished)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.publishFailed('$e'))),
        );
      }
    }
  }
}

class _TranslationTile extends StatelessWidget {
  const _TranslationTile({
    required this.suttaUid,
    required this.translationCount,
    required this.preview,
    required this.onTap,
  });

  final String suttaUid;
  final int translationCount;
  final String preview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant
              .withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.green.withValues(alpha: 0.1),
          child: const Icon(Icons.translate, color: AppColors.green, size: 20),
        ),
        title: Text(
          suttaUid.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          preview,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.6),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
      ),
    );
  }
}
