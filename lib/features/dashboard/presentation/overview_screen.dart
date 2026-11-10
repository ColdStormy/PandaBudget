import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/panda_logo.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/time/clock.dart';
import 'package:pandabudget/core/time/dates.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/accounts/presentation/account_providers.dart';
import 'package:pandabudget/features/analysis/domain/analysis.dart';
import 'package:pandabudget/features/analysis/presentation/budget_status_view.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/planning/domain/forecast.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/planning/presentation/planning_providers.dart';
import 'package:pandabudget/features/transactions/data/drift_transaction_repository.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';
import 'package:pandabudget/features/transactions/presentation/transaction_providers.dart';

/// How many transactions still have no category (capped at 100).
final uncategorizedCountProvider = StreamProvider<int>(
  (ref) => ref
      .watch(transactionRepositoryProvider)
      .watch(const TransactionFilter(uncategorizedOnly: true), limit: 100)
      .map((transactions) => transactions.length),
);

/// The current month at a glance: plan and reality side by side.
class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final month = ref.watch(currentMonthProvider);
    final today = dateOnly(ref.watch(clockProvider)());
    final tree = ref.watch(categoryTreeProvider);

    final balances = ref.watch(accountBalancesProvider).value ?? const [];
    final forecast = ref.watch(forecastProvider).value;
    final plannedItems = ref.watch(plannedItemsProvider).value ?? const [];
    final budgets = ref.watch(budgetsProvider).value ?? const [];
    final goals = (ref.watch(savingsGoalsProvider).value ?? const [])
        .where((goal) => !goal.isArchived)
        .toList();
    final transactions =
        ref
            .watch(transactionsInMonthsProvider((from: month, to: month)))
            .value ??
        const <LedgerTransaction>[];
    final uncategorized = ref.watch(uncategorizedCountProvider).value ?? 0;

    final summary = monthlySummaries(
      transactions,
      tree,
      from: month,
      to: month,
    ).single;
    final statuses = budgetStatuses(budgets, transactions, tree, month: month);
    final planMonth = forecast?.months.firstOrNull;
    final hasPlan = plannedItems.isNotEmpty || budgets.isNotEmpty;

    final upcoming = [
      for (final item in plannedItems)
        for (final date in item.occurrencesBetween(
          today,
          today.add(const Duration(days: 31)),
        ))
          PlannedOccurrence(item: item, date: date),
    ]..sort((a, b) => a.date.compareTo(b.date));

    final isFresh = balances.isEmpty || !hasPlan;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (MediaQuery.sizeOf(context).width < Breakpoints.wide) ...[
              const PandaLogo(size: 32),
              gapMd,
            ],
            Text(l10n.appTitle),
          ],
        ),
      ),
      body: PageBody(
        bottomPadding: Insets.xl,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: Insets.sm, bottom: Insets.md),
            child: Text(
              context.formatMonth(month),
              style: theme.textTheme.headlineSmall,
            ),
          ),
          if (isFresh) ...[
            _GettingStarted(
              hasAccount: balances.isNotEmpty,
              hasTransactions: transactions.isNotEmpty || uncategorized > 0,
              hasPlan: hasPlan,
            ),
            gapMd,
          ],
          if (uncategorized > 0) ...[
            _UncategorizedNotice(count: uncategorized),
            gapMd,
          ],
          AdaptiveColumns(
            children: [
              PandaCard(
                onTap: () => context.go(Routes.analysis),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardTitle(l10n.overviewActual, Icons.donut_large_outlined),
                    gapMd,
                    Figure(
                      label: l10n.net,
                      amountMinor: summary.netMinor,
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
                      ],
                    ),
                  ],
                ),
              ),
              PandaCard(
                onTap: () => context.go(Routes.planning),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardTitle(l10n.overviewPlan, Icons.event_note_outlined),
                    gapMd,
                    Figure(
                      label: l10n.savingsPotential,
                      amountMinor: planMonth?.savingsPotentialMinor ?? 0,
                      tone: AmountTone.signed,
                      showPlus: true,
                      large: true,
                    ),
                    gapMd,
                    Row(
                      children: [
                        Expanded(
                          child: Figure(
                            label: l10n.savingForGoals,
                            amountMinor: planMonth?.goalContributionsMinor ?? 0,
                          ),
                        ),
                        gapMd,
                        Expanded(
                          child: Figure(
                            label: l10n.freeAfterGoals,
                            amountMinor: planMonth?.freeMinor ?? 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (balances.isNotEmpty)
                PandaCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CardTitle(l10n.accounts, Icons.account_balance_outlined),
                      gapSm,
                      for (final balance in balances)
                        _Line(
                          leading: ColorAvatar(
                            color: Color(balance.account.colorValue),
                            icon: accountKindIcon(balance.account.kind),
                            size: 32,
                          ),
                          title: balance.account.name,
                          amountMinor: balance.balanceMinor,
                        ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: Insets.sm),
                        child: Divider(),
                      ),
                      _Line(
                        title: l10n.total,
                        amountMinor: balances.map((b) => b.balanceMinor).sum,
                        emphasised: true,
                      ),
                    ],
                  ),
                ),
              if (upcoming.isNotEmpty)
                PandaCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CardTitle(l10n.overviewUpcoming, Icons.schedule),
                      gapSm,
                      for (final occurrence in upcoming.take(6))
                        _Line(
                          title: occurrence.item.name,
                          subtitle: context.formatShortDate(occurrence.date),
                          amountMinor: occurrence.signedAmountMinor,
                          tone: AmountTone.incomeOnly,
                          showPlus: occurrence.item.kind == PlannedKind.income,
                        ),
                    ],
                  ),
                ),
              if (statuses.isNotEmpty)
                PandaCard(
                  onTap: () => context.go(Routes.analysis),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CardTitle(l10n.tabBudgets, Icons.pie_chart_outline),
                      for (final status in statuses.take(4)) ...[
                        gapMd,
                        BudgetStatusView(status: status),
                      ],
                    ],
                  ),
                ),
              if (goals.isNotEmpty)
                PandaCard(
                  onTap: () => context.go(Routes.planning),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CardTitle(l10n.tabGoals, Icons.flag_outlined),
                      for (final goal in goals.take(4)) ...[
                        gapMd,
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                goal.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${(goal.progress * 100).round()} %',
                              style: theme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                        gapSm,
                        UsageBar(
                          value: goal.progress,
                          color: Color(goal.colorValue),
                        ),
                        if (forecast?.goalPlans[goal.id] case final plan?
                            when !plan.isOnTrack) ...[
                          gapXs,
                          Text(
                            l10n.goalBehind,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: context.financeColors.warning,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.title, this.icon);

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        gapSm,
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.title,
    required this.amountMinor,
    this.leading,
    this.subtitle,
    this.tone = AmountTone.plain,
    this.showPlus = false,
    this.emphasised = false,
  });

  final String title;
  final int amountMinor;
  final Widget? leading;
  final String? subtitle;
  final AmountTone tone;
  final bool showPlus;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasised
        ? theme.textTheme.titleMedium
        : theme.textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (leading != null) ...[leading!, gapMd],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          gapMd,
          AmountText(amountMinor, tone: tone, showPlus: showPlus, style: style),
        ],
      ),
    );
  }
}

