import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/planning/data/drift_planning_repositories.dart';
import 'package:pandabudget/features/planning/domain/budget.dart';
import 'package:pandabudget/features/planning/presentation/planning_providers.dart';

class BudgetEditScreen extends ConsumerWidget {
  const BudgetEditScreen({this.id, super.key});

  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncView(
      value: ref.watch(budgetsProvider),
      builder: (budgets) => _BudgetForm(
        initial: budgets.firstWhereOrNull((budget) => budget.id == id),
      ),
    );
  }
}

class _BudgetForm extends ConsumerStatefulWidget {
  const _BudgetForm({this.initial});

  final Budget? initial;

  @override
  ConsumerState<_BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends ConsumerState<_BudgetForm> with FormInit {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _amount = TextEditingController();
  var _categoryIds = <int>{};
  var _start = const YearMonth(2000, 1);
  YearMonth? _end;
  var _color = PandaColors.swatches.first;

  @override
  void initForm() {
    final budget = widget.initial;
    _name.text = budget?.name ?? '';
    _amount.text = budget == null
        ? ''
        : context.formatPlainAmount(budget.amountMinor);
    _categoryIds = {...?budget?.categoryIds};
    _start = budget?.startMonth ?? ref.read(currentMonthProvider);
    _end = budget?.endMonth;
    _color = budget?.colorValue ?? PandaColors.swatches.first;
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(budgetRepositoryProvider)
        .save(
          (widget.initial ??
                  Budget(name: '', amountMinor: 0, startMonth: _start))
              .copyWith(
                name: _name.text.trim(),
                amountMinor: context.parseMoney(_amount.text) ?? 0,
                startMonth: _start,
                endMonth: () => _end,
                categoryIds: _categoryIds,
                colorValue: _color,
              ),
        );
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await confirmDelete(
      context,
      title: context.l10n.deleteBudgetTitle,
    );
    if (!confirmed) return;
    await ref.read(budgetRepositoryProvider).delete(widget.initial!.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tree = ref.watch(categoryTreeProvider);
    final isNew = widget.initial == null;
    final roots = tree.roots.where(
      (c) => c.kind == CategoryKind.expense && !c.isArchived,
    );

    Widget chip(Category category, {bool implied = false}) => FilterChip(
      label: Text(category.name),
      selected: implied || _categoryIds.contains(category.id),
      // A selected parent already covers its sub-categories.
      onSelected: implied
          ? null
          : (selected) => setState(() {
              if (selected) {
                _categoryIds.add(category.id);
                // Selecting a parent makes its children redundant.
                _categoryIds.removeAll(
                  tree.childrenOf(category.id).map((c) => c.id),
                );
              } else {
                _categoryIds.remove(category.id);
              }
            }),
    );

    return FormPage(
      formKey: _formKey,
      title: isNew ? l10n.addBudget : l10n.editBudget,
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
        AmountField(controller: _amount, label: l10n.budgetPerMonth),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(l10n.budgetCategories),
            Text(
              l10n.budgetCategoriesHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            gapMd,
            for (final root in roots) ...[
              Wrap(
                spacing: Insets.sm,
                runSpacing: Insets.xs,
                children: [
                  chip(root),
                  for (final child in tree.childrenOf(root.id))
                    if (!child.isArchived)
                      chip(child, implied: _categoryIds.contains(root.id)),
                ],
              ),
              gapSm,
            ],
          ],
        ),
        Row(
          children: [
            Expanded(
              child: MonthField(
                label: l10n.validFrom,
                value: _start,
                onChanged: (month) => setState(() => _start = month ?? _start),
              ),
            ),
            gapMd,
            Expanded(
              child: MonthField(
                label: l10n.validUntilOptional,
                value: _end,
                clearable: true,
                onChanged: (month) => setState(() => _end = month),
              ),
            ),
          ],
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
      ],
    );
  }
}
