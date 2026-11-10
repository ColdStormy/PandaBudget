import 'package:intl/intl.dart';

/// Formats and parses amounts.
///
/// Amounts are kept as signed integers in minor units (cents) everywhere in
/// the app to avoid floating point rounding errors.
class MoneyFormatter {
  MoneyFormatter({required this.currencyCode, required this.locale})
    : _currency = NumberFormat.simpleCurrency(
        locale: locale,
        name: currencyCode,
      ),
      _plain = NumberFormat.decimalPatternDigits(
        locale: locale,
        decimalDigits: 2,
      ),
      _compact = NumberFormat.compactSimpleCurrency(
        locale: locale,
        name: currencyCode,
      );

  final String currencyCode;
  final String locale;
  final NumberFormat _currency;
  final NumberFormat _plain;
  final NumberFormat _compact;

  String get decimalSeparator => _plain.symbols.DECIMAL_SEP;

  /// `1234.56 €` style output with the currency symbol.
  String format(int minor) => _currency.format(minor / 100);

  /// Like [format] but always carries a sign, e.g. `+12.00 €`.
  String formatSigned(int minor) =>
      minor > 0 ? '+${format(minor)}' : format(minor);

  /// Amount without currency symbol, for text fields.
  String formatPlain(int minor) => _plain.format(minor / 100);

  /// Short form for chart axes, e.g. `1.2K €`.
  String formatCompact(int minor) => _compact.format(minor / 100);

  /// Parses user input in the formatter's locale. Returns null if invalid.
  int? parse(String input) =>
      parseAmount(input, decimalSeparator: decimalSeparator);
}

/// Parses a decimal amount into minor units.
///
/// Accepts thousands separators, a leading or trailing sign, parentheses for
/// negative values, currency symbols and (non-breaking) spaces, which covers
/// what bank exports and people typing amounts usually produce.
int? parseAmount(String input, {required String decimalSeparator}) {
  var text = input.trim();
  if (text.isEmpty) return null;

  var negative = false;
  if (text.startsWith('(') && text.endsWith(')')) {
    negative = true;
    text = text.substring(1, text.length - 1);
  }
  // Drop everything that is not a digit, separator or sign.
  text = text.replaceAll(RegExp(r"[^0-9.,'+\-−]"), '');
  if (text.isEmpty) return null;

  if (text.endsWith('-') || text.endsWith('−')) {
    negative = !negative;
    text = text.substring(0, text.length - 1);
  } else if (text.endsWith('+')) {
    text = text.substring(0, text.length - 1);
  }
  if (text.startsWith('-') || text.startsWith('−')) {
    negative = !negative;
    text = text.substring(1);
  } else if (text.startsWith('+')) {
    text = text.substring(1);
  }
  if (text.isEmpty || text.contains(RegExp(r'[+\-−]'))) return null;

  final thousands = decimalSeparator == ',' ? '.' : ',';
  text = text.replaceAll(thousands, '').replaceAll("'", '');
  final parts = text.split(decimalSeparator);
  if (parts.length > 2) return null;

  final whole = parts[0].isEmpty ? '0' : parts[0];
  var fraction = parts.length == 2 ? parts[1] : '';
  if (!RegExp(r'^\d+$').hasMatch(whole)) return null;
  if (fraction.isNotEmpty && !RegExp(r'^\d+$').hasMatch(fraction)) return null;

  // Round half up to two decimals if more digits are given.
  var roundUp = false;
  if (fraction.length > 2) {
    roundUp = fraction.codeUnitAt(2) >= 0x35;
    fraction = fraction.substring(0, 2);
  }
  fraction = fraction.padRight(2, '0');

  final value =
      int.parse(whole) * 100 + int.parse(fraction) + (roundUp ? 1 : 0);
  return negative ? -value : value;
}
