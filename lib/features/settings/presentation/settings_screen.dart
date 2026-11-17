import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/panda_logo.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/core/widgets/page_widgets.dart';
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

    Widget link(IconData icon, String title, String hint, String route) =>
        ActionLink(
          icon: icon,
          label: title,
          caption: hint,
          onTap: () => context.go(route),
        );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: PageBody(
          maxWidth: 760,
          bottomPadding: Insets.xl,
          children: [
            PageHeader(title: l10n.navSettings),
            SectionHeader(l10n.settingsData),
            link(
              Icons.account_balance_outlined,
              l10n.accounts,
              l10n.settingsAccountsHint,
              Routes.settingsAccounts,
            ),
            link(
              Icons.label_outline,
              l10n.categories,
              l10n.settingsCategoriesHint,
              Routes.settingsCategories,
            ),
            link(
              Icons.rule,
              l10n.rules,
              l10n.settingsRulesHint,
              Routes.settingsRules,
            ),
            link(
              Icons.table_chart_outlined,
              l10n.importProfiles,
              l10n.settingsImportProfilesHint,
              Routes.settingsImportProfiles,
            ),
            link(
              Icons.history,
              l10n.importHistory,
              l10n.settingsImportHistoryHint,
              Routes.settingsImportHistory,
            ),
            SectionHeader(l10n.settingsCategorisation),
            PandaListRow(
              leading: const Icon(Icons.auto_awesome_outlined),
              title: l10n.categoriseUncategorised,
              subtitle: l10n.categoriseUncategorisedHint,
              subtitleMaxLines: 3,
              onTap: () async {
                final changed = await ref
                    .read(categorizationServiceProvider)
                    .recategorize(onlyUncategorized: true);
                if (context.mounted) {
                  showMessage(context, l10n.recategorizedCount(changed));
                }
              },
            ),
            PandaListRow(
              leading: const Icon(Icons.restart_alt),
              title: l10n.rebuildLearning,
              subtitle: l10n.rebuildLearningHint,
              subtitleMaxLines: 3,
              onTap: () async {
                await ref
                    .read(categorizationServiceProvider)
                    .rebuildClassifier();
                if (context.mounted) {
                  showMessage(context, l10n.rebuildLearningDone);
                }
              },
            ),
            SectionHeader(l10n.settingsAppearance),
            FieldLabel(l10n.theme),
            ChipBar<AppThemeMode>(
              options: {
                AppThemeMode.system: l10n.themeSystem,
                AppThemeMode.light: l10n.themeLight,
                AppThemeMode.dark: l10n.themeDark,
              },
              selected: settings.themeMode,
              onSelected: (mode) => update(settings.copyWith(themeMode: mode)),
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
                for (final code in AppSettings.supportedCurrencies) code: code,
              },
              onChanged: (code) =>
                  update(settings.copyWith(currencyCode: code)),
            ),
            gapXl,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const PandaLogo(size: 28),
                gapSm,
                Text(l10n.aboutLine, style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
