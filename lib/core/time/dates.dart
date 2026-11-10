/// Helpers for calendar dates without a time of day.
///
/// The app represents such dates as a local [DateTime] at midnight and stores
/// them as an integer `yyyymmdd`, which sorts correctly and is not affected by
/// time zones or daylight saving changes.
library;

DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

int dayNumber(DateTime date) => date.year * 10000 + date.month * 100 + date.day;

DateTime dateFromDayNumber(int value) =>
    DateTime(value ~/ 10000, value ~/ 100 % 100, value % 100);

/// Adds [months] to [date], keeping the day of month where possible and
/// clamping it to the length of the target month otherwise.
///
/// [anchorDay] is the originally intended day; passing it keeps a monthly
/// series that started on the 31st from drifting to the 28th forever.
DateTime addMonthsClamped(DateTime date, int months, {int? anchorDay}) {
  final target = DateTime(date.year, date.month + months);
  final lastDay = DateTime(target.year, target.month + 1, 0).day;
  final day = anchorDay ?? date.day;
  return DateTime(target.year, target.month, day > lastDay ? lastDay : day);
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
