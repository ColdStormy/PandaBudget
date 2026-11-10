import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:pandabudget/features/importing/application/import_service.dart';
import 'package:pandabudget/features/importing/data/drift_import_repositories.dart';
import 'package:pandabudget/features/importing/domain/import_parser.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';
import 'package:pandabudget/features/importing/domain/profile_suggester.dart';
import 'package:pandabudget/features/importing/domain/table_reader.dart';

@immutable
class PickedFile {
  const PickedFile({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;
}

/// Lets the user choose a bank file. Returns null if they cancel.
typedef ImportFilePicker = Future<PickedFile?> Function();

/// Overridden in tests to supply a file without a native dialog.
final importFilePickerProvider = Provider<ImportFilePicker>(
  (ref) => () async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['csv', 'txt', 'json'],
    );
    if (file == null) return null;
    return PickedFile(name: file.name, bytes: await file.readAsBytes());
  },
);

enum ImportStep { file, columns, review }

@immutable
class ImportWizardState {
  const ImportWizardState({
    this.step = ImportStep.file,
    this.file,
    this.accountId,
    this.profile,
    this.table,
    this.tableError,
    this.usesSavedProfile = false,
    this.rememberProfile = true,
    this.preview,
    this.isBusy = false,
  });

  final ImportStep step;
  final PickedFile? file;
  final int? accountId;

  /// The format description being applied; a saved profile or a suggestion.
  final ImportProfile? profile;
  final TableData? table;
  final String? tableError;

  /// Whether [profile] was recognised from the saved bank formats.
  final bool usesSavedProfile;
  final bool rememberProfile;
  final ImportPreview? preview;
  final bool isBusy;

  bool get canContinueFromFile =>
      file != null && table != null && accountId != null;

  bool get canContinueFromColumns =>
      table != null && (profile?.isComplete ?? false);

  /// The first rows parsed with the current mapping, shown while mapping.
  List<ParsedImportRow> sampleRows({int count = 5}) {
    final table = this.table;
    final profile = this.profile;
    if (table == null || profile == null) return const [];
    return parseImportRows(
      TableData(headers: table.headers, rows: table.rows.take(count).toList()),
      profile,
      accountId: accountId ?? 0,
    );
  }

  ImportWizardState copyWith({
    ImportStep? step,
    PickedFile? file,
    int? Function()? accountId,
    ImportProfile? profile,
    TableData? Function()? table,
    String? Function()? tableError,
    bool? usesSavedProfile,
    bool? rememberProfile,
    ImportPreview? Function()? preview,
    bool? isBusy,
  }) => ImportWizardState(
    step: step ?? this.step,
    file: file ?? this.file,
    accountId: accountId != null ? accountId() : this.accountId,
    profile: profile ?? this.profile,
    table: table != null ? table() : this.table,
    tableError: tableError != null ? tableError() : this.tableError,
    usesSavedProfile: usesSavedProfile ?? this.usesSavedProfile,
    rememberProfile: rememberProfile ?? this.rememberProfile,
    preview: preview != null ? preview() : this.preview,
    isBusy: isBusy ?? this.isBusy,
  );
}

final importWizardProvider =
    NotifierProvider.autoDispose<ImportWizardController, ImportWizardState>(
      ImportWizardController.new,
    );

/// Drives the three import steps: choose file, map columns, review.
class ImportWizardController extends Notifier<ImportWizardState> {
  @override
  ImportWizardState build() => const ImportWizardState();

  void selectAccount(int? accountId) =>
      state = state.copyWith(accountId: () => accountId);

  void setRememberProfile({required bool remember}) =>
      state = state.copyWith(rememberProfile: remember);

  void goTo(ImportStep step) => state = state.copyWith(step: step);

  Future<void> pickFile() async {
    final picked = await ref.read(importFilePickerProvider)();
    if (picked == null) return;
    await loadFile(picked);
  }

