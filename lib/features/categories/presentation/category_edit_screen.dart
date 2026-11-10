import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/categories/data/drift_category_repository.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/categories/presentation/categories_screen.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/categorization/application/categorization_service.dart';

class CategoryEditScreen extends ConsumerWidget {
  const CategoryEditScreen({this.id, super.key});

  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncView(
      value: ref.watch(categoriesProvider),
      builder: (categories) =>
          _CategoryForm(initial: CategoryTree(categories)[id]),
    );
  }
}

class _CategoryForm extends ConsumerStatefulWidget {
  const _CategoryForm({this.initial});

  final Category? initial;

  @override
  ConsumerState<_CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends ConsumerState<_CategoryForm> with FormInit {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  var _kind = CategoryKind.expense;
  int? _parentId;
  var _color = PandaColors.swatches.first;
  var _icon = 'category';
  var _archived = false;

  @override
  void initForm() {
    final category = widget.initial;
    _name.text = category?.name ?? '';
    _kind = category?.kind ?? CategoryKind.expense;
    _parentId = category?.parentId;
    _color = category?.colorValue ?? PandaColors.swatches.first;
    _icon = category?.iconKey ?? 'category';
    _archived = category?.isArchived ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final parent = ref.read(categoryTreeProvider)[_parentId];
    await ref
        .read(categoryRepositoryProvider)
        .save(
          (widget.initial ?? Category(name: '', kind: _kind)).copyWith(
            name: _name.text.trim(),
            // A sub-category always has the kind of its parent.
            kind: parent?.kind ?? _kind,
            parentId: () => _parentId,
            colorValue: _color,
            iconKey: _icon,
            isArchived: _archived,
          ),
        );
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final confirmed = await confirmDelete(
      context,
      title: l10n.deleteCategoryTitle,
      message: l10n.deleteCategoryMessage,
    );
    if (!confirmed) return;
    await ref.read(categoryRepositoryProvider).delete(widget.initial!.id);
    // The category's training data went with it.
    ref.read(categorizationServiceProvider).invalidate();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tree = ref.watch(categoryTreeProvider);
    final isNew = widget.initial == null;
    final hasChildren =
        !isNew && tree.childrenOf(widget.initial!.id).isNotEmpty;
    final parents = tree.roots.where(
      (root) => root.id != widget.initial?.id && !root.isArchived,
    );

    return FormPage(
      formKey: _formKey,
      title: isNew ? l10n.addCategory : l10n.editCategory,
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
        // A category with sub-categories has to stay on the top level.
        if (!hasChildren)
          SelectField<int?>(
            label: l10n.parentCategory,
            value: _parentId,
            items: {
              null: l10n.noParentCategory,
              for (final parent in parents) parent.id: parent.name,
            },
            onChanged: (id) => setState(() {
              _parentId = id;
              final parent = tree[id];
              if (parent != null) {
                _kind = parent.kind;
                _color = parent.colorValue;
              }
            }),
          ),
        if (_parentId == null)
          SelectField<CategoryKind>(
            label: l10n.categoryKind,
            value: _kind,
            items: {
              for (final kind in CategoryKind.values)
                kind: categoryKindLabel(l10n, kind),
            },
            onChanged: (kind) => setState(() => _kind = kind ?? _kind),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(l10n.icon),
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              children: [
                for (final MapEntry(:key, value: icon) in categoryIcons.entries)
                  InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() => _icon = key),
                    child: ColorAvatar(
                      color: key == _icon
                          ? Color(_color)
                          : Theme.of(context).colorScheme.outline,
                      icon: icon,
                    ),
                  ),
              ],
            ),
          ],
        ),
        if (!isNew)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.archived),
            subtitle: Text(l10n.archivedCategoryHint),
            value: _archived,
            onChanged: (value) => setState(() => _archived = value),
          ),
      ],
    );
  }
}
