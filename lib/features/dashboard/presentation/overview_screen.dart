import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/panda_logo.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/app_text.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/time/clock.dart';
import 'package:pandabudget/core/time/dates.dart';
import 'package:pandabudget/core/widgets/page_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';
import 'package:pandabudget/features/accounts/presentation/account_providers.dart';
import 'package:pandabudget/features/analysis/domain/analysis.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/planning/domain/forecast.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/planning/presentation/budget_status_row.dart';
import 'package:pandabudget/features/planning/presentation/planning_providers.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';
import 'package:pandabudget/features/transactions/presentation/transaction_providers.dart';

/// The current month at a glance: plan and reality side by side.
class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
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

    final upcoming = plannedOccurrences(
      plannedItems,
      today,
      today.add(const Duration(days: 31)),
    );

    final isFresh = balances.isEmpty || !hasPlan;

    final isWide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;

    final header = InkWell(
      onTap: () => context.go(Routes.analysis),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: context.formatMonth(month),
            leading: isWide ? null : const PandaLogo(size: 32),
          ),
          gapSm,
          HeadlineFigures(
            caption: l10n.overviewActual,
            netMinor: summary.netMinor,
            incomeLabel: l10n.income,
            incomeMinor: summary.incomeMinor,
            expenseLabel: l10n.spent,
            expenseMinor: summary.expenseMinor,
          ),
        ],
      ),
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: PageBody(
          bottomPadding: Insets.xl,
          children: [
            Align(alignment: Alignment.centerLeft, child: header),
            if (isFresh) ...[
              gapLg,
              _GettingStarted(
                hasAccount: balances.isNotEmpty,
                hasTransactions: transactions.isNotEmpty || uncategorized > 0,
                hasPlan: hasPlan,
              ),
            ],
            if (uncategorized > 0) ...[
              gapMd,
              ActionLink(
                icon: Icons.label_off_outlined,
                label: uncategorized >= 100
                    ? l10n.uncategorizedMany
                    : l10n.uncategorizedCount(uncategorized),
                onTap: () {
                  ref
                      .read(transactionFilterProvider.notifier)
                      .set(const TransactionFilter(uncategorizedOnly: true));
                  context.go(Routes.transactions);
                },
              ),
            ],
            AdaptiveColumns(
              spacing: Insets.lg,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      l10n.overviewPlan,
                      onTap: () => context.go(Routes.planning),
                    ),
                    Figure(
                      label: l10n.savingsPotential,
                      amountMinor: planMonth?.savingsPotentialMinor ?? 0,
                      tone: AmountTone.signed,
                      showPlus: true,
                      large: true,
                    ),
                    gapMd,
                    FigurePair(
                      firstLabel: l10n.savingForGoals,
                      firstMinor: planMonth?.goalContributionsMinor ?? 0,
                      secondLabel: l10n.freeAfterGoals,
                      secondMinor: planMonth?.freeMinor ?? 0,
                    ),
                  ],
                ),
                if (balances.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        l10n.accounts,
                        trailing: AmountText(
                          balances.map((b) => b.balanceMinor).sum,
                          style: AppText.value,
                        ),
                      ),
                      _AccountGrid(balances),
                    ],
                  ),
                if (upcoming.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(l10n.overviewUpcoming),
                      for (final occurrence in upcoming.take(6))
                        PandaListRow(
                          title: occurrence.item.name,
                          subtitle: context.formatShortDate(occurrence.date),
                          amountMinor: occurrence.signedAmountMinor,
                          tone: AmountTone.incomeOnly,
                          showPlus: occurrence.item.kind == PlannedKind.income,
                        ),
                    ],
                  ),
                if (statuses.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        l10n.tabBudgets,
                        onTap: () => context.go(Routes.analysis),
                      ),
                      for (final status in statuses.take(4))
                        BudgetStatusRow(status),
                    ],
                  ),
                if (goals.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        l10n.tabGoals,
                        onTap: () => context.go(Routes.planning),
                      ),
                      for (final goal in goals.take(4))
                        BudgetRow(
                          title: goal.name,
                          detail: '${(goal.progress * 100).round()} %',
                          progress: goal.progress,
                          color: Color(goal.colorValue),
                          note: forecast?.goalPlans[goal.id]?.isOnTrack == false
                              ? l10n.goalBehind
                              : null,
                          noteColor: context.financeColors.warning,
                        ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Accounts as tiles, two per row.
class _AccountGrid extends StatelessWidget {
  const _AccountGrid(this.balances);

  final List<AccountBalance> balances;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - Insets.sm) / 2;
        return Wrap(
          spacing: Insets.sm,
          runSpacing: Insets.sm,
          children: [
            for (final balance in balances)
              SizedBox(
                width: width,
                child: AccountTile(
                  name: balance.account.name,
                  balanceMinor: balance.balanceMinor,
                ),
              ),
          ],
        );
      },
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

    Widget step(bool done, String title, String caption, VoidCallback onTap) =>
        ActionLink(
          icon: done ? Icons.check_circle : Icons.radio_button_unchecked,
          label: title,
          caption: caption,
          onTap: onTap,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.welcomeTitle, style: theme.textTheme.titleLarge),
        gapXs,
        Text(l10n.welcomeMessage, style: theme.textTheme.bodySmall),
        gapSm,
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
    );
  }
}
