import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/analysis/domain/analysis.dart';
import 'package:pandabudget/features/analysis/presentation/budget_status_view.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/planning/presentation/planning_providers.dart';
import 'package:pandabudget/features/transactions/presentation/transaction_providers.dart';

class BudgetsTab extends ConsumerWidget {
  const BudgetsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final month = ref.watch(currentMonthProvider);
    final tree = ref.watch(categoryTreeProvider);
    final transactions =
        ref
            .watch(transactionsInMonthsProvider((from: month, to: month)))
            .value ??
        const [];

    return AsyncView(
      value: ref.watch(budgetsProvider),
      builder: (budgets) {
        if (budgets.isEmpty) {
          return EmptyState(
            icon: Icons.pie_chart_outline,
            title: l10n.budgetsEmptyTitle,
            message: l10n.budgetsEmptyMessage,
          );
        }
        final statuses = {
          for (final status in budgetStatuses(
            budgets,
            transactions,
            tree,
            month: month,
          ))
            status.budget.id: status,
        };
        return PageBody(
          children: [
            SectionHeader(l10n.budgetsThisMonth(context.formatMonth(month))),
            AdaptiveColumns(
              children: [
                for (final budget in budgets)
                  PandaCard(
                    onTap: () => context.push(Routes.budgetEdit(budget.id)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (statuses[budget.id] case final status?)
                          BudgetStatusView(status: status)
                        else ...[
                          Text(
                            budget.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          gapXs,
                          Caption(l10n.budgetNotActive),
                        ],
                        gapMd,
                        Caption(
                          budget.categoryIds.isEmpty
                              ? l10n.budgetNoCategories
                              : budget.categoryIds
                                    .map((id) => tree[id]?.name)
                                    .nonNulls
                                    .join(', '),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
