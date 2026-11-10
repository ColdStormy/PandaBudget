import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/time/clock.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/planning/data/drift_planning_repositories.dart';
import 'package:pandabudget/features/planning/domain/budget.dart';
import 'package:pandabudget/features/planning/domain/forecast.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/planning/domain/savings_goal.dart';

final plannedItemsProvider = StreamProvider<List<PlannedItem>>(
  (ref) => ref.watch(plannedItemRepositoryProvider).watchAll(),
);

final budgetsProvider = StreamProvider<List<Budget>>(
  (ref) => ref.watch(budgetRepositoryProvider).watchAll(),
);

final savingsGoalsProvider = StreamProvider<List<SavingsGoal>>(
  (ref) => ref.watch(savingsGoalRepositoryProvider).watchAll(),
);

/// The month "today" falls in.
final currentMonthProvider = Provider<YearMonth>(
  (ref) => YearMonth.of(ref.watch(clockProvider)()),
);

/// How far ahead the forecast looks.
const int forecastMonths = 24;

/// The household's plan for the next [forecastMonths] months, starting
/// with the current month. Recomputed whenever any input changes.
final forecastProvider = Provider<AsyncValue<Forecast>>((ref) {
  final items = ref.watch(plannedItemsProvider);
  final budgets = ref.watch(budgetsProvider);
  final goals = ref.watch(savingsGoalsProvider);
  final categories = ref.watch(categoriesProvider);

  for (final input in [items, budgets, goals, categories]) {
    if (input.hasError) {
      return AsyncValue.error(input.error!, input.stackTrace!);
    }
    if (!input.hasValue) return const AsyncValue.loading();
  }
  return AsyncValue.data(
    buildForecast(
      from: ref.watch(currentMonthProvider),
      monthCount: forecastMonths,
      items: items.requireValue,
      budgets: budgets.requireValue,
      goals: goals.requireValue,
      categories: ref.watch(categoryTreeProvider),
    ),
  );
});

/// What the plan says about a single month, past or future. Null while
/// the plan is loading. Used to compare the plan with what really happened.
final monthPlanProvider = Provider.family<MonthForecast?, YearMonth>((
  ref,
  month,
) {
  final items = ref.watch(plannedItemsProvider).value;
  final budgets = ref.watch(budgetsProvider).value;
  if (items == null || budgets == null) return null;
  return buildForecast(
    from: month,
    monthCount: 1,
    items: items,
    budgets: budgets,
    goals: const [],
    categories: ref.watch(categoryTreeProvider),
  ).months.single;
});

/// "Monthly", "Every 3 months", "Once" ...
String recurrenceLabel(AppLocalizations l10n, PlannedItem item) =>
    switch (item.unit) {
      RecurrenceUnit.once => l10n.recurrenceOnce,
      RecurrenceUnit.week =>
        item.interval == 1
            ? l10n.recurrenceWeekly
            : l10n.recurrenceEveryNWeeks(item.interval),
      RecurrenceUnit.month => switch (item.interval) {
        1 => l10n.recurrenceMonthly,
        3 => l10n.recurrenceQuarterly,
        6 => l10n.recurrenceHalfYearly,
        _ => l10n.recurrenceEveryNMonths(item.interval),
      },
      RecurrenceUnit.year =>
        item.interval == 1
            ? l10n.recurrenceYearly
            : l10n.recurrenceEveryNYears(item.interval),
    };
