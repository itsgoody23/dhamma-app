import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/collections_table.dart';
import '../tables/collection_items_table.dart';

part 'collections_dao.g.dart';

@DriftAccessor(
  tables: [UserCollections, CollectionItems],
)
class CollectionsDao extends DatabaseAccessor<AppDatabase>
    with _$CollectionsDaoMixin {
  CollectionsDao(super.db);

  // ── Collections ───────────────────────────────────────────────────────────

  Future<int> createCollection({
    required String name,
    String description = '',
    String colour = '#4A7C59',
  }) {
    return into(userCollections).insert(UserCollectionsCompanion(
      name: Value(name),
      description: Value(description),
      colour: Value(colour),
    ));
  }

  Future<void> updateCollection(
    int id, {
    String? name,
    String? description,
    String? colour,
  }) {
    return (update(userCollections)..where((c) => c.id.equals(id))).write(
      UserCollectionsCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        description:
            description != null ? Value(description) : const Value.absent(),
        colour: colour != null ? Value(colour) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteCollection(int id) async {
    final now = DateTime.now();
    // Soft-delete collection
    await (update(userCollections)..where((c) => c.id.equals(id))).write(
      UserCollectionsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(now),
      ),
    );
    // Soft-delete all items in the collection
    await (update(collectionItems)
          ..where((i) => i.collectionId.equals(id)))
        .write(CollectionItemsCompanion(
      isDeleted: const Value(true),
      updatedAt: Value(now),
    ));
  }

  Stream<List<UserCollection>> watchAllCollections() {
    return (select(userCollections)
          ..where((c) => c.isDeleted.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .watch();
  }

  Future<UserCollection?> getCollection(int id) {
    return (select(userCollections)
          ..where((c) => c.id.equals(id) & c.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  // ── Collection Items ──────────────────────────────────────────────────────

  Future<void> addItem(int collectionId, String suttaUid) async {
    // Get next sort order
    final maxOrder = await customSelect(
      'SELECT MAX(sort_order) AS max_order FROM collection_items '
      'WHERE collection_id = ? AND is_deleted = 0',
      variables: [Variable(collectionId)],
    ).getSingleOrNull();
    final nextOrder = (maxOrder?.read<int?>('max_order') ?? -1) + 1;

    // Check for existing soft-deleted item to revive
    final existing = await (select(collectionItems)
          ..where((i) =>
              i.collectionId.equals(collectionId) &
              i.suttaUid.equals(suttaUid)))
        .getSingleOrNull();

    if (existing != null) {
      await (update(collectionItems)..where((i) => i.id.equals(existing.id)))
          .write(CollectionItemsCompanion(
        isDeleted: const Value(false),
        sortOrder: Value(nextOrder),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      await into(collectionItems).insert(
        CollectionItemsCompanion.insert(
          collectionId: collectionId,
          suttaUid: suttaUid,
          sortOrder: Value(nextOrder),
        ),
      );
    }

    // Touch parent collection's updatedAt
    await (update(userCollections)
          ..where((c) => c.id.equals(collectionId)))
        .write(UserCollectionsCompanion(updatedAt: Value(DateTime.now())));
  }

  Future<void> removeItem(int collectionId, String suttaUid) {
    return (update(collectionItems)
          ..where((i) =>
              i.collectionId.equals(collectionId) &
              i.suttaUid.equals(suttaUid)))
        .write(CollectionItemsCompanion(
      isDeleted: const Value(true),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> reorderItems(int collectionId, List<String> suttaUids) async {
    final now = DateTime.now();
    for (var i = 0; i < suttaUids.length; i++) {
      await (update(collectionItems)
            ..where((item) =>
                item.collectionId.equals(collectionId) &
                item.suttaUid.equals(suttaUids[i])))
          .write(CollectionItemsCompanion(
        sortOrder: Value(i),
        updatedAt: Value(now),
      ));
    }
  }

  Stream<List<CollectionItem>> watchItems(int collectionId) {
    return (select(collectionItems)
          ..where((i) =>
              i.collectionId.equals(collectionId) &
              i.isDeleted.equals(false))
          ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]))
        .watch();
  }

  Future<int> itemCount(int collectionId) async {
    final count = countAll();
    final query = selectOnly(collectionItems)
      ..addColumns([count])
      ..where(collectionItems.collectionId.equals(collectionId) &
          collectionItems.isDeleted.equals(false));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Stream<int> watchItemCount(int collectionId) {
    final count = countAll();
    final query = selectOnly(collectionItems)
      ..addColumns([count])
      ..where(collectionItems.collectionId.equals(collectionId) &
          collectionItems.isDeleted.equals(false));
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }
}
