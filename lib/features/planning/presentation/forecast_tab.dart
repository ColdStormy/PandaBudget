import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/app_text.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/core/widgets/charts.dart';
import 'package:pandabudget/core/widgets/page_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/planning/domain/forecast.dart';
import 'package:pandabudget/features/planning/presentation/planning_providers.dart';

class ForecastTab extends ConsumerStatefulWidget {
  const ForecastTab({required this.onPlanFirstItem, super.key});

  /// Called from the empty state to lead the user to the planning tab.
  final VoidCallback onPlanFirstItem;

  @override
  ConsumerState<ForecastTab> createState() => _ForecastTabState();
}

class _ForecastTabState extends ConsumerState<ForecastTab> {
  YearMonth? _selected;
  int? _selectedYear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AsyncView(
      value: ref.watch(forecastProvider),
      builder: (forecast) {
        final hasPlan = forecast.months.any(
          (m) =>
              m.incomes.isNotEmpty ||
              m.fixedExpenses.isNotEmpty ||
              m.budgets.isNotEmpty,
        );
        if (!hasPlan) {
          return EmptyState(
            icon: Icons.event_note_outlined,
            title: l10n.forecastEmptyTitle,
            message: l10n.forecastEmptyMessage,
            action: FilledButton.icon(
              onPressed: () => context.push(Routes.plannedItemEdit()),
              icon: const Icon(Icons.add),
              label: Text(l10n.addPlannedItem),
            ),
          );
        }

        final months = [for (final m in forecast.months) m.month];
        final selected = months.contains(_selected) ? _selected! : months.first;
        final month = forecast.forMonth(selected)!;
        final years = forecast.years;
        final yearNumbers = [for (final y in years) y.year];
        final selectedYear = yearNumbers.contains(_selectedYear)
            ? _selectedYear!
            : yearNumbers.first;
        final year = years.firstWhere((y) => y.year == selectedYear);
        final finance = context.financeColors;

        return PageBody(
          children: [
            SectionHeader(l10n.forecastChartTitle),
            Padding(
              padding: const EdgeInsets.only(top: Insets.sm),
              child: MonthBarChart(
                months: months,
                selected: selected,
                onSelected: (value) => setState(() => _selected = value),
                negativeColor: finance.expense,
                series: [
                  BarSeries(
                    label: l10n.savingsPotential,
                    color: finance.income,
                    values: [
                      for (final m in forecast.months) m.savingsPotentialMinor,
                    ],
                  ),
                ],
              ),
            ),
            gapLg,
            Center(
              child: MonthSwitcher(
                month: selected,
                min: months.first,
                max: months.last,
                onChanged: (value) => setState(() => _selected = value),
              ),
            ),
            gapSm,
            _MonthDetail(month: month, forecast: forecast),
            gapLg,
            SectionHeader(l10n.forecastYearTitle),
            Center(
              child: YearSwitcher(
                year: selectedYear,
                min: yearNumbers.first,
                max: yearNumbers.last,
                onChanged: (value) => setState(() => _selectedYear = value),
              ),
            ),
            gapSm,
            _YearBlock(year: year),
          ],
        );
      },
    );
  }
}

/// Balance, income and expenses of one calendar year of the forecast.
class _YearBlock extends StatelessWidget {
  const _YearBlock({required this.year});

  final YearForecast year;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final first = year.months.first.month;
    final last = year.months.last.month;
    final isFullYear = year.months.length == 12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isFullYear) ...[
          Caption(
            '${context.formatMonthName(first)} – '
            '${context.formatMonthName(last)}',
          ),
          gapMd,
        ],
        Figure(
          label: l10n.yearlyPlus,
          amountMinor: year.savingsPotentialMinor,
          tone: AmountTone.signed,
          showPlus: true,
          large: true,
        ),
        gapMd,
        Row(
          children: [
            Expanded(
              child: Figure(label: l10n.income, amountMinor: year.incomeMinor),
            ),
            gapMd,
            Expanded(
              child: Figure(
                label: l10n.expenses,
                amountMinor: year.expensesMinor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Everything planned for the selected month, grouped by kind.
class _MonthDetail extends StatelessWidget {
  const _MonthDetail({required this.month, required this.forecast});

  final MonthForecast month;
  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    Widget row(
      String label,
      int amount, {
      String? detail,
      bool minus = false,
    }) => PandaListRow(
      indent: true,
      title: label,
      subtitle: detail,
      amountMinor: minus ? -amount : amount,
    );

    Widget group(
      String title,
      int total,
      List<Widget> rows, {
      bool minus = false,
    }) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title,
          trailing: AmountText(minus ? -total : total, style: AppText.value),
        ),
        ...rows,
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Figure(
          label: l10n.savingsPotentialIn(context.formatMonth(month.month)),
          amountMinor: month.savingsPotentialMinor,
          tone: AmountTone.signed,
          showPlus: true,
          large: true,
        ),
        group(l10n.income, month.incomeMinor, [
          for (final o in month.incomes)
            row(
              o.item.name,
              o.item.amountMinor,
              detail: context.formatShortDate(o.date),
            ),
        ]),
        group(l10n.fixedPayments, month.fixedExpensesMinor, minus: true, [
          for (final o in month.fixedExpenses)
            row(
              o.item.name,
              o.item.amountMinor,
              detail: context.formatShortDate(o.date),
              minus: true,
            ),
        ]),
        if (month.budgets.isNotEmpty)
          group(l10n.tabBudgets, month.budgetedMinor, minus: true, [
            for (final allocation in month.budgets)
              row(
                allocation.budget.name,
                allocation.reservedMinor,
                detail: allocation.isExceededByPlan
                    ? l10n.budgetExceededByPlan
                    : null,
                minus: true,
              ),
          ]),
        if (month.goalContributions.isNotEmpty) ...[
          group(l10n.savingForGoals, month.goalContributionsMinor, [
            for (final MapEntry(key: goalId, value: amount)
                in month.goalContributions.entries)
              row(forecast.goalPlans[goalId]?.goal.name ?? '', amount),
          ]),
          SectionHeader(
            l10n.freeAfterGoals,
            trailing: AmountText(
              month.freeMinor,
              tone: AmountTone.signed,
              style: AppText.value,
            ),
          ),
        ],
        if (month.reserveMinor > 0) ...[
          gapLg,
          Callout(
            icon: Icons.shield_outlined,
            color: context.financeColors.warning,
            child: _ReserveText(amountMinor: month.reserveMinor),
          ),
        ],
      ],
    );
  }
}

class _ReserveText extends ConsumerWidget {
  const _ReserveText({required this.amountMinor});

  final int amountMinor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rendered through AmountText's formatter to match the rest of the UI.
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('${context.l10n.reserveHint} '),
        AmountText(
          amountMinor,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
