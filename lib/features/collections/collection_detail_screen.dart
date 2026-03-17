import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import '../../data/database/app_database.dart';
import '../../data/services/collection_share_service.dart';
import '../../shared/providers/database_provider.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final collectionDetailProvider =
    FutureProvider.autoDispose.family<UserCollection?, int>((ref, id) {
  return ref.watch(appDatabaseProvider).collectionsDao.getCollection(id);
});

final collectionItemsProvider =
    StreamProvider.autoDispose.family<List<CollectionItem>, int>((ref, id) {
  return ref.watch(appDatabaseProvider).collectionsDao.watchItems(id);
});

/// Lookup sutta title by UID.
final suttaTitleProvider =
    FutureProvider.autoDispose.family<String, String>((ref, uid) async {
  final db = ref.watch(appDatabaseProvider);
  final text = await db.textsDao.getSuttaByUidAnyLanguage(uid);
  return text?.title ?? uid;
});

// ── Screen ────────────────────────────────────────────────────────────────────

class CollectionDetailScreen extends ConsumerWidget {
  const CollectionDetailScreen({super.key, required this.collectionId});

  final int collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(collectionDetailProvider(collectionId));
    final itemsAsync = ref.watch(collectionItemsProvider(collectionId));

    final collection = collectionAsync.value;
    final title = collection?.name ?? 'Collection';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (collection != null)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'share') _shareCollection(context, ref);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                    value: 'share', child: Text('Share as JSON')),
              ],
            ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_add_outlined,
                        size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: AppSizes.md),
                    const Text('No suttas yet'),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      'Add suttas from the reader\nor library screen.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.all(AppSizes.md),
            itemCount: items.length,
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              final uids = items.map((i) => i.suttaUid).toList();
              final moved = uids.removeAt(oldIndex);
              uids.insert(newIndex, moved);
              ref
                  .read(appDatabaseProvider)
                  .collectionsDao
                  .reorderItems(collectionId, uids);
            },
            itemBuilder: (context, index) {
              final item = items[index];
              return _SuttaItemTile(
                key: ValueKey(item.id),
                item: item,
                collectionId: collectionId,
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _shareCollection(BuildContext context, WidgetRef ref) async {
    final db = ref.read(appDatabaseProvider);
    final service = CollectionShareService(db);
    await service.exportCollection(collectionId);
  }
}

// ── Sutta Item Tile ─────────────────────────────────────────────────────────

class _SuttaItemTile extends ConsumerWidget {
  const _SuttaItemTile({
    super.key,
    required this.item,
    required this.collectionId,
  });

  final CollectionItem item;
  final int collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleAsync = ref.watch(suttaTitleProvider(item.suttaUid));

    return Dismissible(
      key: ValueKey('dismiss_${item.id}'),
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
            .collectionsDao
            .removeItem(collectionId, item.suttaUid);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSizes.xs),
        child: ListTile(
          leading: const Icon(Icons.drag_handle),
          title: titleAsync.when(
            data: (title) => Text(title),
            loading: () => Text(item.suttaUid),
            error: (_, __) => Text(item.suttaUid),
          ),
          subtitle: Text(item.suttaUid.toUpperCase(),
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(Routes.readerPath(item.suttaUid)),
        ),
      ),
    );
  }
}
