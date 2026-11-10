import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/time/clock.dart';
import 'package:pandabudget/core/time/dates.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/planning/presentation/planning_providers.dart';

class PlannedItemsTab extends ConsumerWidget {
  const PlannedItemsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final today = dateOnly(ref.watch(clockProvider)());

    return AsyncView(
      value: ref.watch(plannedItemsProvider),
      builder: (items) {
        if (items.isEmpty) {
          return EmptyState(
            icon: Icons.repeat,
            title: l10n.plannedEmptyTitle,
            message: l10n.plannedEmptyMessage,
          );
        }
        List<PlannedItem> of(PlannedKind kind) =>
            items.where((item) => item.kind == kind).toList()..sort(
              (a, b) =>
                  b.monthlyEquivalentMinor.compareTo(a.monthlyEquivalentMinor),
            );
        final incomes = of(PlannedKind.income);
        final expenses = of(PlannedKind.expense);
        int monthly(List<PlannedItem> list) => list
            .where((item) => item.isActive)
            .map((item) => item.monthlyEquivalentMinor)
            .sum;

        return PageBody(
          children: [
            gapSm,
            PandaCard(
              child: Row(
                children: [
                  Expanded(
                    child: Figure(
                      label: l10n.avgMonthlyIncome,
                      amountMinor: monthly(incomes),
                    ),
                  ),
                  gapMd,
                  Expanded(
                    child: Figure(
                      label: l10n.avgMonthlyPayments,
                      amountMinor: monthly(expenses),
                    ),
                  ),
                ],
              ),
            ),
            if (incomes.isNotEmpty) ...[
              SectionHeader(l10n.plannedIncome),
              _ItemCard(items: incomes, today: today),
            ],
            if (expenses.isNotEmpty) ...[
              SectionHeader(l10n.plannedPayments),
              _ItemCard(items: expenses, today: today),
            ],
          ],
        );
      },
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.items, required this.today});

  final List<PlannedItem> items;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final finance = context.financeColors;

    return Card(
      child: Column(
        children: [
          for (final (index, item) in items.indexed) ...[
            if (index > 0) const Divider(indent: Insets.md),
            () {
              final next = item.nextOccurrence(today);
              final isIncome = item.kind == PlannedKind.income;
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Insets.md,
                  vertical: Insets.xs,
                ),
                enabled: item.isActive,
                leading: ColorAvatar(
                  color: isIncome
                      ? finance.income
                      : theme.colorScheme.secondary,
                  icon: item.isRecurring
                      ? Icons.repeat
                      : Icons.looks_one_outlined,
                ),
                title: Text(item.name),
                subtitle: Text(
                  [
                    recurrenceLabel(l10n, item),
                    if (!item.isActive)
                      l10n.paused
                    else if (next != null)
                      l10n.nextOn(context.formatDate(next))
                    else
                      l10n.ended,
                  ].join(' · '),
                ),
                trailing: AmountText(
                  item.amountMinor,
                  tone: isIncome ? AmountTone.incomeOnly : AmountTone.plain,
                  style: theme.textTheme.titleMedium,
                ),
                onTap: () => context.push(Routes.plannedItemEdit(item.id)),
              );
            }(),
          ],
        ],
      ),
    );
  }
}
