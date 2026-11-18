import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/money/money_providers.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/widgets/page_widgets.dart';
import 'package:pandabudget/features/analysis/domain/analysis.dart';

/// A budget's spending so far: "€320 of €400", a progress bar and, with
/// [showRemaining], how much is left or over.
class BudgetStatusRow extends ConsumerWidget {
  const BudgetStatusRow(
    this.status, {
    this.showRemaining = false,
    this.onTap,
    super.key,
  });

  final BudgetStatus status;
  final bool showRemaining;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final money = ref.money(context);
    return BudgetRow(
      title: status.budget.name,
      detail:
          '${money.format(status.spentMinor)} '
          '${l10n.ofAmount} '
          '${money.format(status.limitMinor)}',
      progress: status.ratio,
      color: Color(status.budget.colorValue),
      note: showRemaining
          ? '${money.format(status.remainingMinor.abs())} '
                '${status.isOverspent ? l10n.over : l10n.left}'
          : null,
      noteColor: status.isOverspent ? context.financeColors.expense : null,
      onTap: onTap,
    );
  }
}
