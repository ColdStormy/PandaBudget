import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/database/database_provider.dart';
import 'package:pandabudget/features/categorization/domain/category_rule.dart';
import 'package:pandabudget/features/categorization/domain/naive_bayes_classifier.dart';

final categoryRuleRepositoryProvider = Provider<CategoryRuleRepository>(
  (ref) => DriftCategoryRuleRepository(ref.watch(appDatabaseProvider)),
);

final classifierStoreProvider = Provider<ClassifierStore>(
  (ref) => DriftClassifierStore(ref.watch(appDatabaseProvider)),
);

class DriftCategoryRuleRepository implements CategoryRuleRepository {
  DriftCategoryRuleRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$CategoryRulesTable, CategoryRuleRow> get _query =>
      _db.select(_db.categoryRules)..orderBy([
        (r) => OrderingTerm(expression: r.priority),
        (r) => OrderingTerm(expression: r.id),
      ]);

  @override
  Stream<List<CategoryRule>> watchAll() =>
      _query.watch().map((rows) => rows.map(_toEntity).toList());

  @override
  Future<List<CategoryRule>> getAll() async =>
      (await _query.get()).map(_toEntity).toList();

  @override
  Future<int> save(CategoryRule rule) => _db.transaction(() async {
    var priority = rule.priority;
    if (rule.isNew) {
      // New rules go to the end of the list.
      final highest = _db.categoryRules.priority.max();
      final row = await (_db.selectOnly(
        _db.categoryRules,
      )..addColumns([highest])).getSingle();
      priority = (row.read(highest) ?? -1) + 1;
    }
    final id = await _db
        .into(_db.categoryRules)
        .insertOnConflictUpdate(
          CategoryRulesCompanion(
            id: rule.isNew ? const Value.absent() : Value(rule.id),
            name: Value(rule.name),
            categoryId: Value(rule.categoryId),
            priority: Value(priority),
            matchAll: Value(rule.matchAll),
            conditions: Value(rule.conditions),
            isEnabled: Value(rule.isEnabled),
          ),
        );
    return rule.isNew ? id : rule.id;
  });

  @override
  Future<void> delete(int id) =>
      (_db.delete(_db.categoryRules)..where((r) => r.id.equals(id))).go();

  @override
  Future<void> reorder(List<int> orderedIds) => _db.batch((batch) {
    for (final (index, id) in orderedIds.indexed) {
      batch.update(
        _db.categoryRules,
        CategoryRulesCompanion(priority: Value(index)),
        where: (r) => r.id.equals(id),
      );
    }
  });

  static CategoryRule _toEntity(CategoryRuleRow row) => CategoryRule(
    id: row.id,
    name: row.name,
    categoryId: row.categoryId,
    priority: row.priority,
    matchAll: row.matchAll,
    conditions: row.conditions,
    isEnabled: row.isEnabled,
  );
}

class DriftClassifierStore implements ClassifierStore {
  DriftClassifierStore(this._db);

  final AppDatabase _db;

  @override
  Future<ClassifierState> load() async {
    final state = ClassifierState();
    for (final row in await _db.select(_db.classifierCategories).get()) {
      state.documentCounts[row.categoryId] = row.documentCount;
    }
    for (final row in await _db.select(_db.classifierTokens).get()) {
      state.tokenCounts.putIfAbsent(row.token, () => {})[row.categoryId] =
          row.count;
      state.tokenTotals[row.categoryId] =
          (state.tokenTotals[row.categoryId] ?? 0) + row.count;
    }
    return state;
  }

  @override
  Future<void> applyDeltas({
    required Map<int, int> documentDeltas,
    required Map<int, Map<String, int>> tokenDeltas,
  }) => _db.transaction(() async {
    await _db.batch((batch) {
      for (final MapEntry(key: categoryId, value: delta)
          in documentDeltas.entries) {
        if (delta == 0) continue;
        batch.insert(
          _db.classifierCategories,
          ClassifierCategoriesCompanion.insert(
            categoryId: Value(categoryId),
            documentCount: delta,
          ),
          onConflict:
              DoUpdate<$ClassifierCategoriesTable, ClassifierCategoryRow>(
                (old) => ClassifierCategoriesCompanion.custom(
                  documentCount: old.documentCount + Constant(delta),
                ),
              ),
        );
      }
      for (final MapEntry(key: categoryId, value: tokens)
          in tokenDeltas.entries) {
        for (final MapEntry(key: token, value: delta) in tokens.entries) {
          if (delta == 0) continue;
          batch.insert(
            _db.classifierTokens,
            ClassifierTokensCompanion.insert(
              token: token,
              categoryId: categoryId,
              count: delta,
            ),
            onConflict: DoUpdate<$ClassifierTokensTable, ClassifierTokenRow>(
              (old) => ClassifierTokensCompanion.custom(
                count: old.count + Constant(delta),
              ),
            ),
          );
        }
      }
    });
    await (_db.delete(
      _db.classifierTokens,
    )..where((t) => t.count.isSmallerOrEqualValue(0))).go();
    await (_db.delete(
      _db.classifierCategories,
    )..where((c) => c.documentCount.isSmallerOrEqualValue(0))).go();
  });

  @override
  Future<void> clear() => _db.transaction(() async {
    await _db.delete(_db.classifierTokens).go();
    await _db.delete(_db.classifierCategories).go();
  });
}
