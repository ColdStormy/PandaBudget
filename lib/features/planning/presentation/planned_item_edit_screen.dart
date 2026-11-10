import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/time/clock.dart';
import 'package:pandabudget/core/time/dates.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/planning/data/drift_planning_repositories.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/planning/presentation/planning_providers.dart';

/// The repeat patterns offered in the form.
const List<(RecurrenceUnit, int)> _recurrences = [
  (RecurrenceUnit.once, 1),
  (RecurrenceUnit.week, 1),
  (RecurrenceUnit.week, 2),
  (RecurrenceUnit.month, 1),
  (RecurrenceUnit.month, 2),
  (RecurrenceUnit.month, 3),
  (RecurrenceUnit.month, 6),
  (RecurrenceUnit.year, 1),
];

class PlannedItemEditScreen extends ConsumerWidget {
  const PlannedItemEditScreen({this.id, super.key});

  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncView(
      value: ref.watch(plannedItemsProvider),
      builder: (items) => _PlannedItemForm(
        initial: items.firstWhereOrNull((item) => item.id == id),
      ),
    );
  }
}

class _PlannedItemForm extends ConsumerStatefulWidget {
  const _PlannedItemForm({this.initial});

  final PlannedItem? initial;

  @override
  ConsumerState<_PlannedItemForm> createState() => _PlannedItemFormState();
}

class _PlannedItemFormState extends ConsumerState<_PlannedItemForm>
    with FormInit {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  var _kind = PlannedKind.expense;
  (RecurrenceUnit, int) _recurrence = (RecurrenceUnit.month, 1);
  var _start = DateTime(2000);
  DateTime? _end;
  int? _categoryId;
  var _active = true;

  @override
  void initForm() {
    final item = widget.initial;
    _name.text = item?.name ?? '';
    _amount.text = item == null
        ? ''
        : context.formatPlainAmount(item.amountMinor);
    _note.text = item?.note ?? '';
    _kind = item?.kind ?? PlannedKind.expense;
    if (item != null) _recurrence = (item.unit, item.interval);
    _start = item?.startDate ?? dateOnly(ref.read(clockProvider)());
    _end = item?.endDate;
    _categoryId = item?.categoryId;
    _active = item?.isActive ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final (unit, interval) = _recurrence;
    await ref
        .read(plannedItemRepositoryProvider)
        .save(
          (widget.initial ??
                  PlannedItem(
                    name: '',
                    kind: _kind,
                    amountMinor: 0,
                    startDate: _start,
                  ))
              .copyWith(
                name: _name.text.trim(),
                kind: _kind,
                amountMinor: context.parseMoney(_amount.text) ?? 0,
                unit: unit,
                interval: interval,
                startDate: _start,
                endDate: () => unit == RecurrenceUnit.once ? null : _end,
                categoryId: () => _categoryId,
                note: _note.text.trim(),
                isActive: _active,
              ),
        );
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await confirmDelete(
      context,
      title: context.l10n.deletePlannedItemTitle,
    );
    if (!confirmed) return;
    await ref.read(plannedItemRepositoryProvider).delete(widget.initial!.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isNew = widget.initial == null;
    final isOnce = _recurrence.$1 == RecurrenceUnit.once;
    // Items with an interval the presets do not cover keep their own entry.
    final options = {..._recurrences, _recurrence};

    return FormPage(
      formKey: _formKey,
      title: isNew ? l10n.addPlannedItem : l10n.editPlannedItem,
      onSave: _save,
      onDelete: isNew ? null : _delete,
      children: [
        SegmentedButton<PlannedKind>(
          segments: [
            ButtonSegment(
              value: PlannedKind.expense,
              icon: const Icon(Icons.south_west),
              label: Text(l10n.payment),
            ),
            ButtonSegment(
              value: PlannedKind.income,
              icon: const Icon(Icons.north_east),
              label: Text(l10n.income),
            ),
          ],
          selected: {_kind},
          showSelectedIcon: false,
          onSelectionChanged: (selection) => setState(() {
            _kind = selection.first;
            _categoryId = null;
          }),
        ),
        TextFormField(
          controller: _name,
          autofocus: isNew,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: l10n.name,
            hintText: _kind == PlannedKind.income
                ? l10n.plannedIncomeHint
                : l10n.plannedPaymentHint,
          ),
          validator: (value) => requiredValidator(context, value),
        ),
        AmountField(controller: _amount, label: l10n.amount),
        SelectField<(RecurrenceUnit, int)>(
          label: l10n.repeats,
          value: _recurrence,
          items: {
            for (final (unit, interval) in options)
              (unit, interval): recurrenceLabel(
                l10n,
                PlannedItem(
                  name: '',
                  kind: _kind,
                  amountMinor: 0,
                  startDate: _start,
                  unit: unit,
                  interval: interval,
                ),
              ),
          },
          onChanged: (value) =>
              setState(() => _recurrence = value ?? _recurrence),
        ),
        DateField(
          label: isOnce ? l10n.dueDate : l10n.firstDueDate,
          value: _start,
          onChanged: (date) => setState(() => _start = date ?? _start),
        ),
        if (!isOnce)
          DateField(
            label: l10n.endDateOptional,
            value: _end,
            clearable: true,
            onChanged: (date) => setState(() => _end = date),
          ),
        CategoryField(
          value: _categoryId,
          kinds: {
            if (_kind == PlannedKind.income)
              CategoryKind.income
            else
              CategoryKind.expense,
          },
          onChanged: (id) => setState(() => _categoryId = id),
        ),
        TextFormField(
          controller: _note,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: l10n.note),
        ),
        if (!isNew)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.active),
            subtitle: Text(l10n.activePlannedHint),
            value: _active,
            onChanged: (value) => setState(() => _active = value),
          ),
      ],
    );
  }
}