class _UncategorizedNotice extends ConsumerWidget {
  const _UncategorizedNotice({required this.count});

  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return PandaCard(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.md,
        vertical: Insets.sm,
      ),
      onTap: () {
        ref
            .read(transactionFilterProvider.notifier)
            .set(const TransactionFilter(uncategorizedOnly: true));
        context.go(Routes.transactions);
      },
      child: Row(
        children: [
          Icon(Icons.label_off_outlined, color: theme.colorScheme.primary),
          gapMd,
          Expanded(
            child: Text(
              count >= 100
                  ? l10n.uncategorizedMany
                  : l10n.uncategorizedCount(count),
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _GettingStarted extends StatelessWidget {
  const _GettingStarted({
    required this.hasAccount,
    required this.hasTransactions,
    required this.hasPlan,
  });

  final bool hasAccount;
  final bool hasTransactions;
  final bool hasPlan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    Widget step(bool done, String title, String subtitle, VoidCallback onTap) =>
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? theme.colorScheme.primary : theme.colorScheme.outline,
          ),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        );

    return PandaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.welcomeTitle, style: theme.textTheme.titleLarge),
          gapXs,
          Text(
            l10n.welcomeMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          gapMd,
          step(
            hasAccount,
            l10n.stepAccountTitle,
            l10n.stepAccountMessage,
            () => context.push(Routes.accountEdit()),
          ),
          step(
            hasTransactions,
            l10n.stepImportTitle,
            l10n.stepImportMessage,
            () => context.push(Routes.importWizard),
          ),
          step(
            hasPlan,
            l10n.stepPlanTitle,
            l10n.stepPlanMessage,
            () => context.push(Routes.plannedItemEdit()),
          ),
        ],
      ),
    );
  }
}
