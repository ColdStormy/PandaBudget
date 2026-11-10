import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/planning/domain/budget.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

/// Spending (or income) of one top-level category in a period.
@immutable
class CategoryTotal {
  const CategoryTotal({
    required this.categoryId,
    required this.amountMinor,
    required this.transactionCount,
    this.children = const [],
  });

  /// Null for uncategorised transactions.
  final int? categoryId;

  /// Positive total: money spent for expense breakdowns, money received for
  /// income breakdowns.
  final int amountMinor;
  final int transactionCount;

  /// Totals of the sub-categories (and of the category itself, if
  /// transactions are booked on it directly), largest first.
  final List<CategoryTotal> children;
}

/// Income and spending of one month.
@immutable
class MonthSummary {
  const MonthSummary({
    required this.month,
    required this.incomeMinor,
    required this.expenseMinor,
  });

  final YearMonth month;
  final int incomeMinor;

  /// Positive number: what was spent.
  final int expenseMinor;

  int get netMinor => incomeMinor - expenseMinor;
}

/// How a budget did in a month.
@immutable
class BudgetStatus {
  const BudgetStatus({required this.budget, required this.spentMinor});

  final Budget budget;
  final int spentMinor;

  int get limitMinor => budget.amountMinor;

  /// Negative when overspent.
  int get remainingMinor => limitMinor - spentMinor;

  bool get isOverspent => spentMinor > limitMinor;

  /// Share of the limit used; above 1 when overspent.
  double get ratio => limitMinor <= 0
      ? (spentMinor > 0 ? double.infinity : 0)
      : spentMinor / limitMinor;
}

enum FlowDirection { income, expense }

/// Whether [transaction] counts as income, as spending, or not at all
/// (transfers between own accounts).
///
/// The category decides where it has one: a refund booked on an expense
/// category reduces spending instead of inflating income. Uncategorised
/// transactions go by their sign.
FlowDirection? flowOf(LedgerTransaction transaction, CategoryTree categories) {
  final category = categories[transaction.categoryId];
  return switch (category?.kind) {
    CategoryKind.transfer => null,
    CategoryKind.expense => FlowDirection.expense,
    CategoryKind.income => FlowDirection.income,
    null =>
      transaction.amountMinor < 0
          ? FlowDirection.expense
          : FlowDirection.income,
  };
}

/// Totals per top-level category for one [direction], largest first, each
/// with a breakdown into sub-categories.
List<CategoryTotal> totalsByCategory(
  Iterable<LedgerTransaction> transactions,
  CategoryTree categories, {
  FlowDirection direction = FlowDirection.expense,
}) {
  final sign = direction == FlowDirection.expense ? -1 : 1;
  final amounts = <int?, int>{};
  final counts = <int?, int>{};
  for (final transaction in transactions) {
    if (flowOf(transaction, categories) != direction) continue;
    final id = categories[transaction.categoryId]?.id;
    amounts[id] = (amounts[id] ?? 0) + sign * transaction.amountMinor;
    counts[id] = (counts[id] ?? 0) + 1;
  }

  final byRoot = groupBy(
    amounts.keys,
    (id) => id == null ? null : categories.rootIdOf(id),
  );
  final totals = [
    for (final MapEntry(key: rootId, value: ids) in byRoot.entries)
      CategoryTotal(
        categoryId: rootId,
        amountMinor: ids.map((id) => amounts[id]!).sum,
        transactionCount: ids.map((id) => counts[id]!).sum,
        children: ids.length == 1 && ids.single == rootId
            ? const []
            : (ids
                  .map(
                    (id) => CategoryTotal(
                      categoryId: id,
                      amountMinor: amounts[id]!,
                      transactionCount: counts[id]!,
                    ),
                  )
                  .toList()
                ..sort((a, b) => b.amountMinor.compareTo(a.amountMinor))),
      ),
  ]..sort((a, b) => b.amountMinor.compareTo(a.amountMinor));
  return totals;
}

/// Income and spending for every month from [from] to [to], including
/// months without transactions.
List<MonthSummary> monthlySummaries(
  Iterable<LedgerTransaction> transactions,
  CategoryTree categories, {
  required YearMonth from,
  required YearMonth to,
}) {
  final income = <YearMonth, int>{};
  final expense = <YearMonth, int>{};
  for (final transaction in transactions) {
    final month = YearMonth.of(transaction.bookingDate);
    switch (flowOf(transaction, categories)) {
      case FlowDirection.income:
        income[month] = (income[month] ?? 0) + transaction.amountMinor;
      case FlowDirection.expense:
        expense[month] = (expense[month] ?? 0) - transaction.amountMinor;
      case null:
    }
  }
  return [
    for (var month = from; !month.isAfter(to); month = month.next)
      MonthSummary(
        month: month,
        incomeMinor: income[month] ?? 0,
        expenseMinor: expense[month] ?? 0,
      ),
  ];
}

/// What was spent against each budget that is active in [month].
///
/// [transactions] may span more than the month; only those booked in
/// [month] are counted. Refunds in a budget's categories reduce what was
/// spent.
List<BudgetStatus> budgetStatuses(
  Iterable<Budget> budgets,
  Iterable<LedgerTransaction> transactions,
  CategoryTree categories, {
  required YearMonth month,
}) {
  final inMonth = transactions
      .where((t) => month.contains(t.bookingDate))
      .toList();
  return [
    for (final budget in budgets.where((b) => b.isActiveIn(month)))
      () {
        final covered = {
          for (final id in budget.categoryIds)
            ...categories.withDescendants(id),
        };
        final spent = inMonth
            .where((t) => covered.contains(t.categoryId))
            .map((t) => -t.amountMinor)
            .sum;
        return BudgetStatus(budget: budget, spentMinor: spent < 0 ? 0 : spent);
      }(),
  ];
}
