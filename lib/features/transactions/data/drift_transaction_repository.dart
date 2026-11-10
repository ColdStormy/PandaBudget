import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/time/dates.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/database/database_provider.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => DriftTransactionRepository(ref.watch(appDatabaseProvider)),
);

class DriftTransactionRepository implements TransactionRepository {
  DriftTransactionRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<LedgerTransaction>> watch(
    TransactionFilter filter, {
    int limit = 500,
  }) {
    final query = _db.select(_db.transactions)
      ..where((t) => _matches(t, filter))
      ..orderBy([
        (t) => OrderingTerm.desc(t.bookingDate),
        (t) => OrderingTerm.desc(t.id),
      ])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  Expression<bool> _matches($TransactionsTable t, TransactionFilter filter) {
    final conditions = <Expression<bool>>[
      if (filter.accountId case final accountId?) t.accountId.equals(accountId),
      if (filter.uncategorizedOnly)
        t.categoryId.isNull()
      else if (filter.categoryIds case final ids?)
        t.categoryId.isIn(ids),
      if (filter.from case final from?)
        t.bookingDate.isBiggerOrEqualValue(dayNumber(from)),
      if (filter.to case final to?)
        t.bookingDate.isSmallerOrEqualValue(dayNumber(to)),
      if (filter.minAmountMinor case final min?)
        t.amountMinor.isBiggerOrEqualValue(min),
      if (filter.maxAmountMinor case final max?)
        t.amountMinor.isSmallerOrEqualValue(max),
      // Every word of the query has to appear somewhere in the texts.
      for (final word in filter.query.trim().split(RegExp(r'\s+')))
        if (word.isNotEmpty)
          () {
            final pattern = '%${_escapeLike(word)}%';
            return t.counterparty.like(pattern, escapeChar: r'\') |
                t.purpose.like(pattern, escapeChar: r'\') |
                t.note.like(pattern, escapeChar: r'\');
          }(),
    ];
    return conditions.isEmpty
        ? const Constant(true)
        : Expression.and(conditions);
  }

  static String _escapeLike(String text) => text
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');

  @override
  Stream<List<LedgerTransaction>> watchRange(DateTime from, DateTime to) {
    final query = _db.select(_db.transactions)
      ..where(
        (t) =>
            t.bookingDate.isBiggerOrEqualValue(dayNumber(from)) &
            t.bookingDate.isSmallerOrEqualValue(dayNumber(to)),
      )
      ..orderBy([
        (t) => OrderingTerm.desc(t.bookingDate),
        (t) => OrderingTerm.desc(t.id),
      ]);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<List<LedgerTransaction>> getAll({
    bool uncategorizedOnly = false,
  }) async {
    final query = _db.select(_db.transactions);
    if (uncategorizedOnly) query.where((t) => t.categoryId.isNull());
    final rows = await query.get();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<LedgerTransaction?> findById(int id) async {
    final row = await (_db.select(
      _db.transactions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<int> save(LedgerTransaction transaction) async {
    final id = await _db
        .into(_db.transactions)
        .insertOnConflictUpdate(_toCompanion(transaction));
    return transaction.isNew ? id : transaction.id;
  }

  @override
  Future<void> saveAll(List<LedgerTransaction> transactions) => _db.batch(
    (batch) => batch.insertAllOnConflictUpdate(
      _db.transactions,
      transactions.map(_toCompanion).toList(),
    ),
  );

  @override
  Future<void> delete(int id) =>
      (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();

  @override
  Future<Set<String>> existingHashes(int accountId, Set<String> hashes) async {
    if (hashes.isEmpty) return const {};
    final found = <String>{};
    // Stay well below SQLite's limit on bound variables per statement.
    final all = hashes.toList();
    for (var start = 0; start < all.length; start += 500) {
      final chunk = all.skip(start).take(500);
      final query = _db.selectOnly(_db.transactions)
        ..addColumns([_db.transactions.dedupHash])
        ..where(
          _db.transactions.accountId.equals(accountId) &
              _db.transactions.dedupHash.isIn(chunk),
        );
      final rows = await query.get();
      found.addAll(rows.map((row) => row.read(_db.transactions.dedupHash)!));
    }
    return found;
  }

  @override
  Future<int> deleteByImportBatch(int batchId) => (_db.delete(
    _db.transactions,
  )..where((t) => t.importBatchId.equals(batchId))).go();

  static TransactionsCompanion _toCompanion(LedgerTransaction t) =>
      TransactionsCompanion(
        id: t.isNew ? const Value.absent() : Value(t.id),
        accountId: Value(t.accountId),
        bookingDate: Value(t.bookingDate),
        valueDate: Value(t.valueDate),
        amountMinor: Value(t.amountMinor),
        counterparty: Value(t.counterparty),
        purpose: Value(t.purpose),
        counterpartyIban: Value(t.counterpartyIban),
        categoryId: Value(t.categoryId),
        categorySource: Value(t.categorySource),
        ruleId: Value(t.ruleId),
        trainedCategoryId: Value(t.trainedCategoryId),
        note: Value(t.note),
        importBatchId: Value(t.importBatchId),
        dedupHash: Value(t.dedupHash),
      );

  static LedgerTransaction _toEntity(TransactionRow row) => LedgerTransaction(
    id: row.id,
    accountId: row.accountId,
    bookingDate: row.bookingDate,
    valueDate: row.valueDate,
    amountMinor: row.amountMinor,
    counterparty: row.counterparty,
    purpose: row.purpose,
    counterpartyIban: row.counterpartyIban,
    categoryId: row.categoryId,
    categorySource: row.categorySource,
    ruleId: row.ruleId,
    trainedCategoryId: row.trainedCategoryId,
    note: row.note,
    importBatchId: row.importBatchId,
    dedupHash: row.dedupHash,
  );
}
