import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pandabudget/core/money/money_format.dart';

void main() {
  setUpAll(initializeDateFormatting);

  group('parseAmount', () {
    test('reads German formatted amounts', () {
      expect(parseAmount('1.234,56', decimalSeparator: ','), 123456);
      expect(parseAmount('-54,32', decimalSeparator: ','), -5432);
      expect(parseAmount('12,5', decimalSeparator: ','), 1250);
      expect(parseAmount('79,00 €', decimalSeparator: ','), 7900);
      expect(parseAmount('3.250', decimalSeparator: ','), 325000);
    });

    test('reads English formatted amounts', () {
      expect(parseAmount('1,234.56', decimalSeparator: '.'), 123456);
      expect(parseAmount(r'$45.90', decimalSeparator: '.'), 4590);
      expect(parseAmount('+19.99', decimalSeparator: '.'), 1999);
    });

    test('understands the ways banks write negative numbers', () {
      expect(parseAmount('12,50-', decimalSeparator: ','), -1250);
      expect(parseAmount('(12.50)', decimalSeparator: '.'), -1250);
      expect(parseAmount('−12,50', decimalSeparator: ','), -1250);
      expect(parseAmount("1'000.00", decimalSeparator: '.'), 100000);
    });

    test('rounds extra decimals half up', () {
      expect(parseAmount('1.005', decimalSeparator: '.'), 101);
      expect(parseAmount('1.004', decimalSeparator: '.'), 100);
    });

    test('rejects text that is not an amount', () {
      expect(parseAmount('', decimalSeparator: ','), isNull);
      expect(parseAmount('abc', decimalSeparator: ','), isNull);
      expect(parseAmount('1,2,3', decimalSeparator: ','), isNull);
      expect(parseAmount('12-34', decimalSeparator: ','), isNull);
    });
  });

  group('MoneyFormatter', () {
    test('formats in the locale of the user', () {
      final german = MoneyFormatter(currencyCode: 'EUR', locale: 'de');
      final english = MoneyFormatter(currencyCode: 'EUR', locale: 'en');
      expect(german.format(123456), '1.234,56 €');
      expect(english.format(-123456), '-€1,234.56');
      expect(english.formatSigned(500), '+€5.00');
      expect(german.formatPlain(990), '9,90');
    });

    test('parses what it formats', () {
      final german = MoneyFormatter(currencyCode: 'EUR', locale: 'de');
      expect(german.parse(german.formatPlain(123456)), 123456);
      expect(german.parse('12,3'), 1230);
    });
  });
}
