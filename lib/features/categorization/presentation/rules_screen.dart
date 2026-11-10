import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/categorization/application/categorization_service.dart';
import 'package:pandabudget/features/categorization/data/drift_categorization_repositories.dart';
import 'package:pandabudget/features/categorization/domain/category_rule.dart';

final rulesProvider = StreamProvider<List<CategoryRule>>(
  (ref) => ref.watch(categoryRuleRepositoryProvider).watchAll(),
);

String ruleFieldLabel(AppLocalizations l10n, RuleField field) =>
    switch (field) {
      RuleField.counterparty => l10n.counterparty,
      RuleField.purpose => l10n.purpose,
      RuleField.anyText => l10n.ruleFieldAnyText,
      RuleField.iban => l10n.iban,
      RuleField.amount => l10n.amount,
    };

String ruleOperatorLabel(AppLocalizations l10n, RuleOperator operator) =>
    switch (operator) {
      RuleOperator.contains => l10n.ruleOpContains,
      RuleOperator.equals => l10n.ruleOpEquals,
      RuleOperator.startsWith => l10n.ruleOpStartsWith,
      RuleOperator.endsWith => l10n.ruleOpEndsWith,
      RuleOperator.regex => l10n.ruleOpRegex,
      RuleOperator.greaterThan => l10n.ruleOpGreaterThan,
      RuleOperator.lessThan => l10n.ruleOpLessThan,
    };

/// "Counterparty contains “rewe” and Amount is less than “0”"
String describeRule(AppLocalizations l10n, CategoryRule rule) => rule.conditions
    .map(
      (c) =>
          '${ruleFieldLabel(l10n, c.field)} '
          '${ruleOperatorLabel(l10n, c.operator).toLowerCase()} '
          '“${c.value}”',
    )
    .join(rule.matchAll ? ' ${l10n.and} ' : ' ${l10n.or} ');

class RulesScreen extends ConsumerWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tree = ref.watch(categoryTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rules),
        actions: [
          IconButton(
            tooltip: l10n.applyRulesNow,
            icon: const Icon(Icons.play_arrow_outlined),
            onPressed: () async {
              final changed = await ref
                  .read(categorizationServiceProvider)
                  .recategorize();
              if (context.mounted) {
                showMessage(context, l10n.recategorizedCount(changed));
              }
            },
          ),
          gapSm,
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.ruleEdit()),
        icon: const Icon(Icons.add),
        label: Text(l10n.addRule),
      ),
      body: AsyncView(
        value: ref.watch(rulesProvider),
        builder: (rules) {
          if (rules.isEmpty) {
            return EmptyState(
              icon: Icons.rule,
              title: l10n.noRulesTitle,
              message: l10n.noRulesMessage,
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Insets.md,
                  0,
                  Insets.md,
                  Insets.sm,
                ),
                child: Text(
                  l10n.rulesOrderHint,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.only(bottom: Insets.xxl * 2),
                  itemCount: rules.length,
                  onReorderItem: (oldIndex, newIndex) async {
                    final ids = [for (final rule in rules) rule.id];
                    ids.insert(newIndex, ids.removeAt(oldIndex));
                    await ref.read(categoryRuleRepositoryProvider).reorder(ids);
                  },
                  itemBuilder: (context, index) {
                    final rule = rules[index];
                    final category = tree[rule.categoryId];
                    return ListTile(
                      key: ValueKey(rule.id),
                      contentPadding: const EdgeInsets.only(
                        left: Insets.md,
                        right: Insets.xxl,
                      ),
                      leading: CategoryAvatar(category, size: 36),
                      title: Text(rule.name),
                      subtitle: Text(
                        '${describeRule(l10n, rule)}\n'
                        '→ ${category == null ? '' : tree.pathOf(category.id)}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      isThreeLine: true,
                      enabled: rule.isEnabled,
                      onTap: () => context.push(Routes.ruleEdit(rule.id)),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
