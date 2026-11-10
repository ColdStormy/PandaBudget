import 'package:drift/drift.dart';
import 'package:pandabudget/database/converters.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

// Enums are stored by name, so reordering or adding values never changes the
// meaning of existing rows. Amounts are integers in minor units (cents).

@DataClassName('AccountRow')
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get kind => textEnum<AccountKind>()();
  TextColumn get iban => text().nullable()();
  IntColumn get openingBalanceMinor =>
      integer().withDefault(const Constant(0))();
  IntColumn get openingDate => integer().map(const DateOnlyConverter())();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  IntColumn get colorValue => integer()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@DataClassName('CategoryRow')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get kind => textEnum<CategoryKind>()();
  IntColumn get parentId => integer().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get colorValue => integer()();
  TextColumn get iconKey => text().withDefault(const Constant('category'))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@DataClassName('ImportProfileRow')
class ImportProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get fileType => textEnum<ImportFileType>()();
  TextColumn get delimiter => text().withDefault(const Constant(''))();
  TextColumn get encoding => textEnum<TextEncoding>()();
  IntColumn get headerRow => integer().withDefault(const Constant(-1))();
  TextColumn get dateFormat => text()();
  TextColumn get decimalSeparator => text()();
  TextColumn get amountMode => textEnum<AmountMode>()();
  TextColumn get mapping => text().map(const FieldMappingConverter())();
  BoolColumn get invertSign => boolean().withDefault(const Constant(false))();
  TextColumn get debitIndicators => text()();
  TextColumn get jsonRootPath => text().withDefault(const Constant(''))();
}

@DataClassName('ImportBatchRow')
class ImportBatches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get profileId => integer().nullable().references(
    ImportProfiles,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get fileName => text()();
  DateTimeColumn get importedAt => dateTime()();
  IntColumn get importedCount => integer().withDefault(const Constant(0))();
  IntColumn get duplicateCount => integer().withDefault(const Constant(0))();
}

@DataClassName('CategoryRuleRow')
class CategoryRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  BoolColumn get matchAll => boolean().withDefault(const Constant(true))();
  TextColumn get conditions => text().map(const RuleConditionsConverter())();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
}

@DataClassName('TransactionRow')
@TableIndex(
  name: 'transactions_account_date',
  columns: {#accountId, #bookingDate},
)
@TableIndex(name: 'transactions_date', columns: {#bookingDate})
@TableIndex(name: 'transactions_category', columns: {#categoryId})
@TableIndex(name: 'transactions_dedup', columns: {#accountId, #dedupHash})
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get bookingDate => integer().map(const DateOnlyConverter())();
  IntColumn get valueDate =>
      integer().map(const DateOnlyConverter()).nullable()();
  IntColumn get amountMinor => integer()();
  TextColumn get counterparty => text().withDefault(const Constant(''))();
  TextColumn get purpose => text().withDefault(const Constant(''))();
  TextColumn get counterpartyIban => text().nullable()();
  IntColumn get categoryId => integer().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get categorySource => textEnum<CategorySource>()();
  IntColumn get ruleId => integer().nullable().references(
    CategoryRules,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get trainedCategoryId => integer().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get note => text().withDefault(const Constant(''))();
  IntColumn get importBatchId => integer().nullable().references(
    ImportBatches,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get dedupHash => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Naive Bayes model: how often a token was seen in a category.
@DataClassName('ClassifierTokenRow')
class ClassifierTokens extends Table {
  TextColumn get token => text()();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  IntColumn get count => integer()();

  @override
  Set<Column<Object>> get primaryKey => {token, categoryId};
}

/// Naive Bayes model: training examples seen per category.
@DataClassName('ClassifierCategoryRow')
class ClassifierCategories extends Table {
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  IntColumn get documentCount => integer()();

  @override
  Set<Column<Object>> get primaryKey => {categoryId};
}

@DataClassName('PlannedItemRow')
class PlannedItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get kind => textEnum<PlannedKind>()();
  IntColumn get amountMinor => integer()();
  TextColumn get unit => textEnum<RecurrenceUnit>()();
  IntColumn get interval => integer().withDefault(const Constant(1))();
  IntColumn get startDate => integer().map(const DateOnlyConverter())();
  IntColumn get endDate =>
      integer().map(const DateOnlyConverter()).nullable()();
  IntColumn get categoryId => integer().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get accountId => integer().nullable().references(
    Accounts,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

@DataClassName('BudgetRow')
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get amountMinor => integer()();
  IntColumn get startMonth => integer().map(const YearMonthConverter())();
  IntColumn get endMonth =>
      integer().map(const YearMonthConverter()).nullable()();
  IntColumn get colorValue => integer()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

@DataClassName('BudgetCategoryRow')
class BudgetCategories extends Table {
  IntColumn get budgetId =>
      integer().references(Budgets, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>> get primaryKey => {budgetId, categoryId};
}

@DataClassName('SavingsGoalRow')
class SavingsGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get targetMinor => integer()();
  IntColumn get savedMinor => integer().withDefault(const Constant(0))();
  IntColumn get targetMonth => integer().map(const YearMonthConverter())();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  IntColumn get accountId => integer().nullable().references(
    Accounts,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get colorValue => integer()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

@DataClassName('AppSettingRow')
class AppSettingEntries extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
