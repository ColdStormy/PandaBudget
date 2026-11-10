import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/database/app_database.dart';

import 'generated/schema.dart';

/// Guards the database schema.
///
/// `drift_schemas/` holds a snapshot of every schema version that has been
/// released. These tests create a database at each old version, let the app
/// migrate it, and compare the result with the snapshot of the current
/// version. They fail when
/// * tables were changed without raising `schemaVersion` and exporting a new
///   snapshot (`dart run drift_dev make-migrations`), or
/// * a migration step does not produce the schema the app expects.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('a snapshot exists for the current schema version', () {
    expect(
      GeneratedHelper.versions,
      contains(AppDatabase.currentSchemaVersion),
    );
  });

  for (final from in GeneratedHelper.versions) {
    test('migrates from v$from to the current schema', () async {
      final schema = await verifier.schemaAt(from);
      final db = AppDatabase(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);
    });
  }

  test('a freshly created database matches the current snapshot', () async {
    final connection = await verifier.startAt(AppDatabase.currentSchemaVersion);
    // startAt creates the snapshot's schema; opening the app database on top
    // validates that the tables defined in code are identical to it.
    final db = AppDatabase(connection);
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);
  });
}
