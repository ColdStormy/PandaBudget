import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/features/accounts/data/drift_account_repository.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';
import 'package:pandabudget/features/categories/data/drift_category_repository.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/categorization/data/drift_categorization_repositories.dart';
import 'package:pandabudget/features/categorization/domain/category_rule.dart';
import 'package:pandabudget/features/planning/data/drift_planning_repositories.dart';
import 'package:pandabudget/features/planning/domain/budget.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/planning/domain/savings_goal.dart';
import 'package:pandabudget/features/transactions/data/drift_transaction_repository.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

/// Fills [db] with a small, realistic household: two accounts, a plan,
/// budgets, goals and a few months of transactions up to November 2026.
///
/// Used by widget and golden tests so screens show meaningful content.
Future<void> seedDemoData(AppDatabase db) async {
  final accounts = DriftAccountRepository(db);
  final categories = DriftCategoryRepository(db);
  final transactions = DriftTransactionRepository(db);
  final byName = {for (final c in await categories.getAll()) c.name: c};
  Category category(String name) => byName[name]!;

  final giro = await accounts.save(
    Account(
      name: 'Main account',
      kind: AccountKind.checking,
      openingDate: DateTime(2026, 6),
      openingBalanceMinor: 184000,
    ),
  );
  final savings = await accounts.save(
    Account(
      name: 'Savings',
      kind: AccountKind.savings,
      openingDate: DateTime(2026, 6),
      openingBalanceMinor: 650000,
      colorValue: 0xFF4F8F8B,
    ),
  );

  final planned = DriftPlannedItemRepository(db);
  for (final item in [
    PlannedItem(
      name: 'Salary',
      kind: PlannedKind.income,
      amountMinor: 325000,
      startDate: DateTime(2026, 1, 28),
      categoryId: category('Salary').id,
    ),
    PlannedItem(
      name: 'Child benefit',
      kind: PlannedKind.income,
      amountMinor: 25500,
      startDate: DateTime(2026, 1, 5),
      categoryId: category('Benefits').id,
    ),
    PlannedItem(
      name: 'Rent',
      kind: PlannedKind.expense,
      amountMinor: 98000,
      startDate: DateTime(2026),
      categoryId: category('Rent & mortgage').id,
    ),
    PlannedItem(
      name: 'Electricity',
      kind: PlannedKind.expense,
      amountMinor: 7900,
      startDate: DateTime(2026, 1, 2),
      categoryId: category('Utilities').id,
    ),
    PlannedItem(
      name: 'Internet',
      kind: PlannedKind.expense,
      amountMinor: 3999,
      startDate: DateTime(2026, 1, 15),
      categoryId: category('Internet & phone').id,
    ),
    PlannedItem(
      name: 'Car insurance',
      kind: PlannedKind.expense,
      amountMinor: 64000,
      unit: RecurrenceUnit.year,
      startDate: DateTime(2026, 1, 10),
      categoryId: category('Insurance').id,
    ),
    PlannedItem(
      name: 'Broadcasting fee',
      kind: PlannedKind.expense,
      amountMinor: 5508,
      interval: 3,
      startDate: DateTime(2026, 2, 15),
      categoryId: category('Fees & taxes').id,
    ),
    PlannedItem(
      name: 'New washing machine',
      kind: PlannedKind.expense,
      amountMinor: 54900,
      unit: RecurrenceUnit.once,
      startDate: DateTime(2026, 12, 12),
      categoryId: category('Home & garden').id,
    ),
  ]) {
    await planned.save(item);
  }

  final budgets = DriftBudgetRepository(db);
  for (final budget in [
    Budget(
      name: 'Groceries',
      amountMinor: 45000,
      startMonth: const YearMonth(2026, 1),
      categoryIds: {category('Groceries').id},
    ),
    Budget(
      name: 'Eating out',
      amountMinor: 12000,
      startMonth: const YearMonth(2026, 1),
      categoryIds: {category('Eating out').id},
      colorValue: 0xFFD08A3C,
    ),
    Budget(
      name: 'Leisure',
      amountMinor: 15000,
      startMonth: const YearMonth(2026, 1),
      categoryIds: {category('Leisure').id},
      colorValue: 0xFFD9A441,
    ),
    Budget(
      name: 'Getting around',
      amountMinor: 18000,
      startMonth: const YearMonth(2026, 1),
      categoryIds: {category('Transport').id},
      colorValue: 0xFF4F8F8B,
    ),
  ]) {
    await budgets.save(budget);
  }

  final goals = DriftSavingsGoalRepository(db);
  for (final goal in [
    SavingsGoal(
      name: 'Summer vacation',
      targetMinor: 280000,
      savedMinor: 95000,
      targetMonth: const YearMonth(2027, 6),
      accountId: savings,
    ),
    SavingsGoal(
      name: 'Next car',
      targetMinor: 1200000,
      savedMinor: 420000,
      targetMonth: const YearMonth(2028, 3),
      priority: 1,
      colorValue: 0xFF5B7C99,
    ),
  ]) {
    await goals.save(goal);
  }

  await DriftCategoryRuleRepository(db).save(
    CategoryRule(
      name: 'Supermarkets',
      categoryId: category('Groceries').id,
      matchAll: false,
      conditions: const [
        RuleCondition(
          field: RuleField.counterparty,
          operator: RuleOperator.contains,
          value: 'rewe',
        ),
        RuleCondition(
          field: RuleField.counterparty,
          operator: RuleOperator.contains,
          value: 'edeka',
        ),
      ],
    ),
  );

  LedgerTransaction tx(
    DateTime date,
    int amount,
    String counterparty,
    String purpose,
    String? categoryName, {
    CategorySource source = CategorySource.manual,
  }) => LedgerTransaction(
    accountId: giro,
    bookingDate: date,
    amountMinor: amount,
    counterparty: counterparty,
    purpose: purpose,
    categoryId: categoryName == null ? null : category(categoryName).id,
    categorySource: categoryName == null ? CategorySource.none : source,
  );

  final all = <LedgerTransaction>[];
  // The same pattern for July to November with small variations.
  for (var month = 7; month <= 11; month++) {
    final v = month - 7;
    DateTime day(int d) => DateTime(2026, month, d);
    all.addAll([
      tx(day(1), -98000, 'Hausverwaltung Müller', 'Rent', 'Rent & mortgage'),
      tx(day(2), -7900, 'Stadtwerke', 'Electricity', 'Utilities'),
      tx(
        day(3),
        -6230 - v * 310,
        'REWE Markt',
        'Card payment',
        'Groceries',
        source: CategorySource.rule,
      ),
      tx(day(5), 25500, 'Familienkasse', 'Child benefit', 'Benefits'),
      tx(day(6), -5460 + v * 120, 'Shell Station', 'Fuel', 'Fuel'),
      tx(
        day(8),
        -8420 - v * 200,
        'EDEKA Schmidt',
        'Card payment',
        'Groceries',
        source: CategorySource.rule,
      ),
      tx(day(9), -3250 - v * 480, 'Trattoria Roma', 'Dinner', 'Eating out'),
    ]);
    // November is only shown up to the 10th.
    if (month == 11) continue;
    all.addAll([
      tx(day(12), -1299, 'Streamflix', 'Subscription', 'Subscriptions'),
      tx(day(15), -3999, 'Telenet', 'Internet', 'Internet & phone'),
      tx(
        day(17),
        -7310 + v * 150,
        'REWE Markt',
        'Card payment',
        'Groceries',
        source: CategorySource.rule,
      ),
      tx(
        day(19),
        -4900 - v * 700,
        'Deutsche Bahn',
        'Tickets',
        'Public transport',
      ),
      tx(
        day(22),
        -5890,
        'Buchhandlung Lesezeit',
        'Books',
        'Hobbies',
        source: CategorySource.learned,
      ),
      tx(
        day(24),
        -9120 - v * 260,
        'EDEKA Schmidt',
        'Card payment',
        'Groceries',
        source: CategorySource.rule,
      ),
      tx(day(26), -2800 - v * 350, 'Cafe Morgenrot', 'Brunch', 'Eating out'),
      tx(day(28), 325000, 'Muster Arbeitgeber AG', 'Salary', 'Salary'),
      tx(day(28), -30000, 'Savings', 'Monthly saving', 'Transfers'),
    ]);
  }
  all.addAll([
    tx(DateTime(2026, 11, 4), -2490, 'Paketshop', 'Order 88213', null),
    tx(DateTime(2026, 11, 7), -1850, 'Kiosk am Eck', '', null),
  ]);
  await transactions.saveAll(all);
}
