import 'package:meta/meta.dart';
import 'package:pandabudget/core/entity.dart';

/// What an account is used for.
///
/// [checking], [cash] and [creditCard] are the "active" accounts money moves
/// through day to day; [savings] and [investment] hold what the household
/// owns.
enum AccountKind {
  checking,
  savings,
  cash,
  creditCard,
  investment;

  bool get isAsset => this == savings || this == investment;
}

@immutable
class Account {
  const Account({
    required this.name,
    required this.kind,
    required this.openingDate,
    this.id = kNewId,
    this.iban,
    this.openingBalanceMinor = 0,
    this.isArchived = false,
    this.colorValue = 0xFF6A9A3A,
    this.sortOrder = 0,
  });

  final int id;
  final String name;
  final AccountKind kind;
  final String? iban;
  final int openingBalanceMinor;
  final DateTime openingDate;
  final bool isArchived;
  final int colorValue;
  final int sortOrder;

  bool get isNew => id == kNewId;

  Account copyWith({
    int? id,
    String? name,
    AccountKind? kind,
    String? Function()? iban,
    int? openingBalanceMinor,
    DateTime? openingDate,
    bool? isArchived,
    int? colorValue,
    int? sortOrder,
  }) => Account(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    iban: iban != null ? iban() : this.iban,
    openingBalanceMinor: openingBalanceMinor ?? this.openingBalanceMinor,
    openingDate: openingDate ?? this.openingDate,
    isArchived: isArchived ?? this.isArchived,
    colorValue: colorValue ?? this.colorValue,
    sortOrder: sortOrder ?? this.sortOrder,
  );
}

/// An account together with its current balance (opening balance plus all
/// booked transactions).
@immutable
class AccountBalance {
  const AccountBalance({required this.account, required this.balanceMinor});

  final Account account;
  final int balanceMinor;
}

abstract interface class AccountRepository {
  Stream<List<Account>> watchAll({bool includeArchived = false});

  Stream<List<AccountBalance>> watchBalances();

  Future<Account?> findById(int id);

  /// Inserts or updates [account] and returns its id.
  Future<int> save(Account account);

  /// Deletes the account together with its transactions.
  Future<void> delete(int id);
}
