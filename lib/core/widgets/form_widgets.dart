import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/features/settings/presentation/settings_providers.dart';

/// Scaffold for create/edit screens: close button, title, save action and a
/// centred column of fields.
class FormPage extends StatelessWidget {
  const FormPage({
    required this.title,
    required this.children,
    this.onSave,
    this.onDelete,
    this.formKey,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback? onSave;
  final VoidCallback? onDelete;
  final GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(title),
        actions: [
          if (onDelete != null)
            IconButton(
              tooltip: l10n.delete,
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          if (onSave != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
              child: FilledButton(onPressed: onSave, child: Text(l10n.save)),
            ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.form),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                Insets.md,
                Insets.md,
                Insets.md,
                Insets.xxl,
              ),
              itemCount: children.length,
              separatorBuilder: (_, _) => gapMd,
              itemBuilder: (_, index) => children[index],
            ),
          ),
        ),
      ),
    );
  }
}

/// Label above a group of form controls that have no label of their own.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.sm),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

String? requiredValidator(BuildContext context, String? value) =>
    (value == null || value.trim().isEmpty) ? context.l10n.fieldRequired : null;

/// Text field for an amount in the household currency.
class AmountField extends ConsumerWidget {
  const AmountField({
    required this.controller,
    required this.label,
    this.allowZero = false,
    this.allowNegative = false,
    this.optional = false,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool allowZero;
  final bool allowNegative;
  final bool optional;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: allowNegative,
      ),
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        labelText: label,
        suffixText: ref.watch(currencyCodeProvider),
      ),
      validator: (value) {
        if (optional && (value == null || value.trim().isEmpty)) return null;
        final amount = context.parseMoney(value ?? '');
        if (amount == null ||
            (!allowNegative && amount < 0) ||
            (!allowZero && amount == 0)) {
          return context.l10n.amountInvalid;
        }
        return null;
      },
    );
  }
}

/// A read-only field that opens a picker when tapped.
class PickerField extends StatelessWidget {
  const PickerField({
    required this.label,
    required this.value,
    required this.onTap,
    this.icon,
    this.onClear,
    this.leading,
    super.key,
  });

  final String label;
  final String? value;
  final VoidCallback onTap;
  final IconData? icon;
  final VoidCallback? onClear;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      onTap: onTap,
      child: InputDecorator(
        isEmpty: value == null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: leading,
          suffixIcon: value != null && onClear != null
              ? IconButton(
                  tooltip: context.l10n.clear,
                  onPressed: onClear,
                  icon: const Icon(Icons.close),
                )
              : Icon(icon ?? Icons.expand_more),
        ),
        child: value == null
            ? null
            : Text(value!, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class DateField extends StatelessWidget {
  const DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.clearable = false,
    super.key,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final bool clearable;

  @override
  Widget build(BuildContext context) {
    return PickerField(
      label: label,
      value: value == null ? null : context.formatDate(value!),
      icon: Icons.calendar_today_outlined,
      onClear: clearable ? () => onChanged(null) : null,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}

class MonthField extends StatelessWidget {
  const MonthField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.clearable = false,
    super.key,
  });

  final String label;
  final YearMonth? value;
  final ValueChanged<YearMonth?> onChanged;
  final bool clearable;

  @override
  Widget build(BuildContext context) {
    return PickerField(
      label: label,
      value: value == null ? null : context.formatMonth(value!),
      icon: Icons.calendar_month_outlined,
      onClear: clearable ? () => onChanged(null) : null,
      onTap: () async {
        final picked = await showMonthPicker(
          context,
          initial: value ?? YearMonth.of(DateTime.now()),
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}

/// A dialog with a year stepper and a grid of months.
Future<YearMonth?> showMonthPicker(
  BuildContext context, {
  required YearMonth initial,
}) {
  return showDialog<YearMonth>(
    context: context,
    builder: (context) {
      var year = initial.year;
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => setState(() => year--),
                icon: const Icon(Icons.chevron_left),
              ),
              Text('$year'),
              IconButton(
                onPressed: () => setState(() => year++),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          content: SizedBox(
            width: 300,
            child: Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              alignment: WrapAlignment.center,
              children: [
                for (var month = 1; month <= 12; month++)
                  ChoiceChip(
                    label: SizedBox(
                      width: 44,
                      child: Text(
                        context.formatMonthName(YearMonth(year, month)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    showCheckmark: false,
                    selected: initial == YearMonth(year, month),
                    onSelected: (_) =>
                        Navigator.of(context).pop(YearMonth(year, month)),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.cancel),
            ),
          ],
        ),
      );
    },
  );
}

/// A labelled dropdown that matches the look of the text fields.
class SelectField<T> extends StatelessWidget {
  const SelectField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    super.key,
  });

  final String label;
  final T? value;

  /// Value -> label, in display order.
  final Map<T, String> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      // Rebuild the field when the selection is changed from outside.
      key: ValueKey((label, value)),
      initialValue: items.containsKey(value) ? value : null,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      validator: validator,
      items: [
        for (final MapEntry(key: itemValue, value: itemLabel) in items.entries)
          DropdownMenuItem(
            value: itemValue,
            child: Text(itemLabel, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: onChanged,
    );
  }
}

/// Runs [initForm] once, as soon as inherited widgets (localisations, for
/// number formats) can be read. Edit screens fill their controllers there.
mixin FormInit<T extends StatefulWidget> on State<T> {
  bool _formInitialised = false;

  void initForm();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_formInitialised) {
      _formInitialised = true;
      initForm();
    }
  }
}
