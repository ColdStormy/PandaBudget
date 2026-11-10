# Changing the database schema

The database lives on the user's device, so a new app version has to
upgrade the existing file in place. Three things make that safe:

1. Every released schema version is exported to `drift_schemas/` and kept
   in git.
2. `test/drift/app_database/migration_test.dart` creates a database at each
   old version, runs the app's migration and compares the result with the
   current schema. It also fails if tables were changed without a new
   version.
3. Before an upgrade runs, the app copies the database file to
   `<file>.v<old version>.bak` next to it
   (`backupBeforeUpgrade` in `lib/database/connection.dart`).

## Steps

1. Change the tables in `lib/database/tables.dart`.

2. Raise `currentSchemaVersion` in `lib/database/app_database.dart` by one.

3. Regenerate code and export the new schema. This also writes
   `lib/database/app_database.steps.dart` with typed helpers for each step.

   ```bash
   dart run build_runner build
   ```

   ```bash
   dart run drift_dev make-migrations
   ```

4. Describe the upgrade in `AppDatabase.migration`, replacing the
   placeholder `onUpgrade`:

   ```dart
   import 'package:pandabudget/database/app_database.steps.dart';

   onUpgrade: stepByStep(
     from1To2: (m, schema) async {
       await m.addColumn(schema.accounts, schema.accounts.bankName);
     },
   ),
   ```

   Each step uses the `schema` of *its* target version, so old steps keep
   working when tables change again later.

5. Regenerate the test helpers for all versions and run the tests:

   ```bash
   dart run drift_dev schema generate drift_schemas/app_database/ test/drift/app_database/generated/
   ```

   ```bash
   flutter test test/drift
   ```

6. If the step moves or transforms data (not only adds a column), add a
   test that inserts rows at the old version and checks them after the
   migration. `make-migrations` creates a template for this in
   `test/drift/app_database/` on the first upgrade.

## Rules of thumb

- Never edit an exported file in `drift_schemas/`, and never change a
  migration step that has been released.
- New columns need a default or must be nullable, otherwise existing rows
  cannot be upgraded.
- Enums are stored by name. Adding a value is safe; renaming or removing
  one needs a migration that rewrites the stored names.
