import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/page_widgets.dart';
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

    void add() => context.push(Routes.accountEdit());

    return Scaffold(
      appBar: SubpageBar(title: l10n.accounts),
      body: AsyncView(
        value: accounts,
        builder: (accounts) {
          if (accounts.isEmpty) {
            return EmptyState(
              icon: Icons.account_balance_outlined,
              title: l10n.noAccountsTitle,
              message: l10n.noAccountsMessage,
              action: FilledButton(
                onPressed: add,
                child: Text(l10n.addAccount),
              ),
            );
          }
          return PageBody(
            children: [
              for (final account in accounts)
                PandaListRow(
                  leading: ColorAvatar(
                    color: Color(account.colorValue),
                    icon: accountKindIcon(account.kind),
                  ),
                  title: account.name,
                  subtitle: account.isArchived
                      ? '${accountKindLabel(l10n, account.kind)} · '
                            '${l10n.archived}'
                      : accountKindLabel(l10n, account.kind),
                  amountMinor: balances[account.id],
                  onTap: () => context.push(Routes.accountEdit(account.id)),
                ),
              gapSm,
              AddLink(label: l10n.addAccount, onPressed: add),
            ],
          );
        },
      ),
    );
  }
}
