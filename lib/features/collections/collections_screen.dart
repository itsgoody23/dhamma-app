import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import '../../data/database/app_database.dart';
import '../../shared/providers/database_provider.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final allCollectionsProvider =
    StreamProvider.autoDispose<List<UserCollection>>((ref) {
  return ref.watch(appDatabaseProvider).collectionsDao.watchAllCollections();
});

// ── Screen ────────────────────────────────────────────────────────────────────

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(allCollectionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Collections')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.green,
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: collectionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (collections) {
          if (collections.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.collections_bookmark_outlined,
                        size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: AppSizes.md),
                    const Text(
                      'No collections yet',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      'Create a collection to group suttas\nfor study or reading.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.md),
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final c = collections[index];
              return _CollectionCard(collection: c);
            },
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'e.g. "Metta Suttas"',
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              ref.read(appDatabaseProvider).collectionsDao.createCollection(
                    name: name,
                    description: descController.text.trim(),
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

// ── Collection Card ─────────────────────────────────────────────────────────

class _CollectionCard extends ConsumerWidget {
  const _CollectionCard({required this.collection});

  final UserCollection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(_collectionItemCountProvider(collection.id));

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _parseColor(collection.colour),
          radius: 20,
          child: const Icon(Icons.collections_bookmark, color: Colors.white, size: 20),
        ),
        title: Text(collection.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          collection.description.isNotEmpty
              ? collection.description
              : countAsync.when(
                  data: (c) => '$c suttas',
                  loading: () => '...',
                  error: (_, __) => '',
                ),
        ),
        trailing: countAsync.when(
          data: (c) => Text('$c',
              style: TextStyle(
                  color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        onTap: () => context.push(Routes.collectionDetailPath(collection.id)),
        onLongPress: () => _showOptions(context, ref),
      ),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(ctx);
                _showRenameDialog(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title:
                  const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: collection.name);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Collection'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                ref
                    .read(appDatabaseProvider)
                    .collectionsDao
                    .updateCollection(collection.id, name: name);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete collection?'),
        content: Text(
            'This will delete "${collection.name}" and remove all suttas from it.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(appDatabaseProvider)
                  .collectionsDao
                  .deleteCollection(collection.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.green;
    }
  }
}

final _collectionItemCountProvider =
    StreamProvider.autoDispose.family<int, int>((ref, collectionId) {
  return ref.watch(appDatabaseProvider).collectionsDao.watchItemCount(collectionId);
});
