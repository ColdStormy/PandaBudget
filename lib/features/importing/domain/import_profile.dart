import 'package:meta/meta.dart';
import 'package:pandabudget/core/entity.dart';

enum ImportFileType { csv, json }

enum TextEncoding { auto, utf8, latin1 }

/// How a bank file expresses whether money came in or went out.
enum AmountMode {
  /// One column with a signed amount.
  signed,

  /// Separate columns for outgoing (debit) and incoming (credit) amounts.
  debitCredit,

  /// One unsigned amount column plus a column that says debit or credit.
  indicator,
}

/// The transaction attributes a file column can be mapped to.
enum ImportField {
  bookingDate,
  valueDate,
  amount,
  debit,
  credit,
  indicator,
  counterparty,
  purpose,
  counterpartyIban,
  note,
}

/// A saved description of one bank's export format, so a file from that bank
/// can be imported again without mapping its columns each time.
@immutable
class ImportProfile {
  const ImportProfile({
    required this.name,
    this.id = kNewId,
    this.fileType = ImportFileType.csv,
    this.delimiter = '',
    this.encoding = TextEncoding.auto,
    this.headerRow = autoHeaderRow,
    this.dateFormat = 'dd.MM.yyyy',
    this.decimalSeparator = ',',
    this.amountMode = AmountMode.signed,
    this.mapping = const {},
    this.invertSign = false,
    this.debitIndicators = defaultDebitIndicators,
    this.jsonRootPath = '',
  });

  static const int autoHeaderRow = -1;
  static const String defaultDebitIndicators = 'S,D,Soll,Debit,DBIT,-';

  final int id;

  /// Usually the bank's name.
  final String name;
  final ImportFileType fileType;

  /// Field separator for CSV files; empty means "detect".
  final String delimiter;
  final TextEncoding encoding;

  /// Zero-based line of the header row, or [autoHeaderRow] to detect it.
  /// Banks often put a few lines of account information above the table.
  final int headerRow;

  /// Pattern built from `dd`, `MM`, `yyyy` and `yy`.
  final String dateFormat;
  final String decimalSeparator;
  final AmountMode amountMode;

  /// Which column (by header name, or JSON key path) feeds which field.
  final Map<ImportField, String> mapping;

  /// For exports that list charges as positive numbers (some credit cards).
  final bool invertSign;

  /// Comma-separated values of the indicator column that mean "debit".
  final String debitIndicators;

  /// Dotted path to the transaction array in a JSON file; empty to detect.
  final String jsonRootPath;

  bool get isNew => id == kNewId;

  /// Fields that must be mapped for this profile's [amountMode].
  Set<ImportField> get requiredFields => {
    ImportField.bookingDate,
    ...switch (amountMode) {
      AmountMode.signed => {ImportField.amount},
      AmountMode.debitCredit => {ImportField.debit, ImportField.credit},
      AmountMode.indicator => {ImportField.amount, ImportField.indicator},
    },
  };

  /// Fields that can be mapped for this profile's [amountMode].
  List<ImportField> get availableFields => [
    ImportField.bookingDate,
    ImportField.valueDate,
    ...switch (amountMode) {
      AmountMode.signed => [ImportField.amount],
      AmountMode.debitCredit => [ImportField.debit, ImportField.credit],
      AmountMode.indicator => [ImportField.amount, ImportField.indicator],
    },
    ImportField.counterparty,
    ImportField.purpose,
    ImportField.counterpartyIban,
    ImportField.note,
  ];

  bool get isComplete =>
      requiredFields.every((field) => (mapping[field] ?? '').isNotEmpty);

  /// Whether a file with these [headers] has every column this profile maps.
  bool matchesHeaders(Iterable<String> headers) {
    if (!isComplete) return false;
    final available = headers.toSet();
    return availableFields
        .map((field) => mapping[field] ?? '')
        .where((column) => column.isNotEmpty)
        .every(available.contains);
  }

  ImportProfile copyWith({
    int? id,
    String? name,
    ImportFileType? fileType,
    String? delimiter,
    TextEncoding? encoding,
    int? headerRow,
    String? dateFormat,
    String? decimalSeparator,
    AmountMode? amountMode,
    Map<ImportField, String>? mapping,
    bool? invertSign,
    String? debitIndicators,
    String? jsonRootPath,
  }) => ImportProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    fileType: fileType ?? this.fileType,
    delimiter: delimiter ?? this.delimiter,
    encoding: encoding ?? this.encoding,
    headerRow: headerRow ?? this.headerRow,
    dateFormat: dateFormat ?? this.dateFormat,
    decimalSeparator: decimalSeparator ?? this.decimalSeparator,
    amountMode: amountMode ?? this.amountMode,
    mapping: mapping ?? this.mapping,
    invertSign: invertSign ?? this.invertSign,
    debitIndicators: debitIndicators ?? this.debitIndicators,
    jsonRootPath: jsonRootPath ?? this.jsonRootPath,
  );
}

/// One finished import run. Kept so an import can be undone as a whole.
@immutable
class ImportBatch {
  const ImportBatch({
    required this.accountId,
    required this.fileName,
    required this.importedAt,
    this.id = kNewId,
    this.profileId,
    this.importedCount = 0,
    this.duplicateCount = 0,
  });

  final int id;
  final int accountId;
  final int? profileId;
  final String fileName;
  final DateTime importedAt;
  final int importedCount;
  final int duplicateCount;
}

abstract interface class ImportProfileRepository {
  Stream<List<ImportProfile>> watchAll();

  Future<List<ImportProfile>> getAll();

  Future<int> save(ImportProfile profile);

  Future<void> delete(int id);
}

abstract interface class ImportBatchRepository {
  Stream<List<ImportBatch>> watchAll();

  Future<int> create(ImportBatch batch);

  /// Removes the batch record. Its transactions are deleted by the caller so
  /// the classifier can unlearn them first.
  Future<void> delete(int id);
}
