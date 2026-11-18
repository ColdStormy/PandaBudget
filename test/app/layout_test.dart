import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/app/router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/database/demo_data.dart';
import 'package:pandabudget/features/importing/presentation/import_wizard_controller.dart';
import 'package:pandabudget/features/settings/data/drift_settings_repository.dart';
import 'package:pandabudget/features/settings/domain/app_settings.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

/// Visits every screen in the worst case for layout: German (long words),
/// dark theme and a narrow phone. A `RenderFlex` overflow is reported as an
/// exception, so a label that no longer fits fails here with the screen's
/// name instead of showing up as a yellow-black stripe on a device.
void main() {
  appTest('no screen overflows in German on a 360 px wide phone', (
    tester,
  ) async {
    // The demo data looks categories up by their English names; only the
    // interface is German.
    final db = createTestDatabase();
    await tester.runAsync(() async {
      await seedDemoData(db);
      await DriftSettingsRepository(db).save(
        const AppSettings(languageCode: 'de', themeMode: AppThemeMode.dark),
      );
    });
    await pumpApp(
      tester,
      database: db,
      size: const Size(360, 740),
      languageCode: 'de',
      picker: () async => PickedFile(
        name: 'umsaetze.csv',
        bytes: fixtureBytes('german_giro_cp1252.csv'),
      ),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    final router = container.read(routerProvider);

    Future<void> visit(String name, Future<void> Function() go) async {
      await go();
      await settle(tester);
      expect(tester.takeException(), isNull, reason: name);
    }

    Future<void> openTab(String label) async {
      final tab = find.text(label);
      await tester.ensureVisible(tab.first);
      await tester.tap(tab.first);
    }

    for (final (name, route) in [
      ('Overview', Routes.overview),
      ('Planning', Routes.planning),
      ('Transactions', Routes.transactions),
      ('Analysis', Routes.analysis),
      ('Settings', Routes.settings),
      ('Accounts', Routes.settingsAccounts),
      ('Categories', Routes.settingsCategories),
      ('Rules', Routes.settingsRules),
      ('Import profiles', Routes.settingsImportProfiles),
      ('Import history', Routes.settingsImportHistory),
      ('Account form', Routes.accountEdit(1)),
      ('Category form', Routes.categoryEdit(1)),
      ('Rule form', Routes.ruleEdit()),
      ('Planned item form', Routes.plannedItemEdit()),
      ('Budget form', Routes.budgetEdit()),
      ('Goal form', Routes.goalEdit()),
      ('Transaction form', Routes.transactionEdit()),
      ('Import: file', Routes.importWizard),
    ]) {
      await visit(name, () async {
        // Edit screens are pushed in the app; `go` replaces the stack, which
        // is fine for a layout check.
        router.go(route);
      });
    }

    // The four sections of the Planning tab.
    router.go(Routes.planning);
    await settle(tester);
    for (final label in ['Einnahmen & Zahlungen', 'Budgets', 'Sparziele']) {
      await visit('Planning: $label', () => openTab(label));
    }

    // The later steps of the import wizard.
    router.go(Routes.importWizard);
    await settle(tester);
    final wizard = container.read(importWizardProvider.notifier);
    await visit('Import: picked file', () async {
      await tester.runAsync(wizard.pickFile);
      wizard.selectAccount(1);
    });
    await visit('Import: columns', () async => wizard.goTo(ImportStep.columns));
    await visit('Import: review', () async {
      await tester.runAsync(wizard.buildPreview);
    });
  });
}
