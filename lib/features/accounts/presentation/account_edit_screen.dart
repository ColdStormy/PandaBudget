import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/time/clock.dart';
import 'package:pandabudget/core/time/dates.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/accounts/data/drift_account_repository.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';
import 'package:pandabudget/features/accounts/presentation/account_providers.dart';

class AccountEditScreen extends ConsumerWidget {
  const AccountEditScreen({this.id, super.key});

  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncView(
      value: ref.watch(allAccountsProvider),
      builder: (accounts) => _AccountForm(
        initial: accounts.firstWhereOrNull((account) => account.id == id),
      ),
    );
  }
}

class _AccountForm extends ConsumerStatefulWidget {
  const _AccountForm({this.initial});

  final Account? initial;

  @override
  ConsumerState<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends ConsumerState<_AccountForm> with FormInit {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _iban = TextEditingController();
  final _opening = TextEditingController();
  var _kind = AccountKind.checking;
  var _openingDate = DateTime(2000);
  var _color = PandaColors.swatches.first;
  var _archived = false;

  @override
  void initForm() {
    final account = widget.initial;
    _name.text = account?.name ?? '';
    _iban.text = account?.iban ?? '';
    _opening.text = context.formatPlainAmount(
      account?.openingBalanceMinor ?? 0,
    );
    _kind = account?.kind ?? AccountKind.checking;
    _openingDate = account?.openingDate ?? dateOnly(ref.read(clockProvider)());
    _color = account?.colorValue ?? PandaColors.swatches.first;
    _archived = account?.isArchived ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _iban.dispose();
    _opening.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final iban = _iban.text.replaceAll(' ', '');
    await ref
        .read(accountRepositoryProvider)
        .save(
          (widget.initial ??
                  Account(name: '', kind: _kind, openingDate: _openingDate))
              .copyWith(
                name: _name.text.trim(),
                kind: _kind,
                iban: () => iban.isEmpty ? null : iban,
                openingBalanceMinor: context.parseMoney(_opening.text) ?? 0,
                openingDate: _openingDate,
                colorValue: _color,
                isArchived: _archived,
              ),
        );
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final confirmed = await confirmDelete(
      context,
      title: l10n.deleteAccountTitle,
      message: l10n.deleteAccountMessage,
    );
    if (!confirmed) return;
    await ref.read(accountRepositoryProvider).delete(widget.initial!.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isNew = widget.initial == null;
    return FormPage(
      formKey: _formKey,
      title: isNew ? l10n.addAccount : l10n.editAccount,
      onSave: _save,
      onDelete: isNew ? null : _delete,
      children: [
        TextFormField(
          controller: _name,
          autofocus: isNew,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: l10n.name),
          validator: (value) => requiredValidator(context, value),
        ),
        SelectField<AccountKind>(
          label: l10n.accountKind,
          value: _kind,
          items: {
            for (final kind in AccountKind.values)
              kind: accountKindLabel(l10n, kind),
          },
          onChanged: (kind) => setState(() => _kind = kind ?? _kind),
        ),
        TextFormField(
          controller: _iban,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(labelText: l10n.ibanOptional),
        ),
        AmountField(
          controller: _opening,
          label: l10n.openingBalance,
          allowZero: true,
          allowNegative: true,
        ),
        DateField(
          label: l10n.openingDate,
          value: _openingDate,
          onChanged: (date) =>
              setState(() => _openingDate = date ?? _openingDate),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(l10n.color),
            ColorPickerRow(
              value: _color,
              onChanged: (color) => setState(() => _color = color),
            ),
          ],
        ),
        if (!isNew)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.archived),
            subtitle: Text(l10n.archivedAccountHint),
            value: _archived,
            onChanged: (value) => setState(() => _archived = value),
          ),
      ],
    );
  }
}
