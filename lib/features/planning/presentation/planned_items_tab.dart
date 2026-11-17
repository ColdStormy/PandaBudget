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
import 'package:pandabudget/core/widgets/page_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/planning/presentation/planning_providers.dart';

class PlannedItemsTab extends ConsumerWidget {
  const PlannedItemsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final today = dateOnly(ref.watch(clockProvider)());
    void add() => context.push(Routes.plannedItemEdit());

    return AsyncView(
      value: ref.watch(plannedItemsProvider),
      builder: (items) {
        if (items.isEmpty) {
          return EmptyState(
            icon: Icons.repeat,
            title: l10n.plannedEmptyTitle,
            message: l10n.plannedEmptyMessage,
            action: FilledButton(
              onPressed: add,
              child: Text(l10n.addPlannedItem),
            ),
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
            Row(
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
            if (incomes.isNotEmpty) ...[
              SectionHeader(l10n.plannedIncome),
              for (final item in incomes) _ItemRow(item: item, today: today),
            ],
            if (expenses.isNotEmpty) ...[
              SectionHeader(l10n.plannedPayments),
              for (final item in expenses) _ItemRow(item: item, today: today),
            ],
            gapSm,
            AddLink(label: l10n.addPlannedItem, onPressed: add),
          ],
        );
      },
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.today});

  final PlannedItem item;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final finance = context.financeColors;
    final next = item.nextOccurrence(today);
    final isIncome = item.kind == PlannedKind.income;

    return PandaListRow(
      enabled: item.isActive,
      leading: ColorAvatar(
        color: isIncome
            ? finance.income
            : Theme.of(context).colorScheme.secondary,
        icon: item.isRecurring ? Icons.repeat : Icons.looks_one_outlined,
      ),
      title: item.name,
      subtitle: [
        recurrenceLabel(l10n, item),
        if (!item.isActive)
          l10n.paused
        else if (next != null)
          l10n.nextOn(context.formatDate(next))
        else
          l10n.ended,
      ].join(' · '),
      subtitleMaxLines: 2,
      amountMinor: item.amountMinor,
      tone: isIncome ? AmountTone.incomeOnly : AmountTone.plain,
      onTap: () => context.push(Routes.plannedItemEdit(item.id)),
    );
  }
}
