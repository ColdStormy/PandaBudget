import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/features/accounts/data/drift_account_repository.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';
import 'package:pandabudget/features/categories/data/drift_category_repository.dart';
import 'package:pandabudget/features/categorization/application/categorization_service.dart';
import 'package:pandabudget/features/categorization/data/drift_categorization_repositories.dart';
import 'package:pandabudget/features/categorization/domain/category_rule.dart';
import 'package:pandabudget/features/importing/application/import_service.dart';
import 'package:pandabudget/features/importing/data/drift_import_repositories.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';
import 'package:pandabudget/features/importing/domain/profile_suggester.dart';
import 'package:pandabudget/features/transactions/data/drift_transaction_repository.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftTransactionRepository transactions;
  late DriftImportBatchRepository batches;
  late CategorizationService categorization;
  late ImportService service;
  late int account;
  late int groceries;

  setUp(() async {
    db = createTestDatabase();
    transactions = DriftTransactionRepository(db);
    batches = DriftImportBatchRepository(db);
    categorization = CategorizationService(
      rules: DriftCategoryRuleRepository(db),
      classifierStore: DriftClassifierStore(db),
      transactions: transactions,
    );
    service = ImportService(
      transactions: transactions,
      batches: batches,
      categorization: categorization,
      clock: () => DateTime(2026, 11, 10, 9),
    );
    account = await DriftAccountRepository(db).save(
      Account(
        name: 'Giro',
        kind: AccountKind.checking,
        openingDate: DateTime(2026),
      ),
    );
    groceries = (await DriftCategoryRepository(
      db,
    ).getAll()).firstWhere((c) => c.name == 'Groceries').id;
  });

  tearDown(() => db.close());

  Future<ImportPreview> previewOf(String fixture, {int? accountId}) {
    final bytes = fixtureBytes(fixture);
    final table = ImportService.readTable(
      bytes,
      ImportProfile(
        name: 'x',
        fileType: fixture.endsWith('.json')
            ? ImportFileType.json
            : ImportFileType.csv,
      ),
    );
    return service.preview(
      table: table,
      profile: suggestProfile(
        table,
        name: 'Bank',
        fileType: fixture.endsWith('.json')
            ? ImportFileType.json
            : ImportFileType.csv,
      ),
      accountId: accountId ?? account,
      fileName: fixture,
    );
  }

  test('imports a bank file and records the batch', () async {
    final preview = await previewOf('german_giro_cp1252.csv');
    expect(preview.readyCount, 6);
    expect(preview.duplicateCount, 0);
    expect(preview.invalidCount, 0);

    expect(await service.commit(preview), 6);

    final stored = await transactions.getAll();
    expect(stored, hasLength(6));
    final batch = (await batches.watchAll().first).single;
    expect(batch.fileName, 'german_giro_cp1252.csv');
    expect(batch.importedCount, 6);
    expect(batch.importedAt, DateTime(2026, 11, 10, 9));
    expect(stored.every((t) => t.importBatchId == batch.id), isTrue);
  });

  test('importing the same file twice adds nothing', () async {
    await service.commit(await previewOf('german_giro_cp1252.csv'));

    final again = await previewOf('german_giro_cp1252.csv');
    expect(again.readyCount, 0);
    expect(again.duplicateCount, 6);
    expect(await service.commit(again), 0);
    expect(await transactions.getAll(), hasLength(6));
    expect(await batches.watchAll().first, hasLength(1));
  });

  test('the same file may be imported into another account', () async {
    await service.commit(await previewOf('german_giro_cp1252.csv'));
    final other = await DriftAccountRepository(db).save(
      Account(
        name: 'Second',
        kind: AccountKind.checking,
        openingDate: DateTime(2026),
      ),
    );
    final preview = await previewOf('german_giro_cp1252.csv', accountId: other);
    expect(preview.readyCount, 6);
  });

  test('skips unreadable rows and imports the rest', () async {
    final preview = await previewOf('english_debit_credit.csv');
    expect(preview.invalidCount, 1);
    expect(preview.readyCount, 4);
    expect(await service.commit(preview), 4);
  });

  test('proposes categories from rules and learns from them', () async {
    await DriftCategoryRuleRepository(db).save(
      CategoryRule(
        name: 'REWE',
        categoryId: groceries,
        conditions: const [
          RuleCondition(
            field: RuleField.counterparty,
            operator: RuleOperator.contains,
            value: 'rewe',
          ),
        ],
      ),
    );

    final preview = await previewOf('german_giro_cp1252.csv');
    expect(preview.categorizedCount, 1);
    final rewe = preview.rows.first.transaction!;
    expect(rewe.categoryId, groceries);
    expect(rewe.categorySource, CategorySource.rule);

    await service.commit(preview);
    final stored = (await transactions.getAll()).firstWhere(
      (t) => t.counterparty.startsWith('REWE'),
    );
    expect(stored.trainedCategoryId, groceries);
  });

  test('reads JSON exports', () async {
    final preview = await previewOf('bank_export.json');
    expect(preview.readyCount, 2);
    final first = preview.rows.first.transaction!;
    expect(first.amountMinor, -1250);
    expect(first.bookingDate, DateTime(2026, 10));
    expect(first.counterparty, 'Bakery');
  });

  test('undo removes exactly the transactions of that import', () async {
    await categorization.save(
      LedgerTransaction(
        accountId: account,
        bookingDate: DateTime(2026, 10),
        amountMinor: -100,
        counterparty: 'Manual entry',
      ),
    );
    await service.commit(await previewOf('german_giro_cp1252.csv'));
    final batch = (await batches.watchAll().first).single;

    await service.undo(batch.id);

    final remaining = await transactions.getAll();
    expect(remaining.single.counterparty, 'Manual entry');
    expect(await batches.watchAll().first, isEmpty);
    // After undoing, the file can be imported again.
    expect((await previewOf('german_giro_cp1252.csv')).readyCount, 6);
  });
}
