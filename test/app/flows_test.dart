import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/features/accounts/data/drift_account_repository.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';
import 'package:pandabudget/features/categories/data/drift_category_repository.dart';
import 'package:pandabudget/features/importing/data/drift_import_repositories.dart';
import 'package:pandabudget/features/importing/presentation/import_wizard_controller.dart';
import 'package:pandabudget/features/planning/data/drift_planning_repositories.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/transactions/data/drift_transaction_repository.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

/// End-to-end flows through the real app on an in-memory database.
void main() {
  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder.first);
    await tester.pump();
    await tester.tap(finder.first);
    await settle(tester);
  }

  /// Scrolls the visible vertical list until [target] is built and shown.
  Future<void> scrollTo(WidgetTester tester, Finder target) =>
      tester.scrollUntilVisible(
        target,
        300,
        scrollable: find
            .byWidgetPredicate(
              (widget) =>
                  widget is Scrollable &&
                  widget.axisDirection == AxisDirection.down,
            )
            .last,
      );

  Future<void> openSection(WidgetTester tester, String label) => tapAndSettle(
    tester,
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label)),
  );

  Future<int> addAccount(WidgetTester tester, AppDatabase db) async =>
      (await tester.runAsync(
        () => DriftAccountRepository(db).save(
          Account(
            name: 'Giro',
            kind: AccountKind.checking,
            openingDate: DateTime(2026),
          ),
        ),
      ))!;

  appTest('imports a bank file and recognises the format next time', (
    tester,
  ) async {
    final db = createTestDatabase();
    await addAccount(tester, db);
    await pumpApp(
      tester,
      database: db,
      picker: () async => PickedFile(
        name: 'umsaetze.csv',
        bytes: fixtureBytes('german_giro_cp1252.csv'),
      ),
    );

    await openSection(tester, 'Transactions');
    await tapAndSettle(tester, find.text('Import bank file'));
    await tapAndSettle(tester, find.text('Choose a file'));
    expect(find.text('6 rows found'), findsOneWidget);
    expect(find.textContaining('New format.'), findsOneWidget);

    // Step 2: the columns were mapped from the header names.
    await tapAndSettle(tester, find.text('Next'));
    expect(find.text('Buchungstag'), findsWidgets);
    expect(find.text('Betrag (EUR)'), findsWidgets);
    // Further down, the preview shows the first rows as they will be read.
    await scrollTo(tester, find.text('REWE Markt GmbH'));

    // Step 3: review and import.
    await tapAndSettle(tester, find.text('Next'));
    expect(find.text('6 new'), findsOneWidget);
    await tapAndSettle(tester, find.text('Import 6 transactions'));

    expect(find.text('REWE Markt GmbH'), findsOneWidget);
    final stored = await tester.runAsync(
      () => DriftTransactionRepository(db).getAll(),
    );
    expect(stored, hasLength(6));
    final profiles = await tester.runAsync(
      () => DriftImportProfileRepository(db).getAll(),
    );
    expect(profiles!.single.name, 'umsaetze');

    // The second time the format is known and every row is a duplicate.
    await tapAndSettle(tester, find.text('Import'));
    await tapAndSettle(tester, find.text('Choose a file'));
    expect(find.textContaining('Recognised as “umsaetze”'), findsOneWidget);
    await tapAndSettle(tester, find.text('Next'));
    expect(find.text('Nothing new'), findsOneWidget);
    expect(find.text('6 already imported'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Nothing to import'),
          )
          .onPressed,
      isNull,
    );
  });

  appTest('a category chosen by hand is learned for similar payments', (
    tester,
  ) async {
    final db = createTestDatabase();
    final account = await addAccount(tester, db);
    await tester.runAsync(
      () => DriftTransactionRepository(db).saveAll([
        LedgerTransaction(
          accountId: account,
          bookingDate: DateTime(2026, 11, 3),
          amountMinor: -4210,
          counterparty: 'Biomarkt Sonnenblume',
        ),
        LedgerTransaction(
          accountId: account,
          bookingDate: DateTime(2026, 11, 8),
          amountMinor: -1890,
          counterparty: 'Biomarkt Sonnenblume',
        ),
      ]),
    );
    await pumpApp(tester, database: db);
    expect(find.text('2 transactions need a category'), findsOneWidget);

    await openSection(tester, 'Transactions');
    await tapAndSettle(tester, find.byTooltip('Change category'));
    await tapAndSettle(tester, find.text('Groceries'));
    expect(find.text('Category set to Groceries'), findsOneWidget);

    await openSection(tester, 'Settings');
    await tapAndSettle(tester, find.text('Categorise open transactions'));
    expect(find.text('1 transaction updated'), findsOneWidget);

    final groceries = (await tester.runAsync(
      () => DriftCategoryRepository(db).getAll(),
    ))!.firstWhere((c) => c.name == 'Groceries').id;
    final stored = (await tester.runAsync(
      () => DriftTransactionRepository(db).getAll(),
    ))!;
    expect(stored.map((t) => t.categoryId), everyElement(groceries));
    expect(stored.map((t) => t.categorySource).toSet(), {
      CategorySource.manual,
      CategorySource.learned,
    });
  });

  appTest('adds an account through the form', (tester) async {
    final db = await pumpApp(tester);
    await openSection(tester, 'Settings');
    await tapAndSettle(tester, find.text('Accounts'));
    expect(find.text('No accounts yet'), findsOneWidget);

    await tapAndSettle(tester, find.text('Add account'));
    // Saving without a name points at the missing field.
    await tapAndSettle(tester, find.text('Save'));
    expect(find.text('Required'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Giro');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Opening balance'),
      '1,250.50',
    );
    await tapAndSettle(tester, find.text('Save'));

    expect(find.text('Giro'), findsOneWidget);
    final accounts = (await tester.runAsync(
      () => DriftAccountRepository(db).watchAll().first,
    ))!;
    expect(accounts.single.openingBalanceMinor, 125050);
  });

  appTest('a planned salary shows up in the forecast', (tester) async {
    final db = await pumpApp(tester);
    await openSection(tester, 'Planning');
    expect(find.text('Nothing planned yet'), findsOneWidget);

    await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Plan item'));
    await tapAndSettle(tester, find.text('Income'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name'),
      'Salary',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Amount'),
      '3000',
    );
    await tapAndSettle(tester, find.text('Save'));

    final items = (await tester.runAsync(
      () => DriftPlannedItemRepository(db).watchAll().first,
    ))!;
    expect(items.single.kind, PlannedKind.income);
    expect(items.single.amountMinor, 300000);
    expect(items.single.startDate, testToday);

    // November and December 2026 each bring in 3,000.
    expect(find.text('Plus for the year'), findsWidgets);
    expect(find.text('+€6,000.00'), findsOneWidget);
    await scrollTo(tester, find.text('Can be saved in November 2026'));
  });

  appTest('the German app formats money the German way', (tester) async {
    final db = createTestDatabase(languageCode: 'de');
    final account = await addAccount(tester, db);
    await tester.runAsync(
      () => DriftTransactionRepository(db).save(
        LedgerTransaction(
          accountId: account,
          bookingDate: DateTime(2026, 11, 3),
          amountMinor: -123456,
          counterparty: 'Vermieter',
        ),
      ),
    );
    await pumpApp(tester, database: db, languageCode: 'de');
    await tapAndSettle(
      tester,
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Umsätze'),
      ),
    );
    expect(find.text('-1.234,56 €'), findsOneWidget);
    expect(find.text('Dienstag, 3. November'), findsOneWidget);
  });
}
