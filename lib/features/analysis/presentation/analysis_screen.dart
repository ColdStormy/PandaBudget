import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/core/widgets/charts.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/analysis/domain/analysis.dart';
import 'package:pandabudget/features/analysis/presentation/budget_status_view.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/planning/domain/forecast.dart';
import 'package:pandabudget/features/planning/presentation/planning_providers.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';
import 'package:pandabudget/features/transactions/presentation/transaction_providers.dart';

/// Past analysis: where the money of a month went.
class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  /// Months shown in the trend chart, ending with the selected month.
  static const _trendMonths = 12;

  YearMonth? _selected;
  var _direction = FlowDirection.expense;

  void _showTransactions(YearMonth month, CategoryTree tree, int? categoryId) {
    ref
        .read(transactionFilterProvider.notifier)
        .set(
          TransactionFilter(
            from: month.firstDay,
            to: month.lastDay,
            uncategorizedOnly: categoryId == null,
            categoryIds: categoryId == null
                ? null
                : {categoryId, ...tree.withDescendants(categoryId)},
          ),
        );
    context.go(Routes.transactions);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final finance = context.financeColors;
    final currentMonth = ref.watch(currentMonthProvider);
    final month = _selected ?? currentMonth;
    final from = month.addMonths(-(_trendMonths - 1));
    final tree = ref.watch(categoryTreeProvider);
    final budgets = ref.watch(budgetsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navAnalysis),
        actions: [
          MonthSwitcher(
            month: month,
            max: currentMonth,
            onChanged: (value) => setState(() => _selected = value),
          ),
          gapSm,
        ],
      ),
      body: AsyncView(
        value: ref.watch(transactionsInMonthsProvider((from: from, to: month))),
        builder: (transactions) {
          final inMonth = transactions
              .where((t) => month.contains(t.bookingDate))
              .toList();
          final summaries = monthlySummaries(
            transactions,
            tree,
            from: from,
            to: month,
          );
          final summary = summaries.last;
          final totals = totalsByCategory(inMonth, tree, direction: _direction);
          final statuses = budgetStatuses(budgets, inMonth, tree, month: month);

          return PageBody(
            bottomPadding: Insets.xl,
            children: [
              gapSm,
              PandaCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Figure(
                        label: l10n.income,
                        amountMinor: summary.incomeMinor,
                      ),
                    ),
                    gapMd,
                    Expanded(
                      child: Figure(
                        label: l10n.spent,
                        amountMinor: summary.expenseMinor,
                      ),
                    ),
                    gapMd,
                    Expanded(
                      child: Figure(
                        label: l10n.net,
                        amountMinor: summary.netMinor,
                        tone: AmountTone.signed,
                        showPlus: true,
                      ),
                    ),
                  ],
                ),
              ),
              SectionHeader(
                l10n.byCategory,
                trailing: SegmentedButton<FlowDirection>(
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                  ),
                  segments: [
                    ButtonSegment(
                      value: FlowDirection.expense,
                      label: Text(l10n.spending),
                    ),
                    ButtonSegment(
                      value: FlowDirection.income,
                      label: Text(l10n.income),
                    ),
                  ],
                  selected: {_direction},
                  showSelectedIcon: false,
                  onSelectionChanged: (selection) =>
                      setState(() => _direction = selection.first),
                ),
              ),
              PandaCard(
                child: totals.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Insets.lg,
                        ),
                        child: Center(
                          child: Text(
                            l10n.noTransactionsInMonth,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : _Breakdown(
                        totals: totals,
                        tree: tree,
                        onCategoryTap: (id) =>
                            _showTransactions(month, tree, id),
                      ),
              ),
              if (ref.watch(monthPlanProvider(month)) case final plan?
                  when plan.incomeMinor != 0 || plan.expensesMinor != 0) ...[
                SectionHeader(l10n.planVsActual),
                _PlanComparison(plan: plan, actual: summary),
              ],
              if (statuses.isNotEmpty) ...[
                SectionHeader(l10n.tabBudgets),
                AdaptiveColumns(
                  children: [
                    for (final status in statuses)
                      PandaCard(child: BudgetStatusView(status: status)),
                  ],
                ),
              ],
              SectionHeader(
                l10n.trendTitle,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LegendDot(color: finance.income, label: l10n.income),
                    gapMd,
                    LegendDot(
                      color: theme.colorScheme.secondary,
                      label: l10n.spent,
                    ),
                  ],
                ),
              ),
              PandaCard(
                padding: const EdgeInsets.fromLTRB(
                  Insets.md,
                  Insets.lg,
                  Insets.lg,
                  Insets.md,
                ),
                child: MonthBarChart(
                  months: [for (final s in summaries) s.month],
                  selected: month,
                  series: [
                    BarSeries(
                      label: l10n.income,
                      color: finance.income,
                      values: [for (final s in summaries) s.incomeMinor],
                    ),
                    BarSeries(
                      label: l10n.spent,
                      color: theme.colorScheme.secondary,
                      values: [for (final s in summaries) s.expenseMinor],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Planned and actual income, spending and balance of a month side by
/// side, with the difference.
class _PlanComparison extends StatelessWidget {
  const _PlanComparison({required this.plan, required this.actual});

  final MonthForecast plan;
  final MonthSummary actual;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final muted = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    // [higherIsBetter] decides whether a positive difference is good news.
    TableRow row(
      String label,
      int planned,
      int actualValue, {
      required bool higherIsBetter,
    }) {
      final difference = actualValue - planned;
      return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.sm),
            child: Text(label),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AmountText(planned, style: theme.textTheme.bodyMedium),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AmountText(actualValue, style: theme.textTheme.titleSmall),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AmountText(
              higherIsBetter ? difference : -difference,
              tone: AmountTone.signed,
              showPlus: true,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      );
    }

    return PandaCard(
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              const SizedBox.shrink(),
              for (final header in [l10n.planned, l10n.actual, l10n.difference])
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(header, style: muted),
                ),
            ],
          ),
          row(
            l10n.income,
            plan.incomeMinor,
            actual.incomeMinor,
            higherIsBetter: true,
          ),
          row(
            l10n.spending,
            plan.expensesMinor,
            actual.expenseMinor,
            higherIsBetter: false,
          ),
          row(
            l10n.net,
            plan.savingsPotentialMinor,
            actual.netMinor,
            higherIsBetter: true,
          ),
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({
    required this.totals,
    required this.tree,
    required this.onCategoryTap,
  });

  final List<CategoryTotal> totals;
  final CategoryTree tree;
  final ValueChanged<int?> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final sum = totals.fold(
      0,
      (a, t) => a + (t.amountMinor > 0 ? t.amountMinor : 0),
    );
    Color colorOf(CategoryTotal total) => total.categoryId == null
        ? theme.colorScheme.outline
        : Color(tree[total.categoryId]!.colorValue);

    final chart = DonutChart(
      slices: [
        for (final total in totals)
          DonutSlice(value: total.amountMinor, color: colorOf(total)),
      ],
      center: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Caption(l10n.total),
          AmountText(sum, style: theme.textTheme.titleLarge),
        ],
      ),
    );

    final list = Column(
      children: [
        for (final total in totals) ...[
          _CategoryRow(
            avatar: CategoryAvatar(tree[total.categoryId], size: 36),
            name: tree[total.categoryId]?.name ?? l10n.uncategorized,
            amountMinor: total.amountMinor,
            share: sum <= 0 ? 0 : total.amountMinor / sum,
            color: colorOf(total),
            onTap: () => onCategoryTap(total.categoryId),
          ),
          for (final child in total.children)
            if (child.categoryId != total.categoryId)
              _CategoryRow(
                name: tree[child.categoryId]?.name ?? '',
                amountMinor: child.amountMinor,
                onTap: () => onCategoryTap(child.categoryId),
              ),
        ],
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth >= 620
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: Insets.xl,
                    top: Insets.sm,
                  ),
                  child: chart,
                ),
                Expanded(child: list),
              ],
            )
          : Column(children: [chart, gapLg, list]),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.name,
    required this.amountMinor,
    required this.onTap,
    this.avatar,
    this.share,
    this.color,
  });

  final String name;
  final int amountMinor;
  final VoidCallback onTap;

  /// Set for top-level categories; sub-categories render as indented lines.
  final Widget? avatar;
  final double? share;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isChild = avatar == null;
    final muted = theme.colorScheme.onSurfaceVariant;

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isChild ? Insets.xs : Insets.sm,
          horizontal: Insets.xs,
        ),
        child: Row(
          children: [
            if (isChild) const SizedBox(width: 36 + Insets.md) else avatar!,
            if (!isChild) gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: isChild
                        ? theme.textTheme.bodyMedium?.copyWith(color: muted)
                        : theme.textTheme.bodyLarge,
                  ),
                  if (share != null) ...[
                    gapXs,
                    LinearProgressIndicator(
                      value: share!.clamp(0, 1).toDouble(),
                      minHeight: 4,
                      color: color,
                    ),
                  ],
                ],
              ),
            ),
            gapMd,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AmountText(
                  amountMinor,
                  style: isChild
                      ? theme.textTheme.bodyMedium?.copyWith(color: muted)
                      : theme.textTheme.titleSmall,
                ),
                if (share != null)
                  Text(
                    '${(share! * 100).round()} %',
                    style: theme.textTheme.labelSmall?.copyWith(color: muted),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
