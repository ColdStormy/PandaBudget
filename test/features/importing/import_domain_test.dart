import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/features/importing/domain/field_parsers.dart';
import 'package:pandabudget/features/importing/domain/import_parser.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';
import 'package:pandabudget/features/importing/domain/profile_suggester.dart';
import 'package:pandabudget/features/importing/domain/table_reader.dart';
import 'package:pandabudget/features/importing/domain/text_decoder.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('decodeText', () {
    test('reads Windows-1252 when the bytes are not valid UTF-8', () {
      final text = decodeText(fixtureBytes('german_giro_cp1252.csv'));
      expect(text, contains('Begünstigter/Zahlungspflichtiger'));
      expect(text, contains('79,00 €'));
    });

    test('reads UTF-8 and strips the byte order mark', () {
      final text = decodeText(fixtureBytes('indicator_utf8.csv'));
      expect(text, startsWith('Datum;Empfänger'));
    });

    test('honours an explicit encoding', () {
      final bytes = Uint8List.fromList(utf8.encode('Müller'));
      expect(decodeText(bytes, encoding: TextEncoding.latin1), 'MÃ¼ller');
      expect(decodeText(bytes, encoding: TextEncoding.utf8), 'Müller');
    });
  });

  group('readCsv', () {
    test('skips the bank preamble and finds the header row', () {
      final table = readCsv(decodeText(fixtureBytes('german_giro_cp1252.csv')));
      expect(table.headers.first, 'Buchungstag');
      expect(table.headers.last, 'Betrag (EUR)');
      expect(table.rows, hasLength(6));
      // A semicolon inside quotes is data, not a separator.
      expect(table.rows[2][4], 'Miete Oktober; Whg 12');
    });

    test('detects comma separated files', () {
      final table = readCsv(
        decodeText(fixtureBytes('english_debit_credit.csv')),
      );
      expect(table.headers, [
        'Date',
        'Description',
        'Debit',
        'Credit',
        'Balance',
      ]);
      expect(table.rows[1][1], 'SUPERMARKET 123, MAIN ST');
    });

    test('names empty and repeated headers so they stay addressable', () {
      final table = readCsv('a;;a\n1;2;3\n');
      expect(table.headers, ['a', 'Column 2', 'a (2)']);
    });

    test('respects an explicit delimiter and header row', () {
      final table = readCsv(
        'x|y\nDate|Amount\n1|2\n',
        delimiter: '|',
        headerRow: 1,
      );
      expect(table.headers, ['Date', 'Amount']);
      expect(table.rows, [
        ['1', '2'],
      ]);
    });

    test('fails clearly on an empty file', () {
      expect(() => readCsv(''), throwsA(isA<TableFormatException>()));
    });
  });

  group('readJson', () {
    test('finds the transaction array and flattens nested objects', () {
      final table = readJson(decodeText(fixtureBytes('bank_export.json')));
      expect(table.headers, [
        'bookingDate',
        'amount.value',
        'amount.currency',
        'creditorName',
        'remittanceInformation',
      ]);
      expect(table.rows.first[1], '-12.50');
    });

    test('follows an explicit root path', () {
      final table = readJson(
        '{"data":{"items":[{"a":1}],"other":[{"b":2}]}}',
        rootPath: 'data.other',
      );
      expect(table.headers, ['b']);
    });

    test('accepts a top-level array', () {
      expect(readJson('[{"a":"x"},{"a":"y","b":null}]').rows, [
        ['x', ''],
        ['y', ''],
      ]);
    });

    test('rejects documents without transactions', () {
      expect(() => readJson('{"a":1}'), throwsA(isA<TableFormatException>()));
      expect(() => readJson('not json'), throwsA(isA<TableFormatException>()));
    });
  });

  group('parseDate', () {
    test('parses the supported patterns', () {
      final expected = DateTime(2026, 10, 3);
      expect(parseDate('03.10.2026', 'dd.MM.yyyy'), expected);
      expect(parseDate('3.10.26', 'dd.MM.yy'), expected);
      expect(parseDate('2026-10-03', 'yyyy-MM-dd'), expected);
      expect(parseDate('10/03/2026', 'MM/dd/yyyy'), expected);
      expect(parseDate('20261003', 'yyyyMMdd'), expected);
    });

    test('ignores a time of day', () {
      expect(
        parseDate('2026-10-03T08:15:00Z', 'yyyy-MM-dd'),
        DateTime(2026, 10, 3),
      );
      expect(
        parseDate('03.10.2026 14:30', 'dd.MM.yyyy'),
        DateTime(2026, 10, 3),
      );
    });

    test('rejects dates that do not exist or do not match', () {
      expect(parseDate('31.02.2026', 'dd.MM.yyyy'), isNull);
      expect(parseDate('2026-13-01', 'yyyy-MM-dd'), isNull);
      expect(parseDate('03.10.2026', 'yyyy-MM-dd'), isNull);
      expect(parseDate('', 'dd.MM.yyyy'), isNull);
    });
  });

  group('detection', () {
    test('finds the date format that fits the samples', () {
      expect(detectDateFormat(['30.10.2026', '02.10.2026']), 'dd.MM.yyyy');
      expect(detectDateFormat(['2026-10-01']), 'yyyy-MM-dd');
      // 13 cannot be a month, so this must be day-first.
      expect(detectDateFormat(['01/02/2026', '13/02/2026']), 'dd/MM/yyyy');
      expect(detectDateFormat(['02/13/2026']), 'MM/dd/yyyy');
      expect(detectDateFormat(['hello']), isNull);
    });

    test('finds the decimal separator', () {
      expect(detectDecimalSeparator(['-54,32', '3.250,00']), ',');
      expect(detectDecimalSeparator(['45.90', '3,200.00']), '.');
      expect(detectDecimalSeparator(['12,50 €']), ',');
    });
  });

  group('suggestProfile', () {
    test('maps a German giro export', () {
      final table = readCsv(decodeText(fixtureBytes('german_giro_cp1252.csv')));
      final profile = suggestProfile(table, name: 'Bank');
      expect(profile.amountMode, AmountMode.signed);
      expect(profile.dateFormat, 'dd.MM.yyyy');
      expect(profile.decimalSeparator, ',');
      expect(profile.mapping, {
        ImportField.bookingDate: 'Buchungstag',
        ImportField.valueDate: 'Wertstellung',
        ImportField.amount: 'Betrag (EUR)',
        ImportField.counterparty: 'Begünstigter/Zahlungspflichtiger',
        ImportField.purpose: 'Verwendungszweck',
        ImportField.counterpartyIban: 'IBAN',
      });
      expect(profile.isComplete, isTrue);
    });

    test('recognises separate debit and credit columns', () {
      final table = readCsv(
        decodeText(fixtureBytes('english_debit_credit.csv')),
      );
      final profile = suggestProfile(table, name: 'Bank');
      expect(profile.amountMode, AmountMode.debitCredit);
      expect(profile.dateFormat, 'yyyy-MM-dd');
      expect(profile.decimalSeparator, '.');
      expect(profile.mapping[ImportField.debit], 'Debit');
      expect(profile.mapping[ImportField.credit], 'Credit');
      expect(profile.mapping[ImportField.purpose], 'Description');
    });

    test('recognises an amount with a debit/credit indicator', () {
      final table = readCsv(decodeText(fixtureBytes('indicator_utf8.csv')));
      final profile = suggestProfile(table, name: 'Bank');
      expect(profile.amountMode, AmountMode.indicator);
      expect(profile.mapping[ImportField.indicator], 'Soll/Haben');
      expect(profile.dateFormat, 'dd.MM.yy');
    });

    test('maps flattened JSON keys', () {
      final table = readJson(decodeText(fixtureBytes('bank_export.json')));
      final profile = suggestProfile(
        table,
        name: 'Bank',
        fileType: ImportFileType.json,
      );
      expect(profile.mapping[ImportField.bookingDate], 'bookingDate');
      expect(profile.mapping[ImportField.amount], 'amount.value');
      expect(profile.mapping[ImportField.counterparty], 'creditorName');
      expect(profile.mapping[ImportField.purpose], 'remittanceInformation');
      expect(profile.decimalSeparator, '.');
    });
  });

  group('matchProfile', () {
    const giro = ImportProfile(
      id: 1,
      name: 'Giro',
      mapping: {
        ImportField.bookingDate: 'Buchungstag',
        ImportField.amount: 'Betrag (EUR)',
      },
    );
    const detailed = ImportProfile(
      id: 2,
      name: 'Giro detailed',
      mapping: {
        ImportField.bookingDate: 'Buchungstag',
        ImportField.amount: 'Betrag (EUR)',
        ImportField.purpose: 'Verwendungszweck',
      },
    );

    test('picks the stored profile whose columns are all present', () {
      const headers = ['Buchungstag', 'Verwendungszweck', 'Betrag (EUR)'];
      expect(matchProfile([giro, detailed], headers)?.id, 2);
      expect(
        matchProfile([giro, detailed], ['Buchungstag', 'Betrag (EUR)'])?.id,
        1,
      );
    });

    test('returns null for an unknown layout', () {
      expect(matchProfile([giro, detailed], ['Date', 'Amount']), isNull);
    });
  });

  group('parseImportRows', () {
    test('turns a German export into signed transactions', () {
      final table = readCsv(decodeText(fixtureBytes('german_giro_cp1252.csv')));
      final rows = parseImportRows(
        table,
        suggestProfile(table, name: 'Bank'),
        accountId: 7,
      );
      expect(rows.every((row) => row.isValid), isTrue);

      final rewe = rows.first.transaction!;
      expect(rewe.accountId, 7);
      expect(rewe.bookingDate, DateTime(2026, 10, 30));
      expect(rewe.amountMinor, -5432);
      expect(rewe.counterparty, 'REWE Markt GmbH');
      expect(rewe.counterpartyIban, 'DE89370400440532013000');
      expect(rows[1].transaction!.amountMinor, 325000);
      expect(rows[3].transaction!.valueDate, DateTime(2026, 10, 16));
    });

    test('gives identical rows in one file different fingerprints', () {
      final table = readCsv(decodeText(fixtureBytes('german_giro_cp1252.csv')));
      final rows = parseImportRows(
        table,
        suggestProfile(table, name: 'Bank'),
        accountId: 7,
      );
      final hashes = rows.map((row) => row.transaction!.dedupHash).toSet();
      expect(hashes, hasLength(rows.length));
    });

    test('fingerprints are stable across imports and differ per account', () {
      final table = readCsv(decodeText(fixtureBytes('german_giro_cp1252.csv')));
      final profile = suggestProfile(table, name: 'Bank');
      List<String?> hashes(int accountId) => parseImportRows(
        table,
        profile,
        accountId: accountId,
      ).map((row) => row.transaction!.dedupHash).toList();
      expect(hashes(7), hashes(7));
      expect(hashes(7), isNot(hashes(8)));
    });

    test('combines debit and credit columns and reports bad rows', () {
      final table = readCsv(
        decodeText(fixtureBytes('english_debit_credit.csv')),
      );
      final rows = parseImportRows(
        table,
        suggestProfile(table, name: 'Bank'),
        accountId: 1,
      );
      expect(rows[0].transaction!.amountMinor, 320000);
      expect(rows[1].transaction!.amountMinor, -4590);
      expect(rows[4].transaction!.amountMinor, 1999);
      expect(rows[3].isValid, isFalse);
      expect(rows[3].issues, [ImportRowIssue.invalidDate]);
      expect(rows[3].rowNumber, 4);
    });

    test('applies the debit indicator and can invert signs', () {
      final table = readCsv(decodeText(fixtureBytes('indicator_utf8.csv')));
      final profile = suggestProfile(table, name: 'Bank');
      final rows = parseImportRows(table, profile, accountId: 1);
      expect(rows[0].transaction!.amountMinor, -98000);
      expect(rows[1].transaction!.amountMinor, 325000);

      final inverted = parseImportRows(
        table,
        profile.copyWith(invertSign: true),
        accountId: 1,
      );
      expect(inverted[0].transaction!.amountMinor, 98000);
    });

    test('reports missing required values', () {
      const table = TableData(
        headers: ['Date', 'Amount'],
        rows: [
          ['', '1,00'],
          ['01.01.2027', ''],
          ['01.01.2027', 'abc'],
        ],
      );
      const profile = ImportProfile(
        name: 'x',
        mapping: {
          ImportField.bookingDate: 'Date',
          ImportField.amount: 'Amount',
        },
      );
      final rows = parseImportRows(table, profile, accountId: 1);
      expect(rows[0].issues, [ImportRowIssue.missingDate]);
      expect(rows[1].issues, [ImportRowIssue.missingAmount]);
      expect(rows[2].issues, [ImportRowIssue.invalidAmount]);
    });
  });
}
