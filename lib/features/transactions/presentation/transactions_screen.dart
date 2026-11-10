import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/time/clock.dart';
import 'package:pandabudget/core/time/dates.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';
import 'package:pandabudget/features/accounts/presentation/account_providers.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/categorization/application/categorization_service.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';
import 'package:pandabudget/features/transactions/presentation/transaction_providers.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filter = ref.watch(transactionFilterProvider);
    final transactions = ref.watch(filteredTransactionsProvider);
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final tree = ref.watch(categoryTreeProvider);
    final setFilter = ref.read(transactionFilterProvider.notifier).set;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navTransactions),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(Routes.importWizard),
            icon: const Icon(Icons.upload_file_outlined),
            label: Text(l10n.importShort),
          ),
          gapSm,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addTransaction,
        onPressed: () => context.push(Routes.transactionEdit()),
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Insets.md,
                  Insets.xs,
                  Insets.md,
                  Insets.sm,
                ),
                child: TextField(
                  controller: _search,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: l10n.searchTransactions,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: filter.query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: l10n.clear,
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _search.clear();
                              setFilter(filter.copyWith(query: ''));
                            },
                          ),
                  ),
                  onChanged: (value) =>
                      setFilter(filter.copyWith(query: value)),
                ),
              ),
              _FilterBar(filter: filter, accounts: accounts, tree: tree),
              Expanded(
                child: AsyncView(
                  value: transactions,
                  builder: (transactions) {
                    if (transactions.isEmpty) {
                      return filter.isEmpty
                          ? EmptyState(
                              icon: Icons.receipt_long_outlined,
                              title: l10n.noTransactionsTitle,
                              message: l10n.noTransactionsMessage,
                              action: FilledButton.icon(
                                onPressed: () =>
                                    context.push(Routes.importWizard),
                                icon: const Icon(Icons.upload_file_outlined),
                                label: Text(l10n.importBankFile),
                              ),
                            )
                          : EmptyState(
                              icon: Icons.search_off,
                              title: l10n.noTransactionsFound,
                            );
                    }
                    return _TransactionList(
                      transactions: transactions,
                      showAccount: accounts.length > 1,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Period { all, thisMonth, lastMonth, thisYear }

class _FilterBar extends ConsumerWidget {
  const _FilterBar({
    required this.filter,
    required this.accounts,
    required this.tree,
  });

  final TransactionFilter filter;
  final List<Account> accounts;
  final CategoryTree tree;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final controller = ref.read(transactionFilterProvider.notifier);
    final today = dateOnly(ref.watch(clockProvider)());
    final thisMonth = YearMonth.of(today);

    final account = accounts.firstWhereOrNull((a) => a.id == filter.accountId);
    // The filter holds a category plus its sub-categories; the first id is
    // the one the user picked.
    final category = tree[filter.categoryIds?.firstOrNull];

    _Period period() {
      if (filter.from == null && filter.to == null) return _Period.all;
      if (filter.from == thisMonth.firstDay && filter.to == thisMonth.lastDay) {
        return _Period.thisMonth;
      }
      if (filter.from == thisMonth.previous.firstDay &&
          filter.to == thisMonth.previous.lastDay) {
        return _Period.lastMonth;
      }
      return _Period.thisYear;
    }

    String periodLabel(_Period value) => switch (value) {
      _Period.all => l10n.periodAll,
      _Period.thisMonth => l10n.periodThisMonth,
      _Period.lastMonth => l10n.periodLastMonth,
      _Period.thisYear => l10n.periodThisYear,
    };

    void setPeriod(_Period value) {
      final (DateTime? from, DateTime? to) = switch (value) {
        _Period.all => (null, null),
        _Period.thisMonth => (thisMonth.firstDay, thisMonth.lastDay),
        _Period.lastMonth => (
          thisMonth.previous.firstDay,
          thisMonth.previous.lastDay,
        ),
        _Period.thisYear => (
          DateTime(today.year),
          DateTime(today.year, 12, 31),
        ),
      };
      controller.set(filter.copyWith(from: () => from, to: () => to));
    }

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Insets.md),
        children: [
          PopupMenuButton<_Period>(
            tooltip: l10n.period,
            onSelected: setPeriod,
            itemBuilder: (context) => [
              for (final value in _Period.values)
                PopupMenuItem(value: value, child: Text(periodLabel(value))),
            ],
            child: _MenuChip(
              icon: Icons.calendar_today_outlined,
              label: periodLabel(period()),
              selected: period() != _Period.all,
            ),
          ),
          gapSm,
          if (accounts.length > 1) ...[
            PopupMenuButton<int>(
              tooltip: l10n.account,
              onSelected: (id) => controller.set(
                filter.copyWith(accountId: () => id == 0 ? null : id),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(value: 0, child: Text(l10n.allAccounts)),
                for (final account in accounts)
                  PopupMenuItem(value: account.id, child: Text(account.name)),
              ],
              child: _MenuChip(
                icon: Icons.account_balance_outlined,
                label: account?.name ?? l10n.allAccounts,
                selected: account != null,
              ),
            ),
            gapSm,
          ],
          Center(
            child: InputChip(
              avatar: const Icon(Icons.label_outline, size: 18),
              label: Text(category?.name ?? l10n.category),
              selected: category != null,
              showCheckmark: false,
              onDeleted: category == null
                  ? null
                  : () => controller.set(
                      filter.copyWith(categoryIds: () => null),
                    ),
              onPressed: () async {
                final picked = await showCategoryPicker(context);
                if (picked == null) return;
                controller.set(
                  filter.copyWith(
                    uncategorizedOnly: false,
                    categoryIds: () => {
                      picked.id,
                      ...tree.withDescendants(picked.id),
                    },
                  ),
                );
              },
            ),
          ),
          gapSm,
          Center(
            child: FilterChip(
              label: Text(l10n.uncategorized),
              selected: filter.uncategorizedOnly,
              onSelected: (selected) => controller.set(
                filter.copyWith(
                  uncategorizedOnly: selected,
                  categoryIds: () => null,
                ),
              ),
            ),
          ),
          if (filter.activeCount > 0) ...[
            gapSm,
            Center(
              child: TextButton(
                onPressed: controller.clear,
                child: Text(l10n.clearFilters),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MenuChip extends StatelessWidget {
  const _MenuChip({
    required this.icon,
    required this.label,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    // A chip without its own tap handler, so the popup menu gets the tap.
    return Center(
      child: IgnorePointer(
        child: FilterChip(
          avatar: Icon(icon, size: 18),
          label: Text(label),
          selected: selected,
          showCheckmark: false,
          onSelected: (_) {},
        ),
      ),
    );
  }
}

class _TransactionList extends ConsumerWidget {
  const _TransactionList({
    required this.transactions,
    required this.showAccount,
  });

  final List<LedgerTransaction> transactions;
  final bool showAccount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Day headers and transactions interleaved, newest day first.
    final items = <Object>[];
    DateTime? currentDay;
    for (final transaction in transactions) {
      if (currentDay == null ||
          !isSameDay(currentDay, transaction.bookingDate)) {
        currentDay = transaction.bookingDate;
        items.add(currentDay);
      }
      items.add(transaction);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: Insets.xxl * 2),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is DateTime) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.md,
              Insets.md,
              Insets.md,
              Insets.xs,
            ),
            child: Text(
              context.formatDayHeader(item),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        return TransactionTile(
          transaction: item as LedgerTransaction,
          showAccount: showAccount,
        );
      },
    );
  }
}

/// One transaction in a list. Tapping the category avatar changes the
/// category in place; tapping the row opens the transaction.
class TransactionTile extends ConsumerWidget {
  const TransactionTile({
    required this.transaction,
    this.showAccount = false,
    this.showDate = false,
    super.key,
  });

  final LedgerTransaction transaction;
  final bool showAccount;
  final bool showDate;

  Future<void> _pickCategory(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final picked = await showCategoryPicker(context);
    if (picked == null) return;
    await ref
        .read(categorizationServiceProvider)
        .setCategoryManually(transaction, picked.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.categorySetTo(picked.name)),
          action: SnackBarAction(
            label: l10n.createRule,
            onPressed: () => context.push(
              Routes.ruleEdit(),
              extra: transaction.copyWith(categoryId: () => picked.id),
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final tree = ref.watch(categoryTreeProvider);
    final category = tree[transaction.categoryId];
    final accountName = showAccount
        ? ref
              .watch(accountsProvider)
              .value
              ?.firstWhereOrNull((a) => a.id == transaction.accountId)
              ?.name
        : null;

    final details = [
      if (showDate) context.formatShortDate(transaction.bookingDate),
      category?.name ?? l10n.uncategorized,
      if (transaction.counterparty.isNotEmpty && transaction.purpose.isNotEmpty)
        transaction.purpose,
      ?accountName,
    ];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Insets.md,
        vertical: 2,
      ),
      leading: Tooltip(
        message: l10n.changeCategory,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _pickCategory(context, ref),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CategoryAvatar(category),
              if (transaction.categorySource == CategorySource.learned)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      size: 12,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      title: Text(
        transaction.title.isEmpty ? l10n.noDescription : transaction.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        details.join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: AmountText(
        transaction.amountMinor,
        tone: AmountTone.incomeOnly,
        showPlus: true,
        style: theme.textTheme.titleMedium,
      ),
      onTap: () => context.push(Routes.transactionEdit(transaction.id)),
    );
  }
}
