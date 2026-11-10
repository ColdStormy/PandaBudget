import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/planning/domain/goal_planner.dart';
import 'package:pandabudget/features/planning/domain/savings_goal.dart';
import 'package:pandabudget/features/planning/presentation/planning_providers.dart';

class GoalsTab extends ConsumerWidget {
  const GoalsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final plans = ref.watch(forecastProvider).value?.goalPlans ?? const {};

    return AsyncView(
      value: ref.watch(savingsGoalsProvider),
      builder: (goals) {
        if (goals.isEmpty) {
          return EmptyState(
            icon: Icons.flag_outlined,
            title: l10n.goalsEmptyTitle,
            message: l10n.goalsEmptyMessage,
          );
        }
        return PageBody(
          children: [
            gapMd,
            AdaptiveColumns(
              children: [
                for (final goal in goals)
                  GoalCard(
                    goal: goal,
                    plan: plans[goal.id],
                    onTap: () => context.push(Routes.goalEdit(goal.id)),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// A savings goal with its progress and whether the plan reaches it.
class GoalCard extends StatelessWidget {
  const GoalCard({required this.goal, this.plan, this.onTap, super.key});

  final SavingsGoal goal;
  final GoalPlan? plan;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final finance = context.financeColors;
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final plan = this.plan;

    final Widget status;
    if (goal.isReached) {
      status = StatusPill(
        label: l10n.goalReached,
        color: finance.income,
        icon: Icons.check_circle_outline,
      );
    } else if (plan == null) {
      status = const SizedBox.shrink();
    } else if (plan.isOnTrack) {
      status = StatusPill(
        label: l10n.goalOnTrack,
        color: finance.income,
        icon: Icons.trending_up,
      );
    } else {
      status = StatusPill(
        label: l10n.goalBehind,
        color: finance.warning,
        icon: Icons.schedule,
      );
    }

    return PandaCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.name,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              gapSm,
              status,
            ],
          ),
          gapXs,
          Text(
            l10n.goalBy(context.formatMonth(goal.targetMonth)),
            style: muted,
          ),
          gapMd,
          UsageBar(value: goal.progress, color: Color(goal.colorValue)),
          gapSm,
          Row(
            children: [
              AmountText(goal.savedMinor, style: theme.textTheme.bodyMedium),
              Text(' ${l10n.ofAmount} ', style: muted),
              AmountText(goal.targetMinor, style: muted),
            ],
          ),
          if (plan != null && !goal.isReached) ...[
            gapMd,
            const Divider(),
            gapMd,
            Row(
              children: [
                Expanded(child: Text(l10n.goalMonthlyRate, style: muted)),
                AmountText(
                  plan.requiredMonthlyMinor,
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            gapXs,
            if (plan.isOnTrack)
              Text(
                plan.isFrontLoaded
                    ? l10n.goalFrontLoadedHint
                    : l10n.goalOnTrackHint,
                style: muted,
              )
            else
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('${l10n.goalShortBy} ', style: muted),
                  AmountText(
                    plan.shortfallAtTargetMinor,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: finance.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (plan.fundedMonth != null)
                    Text(
                      ' · ${l10n.goalReachableIn(context.formatMonth(plan.fundedMonth!))}',
                      style: muted,
                    ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
