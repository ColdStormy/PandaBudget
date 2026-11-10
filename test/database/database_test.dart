import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/database/connection.dart';
import 'package:pandabudget/features/accounts/data/drift_account_repository.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';
import 'package:pandabudget/features/categories/data/drift_category_repository.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/categorization/data/drift_categorization_repositories.dart';
import 'package:pandabudget/features/categorization/domain/category_rule.dart';
import 'package:pandabudget/features/importing/data/drift_import_repositories.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';
import 'package:pandabudget/features/planning/data/drift_planning_repositories.dart';
import 'package:pandabudget/features/planning/domain/budget.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/planning/domain/savings_goal.dart';
import 'package:pandabudget/features/settings/data/drift_settings_repository.dart';
import 'package:pandabudget/features/settings/domain/app_settings.dart';
import 'package:pandabudget/features/transactions/data/drift_transaction_repository.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftAccountRepository accounts;
  late DriftCategoryRepository categories;
  late DriftTransactionRepository transactions;

  setUp(() {
    db = createTestDatabase();
    accounts = DriftAccountRepository(db);
    categories = DriftCategoryRepository(db);
    transactions = DriftTransactionRepository(db);
  });

  tearDown(() => db.close());

  Future<int> newAccount({String name = 'Giro', int opening = 0}) =>
      accounts.save(
        Account(
          name: name,
          kind: AccountKind.checking,
          openingDate: DateTime(2026),
          openingBalanceMinor: opening,
        ),
      );

  LedgerTransaction tx(
    int accountId,
    int amount, {
    DateTime? date,
    String counterparty = '',
    String purpose = '',
    int? categoryId,
    String? hash,
  }) => LedgerTransaction(
    accountId: accountId,
    bookingDate: date ?? DateTime(2026, 10, 15),
    amountMinor: amount,
    counterparty: counterparty,
    purpose: purpose,
    categoryId: categoryId,
    dedupHash: hash,
  );

  group('schema', () {
    test('a new database is seeded with default categories', () async {
      final all = await categories.getAll();
      expect(all, isNotEmpty);
      expect(all.map((c) => c.name), containsAll(['Groceries', 'Salary']));
      expect(all.where((c) => c.kind == CategoryKind.transfer), hasLength(1));
      final tree = CategoryTree(all);
      final housing = all.firstWhere((c) => c.name == 'Housing');
      expect(tree.childrenOf(housing.id), hasLength(3));
    });

    test('seeds German names for a German device', () async {
      final german = createTestDatabase(languageCode: 'de');
      addTearDown(german.close);
      final names = (await DriftCategoryRepository(
        german,
      ).getAll()).map((c) => c.name);
      expect(names, containsAll(['Lebensmittel', 'Gehalt', 'Umbuchungen']));
    });

    test('foreign keys are enforced', () async {
      await expectLater(
        transactions.save(tx(999, -100)),
        throwsA(isA<SqliteException>()),
      );
    });

    test('reports the current schema version', () async {
      final row = await db.customSelect('PRAGMA user_version').getSingle();
      expect(row.read<int>('user_version'), AppDatabase.currentSchemaVersion);
    });
  });

  group('accounts', () {
    test('balances are the opening balance plus all transactions', () async {
      final giro = await newAccount(opening: 100000);
      final savings = await newAccount(name: 'Savings');
      await transactions.saveAll([tx(giro, -2500), tx(giro, 500)]);

      final balances = await accounts.watchBalances().first;
      expect(
        {for (final b in balances) b.account.id: b.balanceMinor},
        {giro: 98000, savings: 0},
      );
    });

    test('updates keep the id; archived accounts are hidden', () async {
      final id = await newAccount();
      final account = (await accounts.findById(id))!;
      expect(await accounts.save(account.copyWith(name: 'Main')), id);
      expect((await accounts.findById(id))!.name, 'Main');

      await accounts.save(account.copyWith(isArchived: true));
      expect(await accounts.watchAll().first, isEmpty);
      expect(
        await accounts.watchAll(includeArchived: true).first,
        hasLength(1),
      );
    });

    test('deleting an account removes its transactions', () async {
      final id = await newAccount();
      await transactions.save(tx(id, -100));
      await accounts.delete(id);
      expect(await transactions.getAll(), isEmpty);
    });
  });

  group('categories', () {
    test('deleting a category uncategorises its transactions', () async {
      final account = await newAccount();
      final parent = await categories.save(
        const Category(name: 'Pets', kind: CategoryKind.expense),
      );
      final child = await categories.save(
        Category(name: 'Vet', kind: CategoryKind.expense, parentId: parent),
      );
      final id = await transactions.save(tx(account, -100, categoryId: child));

      await categories.delete(parent);

      final names = (await categories.getAll()).map((c) => c.name);
      expect(names, isNot(contains('Vet')));
      expect((await transactions.findById(id))!.categoryId, isNull);
    });

    test('sub-categories follow the kind of their parent', () async {
      final parent = await categories.save(
        const Category(name: 'Side job', kind: CategoryKind.expense),
      );
      final child = await categories.save(
        Category(name: 'Gigs', kind: CategoryKind.expense, parentId: parent),
      );
      final stored = (await categories.getAll()).firstWhere(
        (c) => c.id == parent,
      );
      await categories.save(stored.copyWith(kind: CategoryKind.income));
      final all = await categories.getAll();
      expect(all.firstWhere((c) => c.id == child).kind, CategoryKind.income);
    });
  });

  group('transactions', () {
    late int giro;
    late int cash;

    setUp(() async {
      giro = await newAccount();
      cash = await newAccount(name: 'Cash');
      final groceries = (await categories.getAll()).firstWhere(
        (c) => c.name == 'Groceries',
      );
      await transactions.saveAll([
        tx(
          giro,
          -5432,
          date: DateTime(2026, 10, 30),
          counterparty: 'REWE Markt GmbH',
          purpose: 'Einkauf 100%',
          categoryId: groceries.id,
        ),
        tx(
          giro,
          325000,
          date: DateTime(2026, 10, 28),
          counterparty: 'Employer',
        ),
        tx(cash, -480, date: DateTime(2026, 9, 15), counterparty: 'Bakery'),
      ]);
    });

    Future<List<LedgerTransaction>> find(TransactionFilter filter) =>
        transactions.watch(filter).first;

    test('lists newest first', () async {
      final all = await find(const TransactionFilter());
      expect(all.map((t) => t.amountMinor), [-5432, 325000, -480]);
    });

    test('searches text in any order and case', () async {
      expect(
        await find(const TransactionFilter(query: 'markt rewe')),
        hasLength(1),
      );
      expect(
        await find(const TransactionFilter(query: 'EINKAUF')),
        hasLength(1),
      );
      expect(
        await find(const TransactionFilter(query: 'rewe bakery')),
        isEmpty,
      );
    });

    test('treats % and _ in the search text literally', () async {
      expect(await find(const TransactionFilter(query: '100%')), hasLength(1));
      expect(await find(const TransactionFilter(query: '1_0')), isEmpty);
    });

    test('filters by account, date, amount and category', () async {
      expect(await find(TransactionFilter(accountId: cash)), hasLength(1));
      expect(
        await find(
          TransactionFilter(
            from: DateTime(2026, 10),
            to: DateTime(2026, 10, 29),
          ),
        ),
        hasLength(1),
      );
      expect(
        await find(const TransactionFilter(minAmountMinor: 0)),
        hasLength(1),
      );
      expect(
        await find(const TransactionFilter(maxAmountMinor: -1000)),
        hasLength(1),
      );
      expect(
        await find(const TransactionFilter(uncategorizedOnly: true)),
        hasLength(2),
      );
      final groceries = (await categories.getAll()).firstWhere(
        (c) => c.name == 'Groceries',
      );
      expect(
        await find(TransactionFilter(categoryIds: {groceries.id})),
        hasLength(1),
      );
    });

    test('watchRange is inclusive on both ends', () async {
      final range = await transactions
          .watchRange(DateTime(2026, 10, 28), DateTime(2026, 10, 30))
          .first;
      expect(range, hasLength(2));
    });

    test('stores dates without a time zone shift', () async {
      final stored = (await find(const TransactionFilter())).first;
      expect(stored.bookingDate, DateTime(2026, 10, 30));
      final raw = await db
          .customSelect(
            'SELECT booking_date FROM transactions ORDER BY id LIMIT 1',
          )
          .getSingle();
      expect(raw.read<int>('booking_date'), 20261030);
    });

    test('finds known fingerprints per account', () async {
      await transactions.saveAll([
        tx(giro, -1, hash: 'a'),
        tx(giro, -2, hash: 'b'),
        tx(cash, -3, hash: 'c'),
      ]);
      expect(await transactions.existingHashes(giro, {'a', 'c', 'x'}), {'a'});
      expect(await transactions.existingHashes(giro, {}), isEmpty);
    });

    test('saveAll updates existing rows in place', () async {
      final first = (await find(const TransactionFilter())).first;
      await transactions.saveAll([first.copyWith(note: 'checked')]);
      final all = await find(const TransactionFilter());
      expect(all, hasLength(3));
      expect(all.first.note, 'checked');
    });
  });

  group('rules and classifier store', () {
    late int category;

    setUp(() async {
      category = (await categories.getAll()).first.id;
    });

    CategoryRule rule(String name) => CategoryRule(
      name: name,
      categoryId: category,
      conditions: const [
        RuleCondition(
          field: RuleField.counterparty,
          operator: RuleOperator.contains,
          value: 'rewe',
        ),
      ],
    );

    test('new rules are appended and can be reordered', () async {
      final rules = DriftCategoryRuleRepository(db);
      final a = await rules.save(rule('a'));
      final b = await rules.save(rule('b'));
      final c = await rules.save(rule('c'));
      expect((await rules.getAll()).map((r) => r.id), [a, b, c]);

      await rules.reorder([c, a, b]);
      final reordered = await rules.getAll();
      expect(reordered.map((r) => r.id), [c, a, b]);
      expect(reordered.first.conditions.single.value, 'rewe');
    });

    test('classifier counts accumulate and vanish at zero', () async {
      final store = DriftClassifierStore(db);
      await store.applyDeltas(
        documentDeltas: {category: 2},
        tokenDeltas: {
          category: {'c:rewe': 2, 'c:markt': 1},
        },
      );
      await store.applyDeltas(
        documentDeltas: {category: -1},
        tokenDeltas: {
          category: {'c:rewe': -1, 'c:markt': -1},
        },
      );
      final state = await store.load();
      expect(state.documentCounts, {category: 1});
      expect(state.tokenCounts, {
        'c:rewe': {category: 1},
      });
      expect(state.tokenTotals, {category: 1});

      await store.clear();
      expect((await store.load()).isEmpty, isTrue);
    });

    test('deleting a category drops its rules and training data', () async {
      final rules = DriftCategoryRuleRepository(db);
      final store = DriftClassifierStore(db);
      await rules.save(rule('a'));
      await store.applyDeltas(
        documentDeltas: {category: 1},
        tokenDeltas: {
          category: {'c:rewe': 1},
        },
      );
      await categories.delete(category);
      expect(await rules.getAll(), isEmpty);
      expect((await store.load()).isEmpty, isTrue);
    });
  });

  group('planning', () {
    test('planned items round-trip', () async {
      final repository = DriftPlannedItemRepository(db);
      final id = await repository.save(
        PlannedItem(
          name: 'Insurance',
          kind: PlannedKind.expense,
          amountMinor: 60000,
          unit: RecurrenceUnit.year,
          startDate: DateTime(2027, 3, 10),
          endDate: DateTime(2030, 3, 10),
        ),
      );
      final stored = (await repository.watchAll().first).single;
      expect(stored.id, id);
      expect(stored.unit, RecurrenceUnit.year);
      expect(stored.startDate, DateTime(2027, 3, 10));
      expect(stored.endDate, DateTime(2030, 3, 10));
      await repository.delete(id);
      expect(await repository.watchAll().first, isEmpty);
    });

    test('budgets keep their categories and replace them on save', () async {
      final repository = DriftBudgetRepository(db);
      final ids = (await categories.getAll()).take(3).map((c) => c.id).toList();
      final id = await repository.save(
        Budget(
          name: 'Food',
          amountMinor: 50000,
          startMonth: const YearMonth(2027, 1),
          categoryIds: {ids[0], ids[1]},
        ),
      );
      var stored = (await repository.watchAll().first).single;
      expect(stored.categoryIds, {ids[0], ids[1]});
      expect(stored.startMonth, const YearMonth(2027, 1));
      expect(stored.endMonth, isNull);

      await repository.save(stored.copyWith(categoryIds: {ids[2]}));
      stored = (await repository.watchAll().first).single;
      expect(stored.id, id);
      expect(stored.categoryIds, {ids[2]});
    });

    test('a budget without categories is still listed', () async {
      final repository = DriftBudgetRepository(db);
      await repository.save(
        const Budget(
          name: 'Empty',
          amountMinor: 1,
          startMonth: YearMonth(2027, 1),
        ),
      );
      expect((await repository.watchAll().first).single.categoryIds, isEmpty);
    });

    test('goals are ordered by priority, then deadline', () async {
      final repository = DriftSavingsGoalRepository(db);
      SavingsGoal goal(String name, int priority, YearMonth by) => SavingsGoal(
        name: name,
        targetMinor: 100000,
        targetMonth: by,
        priority: priority,
      );
      await repository.save(goal('car', 1, const YearMonth(2028, 1)));
      await repository.save(goal('later', 0, const YearMonth(2028, 6)));
      await repository.save(goal('sooner', 0, const YearMonth(2027, 6)));
      expect((await repository.watchAll().first).map((g) => g.name), [
        'sooner',
        'later',
        'car',
      ]);
    });
  });

  group('import profiles', () {
    test('the column mapping survives storage', () async {
      final repository = DriftImportProfileRepository(db);
      const profile = ImportProfile(
        name: 'Bank',
        delimiter: ';',
        amountMode: AmountMode.debitCredit,
        mapping: {
          ImportField.bookingDate: 'Buchungstag',
          ImportField.debit: 'Soll',
          ImportField.credit: 'Haben',
        },
      );
      final id = await repository.save(profile);
      final stored = (await repository.getAll()).single;
      expect(stored.id, id);
      expect(stored.mapping, profile.mapping);
      expect(stored.amountMode, AmountMode.debitCredit);
      expect(stored.isComplete, isTrue);
    });
  });

  group('settings', () {
    test('defaults apply until something is saved', () async {
      final repository = DriftSettingsRepository(db);
      final defaults = await repository.load();
      expect(defaults.currencyCode, 'EUR');
      expect(defaults.languageCode, isNull);
      expect(defaults.themeMode, AppThemeMode.system);

      await repository.save(
        const AppSettings(
          currencyCode: 'CHF',
          languageCode: 'de',
          themeMode: AppThemeMode.dark,
        ),
      );
      final stored = await repository.load();
      expect(stored.currencyCode, 'CHF');
      expect(stored.languageCode, 'de');
      expect(stored.themeMode, AppThemeMode.dark);

      await repository.save(stored.copyWith(languageCode: () => null));
      expect((await repository.load()).languageCode, isNull);
    });
  });

  group('backupBeforeUpgrade', () {
    late Directory directory;

    setUp(() => directory = Directory.systemTemp.createTempSync('panda_db'));
    tearDown(() => directory.deleteSync(recursive: true));

    Future<File> createDatabaseFile({required int version}) async {
      final file = File('${directory.path}/app.sqlite');
      final database = AppDatabase(NativeDatabase(file));
      await database.customStatement('PRAGMA user_version = $version');
      await database.close();
      return file;
    }

    test('reads the schema version from the file header', () async {
      final file = await createDatabaseFile(version: 7);
      expect(await readSchemaVersion(file), 7);
      expect(await readSchemaVersion(File('${directory.path}/none')), isNull);

      final notSqlite = File('${directory.path}/text')
        ..writeAsStringSync('x' * 200);
      expect(await readSchemaVersion(notSqlite), isNull);
    });

    test('copies the file when an upgrade is about to run', () async {
      final file = await createDatabaseFile(version: 1);
      final backup = await backupBeforeUpgrade(file, targetVersion: 2);
      expect(backup, isNotNull);
      expect(backup!.path, endsWith('app.sqlite.v1.bak'));
      expect(backup.lengthSync(), file.lengthSync());
    });

    test(
      'does nothing when the schema is current or the file is new',
      () async {
        final file = await createDatabaseFile(version: 2);
        expect(await backupBeforeUpgrade(file, targetVersion: 2), isNull);
        expect(
          await backupBeforeUpgrade(
            File('${directory.path}/missing.sqlite'),
            targetVersion: 2,
          ),
          isNull,
        );
      },
    );
  });
}