  /// Reads [file], recognises a saved bank format or proposes a new one.
  Future<void> loadFile(PickedFile file) async {
    final fileType = _looksLikeJson(file)
        ? ImportFileType.json
        : ImportFileType.csv;
    final baseName = file.name.replaceFirst(RegExp(r'\.[^.]+$'), '');
    final saved = await ref.read(importProfileRepositoryProvider).getAll();

    // A saved profile may need its own delimiter or header row to read the
    // file, so each candidate reads the file with its own settings.
    for (final candidate in saved.where((p) => p.fileType == fileType)) {
      final table = _tryRead(file, candidate);
      if (table != null && candidate.matchesHeaders(table.headers)) {
        state = state.copyWith(
          file: file,
          profile: candidate,
          table: () => table,
          tableError: () => null,
          usesSavedProfile: true,
          preview: () => null,
        );
        return;
      }
    }

    try {
      final table = ImportService.readTable(
        file.bytes,
        ImportProfile(name: baseName, fileType: fileType),
      );
      state = state.copyWith(
        file: file,
        profile: suggestProfile(table, name: baseName, fileType: fileType),
        table: () => table,
        tableError: () => null,
        usesSavedProfile: false,
        preview: () => null,
      );
    } on TableFormatException catch (error) {
      state = state.copyWith(
        file: file,
        profile: ImportProfile(name: baseName, fileType: fileType),
        table: () => null,
        tableError: () => error.message,
        usesSavedProfile: false,
        preview: () => null,
      );
    }
  }

  /// Switches to one of the saved bank formats (or back to the suggestion
  /// with null).
  Future<void> useSavedProfile(ImportProfile? profile) async {
    final file = state.file;
    if (file == null) return;
    if (profile == null) {
      await loadFile(file);
      return;
    }
    _applyProfile(profile, usesSaved: true);
  }

  /// Applies edits from the column mapping form.
  void updateProfile(ImportProfile profile) =>
      _applyProfile(profile, usesSaved: state.usesSavedProfile);

  void _applyProfile(ImportProfile profile, {required bool usesSaved}) {
    final file = state.file;
    final previous = state.profile;
    final needsReread =
        file != null &&
        (previous == null ||
            state.table == null ||
            previous.delimiter != profile.delimiter ||
            previous.encoding != profile.encoding ||
            previous.headerRow != profile.headerRow ||
            previous.jsonRootPath != profile.jsonRootPath);
    if (!needsReread) {
      state = state.copyWith(
        profile: profile,
        usesSavedProfile: usesSaved,
        preview: () => null,
      );
      return;
    }
    try {
      final table = ImportService.readTable(file.bytes, profile);
      state = state.copyWith(
        profile: profile,
        table: () => table,
        tableError: () => null,
        usesSavedProfile: usesSaved,
        preview: () => null,
      );
    } on TableFormatException catch (error) {
      state = state.copyWith(
        profile: profile,
        table: () => null,
        tableError: () => error.message,
        usesSavedProfile: usesSaved,
        preview: () => null,
      );
    }
  }

  /// Parses the whole file and moves on to the review step.
  Future<void> buildPreview() async {
    final current = state;
    if (!current.canContinueFromColumns || current.accountId == null) return;
    state = current.copyWith(isBusy: true);
    final preview = await ref
        .read(importServiceProvider)
        .preview(
          table: current.table!,
          profile: current.profile!,
          accountId: current.accountId!,
          fileName: current.file!.name,
        );
    state = state.copyWith(
      preview: () => preview,
      step: ImportStep.review,
      isBusy: false,
    );
  }

  /// Stores the transactions (and the bank format, if asked to). Returns
  /// the number of imported transactions.
  Future<int> commit() async {
    final current = state;
    final preview = current.preview;
    if (preview == null) return 0;
    state = current.copyWith(isBusy: true);

    var profile = preview.profile;
    if (current.rememberProfile) {
      final id = await ref.read(importProfileRepositoryProvider).save(profile);
      profile = profile.copyWith(id: id);
    }
    final count = await ref
        .read(importServiceProvider)
        .commit(
          ImportPreview(
            fileName: preview.fileName,
            accountId: preview.accountId,
            profile: profile,
            rows: preview.rows,
          ),
        );
    state = state.copyWith(isBusy: false);
    return count;
  }

  static TableData? _tryRead(PickedFile file, ImportProfile profile) {
    try {
      return ImportService.readTable(file.bytes, profile);
    } on TableFormatException {
      return null;
    }
  }

  static bool _looksLikeJson(PickedFile file) {
    if (file.name.toLowerCase().endsWith('.json')) return true;
    for (final byte in file.bytes.take(64)) {
      // Skip whitespace and a byte order mark.
      const skipped = {0x20, 0x0A, 0x0D, 0x09, 0xEF, 0xBB, 0xBF};
      if (skipped.contains(byte)) continue;
      return byte == 0x7B || byte == 0x5B;
    }
    return false;
  }
}
