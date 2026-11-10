import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/database/database_provider.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => DriftAccountRepository(ref.watch(appDatabaseProvider)),
);

class DriftAccountRepository implements AccountRepository {
  DriftAccountRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Account>> watchAll({bool includeArchived = false}) {
    final query = _db.select(_db.accounts)
      ..orderBy([
        (a) => OrderingTerm(expression: a.sortOrder),
        (a) => OrderingTerm(expression: a.name),
      ]);
    if (!includeArchived) query.where((a) => a.isArchived.not());
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Stream<List<AccountBalance>> watchBalances() {
    final booked = _db.transactions.amountMinor.sum();
    final query =
        _db.select(_db.accounts).join([
            leftOuterJoin(
              _db.transactions,
              _db.transactions.accountId.equalsExp(_db.accounts.id),
              useColumns: false,
            ),
          ])
          ..addColumns([booked])
          ..where(_db.accounts.isArchived.not())
          ..groupBy([_db.accounts.id])
          ..orderBy([
            OrderingTerm(expression: _db.accounts.sortOrder),
            OrderingTerm(expression: _db.accounts.name),
          ]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          () {
            final account = _toEntity(row.readTable(_db.accounts));
            return AccountBalance(
              account: account,
              balanceMinor:
                  account.openingBalanceMinor + (row.read(booked) ?? 0),
            );
          }(),
      ],
    );
  }

  @override
  Future<Account?> findById(int id) async {
    final row = await (_db.select(
      _db.accounts,
    )..where((a) => a.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<int> save(Account account) async {
    final companion = AccountsCompanion(
      id: account.isNew ? const Value.absent() : Value(account.id),
      name: Value(account.name),
      kind: Value(account.kind),
      iban: Value(account.iban),
      openingBalanceMinor: Value(account.openingBalanceMinor),
      openingDate: Value(account.openingDate),
      isArchived: Value(account.isArchived),
      colorValue: Value(account.colorValue),
      sortOrder: Value(account.sortOrder),
    );
    final id = await _db.into(_db.accounts).insertOnConflictUpdate(companion);
    return account.isNew ? id : account.id;
  }

  @override
  Future<void> delete(int id) =>
      (_db.delete(_db.accounts)..where((a) => a.id.equals(id))).go();

  static Account _toEntity(AccountRow row) => Account(
    id: row.id,
    name: row.name,
    kind: row.kind,
    iban: row.iban,
    openingBalanceMinor: row.openingBalanceMinor,
    openingDate: row.openingDate,
    isArchived: row.isArchived,
    colorValue: row.colorValue,
    sortOrder: row.sortOrder,
  );
}
