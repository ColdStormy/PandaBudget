import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/features/analysis/domain/analysis.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/planning/domain/budget.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

const food = Category(id: 1, name: 'Food', kind: CategoryKind.expense);
const bakery = Category(
  id: 2,
  name: 'Bakery',
  kind: CategoryKind.expense,
  parentId: 1,
);
const rent = Category(id: 3, name: 'Rent', kind: CategoryKind.expense);
const salary = Category(id: 4, name: 'Salary', kind: CategoryKind.income);
const transfer = Category(id: 5, name: 'Transfer', kind: CategoryKind.transfer);
final categories = CategoryTree([food, bakery, rent, salary, transfer]);

LedgerTransaction tx(int amount, {int? category, DateTime? date}) =>
    LedgerTransaction(
      accountId: 1,
      bookingDate: date ?? DateTime(2026, 10, 15),
      amountMinor: amount,
      categoryId: category,
    );

void main() {
  final october = [
    tx(-5000, category: 1),
    tx(-800, category: 2),
    tx(-400, category: 2),
    tx(-98000, category: 3),
    tx(325000, category: 4),
    tx(-50000, category: 5),
    tx(-1500),
    tx(2000),
    // A refund booked on an expense category.
    tx(1000, category: 1),
  ];

  group('totalsByCategory', () {
    test('rolls sub-categories up into their parent, largest first', () {
      final totals = totalsByCategory(october, categories);
      expect(totals.map((t) => t.categoryId), [3, 1, null]);
      final foodTotal = totals[1];
      // 50 + 8 + 4 - 10 refund
      expect(foodTotal.amountMinor, 5200);
      expect(foodTotal.transactionCount, 4);
      expect(foodTotal.children.map((c) => c.categoryId), [1, 2]);
      expect(foodTotal.children.last.amountMinor, 1200);
      expect(totals.first.children, isEmpty);
    });

    test('uncategorised spending is its own group', () {
      final uncategorised = totalsByCategory(october, categories).last;
      expect(uncategorised.categoryId, isNull);
      expect(uncategorised.amountMinor, 1500);
    });

    test('income is totalled separately and transfers are left out', () {
      final totals = totalsByCategory(
        october,
        categories,
        direction: FlowDirection.income,
      );
      expect(totals.map((t) => (t.categoryId, t.amountMinor)), [
        (4, 325000),
        (null, 2000),
      ]);
    });
  });

  group('monthlySummaries', () {
    test('sums income and spending per month and fills gaps', () {
      final summaries = monthlySummaries(
        [...october, tx(-10000, category: 3, date: DateTime(2026, 12, 2))],
        categories,
        from: const YearMonth(2026, 10),
        to: const YearMonth(2026, 12),
      );
      expect(summaries, hasLength(3));
      expect(summaries[0].incomeMinor, 327000);
      // 50 + 8 + 4 + 980 + 15 - 10 refund; the transfer does not count.
      expect(summaries[0].expenseMinor, 104700);
      expect(summaries[0].netMinor, 222300);
      expect(summaries[1].incomeMinor, 0);
      expect(summaries[1].expenseMinor, 0);
      expect(summaries[2].expenseMinor, 10000);
    });
  });

  group('budgetStatuses', () {
    const foodBudget = Budget(
      id: 1,
      name: 'Food',
      amountMinor: 5000,
      startMonth: YearMonth(2026, 1),
      categoryIds: {1},
    );
    const rentBudget = Budget(
      id: 2,
      name: 'Rent',
      amountMinor: 100000,
      startMonth: YearMonth(2026, 1),
      categoryIds: {3},
    );

    test('counts spending in the categories and their sub-categories', () {
      final statuses = budgetStatuses(
        [foodBudget, rentBudget],
        october,
        categories,
        month: const YearMonth(2026, 10),
      );
      final foodStatus = statuses.first;
      expect(foodStatus.spentMinor, 5200);
      expect(foodStatus.isOverspent, isTrue);
      expect(foodStatus.remainingMinor, -200);
      expect(foodStatus.ratio, closeTo(1.04, 0.001));

      final rentStatus = statuses.last;
      expect(rentStatus.isOverspent, isFalse);
      expect(rentStatus.remainingMinor, 2000);
    });

    test('only looks at the requested month and at active budgets', () {
      final statuses = budgetStatuses(
        [
          foodBudget,
          rentBudget.copyWith(startMonth: const YearMonth(2026, 12)),
        ],
        october,
        categories,
        month: const YearMonth(2026, 11),
      );
      expect(statuses, hasLength(1));
      expect(statuses.single.spentMinor, 0);
    });
  });

  group('CategoryTree', () {
    test('builds paths and finds descendants', () {
      expect(categories.pathOf(2), 'Food › Bakery');
      expect(categories.pathOf(1), 'Food');
      expect(categories.withDescendants(1), {1, 2});
      expect(categories.rootIdOf(2), 1);
      expect(categories.flattened.map((c) => c.id).take(2), [1, 2]);
    });
  });
}
