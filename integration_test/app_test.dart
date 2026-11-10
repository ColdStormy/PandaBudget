import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pandabudget/app/app.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/database/database_provider.dart';
import 'package:pandabudget/features/importing/presentation/import_wizard_controller.dart';
import 'package:pandabudget/features/settings/data/drift_settings_repository.dart';
import 'package:pandabudget/features/settings/domain/app_settings.dart';

/// A bank export as a customer would download it.
const String _bankFile = '''
Booking date;Payee;Purpose;Amount
2026-11-02;REWE Markt;Card payment;-54,32
2026-11-03;Employer Ltd;Salary;3.250,00
2026-11-05;Stadtwerke;Electricity;-79,00
''';

/// Runs the built app on a real device (in CI: the Linux desktop build)
/// and walks through the core workflow once: create an account, import a
/// bank file, see the transactions and the month's figures.
///
///     flutter test integration_test -d linux
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('first use: account, import, analysis', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    // The test looks for English texts, whatever the machine's language.
    await DriftSettingsRepository(database)
        .save(const AppSettings(languageCode: 'en'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          importFilePickerProvider.overrideWithValue(
            () async => PickedFile(
              name: 'export.csv',
              bytes: Uint8List.fromList(utf8.encode(_bankFile)),
            ),
          ),
        ],
        child: const PandaBudgetApp(),
      ),
    );
    await tester.pumpAndSettle();

    /// Database results arrive a moment after a frame settles, so wait
    /// for the expected widget instead of assuming it is there already.
    Future<void> waitFor(Finder finder) async {
      for (var i = 0; i < 100 && finder.evaluate().isEmpty; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(finder, findsWidgets);
    }

    Future<void> tap(Finder finder) async {
      await waitFor(finder);
      await tester.ensureVisible(finder.first);
      await tester.pumpAndSettle();
      await tester.tap(finder.first);
      await tester.pumpAndSettle();
    }

    // The overview guides a new user to the first step.
    await waitFor(find.text('Welcome to PandaBudget'));
    await tap(find.text('Add an account'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Giro');
    await tap(find.text('Save'));

    await tap(find.text('Import transactions'));
    await tap(find.text('Choose a file'));
    await waitFor(find.text('3 rows found'));
    await tap(find.text('Next'));
    await tap(find.text('Next'));
    await tap(find.text('Import 3 transactions'));

    // Back on the overview, the month now has figures.
    await waitFor(find.text('3 transactions need a category'));

    await tap(find.text('Transactions'));
    await waitFor(find.text('REWE Markt'));
    await waitFor(find.text('Employer Ltd'));

    await tap(find.text('Analysis'));
    await waitFor(find.text('By category'));

    final stored = await database.select(database.transactions).get();
    expect(stored.map((t) => t.amountMinor).toSet(), {-5432, 325000, -7900});
  });
}
