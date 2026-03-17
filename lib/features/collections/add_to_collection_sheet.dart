import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../data/database/app_database.dart';
import '../../shared/providers/database_provider.dart';
import 'collections_screen.dart';

/// Shows a bottom sheet to add a sutta to an existing or new collection.
Future<void> showAddToCollectionSheet(
  BuildContext context,
  WidgetRef ref,
  String suttaUid,
) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (_) => _AddToCollectionSheet(suttaUid: suttaUid),
  );
}

class _AddToCollectionSheet extends ConsumerWidget {
  const _AddToCollectionSheet({required this.suttaUid});

  final String suttaUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(allCollectionsProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Add to Collection',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New'),
                    onPressed: () =>
                        _createAndAdd(context, ref),
                  ),
                ],
              ),
            ),
            const Divider(),
            collectionsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSizes.md),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const Padding(
                padding: EdgeInsets.all(AppSizes.md),
                child: Text('Could not load collections'),
              ),
              data: (collections) {
                if (collections.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSizes.lg),
                    child: Center(
                      child: Text('No collections yet. Tap "New" to create one.',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: collections.length,
                    itemBuilder: (context, index) {
                      final c = collections[index];
                      return _CollectionTile(
                        collection: c,
                        onTap: () => _addToCollection(context, ref, c.id),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addToCollection(BuildContext context, WidgetRef ref, int collectionId) {
    ref.read(appDatabaseProvider).collectionsDao.addItem(collectionId, suttaUid);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to collection')),
    );
  }

  void _createAndAdd(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Collection'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'e.g. "Metta Suttas"',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              final dao = ref.read(appDatabaseProvider).collectionsDao;
              final id = await dao.createCollection(name: name);
              await dao.addItem(id, suttaUid);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to "$name"')),
                );
              }
            },
            child: const Text('Create & Add'),
          ),
        ],
      ),
    );
  }
}

class _CollectionTile extends StatelessWidget {
  const _CollectionTile({required this.collection, required this.onTap});

  final UserCollection collection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _parseColor(collection.colour),
        radius: 16,
        child: const Icon(Icons.collections_bookmark,
            color: Colors.white, size: 16),
      ),
      title: Text(collection.name),
      onTap: onTap,
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
