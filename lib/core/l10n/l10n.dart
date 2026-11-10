import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pandabudget/core/money/money_format.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/l10n/generated/app_localizations.dart';

export 'package:pandabudget/l10n/generated/app_localizations.dart';

extension LocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String get localeName => Localizations.localeOf(this).toLanguageTag();

  /// "30 Oct 2026"
  String formatDate(DateTime date) => DateFormat.yMMMd(localeName).format(date);

  /// "Friday, 30 October"
  String formatDayHeader(DateTime date) =>
      DateFormat.MMMMEEEEd(localeName).format(date);

  /// "30 Oct"
  String formatShortDate(DateTime date) =>
      DateFormat.MMMd(localeName).format(date);

  /// "October 2026"
  String formatMonth(YearMonth month) =>
      DateFormat.yMMMM(localeName).format(month.firstDay);

  /// "Oct 26"
  String formatShortMonth(YearMonth month) =>
      DateFormat("MMM ''yy", localeName).format(month.firstDay);

  /// "Oct"
  String formatMonthName(YearMonth month) =>
      DateFormat.MMM(localeName).format(month.firstDay);

  /// "1,234.56" without a currency symbol, for amount text fields.
  String formatPlainAmount(int minor) => NumberFormat.decimalPatternDigits(
    locale: localeName,
    decimalDigits: 2,
  ).format(minor / 100);

  /// Parses an amount typed in the UI language's number format.
  int? parseMoney(String input) => parseAmount(
    input,
    decimalSeparator: NumberFormat.decimalPattern(localeName)
        .symbols
        .DECIMAL_SEP,
  );
}
