import 'package:meta/meta.dart';
import 'package:pandabudget/core/entity.dart';
import 'package:pandabudget/core/time/year_month.dart';

/// Something to save up for by a certain month: a vacation, a car.
@immutable
class SavingsGoal {
  const SavingsGoal({
    required this.name,
    required this.targetMinor,
    required this.targetMonth,
    this.id = kNewId,
    this.savedMinor = 0,
    this.priority = 0,
    this.accountId,
    this.colorValue = 0xFF6A9A3A,
    this.isArchived = false,
  });

  final int id;
  final String name;
  final int targetMinor;

  /// What has been put aside for this goal already.
  final int savedMinor;

  /// The month the money is needed in.
  final YearMonth targetMonth;

  /// Lower numbers are funded first when money is tight.
  final int priority;

  /// The account the savings are kept on, if any.
  final int? accountId;
  final int colorValue;
  final bool isArchived;

  bool get isNew => id == kNewId;

  int get remainingMinor =>
      targetMinor > savedMinor ? targetMinor - savedMinor : 0;

  bool get isReached => remainingMinor == 0;

  double get progress =>
      targetMinor <= 0 ? 1 : (savedMinor / targetMinor).clamp(0, 1).toDouble();

  SavingsGoal copyWith({
    int? id,
    String? name,
    int? targetMinor,
    int? savedMinor,
    YearMonth? targetMonth,
    int? priority,
    int? Function()? accountId,
    int? colorValue,
    bool? isArchived,
  }) => SavingsGoal(
    id: id ?? this.id,
    name: name ?? this.name,
    targetMinor: targetMinor ?? this.targetMinor,
    savedMinor: savedMinor ?? this.savedMinor,
    targetMonth: targetMonth ?? this.targetMonth,
    priority: priority ?? this.priority,
    accountId: accountId != null ? accountId() : this.accountId,
    colorValue: colorValue ?? this.colorValue,
    isArchived: isArchived ?? this.isArchived,
  );
}

abstract interface class SavingsGoalRepository {
  Stream<List<SavingsGoal>> watchAll();

  Future<int> save(SavingsGoal goal);

  Future<void> delete(int id);
}
