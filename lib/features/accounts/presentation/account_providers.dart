import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/features/accounts/data/drift_account_repository.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';

/// Active accounts.
final accountsProvider = StreamProvider<List<Account>>(
  (ref) => ref.watch(accountRepositoryProvider).watchAll(),
);

/// All accounts including archived ones, for the settings screen.
final allAccountsProvider = StreamProvider<List<Account>>(
  (ref) => ref.watch(accountRepositoryProvider).watchAll(includeArchived: true),
);

final accountBalancesProvider = StreamProvider<List<AccountBalance>>(
  (ref) => ref.watch(accountRepositoryProvider).watchBalances(),
);

String accountKindLabel(AppLocalizations l10n, AccountKind kind) =>
    switch (kind) {
      AccountKind.checking => l10n.accountKindChecking,
      AccountKind.savings => l10n.accountKindSavings,
      AccountKind.cash => l10n.accountKindCash,
      AccountKind.creditCard => l10n.accountKindCreditCard,
      AccountKind.investment => l10n.accountKindInvestment,
    };

IconData accountKindIcon(AccountKind kind) => switch (kind) {
  AccountKind.checking => Icons.account_balance_outlined,
  AccountKind.savings => Icons.savings_outlined,
  AccountKind.cash => Icons.wallet_outlined,
  AccountKind.creditCard => Icons.credit_card_outlined,
  AccountKind.investment => Icons.show_chart,
};
