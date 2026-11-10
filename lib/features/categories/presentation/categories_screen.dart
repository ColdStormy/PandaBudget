import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
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
      appBar: AppBar(title: Text(l10n.categories)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.categoryEdit()),
        icon: const Icon(Icons.add),
        label: Text(l10n.addCategory),
      ),
      body: AsyncView(
        value: ref.watch(categoriesProvider),
        builder: (categories) {
          final tree = CategoryTree(categories);
          return PageBody(
            children: [
              for (final kind in CategoryKind.values) ...[
                SectionHeader(categoryKindLabel(l10n, kind)),
                Card(
                  child: Column(
                    children: [
                      for (final (index, root)
                          in tree.roots
                              .where((c) => c.kind == kind)
                              .indexed) ...[
                        if (index > 0) const Divider(indent: Insets.md),
                        _CategoryTile(category: root),
                        for (final child in tree.childrenOf(root.id))
                          _CategoryTile(category: child, indent: true),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, this.indent = false});

  final Category category;
  final bool indent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: indent,
      contentPadding: EdgeInsets.only(
        left: indent ? Insets.xl + Insets.lg : Insets.md,
        right: Insets.md,
      ),
      leading: CategoryAvatar(category, size: indent ? 28 : 36),
      title: Text(category.name),
      subtitle: category.isArchived ? Text(context.l10n.archived) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push(Routes.categoryEdit(category.id)),
    );
  }
}
