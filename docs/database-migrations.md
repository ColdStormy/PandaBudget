# Changing the database schema

The database lives on the user's device, so a new app version has to
upgrade the existing file in place. Three things make that safe:

1. Every released schema version is exported to `drift_schemas/` and kept
   in git.
2. `test/drift/app_database/migration_test.dart` creates a database at each
   old version, runs the app's migration and compares the result with the
   current schema. It also fails if tables were changed without raising the
   version and exporting a new snapshot.
3. Before an upgrade runs, the app copies the database file to
   `<file>.v<old version>.bak` next to it
   (`backupBeforeUpgrade` in `lib/database/connection.dart`).

## Steps

1. Change the tables in `lib/database/tables.dart`.

2. Raise `currentSchemaVersion` in `lib/database/app_database.dart` by one.

3. Regenerate the database code:

   ```bash
   dart run build_runner build
   ```

4. Export the new schema and generate the migration helpers:

   ```bash
   dart run drift_dev make-migrations
   ```

   This writes `drift_schemas/app_database/drift_schema_v<N>.json`,
   `lib/database/app_database.steps.dart` (typed helpers for each step) and
   the schema classes under `test/drift/app_database/generated/`.

5. Describe the upgrade in `AppDatabase.migration`, replacing the
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

6. Run the migration tests. They now also migrate from the previous
   version:

   ```bash
   flutter test test/drift
   ```

7. Add a test that proves existing data survives, especially when a step
   moves or transforms data rather than only adding a column:

   ```dart
   import 'generated/schema_v1.dart' as v1;

   test('existing accounts survive the upgrade from v1 to v2', () async {
     final schema = await verifier.schemaAt(1);
     final old = v1.DatabaseAtV1(schema.newConnection());
     await old.customStatement(
       "INSERT INTO accounts (name, kind, opening_date, color_value) "
       "VALUES ('Giro', 'checking', 20260101, 1)",
     );
     await old.close();

     final db = AppDatabase(schema.newConnection());
     addTearDown(db.close);
     final accounts = await db.select(db.accounts).get();
     expect(accounts.single.name, 'Giro');
   });
   ```

This exact sequence (adding a nullable `bankName` column to accounts as
version 2) was run once as a rehearsal while setting up the project; it is
not part of the code base, which is still at version 1.

## Rules of thumb

- Never edit an exported file in `drift_schemas/`, and never change a
  migration step that has been released.
- New columns need a default or must be nullable, otherwise existing rows
  cannot be upgraded.
- Enums are stored by name. Adding a value is safe; renaming or removing
  one needs a migration that rewrites the stored names.
