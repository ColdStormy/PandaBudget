import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/planning/data/drift_planning_repositories.dart';
import 'package:pandabudget/features/planning/domain/savings_goal.dart';
import 'package:pandabudget/features/planning/presentation/planning_providers.dart';

class GoalEditScreen extends ConsumerWidget {
  const GoalEditScreen({this.id, super.key});

  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncView(
      value: ref.watch(savingsGoalsProvider),
      builder: (goals) =>
          _GoalForm(initial: goals.firstWhereOrNull((goal) => goal.id == id)),
    );
  }
}

class _GoalForm extends ConsumerStatefulWidget {
  const _GoalForm({this.initial});

  final SavingsGoal? initial;

  @override
  ConsumerState<_GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends ConsumerState<_GoalForm> with FormInit {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _target = TextEditingController();
  final _saved = TextEditingController();
  var _month = const YearMonth(2000, 1);
  var _priority = 1;
  var _color = PandaColors.swatches.first;

  @override
  void initForm() {
    final goal = widget.initial;
    _name.text = goal?.name ?? '';
    _target.text = goal == null
        ? ''
        : context.formatPlainAmount(goal.targetMinor);
    _saved.text = context.formatPlainAmount(goal?.savedMinor ?? 0);
    _month = goal?.targetMonth ?? ref.read(currentMonthProvider).addMonths(12);
    _priority = goal?.priority ?? 1;
    _color = goal?.colorValue ?? PandaColors.swatches.first;
  }

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    _saved.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(savingsGoalRepositoryProvider)
        .save(
          (widget.initial ??
                  SavingsGoal(name: '', targetMinor: 0, targetMonth: _month))
              .copyWith(
                name: _name.text.trim(),
                targetMinor: context.parseMoney(_target.text) ?? 0,
                savedMinor: context.parseMoney(_saved.text) ?? 0,
                targetMonth: _month,
                priority: _priority,
                colorValue: _color,
              ),
        );
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await confirmDelete(
      context,
      title: context.l10n.deleteGoalTitle,
    );
    if (!confirmed) return;
    await ref.read(savingsGoalRepositoryProvider).delete(widget.initial!.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isNew = widget.initial == null;
    return FormPage(
      formKey: _formKey,
      title: isNew ? l10n.addGoal : l10n.editGoal,
      onSave: _save,
      onDelete: isNew ? null : _delete,
      children: [
        TextFormField(
          controller: _name,
          autofocus: isNew,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: l10n.name,
            hintText: l10n.goalNameHint,
          ),
          validator: (value) => requiredValidator(context, value),
        ),
        AmountField(controller: _target, label: l10n.goalTarget),
        AmountField(
          controller: _saved,
          label: l10n.goalAlreadySaved,
          allowZero: true,
        ),
        MonthField(
          label: l10n.goalNeededBy,
          value: _month,
          onChanged: (month) => setState(() => _month = month ?? _month),
        ),
        SelectField<int>(
          label: l10n.priority,
          value: _priority,
          items: {
            0: l10n.priorityHigh,
            1: l10n.priorityNormal,
            2: l10n.priorityLow,
          },
          onChanged: (value) => setState(() => _priority = value ?? _priority),
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
