import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/panda_logo.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/categorization/application/categorization_service.dart';
import 'package:pandabudget/features/settings/data/drift_settings_repository.dart';
import 'package:pandabudget/features/settings/domain/app_settings.dart';
import 'package:pandabudget/features/settings/presentation/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final settings = ref.watch(currentSettingsProvider);

    Future<void> update(AppSettings value) =>
        ref.read(settingsRepositoryProvider).save(value);

    Widget link(IconData icon, String title, String subtitle, String route) =>
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go(route),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: PageBody(
        maxWidth: 760,
        bottomPadding: Insets.xl,
        children: [
          SectionHeader(l10n.settingsData),
          Card(
            child: Column(
              children: [
                link(
                  Icons.account_balance_outlined,
                  l10n.accounts,
                  l10n.settingsAccountsHint,
                  Routes.settingsAccounts,
                ),
                const Divider(indent: Insets.md),
                link(
                  Icons.label_outline,
                  l10n.categories,
                  l10n.settingsCategoriesHint,
                  Routes.settingsCategories,
                ),
                const Divider(indent: Insets.md),
                link(
                  Icons.rule,
                  l10n.rules,
                  l10n.settingsRulesHint,
                  Routes.settingsRules,
                ),
                const Divider(indent: Insets.md),
                link(
                  Icons.table_chart_outlined,
                  l10n.importProfiles,
                  l10n.settingsImportProfilesHint,
                  Routes.settingsImportProfiles,
                ),
                const Divider(indent: Insets.md),
                link(
                  Icons.history,
                  l10n.importHistory,
                  l10n.settingsImportHistoryHint,
                  Routes.settingsImportHistory,
                ),
              ],
            ),
          ),
          SectionHeader(l10n.settingsCategorisation),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.auto_awesome_outlined),
                  title: Text(l10n.categoriseUncategorised),
                  subtitle: Text(l10n.categoriseUncategorisedHint),
                  onTap: () async {
                    final changed = await ref
                        .read(categorizationServiceProvider)
                        .recategorize(onlyUncategorized: true);
                    if (context.mounted) {
                      showMessage(context, l10n.recategorizedCount(changed));
                    }
                  },
                ),
                const Divider(indent: Insets.md),
                ListTile(
                  leading: const Icon(Icons.restart_alt),
                  title: Text(l10n.rebuildLearning),
                  subtitle: Text(l10n.rebuildLearningHint),
                  onTap: () async {
                    await ref
                        .read(categorizationServiceProvider)
                        .rebuildClassifier();
                    if (context.mounted) {
                      showMessage(context, l10n.rebuildLearningDone);
                    }
                  },
                ),
              ],
            ),
          ),
          SectionHeader(l10n.settingsAppearance),
          PandaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FieldLabel(l10n.theme),
                SegmentedButton<AppThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: AppThemeMode.system,
                      label: Text(l10n.themeSystem),
                    ),
                    ButtonSegment(
                      value: AppThemeMode.light,
                      label: Text(l10n.themeLight),
                    ),
                    ButtonSegment(
                      value: AppThemeMode.dark,
                      label: Text(l10n.themeDark),
                    ),
                  ],
                  selected: {settings.themeMode},
                  showSelectedIcon: false,
                  onSelectionChanged: (selection) =>
                      update(settings.copyWith(themeMode: selection.first)),
                ),
                gapLg,
                SelectField<String>(
                  label: l10n.language,
                  value: settings.languageCode ?? '',
                  items: {
                    '': l10n.languageSystem,
                    'en': 'English',
                    'de': 'Deutsch',
                  },
                  onChanged: (code) => update(
                    settings.copyWith(
                      languageCode: () =>
                          code == null || code.isEmpty ? null : code,
                    ),
                  ),
                ),
                gapMd,
                SelectField<String>(
                  label: l10n.currency,
                  value: settings.currencyCode,
                  items: {
                    for (final code in AppSettings.supportedCurrencies)
                      code: code,
                  },
                  onChanged: (code) =>
                      update(settings.copyWith(currencyCode: code)),
                ),
              ],
            ),
          ),
          gapXl,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PandaLogo(size: 28),
              gapSm,
              Text(
                l10n.aboutLine,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
