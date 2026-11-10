import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/planning/domain/budget.dart';
import 'package:pandabudget/features/planning/domain/forecast.dart';
import 'package:pandabudget/features/planning/domain/goal_planner.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/planning/domain/savings_goal.dart';

PlannedItem item({
  required int amount,
  int id = 1,
  PlannedKind kind = PlannedKind.expense,
  RecurrenceUnit unit = RecurrenceUnit.month,
  int interval = 1,
  DateTime? start,
  DateTime? end,
  int? categoryId,
  bool isActive = true,
}) => PlannedItem(
  id: id,
  name: 'item $id',
  kind: kind,
  amountMinor: amount,
  unit: unit,
  interval: interval,
  startDate: start ?? DateTime(2027),
  endDate: end,
  categoryId: categoryId,
  isActive: isActive,
);

const january = YearMonth(2027, 1);

void main() {
  group('PlannedItem occurrences', () {
    test('monthly items fall due once a month on their day', () {
      final rent = item(amount: 98000, start: DateTime(2027, 1, 3));
      expect(rent.occurrencesBetween(DateTime(2027), DateTime(2027, 3, 31)), [
        DateTime(2027, 1, 3),
        DateTime(2027, 2, 3),
        DateTime(2027, 3, 3),
      ]);
    });

    test('a start on the 31st uses the last day of shorter months', () {
      final salary = item(amount: 1, start: DateTime(2027, 1, 31));
      expect(salary.occurrencesBetween(DateTime(2027), DateTime(2027, 4, 30)), [
        DateTime(2027, 1, 31),
        DateTime(2027, 2, 28),
        DateTime(2027, 3, 31),
        DateTime(2027, 4, 30),
      ]);
    });

    test('quarterly and yearly items skip the months in between', () {
      final quarterly = item(
        amount: 1,
        interval: 3,
        start: DateTime(2027, 2, 15),
      );
      expect(quarterly.occurrencesIn(const YearMonth(2027, 3)), isEmpty);
      expect(quarterly.occurrencesIn(const YearMonth(2027, 5)), [
        DateTime(2027, 5, 15),
      ]);
      expect(quarterly.occurrencesIn(const YearMonth(2029, 2)), [
        DateTime(2029, 2, 15),
      ]);

      final insurance = item(
        amount: 1,
        unit: RecurrenceUnit.year,
        start: DateTime(2026, 11),
      );
      expect(insurance.occurrencesIn(const YearMonth(2027, 11)), hasLength(1));
      expect(insurance.occurrencesIn(const YearMonth(2027, 10)), isEmpty);
    });

    test('weekly items can fall due four or five times a month', () {
      final weekly = item(
        amount: 1,
        unit: RecurrenceUnit.week,
        start: DateTime(2027, 1, 4), // a Monday
      );
      expect(weekly.occurrencesIn(january), hasLength(4));
      expect(weekly.occurrencesIn(const YearMonth(2027, 3)), hasLength(5));

      final fortnightly = item(
        amount: 1,
        unit: RecurrenceUnit.week,
        interval: 2,
        start: DateTime(2027, 1, 4),
      );
      expect(fortnightly.occurrencesIn(const YearMonth(2027, 2)), [
        DateTime(2027, 2),
        DateTime(2027, 2, 15),
      ]);
    });

    test('one-time items occur exactly once', () {
      final purchase = item(
        amount: 1,
        unit: RecurrenceUnit.once,
        start: DateTime(2027, 6, 10),
      );
      expect(purchase.occurrencesIn(const YearMonth(2027, 6)), hasLength(1));
      expect(purchase.occurrencesIn(const YearMonth(2027, 7)), isEmpty);
      expect(purchase.occurrencesIn(const YearMonth(2028, 6)), isEmpty);
    });

    test(
      'nothing falls due before the start, after the end or when paused',
      () {
        final limited = item(
          amount: 1,
          start: DateTime(2027, 3),
          end: DateTime(2027, 5, 15),
        );
        expect(limited.occurrencesIn(const YearMonth(2027, 2)), isEmpty);
        expect(limited.occurrencesIn(const YearMonth(2027, 5)), hasLength(1));
        expect(limited.occurrencesIn(const YearMonth(2027, 6)), isEmpty);
        expect(
          item(amount: 1, isActive: false).occurrencesIn(january),
          isEmpty,
        );
      },
    );

    test('nextOccurrence looks ahead from a date', () {
      final yearly = item(
        amount: 1,
        unit: RecurrenceUnit.year,
        start: DateTime(2026, 11),
      );
      expect(yearly.nextOccurrence(DateTime(2027, 1, 15)), DateTime(2027, 11));
      expect(yearly.nextOccurrence(DateTime(2026, 11)), DateTime(2026, 11));
    });

    test('monthly equivalent spreads the amount', () {
      expect(
        item(amount: 120000, unit: RecurrenceUnit.year).monthlyEquivalentMinor,
        10000,
      );
      expect(item(amount: 30000, interval: 3).monthlyEquivalentMinor, 10000);
    });
  });

  group('planSavings', () {
    SavingsGoal goal({
      required int id,
      required int target,
      required YearMonth by,
      int saved = 0,
      int priority = 0,
    }) => SavingsGoal(
      id: id,
      name: 'goal $id',
      targetMinor: target,
      savedMinor: saved,
      targetMonth: by,
      priority: priority,
    );

    test('saves at an even rate up to the target month', () {
      final plan = planSavings(
        goals: [goal(id: 1, target: 120000, by: const YearMonth(2027, 6))],
        from: january,
        potentials: List.filled(12, 50000),
      );
      final vacation = plan.goals[1]!;
      expect(vacation.requiredMonthlyMinor, 20000);
      expect(vacation.contributions.values, everyElement(20000));
      expect(vacation.contributions.keys.last, const YearMonth(2027, 6));
      expect(vacation.fundedMonth, const YearMonth(2027, 6));
      expect(vacation.isOnTrack, isTrue);
      expect(vacation.isFrontLoaded, isFalse);
    });

    test('counts what is already saved', () {
      final plan = planSavings(
        goals: [
          goal(
            id: 1,
            target: 120000,
            saved: 60000,
            by: const YearMonth(2027, 3),
          ),
        ],
        from: january,
        potentials: List.filled(6, 50000),
      );
      expect(plan.goals[1]!.requiredMonthlyMinor, 20000);
    });

    test('leaves the rest of the month free', () {
      final plan = planSavings(
        goals: [goal(id: 1, target: 30000, by: const YearMonth(2027, 3))],
        from: january,
        potentials: [50000, 50000, 50000],
      );
      expect(plan.balances, [40000, 80000, 120000]);
    });

    test('unassigned money from earlier months carries over', () {
      final plan = planSavings(
        goals: [goal(id: 1, target: 90000, by: const YearMonth(2027, 3))],
        from: january,
        // March alone could not pay the even rate of 300.
        potentials: [60000, 60000, 10000],
      );
      final result = plan.goals[1]!;
      expect(result.isOnTrack, isTrue);
      expect(result.isFrontLoaded, isFalse);
      expect(result.contributions.values, [30000, 30000, 30000]);
    });

    test('front-loads a goal a lower priority goal would starve', () {
      final plan = planSavings(
        goals: [
          goal(id: 1, target: 90000, by: const YearMonth(2027, 3)),
          goal(id: 2, target: 60000, by: const YearMonth(2027, 2), priority: 1),
        ],
        from: january,
        // At even rates both goals take 300 in January and February and
        // leave nothing for the first goal's last instalment in March.
        potentials: [60000, 60000, 10000],
      );
      final important = plan.goals[1]!;
      expect(important.isOnTrack, isTrue);
      expect(important.isFrontLoaded, isTrue);
      expect(important.fundedMonth, const YearMonth(2027, 2));
      expect(plan.goals[2]!.isOnTrack, isFalse);
      expect(plan.goals[2]!.shortfallAtTargetMinor, 30000);
    });

    test('reports the shortfall of a goal that cannot be reached in time', () {
      final plan = planSavings(
        goals: [goal(id: 1, target: 100000, by: const YearMonth(2027, 2))],
        from: january,
        potentials: [20000, 20000, 20000, 20000, 20000],
      );
      final result = plan.goals[1]!;
      expect(result.isOnTrack, isFalse);
      expect(result.shortfallAtTargetMinor, 60000);
      // Keeps saving after the deadline until the goal is reached.
      expect(result.fundedMonth, const YearMonth(2027, 5));
    });

    test('funds goals by priority, then by deadline', () {
      final plan = planSavings(
        goals: [
          goal(id: 1, target: 60000, by: const YearMonth(2027, 2), priority: 1),
          goal(id: 2, target: 60000, by: const YearMonth(2027, 2)),
        ],
        from: january,
        potentials: [30000, 30000],
      );
      expect(plan.goals[2]!.isOnTrack, isTrue);
      expect(plan.goals[1]!.isOnTrack, isFalse);
      expect(plan.goals[1]!.contributions, isEmpty);
    });

    test('holds money back for an expensive month ahead', () {
      final plan = planSavings(
        goals: [goal(id: 1, target: 90000, by: const YearMonth(2027, 3))],
        from: january,
        // March costs 400 more than it brings in.
        potentials: [50000, 50000, -40000, 50000, 50000],
      );
      // February has to end with 400 on hand; January's surplus is free
      // because February itself brings in enough.
      expect(plan.reserves, [0, 40000, 0, 0, 0]);
      // The balance never goes below zero.
      expect(plan.balances, everyElement(greaterThanOrEqualTo(0)));
      final result = plan.goals[1]!;
      expect(result.contributions[january], lessThanOrEqualTo(50000));
      expect(
        result.contributions.values.reduce((a, b) => a + b),
        lessThanOrEqualTo(90000),
      );
    });

    test('does not save while the plan is in the red', () {
      final plan = planSavings(
        goals: [goal(id: 1, target: 10000, by: const YearMonth(2027, 2))],
        from: january,
        potentials: [-5000, 2000, 30000],
      );
      expect(plan.goals[1]!.contributions.keys, [const YearMonth(2027, 3)]);
      expect(plan.goals[1]!.isOnTrack, isFalse);
    });

    test('ignores reached and archived goals', () {
      final plan = planSavings(
        goals: [
          goal(id: 1, target: 1000, saved: 1000, by: january),
          goal(id: 2, target: 1000, by: january).copyWith(isArchived: true),
        ],
        from: january,
        potentials: [5000],
      );
      expect(plan.goals, isEmpty);
    });

    test('a deadline that has already passed counts as missed', () {
      final plan = planSavings(
        goals: [goal(id: 1, target: 10000, by: const YearMonth(2026, 12))],
        from: january,
        potentials: [50000],
      );
      expect(plan.goals[1]!.isOnTrack, isFalse);
      expect(plan.goals[1]!.fundedMonth, january);
    });
  });

  group('buildForecast', () {
    const groceries = Category(
      id: 1,
      name: 'Groceries',
      kind: CategoryKind.expense,
    );
    const bakery = Category(
      id: 2,
      name: 'Bakery',
      kind: CategoryKind.expense,
      parentId: 1,
    );
    const housing = Category(
      id: 3,
      name: 'Housing',
      kind: CategoryKind.expense,
    );
    final categories = CategoryTree([groceries, bakery, housing]);

    final salary = item(
      amount: 300000,
      kind: PlannedKind.income,
      start: DateTime(2027, 1, 28),
    );
    final rent = item(id: 2, amount: 100000, categoryId: 3);
    final insurance = item(
      id: 3,
      amount: 60000,
      unit: RecurrenceUnit.year,
      start: DateTime(2027, 3, 10),
    );
    const food = Budget(
      id: 1,
      name: 'Food',
      amountMinor: 50000,
      startMonth: january,
      categoryIds: {1},
    );

    Forecast forecast({
      List<PlannedItem>? items,
      List<Budget> budgets = const [food],
      List<SavingsGoal> goals = const [],
      int months = 12,
    }) => buildForecast(
      from: january,
      monthCount: months,
      items: items ?? [salary, rent, insurance],
      budgets: budgets,
      goals: goals,
      categories: categories,
    );

    test('a month adds up income, fixed costs and budgets', () {
      final month = forecast().months.first;
      expect(month.incomeMinor, 300000);
      expect(month.fixedExpensesMinor, 100000);
      expect(month.budgetedMinor, 50000);
      expect(month.savingsPotentialMinor, 150000);
      expect(month.freeMinor, 150000);
    });

    test('irregular payments show up in the month they fall due', () {
      final result = forecast();
      final march = result.forMonth(const YearMonth(2027, 3))!;
      expect(march.fixedExpensesMinor, 160000);
      expect(march.savingsPotentialMinor, 90000);
      expect(march.fixedExpenses.map((o) => o.item.id), [2, 3]);
    });

    test('the year total is the yearly plus', () {
      final year = forecast().years.single;
      expect(year.year, 2027);
      expect(year.incomeMinor, 12 * 300000);
      expect(year.savingsPotentialMinor, 12 * 150000 - 60000);
    });

    test('planned payments in a budgeted category are part of the budget', () {
      final bread = item(id: 4, amount: 8000, categoryId: 2);
      final month = forecast(items: [salary, rent, bread]).months.first;
      // Counted inside the 500 budget, not on top of it.
      expect(month.fixedExpensesMinor, 100000);
      expect(month.budgetedMinor, 50000);
      expect(month.budgets.single.plannedMinor, 8000);
      expect(month.savingsPotentialMinor, 150000);
    });

    test('a budget grows when its planned payments exceed it', () {
      final feast = item(id: 4, amount: 70000, categoryId: 1);
      final month = forecast(items: [salary, feast]).months.first;
      expect(month.budgets.single.isExceededByPlan, isTrue);
      expect(month.budgetedMinor, 70000);
    });

    test('budgets only count in the months they are valid', () {
      final limited = food.copyWith(endMonth: () => const YearMonth(2027, 2));
      final result = forecast(budgets: [limited]);
      expect(result.months[1].budgetedMinor, 50000);
      expect(result.months[2].budgetedMinor, 0);
    });

    test('goal contributions reduce what is free, not the potential', () {
      const vacation = SavingsGoal(
        id: 1,
        name: 'Vacation',
        targetMinor: 120000,
        targetMonth: YearMonth(2027, 6),
      );
      final result = forecast(goals: [vacation]);
      final month = result.months.first;
      expect(month.goalContributions, {1: 20000});
      expect(month.savingsPotentialMinor, 150000);
      expect(month.freeMinor, 130000);
      expect(result.goalPlans[1]!.isOnTrack, isTrue);
      expect(result.months[6].goalContributions, isEmpty);
      expect(result.years.single.goalContributionsMinor, 120000);
    });

    test('the balance accumulates what stays free', () {
      final result = forecast(months: 3);
      expect(result.months.map((m) => m.balanceMinor), [
        150000,
        300000,
        390000,
      ]);
    });
  });
}
