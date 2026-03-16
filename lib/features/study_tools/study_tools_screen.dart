import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import '../../data/database/app_database.dart';
import '../../shared/providers/database_provider.dart';

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
    _tabs = TabController(length: 3, vsync: this);
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
          tabs: const [
            Tab(text: 'Bookmarks'),
            Tab(text: 'Highlights'),
            Tab(text: 'Notes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _BookmarksTab(),
          _HighlightsTab(),
          _NotesTab(),
        ],
      ),
    );
  }
}

// ── Bookmarks ─────────────────────────────────────────────────────────────────

class _BookmarksTab extends ConsumerWidget {
  const _BookmarksTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(
      StreamProvider((_) =>
          ref.watch(appDatabaseProvider).studyToolsDao.watchAllBookmarks()),
    );

    return bookmarksAsync.when(
      data: (bookmarks) {
        if (bookmarks.isEmpty) {
          return const _EmptyTab(
            icon: Icons.bookmark_outline,
            message: 'No bookmarks yet.\nLong-press a sutta to bookmark it.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.md),
          itemCount: bookmarks.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
          itemBuilder: (context, index) =>
              _BookmarkTile(bookmark: bookmarks[index], ref: ref),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  const _BookmarkTile({required this.bookmark, required this.ref});

  final UserBookmark bookmark;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
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
          title: Text(bookmark.textUid),
          subtitle: bookmark.label.isNotEmpty ? Text(bookmark.label) : null,
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => context.push(Routes.readerPath(bookmark.textUid)),
          onLongPress: () => _editLabel(context),
        ),
      ),
    );
  }

  void _editLabel(BuildContext context) {
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
    final highlightsAsync = ref.watch(
      StreamProvider((_) =>
          ref.watch(appDatabaseProvider).studyToolsDao.watchAllHighlights()),
    );

    return highlightsAsync.when(
      data: (highlights) {
        if (highlights.isEmpty) {
          return const _EmptyTab(
            icon: Icons.highlight_outlined,
            message:
                'No highlights yet.\nLong-press text in a sutta to highlight it.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.md),
          itemCount: highlights.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) =>
              _HighlightTile(highlight: highlights[index], ref: ref),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  const _HighlightTile({required this.highlight, required this.ref});

  final UserHighlight highlight;
  final WidgetRef ref;

  Color _parseHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
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
          highlight.textUid,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Chars ${highlight.startOffset}–${highlight.endOffset}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: () => context.push(Routes.readerPath(highlight.textUid)),
      ),
    );
  }
}

// ── Notes ─────────────────────────────────────────────────────────────────────

class _NotesTab extends ConsumerWidget {
  const _NotesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(
      StreamProvider(
          (_) => ref.watch(appDatabaseProvider).studyToolsDao.watchAllNotes()),
    );

    return notesAsync.when(
      data: (notes) {
        if (notes.isEmpty) {
          return const _EmptyTab(
            icon: Icons.edit_note_outlined,
            message: 'No notes yet.\nTap the note icon while reading a sutta.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.md),
          itemCount: notes.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
          itemBuilder: (context, index) => _NoteTile(note: notes[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note});

  final UserNote note;

  @override
  Widget build(BuildContext context) {
    final excerpt = note.content.length > 120
        ? '${note.content.substring(0, 120)}…'
        : note.content;

    return Card(
      child: ListTile(
        title: Text(note.textUid,
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
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
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
