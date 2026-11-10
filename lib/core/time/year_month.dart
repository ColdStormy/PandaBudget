import 'package:meta/meta.dart';

/// A calendar month without a day, e.g. March 2027.
///
/// Planning and analysis both work month by month, so this is the main unit
/// of time in the app.
@immutable
class YearMonth implements Comparable<YearMonth> {
  const YearMonth(this.year, this.month)
    : assert(month >= 1 && month <= 12, 'month must be 1..12');

  factory YearMonth.of(DateTime date) => YearMonth(date.year, date.month);

  /// Rebuilds a month from [index] as produced by the [index] getter.
  factory YearMonth.fromIndex(int index) =>
      YearMonth(index ~/ 12, index % 12 + 1);

  final int year;
  final int month;

  /// Months since year 0; handy for arithmetic and for storing in a database.
  int get index => year * 12 + month - 1;

  DateTime get firstDay => DateTime(year, month);

  DateTime get lastDay => DateTime(year, month + 1, 0);

  int get daysInMonth => lastDay.day;

  YearMonth get next => addMonths(1);

  YearMonth get previous => addMonths(-1);

  YearMonth addMonths(int count) => YearMonth.fromIndex(index + count);

  /// Number of months from this month to [other] (positive if later).
  int monthsUntil(YearMonth other) => other.index - index;

  bool contains(DateTime date) => date.year == year && date.month == month;

  bool isBefore(YearMonth other) => index < other.index;

  bool isAfter(YearMonth other) => index > other.index;

  /// The given [day] in this month, clamped to the month's length so that
  /// "the 31st" lands on the 28th/29th/30th where needed.
  DateTime day(int day) => DateTime(year, month, day.clamp(1, daysInMonth));

  @override
  int compareTo(YearMonth other) => index.compareTo(other.index);

  @override
  bool operator ==(Object other) => other is YearMonth && other.index == index;

  @override
  int get hashCode => index;

  @override
  String toString() => '$year-${month.toString().padLeft(2, '0')}';
}
