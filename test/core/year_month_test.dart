import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/core/time/dates.dart';
import 'package:pandabudget/core/time/year_month.dart';

void main() {
  group('YearMonth', () {
    test('arithmetic crosses year boundaries', () {
      const december = YearMonth(2026, 12);
      expect(december.next, const YearMonth(2027, 1));
      expect(const YearMonth(2027, 1).previous, december);
      expect(december.addMonths(14), const YearMonth(2028, 2));
      expect(december.addMonths(-12), const YearMonth(2025, 12));
    });

    test('index round-trips', () {
      for (var month = 1; month <= 12; month++) {
        final value = YearMonth(2027, month);
        expect(YearMonth.fromIndex(value.index), value);
      }
    });

    test('knows its first and last day, including leap years', () {
      expect(const YearMonth(2028, 2).lastDay, DateTime(2028, 2, 29));
      expect(const YearMonth(2027, 2).daysInMonth, 28);
      expect(const YearMonth(2027, 4).firstDay, DateTime(2027, 4));
    });

    test('clamps days that do not exist in the month', () {
      expect(const YearMonth(2027, 2).day(31), DateTime(2027, 2, 28));
      expect(const YearMonth(2027, 1).day(31), DateTime(2027, 1, 31));
    });

    test('monthsUntil is signed', () {
      const start = YearMonth(2026, 11);
      expect(start.monthsUntil(const YearMonth(2027, 2)), 3);
      expect(start.monthsUntil(const YearMonth(2026, 9)), -2);
    });
  });

  group('dates', () {
    test('day numbers round-trip and sort chronologically', () {
      final date = DateTime(2026, 3, 9);
      expect(dayNumber(date), 20260309);
      expect(dateFromDayNumber(20260309), date);
      expect(dayNumber(DateTime(2025, 12, 31)) < dayNumber(date), isTrue);
    });

    test('addMonthsClamped keeps the anchor day', () {
      final jan31 = DateTime(2027, 1, 31);
      expect(addMonthsClamped(jan31, 1), DateTime(2027, 2, 28));
      expect(addMonthsClamped(jan31, 2, anchorDay: 31), DateTime(2027, 3, 31));
    });
  });
}
