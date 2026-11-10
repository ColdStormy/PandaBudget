import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:pandabudget/core/money/money_format.dart';
import 'package:pandabudget/core/time/dates.dart';
import 'package:pandabudget/features/importing/domain/field_parsers.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';
import 'package:pandabudget/features/importing/domain/table_reader.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

enum ImportRowIssue { missingDate, invalidDate, missingAmount, invalidAmount }

/// One row of a bank file after applying an [ImportProfile].
@immutable
class ParsedImportRow {
  const ParsedImportRow({
    required this.rowNumber,
    required this.cells,
    this.transaction,
    this.issues = const [],
  });

  /// One-based position in the table, for messages shown to the user.
  final int rowNumber;
  final List<String> cells;

  /// Set when the row could be read without [issues].
  final LedgerTransaction? transaction;
  final List<ImportRowIssue> issues;

  bool get isValid => transaction != null;
}

/// Converts the rows of [table] into transactions for [accountId] using the
/// column mapping and formats of [profile].
List<ParsedImportRow> parseImportRows(
  TableData table,
  ImportProfile profile, {
  required int accountId,
}) {
  int column(ImportField field) => table.columnOf(profile.mapping[field] ?? '');

  final dateColumn = column(ImportField.bookingDate);
  final valueDateColumn = column(ImportField.valueDate);
  final amountColumn = column(ImportField.amount);
  final debitColumn = column(ImportField.debit);
  final creditColumn = column(ImportField.credit);
  final indicatorColumn = column(ImportField.indicator);
  final counterpartyColumn = column(ImportField.counterparty);
  final purposeColumn = column(ImportField.purpose);
  final ibanColumn = column(ImportField.counterpartyIban);
  final noteColumn = column(ImportField.note);

  final debitIndicators = profile.debitIndicators
      .split(',')
      .map((value) => value.trim().toLowerCase())
      .where((value) => value.isNotEmpty)
      .toSet();

  String cell(List<String> row, int index) => index < 0 ? '' : row[index];
  int? amountOf(String text) =>
      parseAmount(text, decimalSeparator: profile.decimalSeparator);

  final seen = <String, int>{};
  final result = <ParsedImportRow>[];
  for (final (index, row) in table.rows.indexed) {
    final issues = <ImportRowIssue>[];

    final dateText = cell(row, dateColumn);
    final date = parseDate(dateText, profile.dateFormat);
    if (dateText.isEmpty) {
      issues.add(ImportRowIssue.missingDate);
    } else if (date == null) {
      issues.add(ImportRowIssue.invalidDate);
    }

    int? amount;
    switch (profile.amountMode) {
      case AmountMode.signed:
        final text = cell(row, amountColumn);
        amount = amountOf(text);
        if (text.isEmpty) {
          issues.add(ImportRowIssue.missingAmount);
        } else if (amount == null) {
          issues.add(ImportRowIssue.invalidAmount);
        }
      case AmountMode.debitCredit:
        final debitText = cell(row, debitColumn);
        final creditText = cell(row, creditColumn);
        final debit = amountOf(debitText);
        final credit = amountOf(creditText);
        if (debitText.isEmpty && creditText.isEmpty) {
          issues.add(ImportRowIssue.missingAmount);
        } else if ((debitText.isNotEmpty && debit == null) ||
            (creditText.isNotEmpty && credit == null)) {
          issues.add(ImportRowIssue.invalidAmount);
        } else {
          amount = (credit ?? 0).abs() - (debit ?? 0).abs();
        }
      case AmountMode.indicator:
        final text = cell(row, amountColumn);
        final value = amountOf(text);
        if (text.isEmpty) {
          issues.add(ImportRowIssue.missingAmount);
        } else if (value == null) {
          issues.add(ImportRowIssue.invalidAmount);
        } else {
          final isDebit = debitIndicators.contains(
            cell(row, indicatorColumn).trim().toLowerCase(),
          );
          amount = isDebit ? -value.abs() : value.abs();
        }
    }
    if (amount != null && profile.invertSign) amount = -amount;

    if (issues.isNotEmpty || date == null || amount == null) {
      result.add(
        ParsedImportRow(rowNumber: index + 1, cells: row, issues: issues),
      );
      continue;
    }

    final counterparty = _collapse(cell(row, counterpartyColumn));
    final purpose = _collapse(cell(row, purposeColumn));
    final iban = cell(row, ibanColumn).replaceAll(' ', '');

    // Two identical rows in one file are two real payments (two coffees on
    // the same day), so the fingerprint includes how often it has occurred.
    final base = [
      accountId,
      dayNumber(date),
      amount,
      counterparty.toLowerCase(),
      purpose.toLowerCase(),
    ].join('|');
    final occurrence = seen[base] = (seen[base] ?? 0) + 1;
    final hash = sha1.convert(utf8.encode('$base|$occurrence')).toString();

    result.add(
      ParsedImportRow(
        rowNumber: index + 1,
        cells: row,
        transaction: LedgerTransaction(
          accountId: accountId,
          bookingDate: date,
          valueDate: parseDate(cell(row, valueDateColumn), profile.dateFormat),
          amountMinor: amount,
          counterparty: counterparty,
          purpose: purpose,
          counterpartyIban: iban.isEmpty ? null : iban,
          note: cell(row, noteColumn),
          dedupHash: hash,
        ),
      ),
    );
  }
  return result;
}

/// Bank exports pad fields with runs of spaces; collapse them.
String _collapse(String text) => text.replaceAll(RegExp(r'\s+'), ' ').trim();
