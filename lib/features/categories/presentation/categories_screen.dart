import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/page_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';

String categoryKindLabel(AppLocalizations l10n, CategoryKind kind) =>
    switch (kind) {
      CategoryKind.expense => l10n.categoryKindExpense,
      CategoryKind.income => l10n.categoryKindIncome,
      CategoryKind.transfer => l10n.categoryKindTransfer,
    };

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: SubpageBar(title: l10n.categories),
      body: AsyncView(
        value: ref.watch(categoriesProvider),
        builder: (categories) {
          final tree = CategoryTree(categories);
          return PageBody(
            children: [
              for (final kind in CategoryKind.values) ...[
                SectionHeader(categoryKindLabel(l10n, kind)),
                for (final root in tree.roots.where((c) => c.kind == kind)) ...[
                  _CategoryRow(category: root),
                  for (final child in tree.childrenOf(root.id))
                    _CategoryRow(category: child, indent: true),
                ],
              ],
              gapMd,
              AddLink(
                label: l10n.addCategory,
                onPressed: () => context.push(Routes.categoryEdit()),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category, this.indent = false});

  final Category category;
  final bool indent;

  @override
  Widget build(BuildContext context) {
    return PandaListRow(
      indent: indent,
      leading: CategoryAvatar(category, size: indent ? 28 : 36),
      title: category.name,
      subtitle: category.isArchived ? context.l10n.archived : null,
      onTap: () => context.push(Routes.categoryEdit(category.id)),
    );
  }
}
