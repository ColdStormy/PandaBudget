import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/categorization/application/categorization_service.dart';
import 'package:pandabudget/features/categorization/data/drift_categorization_repositories.dart';
import 'package:pandabudget/features/categorization/domain/category_rule.dart';
import 'package:pandabudget/features/categorization/presentation/rules_screen.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

class RuleEditScreen extends ConsumerWidget {
  const RuleEditScreen({this.id, this.template, super.key});

  final int? id;

  /// A transaction to derive a new rule from.
  final LedgerTransaction? template;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncView(
      value: ref.watch(rulesProvider),
      builder: (rules) => _RuleForm(
        initial: rules.firstWhereOrNull((rule) => rule.id == id),
        template: template,
      ),
    );
  }
}

class _ConditionDraft {
  _ConditionDraft(RuleCondition condition)
    : field = condition.field,
      operator = condition.operator,
      value = TextEditingController(text: condition.value);

  RuleField field;
  RuleOperator operator;
  final TextEditingController value;

  RuleCondition toCondition() =>
      RuleCondition(field: field, operator: operator, value: value.text.trim());
}

class _RuleForm extends ConsumerStatefulWidget {
  const _RuleForm({this.initial, this.template});

  final CategoryRule? initial;
  final LedgerTransaction? template;

  @override
  ConsumerState<_RuleForm> createState() => _RuleFormState();
}

class _RuleFormState extends ConsumerState<_RuleForm> with FormInit {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _conditions = <_ConditionDraft>[];
  int? _categoryId;
  var _matchAll = true;
  var _enabled = true;
  var _categoryMissing = false;

  @override
  void initForm() {
    final rule = widget.initial;
    final template = widget.template;
    if (rule != null) {
      _name.text = rule.name;
      _categoryId = rule.categoryId;
      _matchAll = rule.matchAll;
      _enabled = rule.isEnabled;
      _conditions.addAll(rule.conditions.map(_ConditionDraft.new));
    } else if (template != null) {
      final byCounterparty = template.counterparty.isNotEmpty;
      _name.text = template.title;
      _categoryId = template.categoryId;
      _conditions.add(
        _ConditionDraft(
          RuleCondition(
            field: byCounterparty ? RuleField.counterparty : RuleField.purpose,
            operator: RuleOperator.contains,
            value: template.title,
          ),
        ),
      );
    }
    if (_conditions.isEmpty) _addCondition();
  }

  void _addCondition() => _conditions.add(
    _ConditionDraft(
      const RuleCondition(
        field: RuleField.counterparty,
        operator: RuleOperator.contains,
        value: '',
      ),
    ),
  );

  @override
  void dispose() {
    _name.dispose();
    for (final condition in _conditions) {
      condition.value.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final valid = _formKey.currentState!.validate();
    setState(() => _categoryMissing = _categoryId == null);
    if (!valid || _categoryId == null) return;

    final l10n = context.l10n;
    await ref
        .read(categoryRuleRepositoryProvider)
        .save(
          (widget.initial ??
                  CategoryRule(
                    name: '',
                    categoryId: _categoryId!,
                    conditions: const [],
                  ))
              .copyWith(
                name: _name.text.trim(),
                categoryId: _categoryId,
                matchAll: _matchAll,
                isEnabled: _enabled,
                conditions: [for (final c in _conditions) c.toCondition()],
              ),
        );
    // Let the new rule take effect on what is already there. Categories
    // set by hand are never changed.
    final changed = await ref
        .read(categorizationServiceProvider)
        .recategorize();
    if (!mounted) return;
    if (changed > 0) showMessage(context, l10n.recategorizedCount(changed));
    context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await confirmDelete(
      context,
      title: context.l10n.deleteRuleTitle,
    );
    if (!confirmed) return;
    await ref.read(categoryRuleRepositoryProvider).delete(widget.initial!.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isNew = widget.initial == null;

    return FormPage(
      formKey: _formKey,
      title: isNew ? l10n.addRule : l10n.editRule,
      onSave: _save,
      onDelete: isNew ? null : _delete,
      children: [
        TextFormField(
          controller: _name,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: l10n.name),
          validator: (value) => requiredValidator(context, value),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(l10n.ruleConditions),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: true, label: Text(l10n.ruleMatchAll)),
                ButtonSegment(value: false, label: Text(l10n.ruleMatchAny)),
              ],
              selected: {_matchAll},
              showSelectedIcon: false,
              onSelectionChanged: (selection) =>
                  setState(() => _matchAll = selection.first),
            ),
          ],
        ),
        for (final (index, condition) in _conditions.indexed)
          PandaCard(
            padding: const EdgeInsets.all(Insets.md),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SelectField<RuleField>(
                        label: l10n.ruleField,
                        value: condition.field,
                        items: {
                          for (final field in RuleField.values)
                            field: ruleFieldLabel(l10n, field),
                        },
                        onChanged: (field) => setState(() {
                          condition.field = field ?? condition.field;
                          final allowed = RuleOperator.forField(
                            condition.field,
                          );
                          if (!allowed.contains(condition.operator)) {
                            condition.operator = allowed.first;
                          }
                        }),
                      ),
                    ),
                    gapSm,
                    Expanded(
                      child: SelectField<RuleOperator>(
                        label: l10n.ruleOperator,
                        value: condition.operator,
                        items: {
                          for (final operator in RuleOperator.forField(
                            condition.field,
                          ))
                            operator: ruleOperatorLabel(l10n, operator),
                        },
                        onChanged: (operator) => setState(
                          () => condition.operator =
                              operator ?? condition.operator,
                        ),
                      ),
                    ),
                  ],
                ),
                gapSm,
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: condition.value,
                        keyboardType: condition.field.isNumeric
                            ? const TextInputType.numberWithOptions(
                                decimal: true,
                                signed: true,
                              )
                            : TextInputType.text,
                        decoration: InputDecoration(
                          labelText: l10n.ruleValue,
                          helperText: condition.field.isNumeric
                              ? l10n.ruleAmountHint
                              : null,
                        ),
                        validator: (value) => requiredValidator(context, value),
                      ),
                    ),
                    if (_conditions.length > 1)
                      IconButton(
                        tooltip: l10n.delete,
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => setState(() {
                          _conditions.removeAt(index).value.dispose();
                        }),
                      ),
                  ],
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(_addCondition),
            icon: const Icon(Icons.add),
            label: Text(l10n.addCondition),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryField(
              label: l10n.ruleAssignCategory,
              value: _categoryId,
              clearable: false,
              onChanged: (id) => setState(() {
                _categoryId = id;
                _categoryMissing = false;
              }),
            ),
            if (_categoryMissing)
              Padding(
                padding: const EdgeInsets.only(left: Insets.md, top: Insets.xs),
                child: Text(
                  l10n.fieldRequired,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
          ],
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.ruleEnabled),
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
      ],
    );
  }
}
