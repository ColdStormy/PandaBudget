import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';
import 'package:pandabudget/features/accounts/presentation/account_providers.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final accounts = ref.watch(allAccountsProvider);
    final balances = {
      for (final balance
          in ref.watch(accountBalancesProvider).value ??
              const <AccountBalance>[])
        balance.account.id: balance.balanceMinor,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accounts)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.accountEdit()),
        icon: const Icon(Icons.add),
        label: Text(l10n.addAccount),
      ),
      body: AsyncView(
        value: accounts,
        builder: (accounts) {
          if (accounts.isEmpty) {
            return EmptyState(
              icon: Icons.account_balance_outlined,
              title: l10n.noAccountsTitle,
              message: l10n.noAccountsMessage,
            );
          }
          return PageBody(
            children: [
              Card(
                child: Column(
                  children: [
                    for (final (index, account) in accounts.indexed) ...[
                      if (index > 0) const Divider(indent: Insets.md),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Insets.md,
                          vertical: Insets.xs,
                        ),
                        leading: ColorAvatar(
                          color: Color(account.colorValue),
                          icon: accountKindIcon(account.kind),
                        ),
                        title: Text(account.name),
                        subtitle: Text(
                          account.isArchived
                              ? '${accountKindLabel(l10n, account.kind)} · '
                                    '${l10n.archived}'
                              : accountKindLabel(l10n, account.kind),
                        ),
                        trailing: balances[account.id] == null
                            ? null
                            : AmountText(
                                balances[account.id]!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                        onTap: () =>
                            context.push(Routes.accountEdit(account.id)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
