import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/database/database_provider.dart';
import 'package:pandabudget/features/planning/domain/budget.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/planning/domain/savings_goal.dart';

final plannedItemRepositoryProvider = Provider<PlannedItemRepository>(
  (ref) => DriftPlannedItemRepository(ref.watch(appDatabaseProvider)),
);

final budgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => DriftBudgetRepository(ref.watch(appDatabaseProvider)),
);

final savingsGoalRepositoryProvider = Provider<SavingsGoalRepository>(
  (ref) => DriftSavingsGoalRepository(ref.watch(appDatabaseProvider)),
);

class DriftPlannedItemRepository implements PlannedItemRepository {
  DriftPlannedItemRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<PlannedItem>> watchAll() =>
      (_db.select(
        _db.plannedItems,
      )..orderBy([(i) => OrderingTerm(expression: i.name)])).watch().map(
        (rows) => [
          for (final row in rows)
            PlannedItem(
              id: row.id,
              name: row.name,
              kind: row.kind,
              amountMinor: row.amountMinor,
              unit: row.unit,
              interval: row.interval,
              startDate: row.startDate,
              endDate: row.endDate,
              categoryId: row.categoryId,
              accountId: row.accountId,
              note: row.note,
              isActive: row.isActive,
            ),
        ],
      );

  @override
  Future<int> save(PlannedItem item) async {
    final id = await _db
        .into(_db.plannedItems)
        .insertOnConflictUpdate(
          PlannedItemsCompanion(
            id: item.isNew ? const Value.absent() : Value(item.id),
            name: Value(item.name),
            kind: Value(item.kind),
            amountMinor: Value(item.amountMinor),
            unit: Value(item.unit),
            interval: Value(item.interval),
            startDate: Value(item.startDate),
            endDate: Value(item.endDate),
            categoryId: Value(item.categoryId),
            accountId: Value(item.accountId),
            note: Value(item.note),
            isActive: Value(item.isActive),
          ),
        );
    return item.isNew ? id : item.id;
  }

  @override
  Future<void> delete(int id) =>
      (_db.delete(_db.plannedItems)..where((i) => i.id.equals(id))).go();
}

class DriftBudgetRepository implements BudgetRepository {
  DriftBudgetRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Budget>> watchAll() {
    final query = _db.select(_db.budgets).join([
      leftOuterJoin(
        _db.budgetCategories,
        _db.budgetCategories.budgetId.equalsExp(_db.budgets.id),
      ),
    ])..orderBy([OrderingTerm(expression: _db.budgets.name)]);
    return query.watch().map((rows) {
      final budgets = <int, BudgetRow>{};
      final categories = <int, Set<int>>{};
      for (final row in rows) {
        final budget = row.readTable(_db.budgets);
        budgets[budget.id] = budget;
        final link = row.readTableOrNull(_db.budgetCategories);
        final ids = categories.putIfAbsent(budget.id, () => {});
        if (link != null) ids.add(link.categoryId);
      }
      return [
        for (final row in budgets.values)
          Budget(
            id: row.id,
            name: row.name,
            amountMinor: row.amountMinor,
            startMonth: row.startMonth,
            endMonth: row.endMonth,
            categoryIds: categories[row.id]!,
            colorValue: row.colorValue,
            isArchived: row.isArchived,
          ),
      ];
    });
  }

  @override
  Future<int> save(Budget budget) => _db.transaction(() async {
    final inserted = await _db
        .into(_db.budgets)
        .insertOnConflictUpdate(
          BudgetsCompanion(
            id: budget.isNew ? const Value.absent() : Value(budget.id),
            name: Value(budget.name),
            amountMinor: Value(budget.amountMinor),
            startMonth: Value(budget.startMonth),
            endMonth: Value(budget.endMonth),
            colorValue: Value(budget.colorValue),
            isArchived: Value(budget.isArchived),
          ),
        );
    final id = budget.isNew ? inserted : budget.id;
    await (_db.delete(
      _db.budgetCategories,
    )..where((link) => link.budgetId.equals(id))).go();
    await _db.batch(
      (batch) => batch.insertAll(_db.budgetCategories, [
        for (final categoryId in budget.categoryIds)
          BudgetCategoriesCompanion.insert(
            budgetId: id,
            categoryId: categoryId,
          ),
      ]),
    );
    return id;
  });

  @override
  Future<void> delete(int id) =>
      (_db.delete(_db.budgets)..where((b) => b.id.equals(id))).go();
}

class DriftSavingsGoalRepository implements SavingsGoalRepository {
  DriftSavingsGoalRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<SavingsGoal>> watchAll() =>
      (_db.select(_db.savingsGoals)..orderBy([
            (g) => OrderingTerm(expression: g.priority),
            (g) => OrderingTerm(expression: g.targetMonth),
          ]))
          .watch()
          .map(
            (rows) => [
              for (final row in rows)
                SavingsGoal(
                  id: row.id,
                  name: row.name,
                  targetMinor: row.targetMinor,
                  savedMinor: row.savedMinor,
                  targetMonth: row.targetMonth,
                  priority: row.priority,
                  accountId: row.accountId,
                  colorValue: row.colorValue,
                  isArchived: row.isArchived,
                ),
            ],
          );

  @override
  Future<int> save(SavingsGoal goal) async {
    final id = await _db
        .into(_db.savingsGoals)
        .insertOnConflictUpdate(
          SavingsGoalsCompanion(
            id: goal.isNew ? const Value.absent() : Value(goal.id),
            name: Value(goal.name),
            targetMinor: Value(goal.targetMinor),
            savedMinor: Value(goal.savedMinor),
            targetMonth: Value(goal.targetMonth),
            priority: Value(goal.priority),
            accountId: Value(goal.accountId),
            colorValue: Value(goal.colorValue),
            isArchived: Value(goal.isArchived),
          ),
        );
    return goal.isNew ? id : goal.id;
  }

  @override
  Future<void> delete(int id) =>
      (_db.delete(_db.savingsGoals)..where((g) => g.id.equals(id))).go();
}
