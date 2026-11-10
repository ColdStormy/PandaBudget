import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/time/clock.dart';
import 'package:pandabudget/core/time/dates.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/accounts/presentation/account_providers.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/categorization/application/categorization_service.dart';
import 'package:pandabudget/features/transactions/data/drift_transaction_repository.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

final _transactionByIdProvider = FutureProvider.autoDispose
    .family<LedgerTransaction?, int?>(
      (ref, id) async => id == null
          ? null
          : await ref.watch(transactionRepositoryProvider).findById(id),
    );

class TransactionEditScreen extends ConsumerWidget {
  const TransactionEditScreen({this.id, super.key});

  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = ref.watch(_transactionByIdProvider(id));
    // Wait for the accounts too so the form can preselect one.
    final accounts = ref.watch(accountsProvider);
    if (transaction.isLoading || accounts.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _TransactionForm(initial: transaction.value);
  }
}

class _TransactionForm extends ConsumerStatefulWidget {
  const _TransactionForm({this.initial});

  final LedgerTransaction? initial;

  @override
  ConsumerState<_TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends ConsumerState<_TransactionForm>
    with FormInit {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _counterparty = TextEditingController();
  final _purpose = TextEditingController();
  final _note = TextEditingController();
  int? _accountId;
  int? _categoryId;
  var _isIncome = false;
  var _date = DateTime(2000);

  @override
  void initForm() {
    final transaction = widget.initial;
    final accounts = ref.read(accountsProvider).value ?? const [];
    _accountId = transaction?.accountId ?? accounts.firstOrNull?.id;
    _categoryId = transaction?.categoryId;
    _isIncome = (transaction?.amountMinor ?? -1) > 0;
    _date = transaction?.bookingDate ?? dateOnly(ref.read(clockProvider)());
    _amount.text = transaction == null
        ? ''
        : context.formatPlainAmount(transaction.amountMinor.abs());
    _counterparty.text = transaction?.counterparty ?? '';
    _purpose.text = transaction?.purpose ?? '';
    _note.text = transaction?.note ?? '';
  }

  @override
  void dispose() {
    _amount.dispose();
    _counterparty.dispose();
    _purpose.dispose();
    _note.dispose();
    super.dispose();
  }

  LedgerTransaction _draft() {
    final amount = context.parseMoney(_amount.text) ?? 0;
    final initial = widget.initial;
    final categoryChanged = _categoryId != initial?.categoryId;
    return (initial ??
            LedgerTransaction(
              accountId: _accountId!,
              bookingDate: _date,
              amountMinor: 0,
            ))
        .copyWith(
          accountId: _accountId,
          bookingDate: _date,
          amountMinor: _isIncome ? amount : -amount,
          counterparty: _counterparty.text.trim(),
          purpose: _purpose.text.trim(),
          note: _note.text.trim(),
          categoryId: () => _categoryId,
          categorySource: !categoryChanged
              ? null
              : _categoryId == null
              ? CategorySource.none
              : CategorySource.manual,
          ruleId: categoryChanged ? () => null : null,
        );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _accountId == null) return;
    final service = ref.read(categorizationServiceProvider);
    var transaction = _draft();
    // A new transaction without a category gets one from the rules or the
    // classifier, like imported ones do.
    if (transaction.isNew && transaction.categoryId == null) {
      transaction = (await service.categorize([transaction])).single;
    }
    await service.save(transaction);
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await confirmDelete(
      context,
      title: context.l10n.deleteTransactionTitle,
    );
    if (!confirmed) return;
    await ref.read(transactionRepositoryProvider).delete(widget.initial!.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accounts = ref.watch(accountsProvider).value ?? const [];
    final isNew = widget.initial == null;

    if (accounts.isEmpty && isNew) {
      return Scaffold(
        appBar: AppBar(leading: const CloseButton()),
        body: EmptyState(
          icon: Icons.account_balance_outlined,
          title: l10n.noAccountsTitle,
          message: l10n.transactionNeedsAccount,
          action: FilledButton(
            onPressed: () => context.pushReplacement(Routes.accountEdit()),
            child: Text(l10n.addAccount),
          ),
        ),
      );
    }

    return FormPage(
      formKey: _formKey,
      title: isNew ? l10n.addTransaction : l10n.editTransaction,
      onSave: _save,
      onDelete: isNew ? null : _delete,
      children: [
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: false,
              icon: const Icon(Icons.south_west),
              label: Text(l10n.expense),
            ),
            ButtonSegment(
              value: true,
              icon: const Icon(Icons.north_east),
              label: Text(l10n.income),
            ),
          ],
          selected: {_isIncome},
          showSelectedIcon: false,
          onSelectionChanged: (selection) =>
              setState(() => _isIncome = selection.first),
        ),
        AmountField(controller: _amount, label: l10n.amount),
        SelectField<int>(
          label: l10n.account,
          value: _accountId,
          items: {for (final account in accounts) account.id: account.name},
          onChanged: (id) => setState(() => _accountId = id),
        ),
        DateField(
          label: l10n.bookingDate,
          value: _date,
          onChanged: (date) => setState(() => _date = date ?? _date),
        ),
        TextFormField(
          controller: _counterparty,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l10n.counterparty),
        ),
        TextFormField(
          controller: _purpose,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: l10n.purpose),
        ),
        CategoryField(
          value: _categoryId,
          onChanged: (id) => setState(() => _categoryId = id),
        ),
        TextFormField(
          controller: _note,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 2,
          decoration: InputDecoration(labelText: l10n.note),
        ),
        if (!isNew)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => context.push(Routes.ruleEdit(), extra: _draft()),
              icon: const Icon(Icons.rule),
              label: Text(l10n.createRuleFromTransaction),
            ),
          ),
      ],
    );
  }
}
