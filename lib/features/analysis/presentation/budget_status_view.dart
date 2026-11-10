import 'package:flutter/material.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/analysis/domain/analysis.dart';

/// Name, usage bar and "x of y" for one budget in one month.
class BudgetStatusView extends StatelessWidget {
  const BudgetStatusView({required this.status, super.key});

  final BudgetStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final finance = context.financeColors;
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                status.budget.name,
                style: theme.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            gapSm,
            if (status.isOverspent)
              StatusPill(
                label: l10n.overspent,
                color: finance.expense,
                icon: Icons.warning_amber_rounded,
              ),
          ],
        ),
        gapMd,
        UsageBar(value: status.ratio, color: Color(status.budget.colorValue)),
        gapSm,
        Row(
          children: [
            AmountText(status.spentMinor, style: theme.textTheme.bodyMedium),
            Text(' ${l10n.ofAmount} ', style: muted),
            AmountText(status.limitMinor, style: muted),
            const Spacer(),
            AmountText(
              status.remainingMinor.abs(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: status.isOverspent ? finance.expense : null,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' ${status.isOverspent ? l10n.over : l10n.left}',
              style: muted?.copyWith(
                color: status.isOverspent ? finance.expense : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
