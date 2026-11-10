import 'package:meta/meta.dart';
import 'package:pandabudget/core/entity.dart';
import 'package:pandabudget/core/time/year_month.dart';

/// A monthly spending limit for a group of categories, e.g. 450 for
/// groceries and household items.
@immutable
class Budget {
  const Budget({
    required this.name,
    required this.amountMinor,
    required this.startMonth,
    this.id = kNewId,
    this.endMonth,
    this.categoryIds = const {},
    this.colorValue = 0xFF6A9A3A,
    this.isArchived = false,
  });

  final int id;
  final String name;

  /// Limit per month.
  final int amountMinor;

  /// First and last month the budget applies to; open-ended if
  /// [endMonth] is null.
  final YearMonth startMonth;
  final YearMonth? endMonth;

  /// Spending in these categories (and their sub-categories) counts
  /// against the budget.
  final Set<int> categoryIds;
  final int colorValue;
  final bool isArchived;

  bool get isNew => id == kNewId;

  bool isActiveIn(YearMonth month) =>
      !isArchived &&
      !month.isBefore(startMonth) &&
      (endMonth == null || !month.isAfter(endMonth!));

  Budget copyWith({
    int? id,
    String? name,
    int? amountMinor,
    YearMonth? startMonth,
    YearMonth? Function()? endMonth,
    Set<int>? categoryIds,
    int? colorValue,
    bool? isArchived,
  }) => Budget(
    id: id ?? this.id,
    name: name ?? this.name,
    amountMinor: amountMinor ?? this.amountMinor,
    startMonth: startMonth ?? this.startMonth,
    endMonth: endMonth != null ? endMonth() : this.endMonth,
    categoryIds: categoryIds ?? this.categoryIds,
    colorValue: colorValue ?? this.colorValue,
    isArchived: isArchived ?? this.isArchived,
  );
}

abstract interface class BudgetRepository {
  Stream<List<Budget>> watchAll();

  Future<int> save(Budget budget);

  Future<void> delete(int id);
}
