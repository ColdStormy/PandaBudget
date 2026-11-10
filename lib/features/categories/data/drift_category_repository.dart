import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/database/database_provider.dart';
import 'package:pandabudget/features/categories/domain/category.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => DriftCategoryRepository(ref.watch(appDatabaseProvider)),
);

class DriftCategoryRepository implements CategoryRepository {
  DriftCategoryRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$CategoriesTable, CategoryRow> _query({
    required bool includeArchived,
  }) {
    final query = _db.select(_db.categories)
      ..orderBy([
        (c) => OrderingTerm(expression: c.sortOrder),
        (c) => OrderingTerm(expression: c.name),
      ]);
    if (!includeArchived) query.where((c) => c.isArchived.not());
    return query;
  }

  @override
  Stream<List<Category>> watchAll({bool includeArchived = true}) =>
      _query(includeArchived: includeArchived)
          .watch()
          .map((rows) => rows.map(_toEntity).toList());

  @override
  Future<List<Category>> getAll() async {
    final rows = await _query(includeArchived: true).get();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<int> save(Category category) {
    final companion = CategoriesCompanion(
      id: category.isNew ? const Value.absent() : Value(category.id),
      name: Value(category.name),
      kind: Value(category.kind),
      parentId: Value(category.parentId),
      colorValue: Value(category.colorValue),
      iconKey: Value(category.iconKey),
      isArchived: Value(category.isArchived),
      sortOrder: Value(category.sortOrder),
    );
    return _db.transaction(() async {
      final id = await _db
          .into(_db.categories)
          .insertOnConflictUpdate(companion);
      final savedId = category.isNew ? id : category.id;
      // Sub-categories always share their parent's kind.
      await (_db.update(_db.categories)
            ..where((c) => c.parentId.equals(savedId)))
          .write(CategoriesCompanion(kind: Value(category.kind)));
      return savedId;
    });
  }

  @override
  Future<void> delete(int id) =>
      (_db.delete(_db.categories)..where((c) => c.id.equals(id))).go();

  static Category _toEntity(CategoryRow row) => Category(
    id: row.id,
    name: row.name,
    kind: row.kind,
    parentId: row.parentId,
    colorValue: row.colorValue,
    iconKey: row.iconKey,
    isArchived: row.isArchived,
    sortOrder: row.sortOrder,
  );
}
