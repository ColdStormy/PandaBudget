import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:pandabudget/core/entity.dart';
import 'package:pandabudget/core/time/dates.dart';
import 'package:pandabudget/core/time/year_month.dart';

enum PlannedKind { income, expense }

enum RecurrenceUnit { once, week, month, year }

/// A payment or income the household expects: the salary, the rent, the
/// yearly insurance premium, a one-time purchase.
@immutable
class PlannedItem {
  const PlannedItem({
    required this.name,
    required this.kind,
    required this.amountMinor,
    required this.startDate,
    this.id = kNewId,
    this.unit = RecurrenceUnit.month,
    this.interval = 1,
    this.endDate,
    this.categoryId,
    this.accountId,
    this.note = '',
    this.isActive = true,
  }) : assert(interval >= 1, 'interval must be at least 1');

  final int id;
  final String name;
  final PlannedKind kind;

  /// Always positive; [kind] says whether it comes in or goes out.
  final int amountMinor;

  /// Repeats every [interval] [unit]s, e.g. every 3 months.
  final RecurrenceUnit unit;
  final int interval;

  /// First (or, for one-time items, only) due date.
  final DateTime startDate;

  /// Last day an occurrence may fall on; null for open-ended items.
  final DateTime? endDate;
  final int? categoryId;
  final int? accountId;
  final String note;
  final bool isActive;

  bool get isNew => id == kNewId;

  bool get isRecurring => unit != RecurrenceUnit.once;

  /// Positive for income, negative for expenses.
  int get signedAmountMinor =>
      kind == PlannedKind.income ? amountMinor : -amountMinor;

  /// The average effect on one month, used for sorting and summaries.
  int get monthlyEquivalentMinor => switch (unit) {
    RecurrenceUnit.once => 0,
    RecurrenceUnit.week => (amountMinor * 52 / 12 / interval).round(),
    RecurrenceUnit.month => (amountMinor / interval).round(),
    RecurrenceUnit.year => (amountMinor / (12 * interval)).round(),
  };

  /// All due dates between [from] and [to], both inclusive.
  List<DateTime> occurrencesBetween(DateTime from, DateTime to) {
    if (!isActive) return const [];
    final start = dateOnly(startDate);
    final first = dateOnly(from);
    var last = dateOnly(to);
    if (endDate != null && endDate!.isBefore(last)) last = dateOnly(endDate!);
    if (last.isBefore(start) || last.isBefore(first)) return const [];

    final result = <DateTime>[];
    switch (unit) {
      case RecurrenceUnit.once:
        if (!start.isBefore(first)) result.add(start);
      case RecurrenceUnit.week:
        final step = 7 * interval;
        var steps = 0;
        if (first.isAfter(start)) {
          // Jump close to the range instead of walking from the start.
          final days = _daysBetween(start, first);
          steps = (days + step - 1) ~/ step;
        }
        for (
          var date = _addDays(start, steps * step);
          !date.isAfter(last);
          date = _addDays(date, step)
        ) {
          result.add(date);
        }
      case RecurrenceUnit.month:
      case RecurrenceUnit.year:
        final stepMonths = unit == RecurrenceUnit.year
            ? 12 * interval
            : interval;
        var steps = 0;
        if (first.isAfter(start)) {
          final months = YearMonth.of(start).monthsUntil(YearMonth.of(first));
          steps = months ~/ stepMonths;
        }
        for (; ; steps++) {
          final date = addMonthsClamped(
            start,
            steps * stepMonths,
            anchorDay: start.day,
          );
          if (date.isAfter(last)) break;
          if (!date.isBefore(first)) result.add(date);
        }
    }
    return result;
  }

  List<DateTime> occurrencesIn(YearMonth month) =>
      occurrencesBetween(month.firstDay, month.lastDay);

  /// The next due date on or after [date], if there is one.
  DateTime? nextOccurrence(DateTime date) {
    // Ten years comfortably covers every supported interval.
    final horizon = DateTime(date.year + 10, date.month, date.day);
    return occurrencesBetween(date, horizon).firstOrNull;
  }

  PlannedItem copyWith({
    int? id,
    String? name,
    PlannedKind? kind,
    int? amountMinor,
    RecurrenceUnit? unit,
    int? interval,
    DateTime? startDate,
    DateTime? Function()? endDate,
    int? Function()? categoryId,
    int? Function()? accountId,
    String? note,
    bool? isActive,
  }) => PlannedItem(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    amountMinor: amountMinor ?? this.amountMinor,
    unit: unit ?? this.unit,
    interval: interval ?? this.interval,
    startDate: startDate ?? this.startDate,
    endDate: endDate != null ? endDate() : this.endDate,
    categoryId: categoryId != null ? categoryId() : this.categoryId,
    accountId: accountId != null ? accountId() : this.accountId,
    note: note ?? this.note,
    isActive: isActive ?? this.isActive,
  );
}

// Calendar-day arithmetic on local midnights. Going through UTC avoids
// off-by-one errors on days with a daylight saving switch.
int _daysBetween(DateTime a, DateTime b) => DateTime.utc(
  b.year,
  b.month,
  b.day,
).difference(DateTime.utc(a.year, a.month, a.day)).inDays;

DateTime _addDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);

abstract interface class PlannedItemRepository {
  Stream<List<PlannedItem>> watchAll();

  Future<int> save(PlannedItem item);

  Future<void> delete(int id);
}
