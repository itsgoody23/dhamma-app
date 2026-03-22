import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/routing/routes.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/progress_dao.dart';
import '../../shared/providers/database_provider.dart';
import '../collections/collections_screen.dart';

/// Looks up the sutta title for a given UID, returning a formatted string
/// like "MN 1 — Mūlapariyāya Sutta" or falling back to the raw UID.
final suttaTitleProvider =
    FutureProvider.autoDispose.family<String, String>((ref, uid) async {
  final db = ref.watch(appDatabaseProvider);
  final sutta = await db.textsDao.getSuttaByUidAnyLanguage(uid);
  if (sutta == null) return uid;
  return sutta.title;
});

class StudyToolsScreen extends ConsumerStatefulWidget {
  const StudyToolsScreen({super.key});

  @override
  ConsumerState<StudyToolsScreen> createState() => _StudyToolsScreenState();
}

class _StudyToolsScreenState extends ConsumerState<StudyToolsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study'),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: const [
            Tab(text: 'History'),
            Tab(text: 'Bookmarks'),
            Tab(text: 'Highlights'),
            Tab(text: 'Notes'),
            Tab(text: 'Collections'),
            Tab(text: 'Translations'),
            Tab(text: 'Dictionary'),
            Tab(text: 'Community'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _HistoryTab(),
          _BookmarksTab(),
          _HighlightsTab(),
          _NotesTab(),
          _CollectionsTab(),
          _TranslationsTab(),
          _DictionaryTab(),
          _CommunityTab(),
        ],
      ),
    );
  }
}

// ── History ───────────────────────────────────────────────────────────────────

