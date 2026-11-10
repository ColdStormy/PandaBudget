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
        final finance = context.financeColors;

        return PageBody(
          children: [
            gapSm,
            AdaptiveColumns(
              columns: forecast.years.length.clamp(1, 3),
              children: [
                for (final year in forecast.years) _YearCard(year: year),
              ],
            ),
            SectionHeader(l10n.forecastChartTitle),
            PandaCard(
              padding: const EdgeInsets.fromLTRB(
                Insets.md,
                Insets.lg,
                Insets.lg,
                Insets.md,
              ),
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
            _MonthCard(month: month, forecast: forecast),
          ],
        );
      },
    );
  }
}

class _YearCard extends StatelessWidget {
  const _YearCard({required this.year});

  final YearForecast year;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final first = year.months.first.month;
    final last = year.months.last.month;
    final isFullYear = year.months.length == 12;

    return PandaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${year.year}', style: theme.textTheme.titleMedium),
              gapSm,
              if (!isFullYear)
                Expanded(
                  child: Caption(
                    '${context.formatMonthName(first)} – '
                    '${context.formatMonthName(last)}',
                  ),
                ),
            ],
          ),
          gapMd,
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
                child: Figure(
                  label: l10n.income,
                  amountMinor: year.incomeMinor,
                ),
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
      ),
    );
  }
}

class _MonthCard extends StatelessWidget {
  const _MonthCard({required this.month, required this.forecast});

  final MonthForecast month;
  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    Widget line(
      String label,
      int amount, {
      String? detail,
      bool minus = false,
    }) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (detail != null)
                  Text(
                    detail,
                    style: muted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          gapMd,
          AmountText(
            minus ? -amount : amount,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );

    Widget group(
      String title,
      int total,
      List<Widget> lines, {
      bool minus = false,
    }) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
            AmountText(
              minus ? -total : total,
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
        if (lines.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: Insets.md, top: Insets.xs),
            child: DefaultTextStyle.merge(
              style: muted,
              child: Column(children: lines),
            ),
          ),
      ],
    );

    return PandaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Figure(
            label: l10n.savingsPotentialIn(context.formatMonth(month.month)),
            amountMinor: month.savingsPotentialMinor,
            tone: AmountTone.signed,
            showPlus: true,
            large: true,
          ),
          gapLg,
          group(l10n.income, month.incomeMinor, [
            for (final o in month.incomes)
              line(
                o.item.name,
                o.item.amountMinor,
                detail: context.formatShortDate(o.date),
              ),
          ]),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Insets.md),
            child: Divider(),
          ),
          group(l10n.fixedPayments, month.fixedExpensesMinor, minus: true, [
            for (final o in month.fixedExpenses)
              line(
                o.item.name,
                o.item.amountMinor,
                detail: context.formatShortDate(o.date),
                minus: true,
              ),
          ]),
          if (month.budgets.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Insets.md),
              child: Divider(),
            ),
            group(l10n.tabBudgets, month.budgetedMinor, minus: true, [
              for (final allocation in month.budgets)
                line(
                  allocation.budget.name,
                  allocation.reservedMinor,
                  detail: allocation.isExceededByPlan
                      ? l10n.budgetExceededByPlan
                      : null,
                  minus: true,
                ),
            ]),
          ],
          if (month.goalContributions.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Insets.md),
              child: Divider(),
            ),
            group(l10n.savingForGoals, month.goalContributionsMinor, [
              for (final MapEntry(key: goalId, value: amount)
                  in month.goalContributions.entries)
                line(forecast.goalPlans[goalId]?.goal.name ?? '', amount),
            ]),
            gapMd,
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.freeAfterGoals,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                AmountText(
                  month.freeMinor,
                  tone: AmountTone.signed,
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
          ],
          if (month.reserveMinor > 0) ...[
            gapLg,
            Container(
              padding: const EdgeInsets.all(Insets.md),
              decoration: BoxDecoration(
                color: context.financeColors.warning.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 20,
                    color: context.financeColors.warning,
                  ),
                  gapMd,
                  Expanded(
                    child: _ReserveText(amountMinor: month.reserveMinor),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
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
