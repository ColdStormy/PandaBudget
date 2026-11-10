import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/features/accounts/data/drift_account_repository.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';
import 'package:pandabudget/features/categories/data/drift_category_repository.dart';
import 'package:pandabudget/features/categorization/application/categorization_service.dart';
import 'package:pandabudget/features/categorization/data/drift_categorization_repositories.dart';
import 'package:pandabudget/features/categorization/domain/category_rule.dart';
import 'package:pandabudget/features/transactions/data/drift_transaction_repository.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftTransactionRepository transactions;
  late DriftCategoryRuleRepository rules;
  late DriftClassifierStore store;
  late CategorizationService service;
  late int account;
  late int groceries;
  late int eatingOut;
  late int utilities;

  CategorizationService newService() => CategorizationService(
    rules: rules,
    classifierStore: store,
    transactions: transactions,
  );

  setUp(() async {
    db = createTestDatabase();
    transactions = DriftTransactionRepository(db);
    rules = DriftCategoryRuleRepository(db);
    store = DriftClassifierStore(db);
    service = newService();
    account = await DriftAccountRepository(db).save(
      Account(
        name: 'Giro',
        kind: AccountKind.checking,
        openingDate: DateTime(2026),
      ),
    );
    final byName = {
      for (final c in await DriftCategoryRepository(db).getAll()) c.name: c.id,
    };
    groceries = byName['Groceries']!;
    eatingOut = byName['Eating out']!;
    utilities = byName['Utilities']!;
  });

  tearDown(() => db.close());

  LedgerTransaction tx(String counterparty, {String purpose = ''}) =>
      LedgerTransaction(
        accountId: account,
        bookingDate: DateTime(2026, 10, 3),
        amountMinor: -1234,
        counterparty: counterparty,
        purpose: purpose,
      );

  Future<LedgerTransaction> stored(int id) async =>
      (await transactions.findById(id))!;

  Future<int> addRule(String needle, int categoryId) => rules.save(
    CategoryRule(
      name: needle,
      categoryId: categoryId,
      conditions: [
        RuleCondition(
          field: RuleField.counterparty,
          operator: RuleOperator.contains,
          value: needle,
        ),
      ],
    ),
  );

  test('a manual category teaches the classifier', () async {
    final id = await service.save(tx('Trattoria Roma', purpose: 'Dinner'));
    await service.setCategoryManually(await stored(id), eatingOut);

    final first = await stored(id);
    expect(first.categoryId, eatingOut);
    expect(first.categorySource, CategorySource.manual);
    expect(first.trainedCategoryId, eatingOut);

    final suggestion = (await service.categorize([
      tx('Trattoria Roma', purpose: 'Lunch'),
    ])).single;
    expect(suggestion.categoryId, eatingOut);
    expect(suggestion.categorySource, CategorySource.learned);
  });

  test('what was learned survives a restart', () async {
    final id = await service.save(tx('Trattoria Roma'));
    await service.setCategoryManually(await stored(id), eatingOut);

    final afterRestart = newService();
    final suggestion = (await afterRestart.categorize([tx('Trattoria Roma')]))
        .single;
    expect(suggestion.categoryId, eatingOut);
  });

  test('correcting a category unlearns the old one', () async {
    final id = await service.save(tx('Markthalle Neun'));
    await service.setCategoryManually(await stored(id), groceries);
    await service.setCategoryManually(await stored(id), eatingOut);

    expect((await stored(id)).trainedCategoryId, eatingOut);
    final state = await store.load();
    expect(state.documentCounts, {eatingOut: 1});
    expect(
      state.tokenCounts.values.expand((perCategory) => perCategory.keys),
      everyElement(eatingOut),
    );
  });

  test('clearing a category removes it from the model', () async {
    final id = await service.save(tx('Markthalle Neun'));
    await service.setCategoryManually(await stored(id), groceries);
    await service.setCategoryManually(await stored(id), null);

    final cleared = await stored(id);
    expect(cleared.categoryId, isNull);
    expect(cleared.categorySource, CategorySource.none);
    expect(cleared.trainedCategoryId, isNull);
    expect((await store.load()).isEmpty, isTrue);
  });

  test('rules win over what was learned and also train the model', () async {
    final manual = await service.save(tx('REWE Markt'));
    await service.setCategoryManually(await stored(manual), eatingOut);
    final ruleId = await addRule('rewe', groceries);

    final categorized = (await service.categorize([tx('REWE City')])).single;
    expect(categorized.categoryId, groceries);
    expect(categorized.categorySource, CategorySource.rule);
    expect(categorized.ruleId, ruleId);

    final id = await service.save(categorized);
    expect((await stored(id)).trainedCategoryId, groceries);
    expect((await store.load()).documentCounts[groceries], 1);
  });

  test('suggestions of the classifier do not train it again', () async {
    final id = await service.save(tx('Stadtwerke Musterstadt'));
    await service.setCategoryManually(await stored(id), utilities);

    final learned = (await service.categorize([tx('Stadtwerke Musterstadt')]))
        .single;
    expect(learned.categorySource, CategorySource.learned);
    final learnedId = await service.save(learned);

    expect((await stored(learnedId)).trainedCategoryId, isNull);
    expect((await store.load()).documentCounts, {utilities: 1});
  });

  test('categorize leaves manual categories alone', () async {
    await addRule('rewe', groceries);
    final manual = tx('REWE Bistro').copyWith(
      categoryId: () => eatingOut,
      categorySource: CategorySource.manual,
    );
    expect((await service.categorize([manual])).single.categoryId, eatingOut);
  });

  test('recategorize applies a new rule to stored transactions', () async {
    final open = await service.save(tx('REWE Markt'));
    final other = await service.save(tx('Unknown Shop'));
    final manual = await service.save(tx('REWE Bistro'));
    await service.setCategoryManually(await stored(manual), eatingOut);

    await addRule('rewe', groceries);
    final changed = await service.recategorize();

    expect(changed, 1);
    expect((await stored(open)).categoryId, groceries);
    expect((await stored(open)).categorySource, CategorySource.rule);
    expect((await stored(other)).categoryId, isNull);
    expect((await stored(manual)).categoryId, eatingOut);
    // Running it again changes nothing.
    expect(await service.recategorize(), 0);
  });

  test('recategorize can be limited to uncategorised transactions', () async {
    final ruleA = await addRule('rewe', groceries);
    final id = await service.save(
      (await service.categorize([tx('REWE Markt')])).single,
    );
    // Point the rule somewhere else; the stored result should stay.
    final rule = (await rules.getAll()).single;
    await rules.save(rule.copyWith(categoryId: eatingOut));

    expect(await service.recategorize(onlyUncategorized: true), 0);
    expect((await stored(id)).categoryId, groceries);
    expect(await service.recategorize(), 1);
    expect((await stored(id)).categoryId, eatingOut);
    expect((await stored(id)).ruleId, ruleA);
  });

  test('rebuildClassifier relearns from rules and manual choices', () async {
    final id = await service.save(tx('Trattoria Roma'));
    await service.setCategoryManually(await stored(id), eatingOut);
    await store.clear();
    service.invalidate();
    expect(
      (await service.categorize([tx('Trattoria Roma')])).single.categoryId,
      isNull,
    );

    await service.rebuildClassifier();

    expect((await store.load()).documentCounts, {eatingOut: 1});
    expect(
      (await service.categorize([tx('Trattoria Roma')])).single.categoryId,
      eatingOut,
    );
  });
}
