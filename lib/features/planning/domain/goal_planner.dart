import 'package:meta/meta.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/features/planning/domain/savings_goal.dart';

/// The savings plan for one goal over the forecast horizon.
@immutable
class GoalPlan {
  const GoalPlan({
    required this.goal,
    required this.requiredMonthlyMinor,
    required this.contributions,
    required this.fundedMonth,
    required this.shortfallAtTargetMinor,
    required this.isFrontLoaded,
  });

  final SavingsGoal goal;

  /// The even monthly rate that reaches the goal exactly in its target
  /// month, counted from the first forecast month.
  final int requiredMonthlyMinor;

  /// What the plan puts aside per month.
  final Map<YearMonth, int> contributions;

  /// The month the goal is fully funded, or null if that does not happen
  /// within the forecast horizon.
  final YearMonth? fundedMonth;

  /// What is still missing at the end of the target month.
  final int shortfallAtTargetMinor;

  /// True if an even rate would not make it and the plan therefore saves
  /// more in early months that can afford it.
  final bool isFrontLoaded;

  bool get isOnTrack => shortfallAtTargetMinor == 0;
}

/// Result of [planSavings].
@immutable
class SavingsPlan {
  const SavingsPlan({
    required this.goals,
    required this.reserves,
    required this.balances,
  });

  /// Plans keyed by goal id.
  final Map<int, GoalPlan> goals;

  /// Per month: the cushion kept back for months further ahead that cost
  /// more than they bring in (a yearly insurance premium, for example).
  final List<int> reserves;

  /// Per month: unassigned money accumulated up to the end of that month.
  final List<int> balances;
}

/// Distributes what each month leaves over across the savings goals.
///
/// [potentials] holds, starting at [from], what each month has left after
/// planned payments and budgets; it can be negative.
///
/// The plan
/// * never spends money a later, more expensive month will need: the
///   shortfalls ahead are held back as a reserve first;
/// * funds goals in order of priority, then deadline;
/// * saves at an even rate towards each deadline, and only front-loads a
///   goal (saving faster while money is available) if the even rate would
///   miss the deadline;
/// * keeps funding a goal after a missed deadline until it is reached.
SavingsPlan planSavings({
  required List<SavingsGoal> goals,
  required YearMonth from,
  required List<int> potentials,
}) {
  final open =
      goals.where((goal) => !goal.isArchived && !goal.isReached).toList()
        ..sort((a, b) {
          final byPriority = a.priority.compareTo(b.priority);
          if (byPriority != 0) return byPriority;
          final byDeadline = a.targetMonth.compareTo(b.targetMonth);
          return byDeadline != 0 ? byDeadline : a.id.compareTo(b.id);
        });

  // reserves[i]: money that must still be on hand at the end of month i so
  // that no later month drops below zero.
  final reserves = List<int>.filled(potentials.length, 0);
  for (var i = potentials.length - 2; i >= 0; i--) {
    final needed = reserves[i + 1] - potentials[i + 1];
    reserves[i] = needed > 0 ? needed : 0;
  }

  final frontLoaded = <int>{};
  late _Simulation simulation;
  // Each round moves at most one more goal to front-loading, so this ends
  // after at most `open.length + 1` rounds.
  while (true) {
    simulation = _simulate(open, from, potentials, reserves, frontLoaded);
    final late = open
        .where(
          (goal) =>
              !frontLoaded.contains(goal.id) &&
              simulation.shortfallAtTarget[goal.id]! > 0,
        )
        .toList();
    if (late.isEmpty) break;
    frontLoaded.add(late.first.id);
  }

  return SavingsPlan(
    reserves: reserves,
    balances: simulation.balances,
    goals: {
      for (final goal in open)
        goal.id: GoalPlan(
          goal: goal,
          requiredMonthlyMinor: _evenRate(
            goal.remainingMinor,
            from.monthsUntil(goal.targetMonth),
          ),
          contributions: simulation.contributions[goal.id]!,
          fundedMonth: simulation.fundedMonth[goal.id],
          shortfallAtTargetMinor: simulation.shortfallAtTarget[goal.id]!,
          isFrontLoaded: frontLoaded.contains(goal.id),
        ),
    },
  );
}

/// Remaining amount spread over the months up to and including the target
/// month, rounded up so the last month is not left with the rounding error.
int _evenRate(int remaining, int monthsUntilTarget) {
  if (remaining <= 0) return 0;
  if (monthsUntilTarget <= 0) return remaining;
  final months = monthsUntilTarget + 1;
  return (remaining + months - 1) ~/ months;
}

class _Simulation {
  final Map<int, Map<YearMonth, int>> contributions = {};
  final Map<int, YearMonth?> fundedMonth = {};
  final Map<int, int> shortfallAtTarget = {};
  final List<int> balances = [];
}

_Simulation _simulate(
  List<SavingsGoal> goals,
  YearMonth from,
  List<int> potentials,
  List<int> reserves,
  Set<int> frontLoaded,
) {
  final result = _Simulation();
  final remaining = {for (final goal in goals) goal.id: goal.remainingMinor};
  for (final goal in goals) {
    result.contributions[goal.id] = {};
    result.fundedMonth[goal.id] = null;
    // Goals whose deadline lies before the forecast start are already late.
    result.shortfallAtTarget[goal.id] = goal.targetMonth.isBefore(from)
        ? goal.remainingMinor
        : 0;
  }

  var balance = 0;
  for (var i = 0; i < potentials.length; i++) {
    final month = from.addMonths(i);
    balance += potentials[i];
    var available = balance - reserves[i];

    for (final goal in goals) {
      final left = remaining[goal.id]!;
      if (left > 0 && available > 0) {
        final wanted = frontLoaded.contains(goal.id)
            ? left
            : _evenRate(left, month.monthsUntil(goal.targetMonth));
        final amount = wanted < available ? wanted : available;
        if (amount > 0) {
          result.contributions[goal.id]![month] = amount;
          remaining[goal.id] = left - amount;
          available -= amount;
          balance -= amount;
          if (left - amount == 0) result.fundedMonth[goal.id] = month;
        }
      }
      if (month == goal.targetMonth) {
        result.shortfallAtTarget[goal.id] = remaining[goal.id]!;
      }
    }
    result.balances.add(balance);
  }

  // A deadline beyond the horizon cannot be judged; treat it as on track
  // as long as the even rate has been affordable so far.
  return result;
}
