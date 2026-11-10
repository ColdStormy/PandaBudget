import 'package:drift/drift.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/database/converters.dart';
import 'package:pandabudget/database/seed.dart';
import 'package:pandabudget/database/tables.dart';
import 'package:pandabudget/features/accounts/domain/account.dart';
import 'package:pandabudget/features/categories/domain/category.dart';
import 'package:pandabudget/features/categorization/domain/category_rule.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';
import 'package:pandabudget/features/planning/domain/planned_item.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

part 'app_database.g.dart';

/// The app's local SQLite database.
///
/// Changing the schema: see `docs/database-migrations.md`. In short, edit
/// the tables, raise [schemaVersion], run
/// `dart run drift_dev make-migrations` and add the generated step to
/// [migration].
@DriftDatabase(
  tables: [
    Accounts,
    Categories,
    ImportProfiles,
    ImportBatches,
    CategoryRules,
    Transactions,
    ClassifierTokens,
    ClassifierCategories,
    PlannedItems,
    Budgets,
    BudgetCategories,
    SavingsGoals,
    AppSettingEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e, {this.seedLanguageCode = 'en'});

  /// The schema version this build of the app works with.
  static const int currentSchemaVersion = 1;

  /// Language of the default categories created with a new database.
  final String seedLanguageCode;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await seedDefaultCategories(this, languageCode: seedLanguageCode);
    },
    // Version 1 is the first schema, so there is nothing to upgrade from
    // yet. From version 2 on this becomes
    // `onUpgrade: stepByStep(from1To2: (m, schema) async { ... })`
    // with the helpers that `make-migrations` generates.
    onUpgrade: (migrator, from, to) async {
      throw UnsupportedError('No migration from schema $from to $to.');
    },
    beforeOpen: (details) async {
      // SQLite does not enforce foreign keys unless asked to, per connection.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
