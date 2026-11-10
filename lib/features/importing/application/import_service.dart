import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:pandabudget/core/time/clock.dart';
import 'package:pandabudget/features/categorization/application/categorization_service.dart';
import 'package:pandabudget/features/importing/data/drift_import_repositories.dart';
import 'package:pandabudget/features/importing/domain/import_parser.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';
import 'package:pandabudget/features/importing/domain/table_reader.dart';
import 'package:pandabudget/features/importing/domain/text_decoder.dart';
import 'package:pandabudget/features/transactions/data/drift_transaction_repository.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

final importServiceProvider = Provider<ImportService>(
  (ref) => ImportService(
    transactions: ref.watch(transactionRepositoryProvider),
    batches: ref.watch(importBatchRepositoryProvider),
    categorization: ref.watch(categorizationServiceProvider),
    clock: ref.watch(clockProvider),
  ),
);

enum ImportRowStatus { ready, duplicate, invalid }

/// A row of the file as it will be shown before importing.
@immutable
class ImportPreviewRow {
  const ImportPreviewRow({required this.parsed, required this.status});

  final ParsedImportRow parsed;
  final ImportRowStatus status;

  /// The transaction with its proposed category; null for invalid rows.
  LedgerTransaction? get transaction => parsed.transaction;
}

@immutable
class ImportPreview {
  const ImportPreview({
    required this.fileName,
    required this.accountId,
    required this.profile,
    required this.rows,
  });

  final String fileName;
  final int accountId;
  final ImportProfile profile;
  final List<ImportPreviewRow> rows;

  Iterable<ImportPreviewRow> _with(ImportRowStatus status) =>
      rows.where((row) => row.status == status);

  int get readyCount => _with(ImportRowStatus.ready).length;

  int get duplicateCount => _with(ImportRowStatus.duplicate).length;

  int get invalidCount => _with(ImportRowStatus.invalid).length;

  int get categorizedCount =>
      _with(ImportRowStatus.ready)
          .where((row) => row.transaction!.categoryId != null)
          .length;
}

/// Reads bank files and turns them into stored transactions.
class ImportService {
  ImportService({
    required this._transactions,
    required this._batches,
    required this._categorization,
    required this._clock,
  });

  final TransactionRepository _transactions;
  final ImportBatchRepository _batches;
  final CategorizationService _categorization;
  final Clock _clock;

  /// Decodes the file into a table using the file-level settings of
  /// [profile] (encoding, delimiter, header row, JSON root).
  static TableData readTable(Uint8List bytes, ImportProfile profile) {
    final text = decodeText(bytes, encoding: profile.encoding);
    return switch (profile.fileType) {
      ImportFileType.csv => readCsv(
        text,
        delimiter: profile.delimiter,
        headerRow: profile.headerRow,
      ),
      ImportFileType.json => readJson(text, rootPath: profile.jsonRootPath),
    };
  }

  /// Parses [table] with [profile], marks rows that were imported before
  /// and proposes categories. Nothing is stored yet.
  Future<ImportPreview> preview({
    required TableData table,
    required ImportProfile profile,
    required int accountId,
    required String fileName,
  }) async {
    final parsed = parseImportRows(table, profile, accountId: accountId);
    final valid = parsed.where((row) => row.isValid).toList();
    final known = await _transactions.existingHashes(accountId, {
      for (final row in valid) row.transaction!.dedupHash!,
    });

    final fresh = valid
        .where((row) => !known.contains(row.transaction!.dedupHash))
        .toList();
    final categorized = await _categorization.categorize([
      for (final row in fresh) row.transaction!,
    ]);
    final categorizedByRow = {
      for (final (index, row) in fresh.indexed)
        row.rowNumber: categorized[index],
    };

    return ImportPreview(
      fileName: fileName,
      accountId: accountId,
      profile: profile,
      rows: [
        for (final row in parsed)
          if (!row.isValid)
            ImportPreviewRow(parsed: row, status: ImportRowStatus.invalid)
          else if (categorizedByRow[row.rowNumber] case final transaction?)
            ImportPreviewRow(
              parsed: ParsedImportRow(
                rowNumber: row.rowNumber,
                cells: row.cells,
                transaction: transaction,
              ),
              status: ImportRowStatus.ready,
            )
          else
            ImportPreviewRow(parsed: row, status: ImportRowStatus.duplicate),
      ],
    );
  }

  /// Stores the new rows of [preview] as one batch and returns how many
  /// transactions were imported.
  Future<int> commit(ImportPreview preview) async {
    final transactions = [
      for (final row in preview.rows)
        if (row.status == ImportRowStatus.ready) row.transaction!,
    ];
    if (transactions.isEmpty) return 0;

    final batchId = await _batches.create(
      ImportBatch(
        accountId: preview.accountId,
        profileId: preview.profile.isNew ? null : preview.profile.id,
        fileName: preview.fileName,
        importedAt: _clock(),
        importedCount: transactions.length,
        duplicateCount: preview.duplicateCount,
      ),
    );
    await _categorization.saveAll([
      for (final transaction in transactions)
        transaction.copyWith(importBatchId: () => batchId),
    ]);
    return transactions.length;
  }

  /// Removes everything a previous import added.
  Future<void> undo(int batchId) async {
    await _transactions.deleteByImportBatch(batchId);
    await _batches.delete(batchId);
  }
}
