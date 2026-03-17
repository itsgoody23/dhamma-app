import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/providers/database_provider.dart';

/// Provider to watch user commentary for a given sutta.
final userCommentaryProvider = StreamProvider.autoDispose
    .family<List<UserCommentaryData>, String>((ref, suttaUid) {
  final db = ref.watch(appDatabaseProvider);
  return db.userTranslationsDao.watchCommentaryForSutta(suttaUid);
});

/// Displays user commentary/annotations for a sutta as expandable
/// inline blocks. Users can add, edit, and delete their personal
/// commentary on individual paragraphs/verses.
class CommentaryView extends ConsumerWidget {
  const CommentaryView({
    super.key,
    required this.suttaUid,
  });

  final String suttaUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentaryAsync = ref.watch(userCommentaryProvider(suttaUid));

    return commentaryAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (commentaries) {
        if (commentaries.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 32),
              Row(
                children: [
                  Icon(Icons.comment_outlined,
                      size: 16,
                      color: AppColors.green.withValues(alpha: 0.7)),
                  const SizedBox(width: 6),
                  Text(
                    'My Annotations',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.green.withValues(alpha: 0.7),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              ...commentaries.map(
                (c) => _CommentaryCard(
                  commentary: c,
                  suttaUid: suttaUid,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CommentaryCard extends ConsumerStatefulWidget {
  const _CommentaryCard({
    required this.commentary,
    required this.suttaUid,
  });

  final UserCommentaryData commentary;
  final String suttaUid;

  @override
  ConsumerState<_CommentaryCard> createState() => _CommentaryCardState();
}

class _CommentaryCardState extends ConsumerState<_CommentaryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.commentary;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      elevation: 0,
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: AppColors.green.withValues(alpha: 0.15),
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    c.verseRef,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.green.withValues(alpha: 0.8),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 8),
                Text(
                  c.content,
                  style: const TextStyle(fontSize: 14, height: 1.6),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      onPressed: () => _editCommentary(context, c),
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 16, color: Colors.red),
                      onPressed: () => _deleteCommentary(c),
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ] else
                Text(
                  c.content,
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
            ],
          ),
        ),
      ),
    );
  }

  void _editCommentary(BuildContext context, UserCommentaryData commentary) {
    final controller = TextEditingController(text: commentary.content);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxHeight: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit annotation for ${commentary.verseRef}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  minLines: 4,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Your annotation...',
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isNotEmpty) {
                        ref
                            .read(appDatabaseProvider)
                            .userTranslationsDao
                            .upsertCommentary(
                              suttaUid: widget.suttaUid,
                              verseRef: commentary.verseRef,
                              content: text,
                            );
                      }
                      Navigator.pop(ctx);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteCommentary(UserCommentaryData commentary) {
    ref.read(appDatabaseProvider).userTranslationsDao.deleteCommentary(
          commentary.id,
        );
  }
}

/// A dialog to add a new commentary annotation.
Future<void> showAddCommentaryDialog(
  BuildContext context,
  WidgetRef ref,
  String suttaUid,
) async {
  final verseController = TextEditingController();
  final contentController = TextEditingController();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 450),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Annotation',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: verseController,
              decoration: const InputDecoration(
                labelText: 'Verse or paragraph reference',
                hintText: 'e.g. "verse 1", "para 3", "opening"',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: TextField(
                controller: contentController,
                maxLines: null,
                minLines: 4,
                autofocus: false,
                decoration: const InputDecoration(
                  labelText: 'Your annotation',
                  hintText: 'Your thoughts, commentary, or notes...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    final verse = verseController.text.trim();
                    final content = contentController.text.trim();
                    if (verse.isNotEmpty && content.isNotEmpty) {
                      ref
                          .read(appDatabaseProvider)
                          .userTranslationsDao
                          .upsertCommentary(
                            suttaUid: suttaUid,
                            verseRef: verse,
                            content: content,
                          );
                    }
                    Navigator.pop(ctx);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
