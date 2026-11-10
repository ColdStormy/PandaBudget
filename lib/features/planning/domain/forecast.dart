import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/planning/domain/budget.dart';
import 'package:pandabudget/features/planning/domain/goal_planner.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/planning/domain/savings_goal.dart';

/// One due date of a planned item.
@immutable
class PlannedOccurrence {
  const PlannedOccurrence({required this.item, required this.date});

  final PlannedItem item;
  final DateTime date;

  int get signedAmountMinor => item.signedAmountMinor;
}

/// How much a month's plan reserves for one budget.
@immutable
class BudgetAllocation {
  const BudgetAllocation({required this.budget, required this.planned});

  final Budget budget;

  /// Planned payments whose category belongs to this budget. They are part
  /// of the budget, not an addition to it.
  final List<PlannedOccurrence> planned;

  int get plannedMinor => planned.map((o) => o.item.amountMinor).sum;

  /// What the month sets aside for this budget: its limit, or more if the
  /// planned payments alone already exceed it.
  int get reservedMinor =>
      plannedMinor > budget.amountMinor ? plannedMinor : budget.amountMinor;

  bool get isExceededByPlan => plannedMinor > budget.amountMinor;
}

/// The plan for a single month.
@immutable
class MonthForecast {
  const MonthForecast({
    required this.month,
    required this.incomes,
    required this.fixedExpenses,
    required this.budgets,
    required this.goalContributions,
    required this.reserveMinor,
    required this.balanceMinor,
  });

  final YearMonth month;

  /// Planned incomes due this month, by date.
  final List<PlannedOccurrence> incomes;

  /// Planned payments due this month that no budget covers, by date.
  final List<PlannedOccurrence> fixedExpenses;
  final List<BudgetAllocation> budgets;

  /// Goal id -> amount put towards the goal this month.
  final Map<int, int> goalContributions;

  /// Part of [balanceMinor] held back for more expensive months ahead.
  final int reserveMinor;

  /// Money not assigned to anything, accumulated from the first forecast
  /// month to the end of this one.
  final int balanceMinor;

  int get incomeMinor => incomes.map((o) => o.item.amountMinor).sum;

  int get fixedExpensesMinor =>
      fixedExpenses.map((o) => o.item.amountMinor).sum;

  int get budgetedMinor => budgets.map((b) => b.reservedMinor).sum;

  int get expensesMinor => fixedExpensesMinor + budgetedMinor;

  /// What the month leaves over after planned payments and budgets: the
  /// amount that can go into savings. Negative if the month costs more
  /// than it brings in.
  int get savingsPotentialMinor => incomeMinor - expensesMinor;

  int get goalContributionsMinor => goalContributions.values.sum;

  /// Savings potential that is not earmarked for a goal.
  int get freeMinor => savingsPotentialMinor - goalContributionsMinor;
}

/// Totals of a calendar year within the forecast.
@immutable
class YearForecast {
  const YearForecast({required this.year, required this.months});

  final int year;
  final List<MonthForecast> months;

  int get incomeMinor => months.map((m) => m.incomeMinor).sum;

  int get expensesMinor => months.map((m) => m.expensesMinor).sum;

  /// The year's surplus: what can be saved in total.
  int get savingsPotentialMinor =>
      months.map((m) => m.savingsPotentialMinor).sum;

  int get goalContributionsMinor =>
      months.map((m) => m.goalContributionsMinor).sum;
}

@immutable
class Forecast {
  const Forecast({required this.months, required this.goalPlans});

  final List<MonthForecast> months;

  /// Savings plans keyed by goal id.
  final Map<int, GoalPlan> goalPlans;

  MonthForecast? forMonth(YearMonth month) =>
      months.firstWhereOrNull((m) => m.month == month);

  List<YearForecast> get years => [
    for (final entry in groupBy(months, (m) => m.month.year).entries)
      YearForecast(year: entry.key, months: entry.value),
  ];
}

/// Projects the household's plan [monthCount] months ahead, starting with
/// [from].
///
/// For every month this collects the planned incomes and payments that fall
/// due, reserves the active budgets, and then lets [planSavings] spread
/// what is left over the savings goals.
Forecast buildForecast({
  required YearMonth from,
  required int monthCount,
  required List<PlannedItem> items,
  required List<Budget> budgets,
  required List<SavingsGoal> goals,
  required CategoryTree categories,
}) {
  final drafts = <_MonthDraft>[];
  for (var i = 0; i < monthCount; i++) {
    final month = from.addMonths(i);
    final occurrences = [
      for (final item in items)
        for (final date in item.occurrencesIn(month))
          PlannedOccurrence(item: item, date: date),
    ]..sort((a, b) => a.date.compareTo(b.date));

    final activeBudgets = budgets.where((b) => b.isActiveIn(month)).toList();
    final coverage = {
      for (final budget in activeBudgets)
        budget.id: {
          for (final id in budget.categoryIds)
            ...categories.withDescendants(id),
        },
    };

    final plannedByBudget = <int, List<PlannedOccurrence>>{};
    final fixed = <PlannedOccurrence>[];
    for (final occurrence in occurrences) {
      if (occurrence.item.kind != PlannedKind.expense) continue;
      final budget = activeBudgets.firstWhereOrNull(
        (b) => coverage[b.id]!.contains(occurrence.item.categoryId),
      );
      if (budget == null) {
        fixed.add(occurrence);
      } else {
        plannedByBudget.putIfAbsent(budget.id, () => []).add(occurrence);
      }
    }

    drafts.add(
      _MonthDraft(
        month: month,
        incomes: occurrences
            .where((o) => o.item.kind == PlannedKind.income)
            .toList(),
        fixedExpenses: fixed,
        budgets: [
          for (final budget in activeBudgets)
            BudgetAllocation(
              budget: budget,
              planned: plannedByBudget[budget.id] ?? const [],
            ),
        ],
      ),
    );
  }

  final plan = planSavings(
    goals: goals,
    from: from,
    potentials: [for (final draft in drafts) draft.potentialMinor],
  );

  return Forecast(
    goalPlans: plan.goals,
    months: [
      for (final (index, draft) in drafts.indexed)
        MonthForecast(
          month: draft.month,
          incomes: draft.incomes,
          fixedExpenses: draft.fixedExpenses,
          budgets: draft.budgets,
          goalContributions: {
            for (final goalPlan in plan.goals.values)
              goalPlan.goal.id: ?goalPlan.contributions[draft.month],
          },
          reserveMinor: plan.reserves[index],
          balanceMinor: plan.balances[index],
        ),
    ],
  );
}

class _MonthDraft {
  _MonthDraft({
    required this.month,
    required this.incomes,
    required this.fixedExpenses,
    required this.budgets,
  });

  final YearMonth month;
  final List<PlannedOccurrence> incomes;
  final List<PlannedOccurrence> fixedExpenses;
  final List<BudgetAllocation> budgets;

  int get potentialMinor =>
      incomes.map((o) => o.item.amountMinor).sum -
      fixedExpenses.map((o) => o.item.amountMinor).sum -
      budgets.map((b) => b.reservedMinor).sum;
}
