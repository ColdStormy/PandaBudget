import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/database/database_provider.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';

final importProfileRepositoryProvider = Provider<ImportProfileRepository>(
  (ref) => DriftImportProfileRepository(ref.watch(appDatabaseProvider)),
);

final importBatchRepositoryProvider = Provider<ImportBatchRepository>(
  (ref) => DriftImportBatchRepository(ref.watch(appDatabaseProvider)),
);

class DriftImportProfileRepository implements ImportProfileRepository {
  DriftImportProfileRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$ImportProfilesTable, ImportProfileRow> get _query =>
      _db.select(_db.importProfiles)
        ..orderBy([(p) => OrderingTerm(expression: p.name)]);

  @override
  Stream<List<ImportProfile>> watchAll() =>
      _query.watch().map((rows) => rows.map(_toEntity).toList());

  @override
  Future<List<ImportProfile>> getAll() async =>
      (await _query.get()).map(_toEntity).toList();

  @override
  Future<int> save(ImportProfile profile) async {
    final id = await _db
        .into(_db.importProfiles)
        .insertOnConflictUpdate(
          ImportProfilesCompanion(
            id: profile.isNew ? const Value.absent() : Value(profile.id),
            name: Value(profile.name),
            fileType: Value(profile.fileType),
            delimiter: Value(profile.delimiter),
            encoding: Value(profile.encoding),
            headerRow: Value(profile.headerRow),
            dateFormat: Value(profile.dateFormat),
            decimalSeparator: Value(profile.decimalSeparator),
            amountMode: Value(profile.amountMode),
            mapping: Value(profile.mapping),
            invertSign: Value(profile.invertSign),
            debitIndicators: Value(profile.debitIndicators),
            jsonRootPath: Value(profile.jsonRootPath),
          ),
        );
    return profile.isNew ? id : profile.id;
  }

  @override
  Future<void> delete(int id) =>
      (_db.delete(_db.importProfiles)..where((p) => p.id.equals(id))).go();

  static ImportProfile _toEntity(ImportProfileRow row) => ImportProfile(
    id: row.id,
    name: row.name,
    fileType: row.fileType,
    delimiter: row.delimiter,
    encoding: row.encoding,
    headerRow: row.headerRow,
    dateFormat: row.dateFormat,
    decimalSeparator: row.decimalSeparator,
    amountMode: row.amountMode,
    mapping: row.mapping,
    invertSign: row.invertSign,
    debitIndicators: row.debitIndicators,
    jsonRootPath: row.jsonRootPath,
  );
}

class DriftImportBatchRepository implements ImportBatchRepository {
  DriftImportBatchRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<ImportBatch>> watchAll() =>
      (_db.select(
        _db.importBatches,
      )..orderBy([(b) => OrderingTerm.desc(b.importedAt)])).watch().map(
        (rows) => [
          for (final row in rows)
            ImportBatch(
              id: row.id,
              accountId: row.accountId,
              profileId: row.profileId,
              fileName: row.fileName,
              importedAt: row.importedAt,
              importedCount: row.importedCount,
              duplicateCount: row.duplicateCount,
            ),
        ],
      );

  @override
  Future<int> create(ImportBatch batch) => _db
      .into(_db.importBatches)
      .insert(
        ImportBatchesCompanion.insert(
          accountId: batch.accountId,
          profileId: Value(batch.profileId),
          fileName: batch.fileName,
          importedAt: batch.importedAt,
          importedCount: Value(batch.importedCount),
          duplicateCount: Value(batch.duplicateCount),
        ),
      );

  @override
  Future<void> delete(int id) =>
      (_db.delete(_db.importBatches)..where((b) => b.id.equals(id))).go();
}
