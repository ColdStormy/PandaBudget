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

    Future<void> tap(Finder finder) async {
      await tester.ensureVisible(finder.first);
      await tester.pumpAndSettle();
      await tester.tap(finder.first);
      await tester.pumpAndSettle();
    }

    // The overview guides a new user to the first step.
    expect(find.text('Welcome to PandaBudget'), findsOneWidget);
    await tap(find.text('Add an account'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Giro');
    await tap(find.text('Save'));

    await tap(find.text('Import transactions'));
    await tap(find.text('Choose a file'));
    expect(find.text('3 rows found'), findsOneWidget);
    await tap(find.text('Next'));
    await tap(find.text('Next'));
    await tap(find.text('Import 3 transactions'));

    // Back on the overview, the month now has figures.
    expect(find.text('3 transactions need a category'), findsOneWidget);

    await tap(find.text('Transactions'));
    expect(find.text('REWE Markt'), findsOneWidget);
    expect(find.text('Employer Ltd'), findsOneWidget);

    await tap(find.text('Analysis'));
    expect(find.text('By category'), findsOneWidget);

    final stored = await database.select(database.transactions).get();
    expect(stored.map((t) => t.amountMinor).toSet(), {-5432, 325000, -7900});
  });
}