final _studyHistoryProvider =
    FutureProvider.autoDispose<List<HistoryItem>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.progressDao.getAllHistory();
});

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(_studyHistoryProvider);

    return historyAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const _EmptyTab(
            icon: Icons.history_outlined,
            message: 'No reading history yet.\nOpen a sutta to get started.',
          );
        }
        // Group items by date bucket.
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));
        final weekAgo = today.subtract(const Duration(days: 7));

        String _bucket(DateTime dt) {
          final d = DateTime(dt.year, dt.month, dt.day);
          if (!d.isBefore(today)) return 'Today';
          if (!d.isBefore(yesterday)) return 'Yesterday';
          if (!d.isBefore(weekAgo)) return 'Last 7 days';
          return 'Older';
        }

        final groups = <String, List<HistoryItem>>{};
        for (final item in items) {
          final bucket = _bucket(item.lastReadAt);
          groups.putIfAbsent(bucket, () => []).add(item);
        }

        const bucketOrder = ['Today', 'Yesterday', 'Last 7 days', 'Older'];
        final widgets = <Widget>[];
        for (final bucket in bucketOrder) {
          final group = groups[bucket];
          if (group == null || group.isEmpty) continue;
          widgets.add(Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.xs),
            child: Text(
              bucket.toUpperCase(),
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8),
            ),
          ));
          for (final item in group) {
            widgets.add(_HistoryTile(item: item));
          }
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: AppSizes.lg),
          children: widgets,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item});

  final HistoryItem item;

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.nikayaColor(item.nikaya);
    return Card(
      margin:
          const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 2),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(item.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis),
        subtitle: Row(
          children: [
            Text(
              item.nikaya.toUpperCase(),
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            if (item.completed)
              const Text('✓ Complete',
                  style: TextStyle(fontSize: 11, color: Colors.grey))
            else
              const Text('In progress',
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        trailing: Text(
          _timeAgo(item.lastReadAt),
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        onTap: () => context.push(
          Routes.readerPath(item.textUid, scrollTo: item.lastPosition > 0 ? item.lastPosition : null),
        ),
      ),
    );
  }
}

// ── Bookmarks ─────────────────────────────────────────────────────────────────

class _BookmarksTab extends ConsumerWidget {
  const _BookmarksTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(allBookmarksProvider);

    return bookmarksAsync.when(
      data: (bookmarks) {
        if (bookmarks.isEmpty) {
          return const _EmptyTab(
            icon: Icons.bookmark_outline,
            message: 'No bookmarks yet.\nTap the bookmark icon while reading.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.md),
          itemCount: bookmarks.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
          itemBuilder: (context, index) =>
              _BookmarkTile(bookmark: bookmarks[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _BookmarkTile extends ConsumerWidget {
  const _BookmarkTile({required this.bookmark});

  final UserBookmark bookmark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleAsync = ref.watch(suttaTitleProvider(bookmark.textUid));
    final title = titleAsync.value ?? bookmark.textUid;

    return Dismissible(
      key: Key('bm-${bookmark.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.md),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(appDatabaseProvider).studyToolsDao.deleteBookmark(bookmark.id);
      },
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.bookmark, color: AppColors.green),
          title: Text(title),
          subtitle: bookmark.label.isNotEmpty ? Text(bookmark.label) : null,
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => context.push(Routes.readerPath(bookmark.textUid)),
          onLongPress: () => _editLabel(context, ref),
        ),
      ),
    );
  }

  void _editLabel(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: bookmark.label);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit label'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Label (optional)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              ref
                  .read(appDatabaseProvider)
                  .studyToolsDao
                  .updateBookmarkLabel(bookmark.id, controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ── Highlights ────────────────────────────────────────────────────────────────

class _HighlightsTab extends ConsumerWidget {
  const _HighlightsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlightsAsync = ref.watch(allHighlightsProvider);

    return highlightsAsync.when(
      data: (highlights) {
        if (highlights.isEmpty) {
          return const _EmptyTab(
            icon: Icons.highlight_outlined,
            message:
                'No highlights yet.\nSelect text in a sutta to highlight it.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.md),
          itemCount: highlights.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) =>
              _HighlightTile(highlight: highlights[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _HighlightTile extends ConsumerWidget {
  const _HighlightTile({required this.highlight});

  final UserHighlight highlight;

  Color _parseHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleAsync = ref.watch(suttaTitleProvider(highlight.textUid));
    final title = titleAsync.value ?? highlight.textUid;

    return Dismissible(
      key: Key('hl-${highlight.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.md),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        ref
            .read(appDatabaseProvider)
            .studyToolsDao
            .deleteHighlight(highlight.id);
      },
      child: ListTile(
        leading: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: _parseHex(highlight.colour),
            shape: BoxShape.circle,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (highlight.note != null && highlight.note!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 2),
                child: Text(
                  highlight.note!.length > 80
                      ? '${highlight.note!.substring(0, 80)}…'
                      : highlight.note!,
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
            Text(
              highlight.language.toUpperCase(),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: () => context.push(
            Routes.readerPath(highlight.textUid, scrollTo: highlight.startOffset)),
      ),
    );
  }
}

// ── Notes ─────────────────────────────────────────────────────────────────────

class _NotesTab extends ConsumerWidget {
  const _NotesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(allNotesProvider);
    final hlNotesAsync = ref.watch(highlightNotesProvider);

    return notesAsync.when(
      data: (notes) {
        final hlNotes = hlNotesAsync.value ?? [];
        if (notes.isEmpty && hlNotes.isEmpty) {
          return const _EmptyTab(
            icon: Icons.edit_note_outlined,
            message: 'No notes yet.\nTap the note icon while reading a sutta.',
          );
        }

        final items = <Widget>[];

        // Sutta-level notes
        if (notes.isNotEmpty) {
          items.add(const Padding(
            padding: EdgeInsets.only(bottom: AppSizes.xs),
            child: Text('SUTTA NOTES',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8)),
          ));
          for (final note in notes) {
            items.add(_NoteTile(note: note));
          }
        }

        // Highlight notes
        if (hlNotes.isNotEmpty) {
          items.add(Padding(
            padding: EdgeInsets.only(
                top: notes.isNotEmpty ? AppSizes.lg : 0,
                bottom: AppSizes.xs),
            child: const Text('HIGHLIGHT NOTES',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8)),
          ));
          for (final hl in hlNotes) {
            items.add(_HighlightNoteTile(highlight: hl));
          }
        }

        return ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: items,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _NoteTile extends ConsumerWidget {
  const _NoteTile({required this.note});

  final UserNote note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleAsync = ref.watch(suttaTitleProvider(note.textUid));
    final title = titleAsync.value ?? note.textUid;
    final excerpt = note.content.length > 120
        ? '${note.content.substring(0, 120)}…'
        : note.content;

    return Dismissible(
      key: Key('note-${note.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.md),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(appDatabaseProvider).studyToolsDao.deleteNote(note.id);
      },
      child: Card(
        child: ListTile(
          title: Text(title,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(excerpt, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                _formatDate(note.updatedAt),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => context.push(Routes.readerPath(note.textUid)),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _HighlightNoteTile extends ConsumerWidget {
  const _HighlightNoteTile({required this.highlight});

  final UserHighlight highlight;

  Color _parseHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleAsync = ref.watch(suttaTitleProvider(highlight.textUid));
    final title = titleAsync.value ?? highlight.textUid;
    final note = highlight.note ?? '';
    final excerpt =
        note.length > 120 ? '${note.substring(0, 120)}…' : note;

    return Dismissible(
      key: Key('hl-note-${highlight.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.md),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        // Clear the note from the highlight (keeps the highlight itself).
        ref
            .read(appDatabaseProvider)
            .studyToolsDao
            .updateHighlightNote(highlight.id, '');
      },
      child: Card(
        child: ListTile(
          leading: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _parseHex(highlight.colour),
              shape: BoxShape.circle,
            ),
          ),
          title: Text(title,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(excerpt, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                highlight.language.toUpperCase(),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => context.push(Routes.readerPath(highlight.textUid,
              scrollTo: highlight.startOffset)),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Collections ──────────────────────────────────────────────────────────────

class _CollectionsTab extends ConsumerWidget {
  const _CollectionsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(allCollectionsProvider);

    return collectionsAsync.when(
      data: (collections) {
        if (collections.isEmpty) {
          return const _EmptyTab(
            icon: Icons.collections_bookmark_outlined,
            message:
                'No collections yet.\nCreate one from the reader overflow menu.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSizes.md),
          itemCount: collections.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: FilledButton.tonalIcon(
                  onPressed: () => context.push(Routes.collections),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('Manage Collections'),
                ),
              );
            }
            final c = collections[index - 1];
            return Card(
              margin: const EdgeInsets.only(bottom: AppSizes.xs),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _parseCollectionColor(c.colour),
                  radius: 16,
                  child: const Icon(Icons.collections_bookmark,
                      color: Colors.white, size: 16),
                ),
                title: Text(c.name),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () =>
                    context.push(Routes.collectionDetailPath(c.id)),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const _EmptyTab(
        icon: Icons.error_outline,
        message: 'Could not load collections.',
      ),
    );
  }

  Color _parseCollectionColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.green;
    }
  }
}

// ── Translations ────────────────────────────────────────────────────────────

class _TranslationsTab extends ConsumerWidget {
  const _TranslationsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translationsAsync = ref.watch(_userTranslationCountProvider);

    return translationsAsync.when(
      data: (count) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.translate,
                  size: 48,
                  color: count > 0
                      ? AppColors.green
                      : Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  count > 0
                      ? '$count personal translation${count == 1 ? '' : 's'}'
                      : 'No translations yet',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  count > 0
                      ? 'View, edit, export, and import your translations.'
                      : 'Open any sutta and select "My translation" to start.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 24),
                FilledButton.tonalIcon(
                  onPressed: () => context.push(Routes.myTranslations),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('My Translations'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const _EmptyTab(
        icon: Icons.error_outline,
        message: 'Could not load translations.',
      ),
    );
  }
}

// ── Dictionary ────────────────────────────────────────────────────────────

class _DictionaryTab extends StatelessWidget {
  const _DictionaryTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book, size: 48, color: AppColors.green),
            const SizedBox(height: 16),
            const Text(
              'Pali Dictionary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'Search 23,000+ Pali words with definitions.\nAlso available from the reader toolbar.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            FilledButton.tonalIcon(
              onPressed: () => context.push(Routes.dictionary),
              icon: const Icon(Icons.search, size: 16),
              label: const Text('Open Dictionary'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Community ─────────────────────────────────────────────────────────────

class _CommunityTab extends StatelessWidget {
  const _CommunityTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people_outline, size: 48, color: AppColors.green),
            const SizedBox(height: 16),
            const Text(
              'Community Packages',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse and import translation packages\nshared by the community.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            FilledButton.tonalIcon(
              onPressed: () => context.push(Routes.communityPackages),
              icon: const Icon(Icons.explore, size: 16),
              label: const Text('Browse Packages'),
            ),
          ],
        ),
      ),
    );
  }
}

final _userTranslationCountProvider =
    FutureProvider.autoDispose<int>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final count = await db.customSelect(
    'SELECT COUNT(*) AS c FROM user_translations WHERE is_deleted = 0',
  ).getSingle();
  return count.read<int>('c');
});
