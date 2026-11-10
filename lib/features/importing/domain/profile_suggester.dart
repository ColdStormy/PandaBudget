import 'package:pandabudget/features/importing/domain/field_parsers.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';
import 'package:pandabudget/features/importing/domain/table_reader.dart';

/// Header names (normalised) that typically carry each field, most specific
/// first. Covers common German and English bank exports.
const Map<ImportField, List<String>> _synonyms = {
  ImportField.bookingDate: [
    'buchungstag',
    'buchungsdatum',
    'bookingdate',
    'transactiondate',
    'posteddate',
    'buchung',
    'datum',
    'date',
  ],
  ImportField.valueDate: [
    'valutadatum',
    'wertstellung',
    'wertstellungstag',
    'valuedate',
    'valuta',
  ],
  ImportField.debit: [
    'soll',
    'debit',
    'belastung',
    'ausgang',
    'withdrawal',
    'paidout',
    'moneyout',
  ],
  ImportField.credit: [
    'haben',
    'credit',
    'gutschrift',
    'eingang',
    'deposit',
    'paidin',
    'moneyin',
  ],
  ImportField.indicator: [
    'sollhaben',
    'creditdebitindicator',
    'debitcredit',
    'creditdebit',
    'cdtdbtind',
  ],
  ImportField.amount: [
    'betrag',
    'betrageur',
    'umsatz',
    'amount',
    'transactionamount',
    'value',
  ],
  ImportField.counterparty: [
    'beguenstigterzahlungspflichtiger',
    'namezahlungsbeteiligter',
    'auftraggeberempfaenger',
    'zahlungsempfaenger',
    'zahlungspflichtiger',
    'empfaenger',
    'auftraggeber',
    'counterparty',
    'payee',
    'merchant',
    'partnername',
    'name',
  ],
  ImportField.purpose: [
    'verwendungszweck',
    'buchungstext',
    'remittanceinformation',
    'purpose',
    'description',
    'reference',
    'memo',
    'details',
    'zweck',
    'text',
  ],
  ImportField.counterpartyIban: [
    'ibanzahlungsbeteiligter',
    'counterpartyiban',
    'kontonummeriban',
    'iban',
    'kontonummer',
    'accountnumber',
  ],
  ImportField.note: ['notiz', 'kommentar', 'note', 'comment'],
};

/// Lower-cases [header], transliterates umlauts and drops everything that is
/// not a letter or digit, so "Begünstigter/Zahlungspflichtiger" and
/// "beguenstigter zahlungspflichtiger" compare equal.
String normalizeHeader(String header) => header
    .toLowerCase()
    .replaceAll('ä', 'ae')
    .replaceAll('ö', 'oe')
    .replaceAll('ü', 'ue')
    .replaceAll('ß', 'ss')
    .replaceAll(RegExp('[^a-z0-9]'), '');

/// Proposes a profile for a file nobody has imported before.
///
/// Columns are matched to fields by their header names, the amount layout is
/// derived from which amount-like columns exist, and date format and decimal
/// separator are detected from the data. The user reviews and corrects the
/// result before it is saved.
ImportProfile suggestProfile(
  TableData table, {
  required String name,
  ImportFileType fileType = ImportFileType.csv,
}) {
  final normalized = {
    for (final header in table.headers) header: normalizeHeader(header),
  };
  final used = <String>{};
  final mapping = <ImportField, String>{};

  String? find(ImportField field) {
    final candidates = _synonyms[field]!;
    // Exact header matches win over partial ones.
    for (final exact in [true, false]) {
      for (final candidate in candidates) {
        for (final MapEntry(key: header, value: norm) in normalized.entries) {
          if (used.contains(header)) continue;
          // The account's own IBAN is not the counterparty's.
          if (field == ImportField.counterpartyIban &&
              norm.contains('auftragskonto')) {
            continue;
          }
          if (exact ? norm == candidate : norm.contains(candidate)) {
            return header;
          }
        }
      }
    }
    return null;
  }

  void assign(ImportField field) {
    final header = find(field);
    if (header != null) {
      mapping[field] = header;
      used.add(header);
    }
  }

  // Order matters: specific fields claim their columns before generic ones.
  [
    ImportField.valueDate,
    ImportField.bookingDate,
    ImportField.indicator,
    ImportField.amount,
  ].forEach(assign);
  // Only look for separate debit/credit columns if there is no single
  // amount column; otherwise names like "creditorName" would be taken.
  if (!mapping.containsKey(ImportField.amount)) {
    [ImportField.debit, ImportField.credit].forEach(assign);
  }
  [
    ImportField.counterpartyIban,
    ImportField.counterparty,
    ImportField.purpose,
    ImportField.note,
  ].forEach(assign);

  final AmountMode amountMode;
  if (mapping.containsKey(ImportField.amount) &&
      mapping.containsKey(ImportField.indicator)) {
    amountMode = AmountMode.indicator;
  } else if (mapping.containsKey(ImportField.amount)) {
    amountMode = AmountMode.signed;
  } else if (mapping.containsKey(ImportField.debit) &&
      mapping.containsKey(ImportField.credit)) {
    amountMode = AmountMode.debitCredit;
  } else {
    amountMode = AmountMode.signed;
  }

  final dateColumn = mapping[ImportField.bookingDate];
  final amountColumns = [
    mapping[ImportField.amount],
    mapping[ImportField.debit],
    mapping[ImportField.credit],
  ].nonNulls;

  final draft = ImportProfile(
    name: name,
    fileType: fileType,
    amountMode: amountMode,
    mapping: mapping,
    dateFormat:
        (dateColumn == null
            ? null
            : detectDateFormat(table.samples(dateColumn))) ??
        'dd.MM.yyyy',
    decimalSeparator: detectDecimalSeparator(
      amountColumns.expand(table.samples),
    ),
  );
  // Keep only the mappings that apply to the chosen amount layout.
  return draft.copyWith(
    mapping: {
      for (final field in draft.availableFields)
        if (mapping[field] != null) field: mapping[field]!,
    },
  );
}

/// The saved profile that fits a file with these [headers] best, if any.
ImportProfile? matchProfile(
  Iterable<ImportProfile> profiles,
  List<String> headers, {
  ImportFileType? fileType,
}) {
  ImportProfile? best;
  for (final profile in profiles) {
    if (fileType != null && profile.fileType != fileType) continue;
    if (!profile.matchesHeaders(headers)) continue;
    if (best == null || profile.mapping.length > best.mapping.length) {
      best = profile;
    }
  }
  return best;
}
