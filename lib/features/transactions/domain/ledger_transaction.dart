import 'package:meta/meta.dart';
import 'package:pandabudget/core/entity.dart';

/// How a transaction got its category.
enum CategorySource {
  /// Not categorised yet.
  none,

  /// Assigned by a user-defined rule.
  rule,

  /// Suggested by the learning classifier.
  learned,

  /// Chosen by the user.
  manual,
}

/// A single booked movement on an account.
///
/// [amountMinor] is signed: negative for money leaving the account.
@immutable
class LedgerTransaction {
  const LedgerTransaction({
    required this.accountId,
    required this.bookingDate,
    required this.amountMinor,
    this.id = kNewId,
    this.valueDate,
    this.counterparty = '',
    this.purpose = '',
    this.counterpartyIban,
    this.categoryId,
    this.categorySource = CategorySource.none,
    this.ruleId,
    this.trainedCategoryId,
    this.note = '',
    this.importBatchId,
    this.dedupHash,
  });

  final int id;
  final int accountId;
  final DateTime bookingDate;
  final DateTime? valueDate;
  final int amountMinor;
  final String counterparty;
  final String purpose;
  final String? counterpartyIban;
  final int? categoryId;
  final CategorySource categorySource;

  /// The rule that assigned the category when the source is
  /// [CategorySource.rule].
  final int? ruleId;

  /// The category this transaction was last fed to the classifier with, so
  /// it can be unlearned exactly when the category changes.
  final int? trainedCategoryId;
  final String note;
  final int? importBatchId;

  /// Fingerprint used to skip rows that were imported before.
  final String? dedupHash;

  bool get isNew => id == kNewId;

  bool get isExpense => amountMinor < 0;

  /// The best short label for lists: counterparty, else purpose.
  String get title => counterparty.isNotEmpty ? counterparty : purpose;

  LedgerTransaction copyWith({
    int? id,
    int? accountId,
    DateTime? bookingDate,
    DateTime? Function()? valueDate,
    int? amountMinor,
    String? counterparty,
    String? purpose,
    String? Function()? counterpartyIban,
    int? Function()? categoryId,
    CategorySource? categorySource,
    int? Function()? ruleId,
    int? Function()? trainedCategoryId,
    String? note,
    int? Function()? importBatchId,
    String? Function()? dedupHash,
  }) => LedgerTransaction(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    bookingDate: bookingDate ?? this.bookingDate,
    valueDate: valueDate != null ? valueDate() : this.valueDate,
    amountMinor: amountMinor ?? this.amountMinor,
    counterparty: counterparty ?? this.counterparty,
    purpose: purpose ?? this.purpose,
    counterpartyIban: counterpartyIban != null
        ? counterpartyIban()
        : this.counterpartyIban,
    categoryId: categoryId != null ? categoryId() : this.categoryId,
    categorySource: categorySource ?? this.categorySource,
    ruleId: ruleId != null ? ruleId() : this.ruleId,
    trainedCategoryId: trainedCategoryId != null
        ? trainedCategoryId()
        : this.trainedCategoryId,
    note: note ?? this.note,
    importBatchId: importBatchId != null ? importBatchId() : this.importBatchId,
    dedupHash: dedupHash != null ? dedupHash() : this.dedupHash,
  );
}

/// Criteria for listing and searching transactions. Unset fields match all.
@immutable
class TransactionFilter {
  const TransactionFilter({
    this.query = '',
    this.accountId,
    this.categoryIds,
    this.uncategorizedOnly = false,
    this.from,
    this.to,
    this.minAmountMinor,
    this.maxAmountMinor,
  });

  /// Free text matched against counterparty, purpose and note.
  final String query;
  final int? accountId;
  final Set<int>? categoryIds;
  final bool uncategorizedOnly;

  /// Inclusive date range.
  final DateTime? from;
  final DateTime? to;

  /// Inclusive range on the signed amount.
  final int? minAmountMinor;
  final int? maxAmountMinor;

  bool get isEmpty =>
      query.isEmpty &&
      accountId == null &&
      categoryIds == null &&
      !uncategorizedOnly &&
      from == null &&
      to == null &&
      minAmountMinor == null &&
      maxAmountMinor == null;

  /// Number of active criteria besides the text query.
  int get activeCount => [
    accountId != null,
    categoryIds != null || uncategorizedOnly,
    from != null || to != null,
    minAmountMinor != null || maxAmountMinor != null,
  ].where((active) => active).length;

  TransactionFilter copyWith({
    String? query,
    int? Function()? accountId,
    Set<int>? Function()? categoryIds,
    bool? uncategorizedOnly,
    DateTime? Function()? from,
    DateTime? Function()? to,
    int? Function()? minAmountMinor,
    int? Function()? maxAmountMinor,
  }) => TransactionFilter(
    query: query ?? this.query,
    accountId: accountId != null ? accountId() : this.accountId,
    categoryIds: categoryIds != null ? categoryIds() : this.categoryIds,
    uncategorizedOnly: uncategorizedOnly ?? this.uncategorizedOnly,
    from: from != null ? from() : this.from,
    to: to != null ? to() : this.to,
    minAmountMinor: minAmountMinor != null
        ? minAmountMinor()
        : this.minAmountMinor,
    maxAmountMinor: maxAmountMinor != null
        ? maxAmountMinor()
        : this.maxAmountMinor,
  );
}

abstract interface class TransactionRepository {
  /// Newest first.
  Stream<List<LedgerTransaction>> watch(
    TransactionFilter filter, {
    int limit = 500,
  });

  /// All transactions booked between [from] and [to] (inclusive).
  Stream<List<LedgerTransaction>> watchRange(DateTime from, DateTime to);

  Future<List<LedgerTransaction>> getAll({bool uncategorizedOnly = false});

  Future<LedgerTransaction?> findById(int id);

  Future<int> save(LedgerTransaction transaction);

  /// Inserts new and updates existing transactions in one batch.
  Future<void> saveAll(List<LedgerTransaction> transactions);

  Future<void> delete(int id);

  /// Which of [hashes] already exist on [accountId].
  Future<Set<String>> existingHashes(int accountId, Set<String> hashes);

  /// Deletes all transactions an import added; returns how many.
  Future<int> deleteByImportBatch(int batchId);
}
