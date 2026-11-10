import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/features/importing/data/drift_import_repositories.dart';
import 'package:pandabudget/features/importing/domain/field_parsers.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';

final importProfilesProvider = StreamProvider<List<ImportProfile>>(
  (ref) => ref.watch(importProfileRepositoryProvider).watchAll(),
);

final importBatchesProvider = StreamProvider<List<ImportBatch>>(
  (ref) => ref.watch(importBatchRepositoryProvider).watchAll(),
);

String importFieldLabel(AppLocalizations l10n, ImportField field) =>
    switch (field) {
      ImportField.bookingDate => l10n.bookingDate,
      ImportField.valueDate => l10n.valueDate,
      ImportField.amount => l10n.amount,
      ImportField.debit => l10n.importFieldDebit,
      ImportField.credit => l10n.importFieldCredit,
      ImportField.indicator => l10n.importFieldIndicator,
      ImportField.counterparty => l10n.counterparty,
      ImportField.purpose => l10n.purpose,
      ImportField.counterpartyIban => l10n.iban,
      ImportField.note => l10n.note,
    };

String amountModeLabel(AppLocalizations l10n, AmountMode mode) =>
    switch (mode) {
      AmountMode.signed => l10n.amountModeSigned,
      AmountMode.debitCredit => l10n.amountModeDebitCredit,
      AmountMode.indicator => l10n.amountModeIndicator,
    };

/// The fields that describe a bank's export format.
///
/// With [headers] (while importing a file) columns are picked from the
/// file's header row. Without them (editing a saved profile) the column
/// names are typed in.
class ImportProfileForm extends StatelessWidget {
  const ImportProfileForm({
    required this.profile,
    required this.onChanged,
    this.headers,
    super.key,
  });

  final ImportProfile profile;
  final ValueChanged<ImportProfile> onChanged;
  final List<String>? headers;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isCsv = profile.fileType == ImportFileType.csv;

    Widget mappingField(ImportField field) {
      final required = profile.requiredFields.contains(field);
      final label = '${importFieldLabel(l10n, field)}${required ? ' *' : ''}';
      final current = profile.mapping[field] ?? '';

      void update(String? column) => onChanged(
        profile.copyWith(
          mapping: {
            for (final entry in profile.mapping.entries)
              if (entry.key != field) entry.key: entry.value,
            if (column != null && column.isNotEmpty) field: column,
          },
        ),
      );

      if (headers == null) {
        return TextFormField(
          key: ValueKey('mapping-${field.name}'),
          initialValue: current,
          decoration: InputDecoration(
            labelText: label,
            hintText: l10n.columnNameHint,
          ),
          onChanged: update,
        );
      }
      return SelectField<String>(
        label: label,
        value: headers!.contains(current) ? current : '',
        items: {
          '': l10n.notMapped,
          for (final header in headers!) header: header,
        },
        onChanged: update,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: const ValueKey('profile-name'),
          initialValue: profile.name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: l10n.profileName,
            hintText: l10n.profileNameHint,
          ),
          validator: (value) => requiredValidator(context, value),
          onChanged: (name) => onChanged(profile.copyWith(name: name)),
        ),
        gapLg,
        FieldLabel(l10n.fileFormat),
        if (headers == null) ...[
          SelectField<ImportFileType>(
            label: l10n.fileType,
            value: profile.fileType,
            items: const {
              ImportFileType.csv: 'CSV',
              ImportFileType.json: 'JSON',
            },
            onChanged: (type) => onChanged(profile.copyWith(fileType: type)),
          ),
          gapMd,
        ],
        if (isCsv) ...[
          Row(
            children: [
              Expanded(
                child: SelectField<String>(
                  label: l10n.delimiter,
                  value: profile.delimiter,
                  items: {
                    '': l10n.detectAutomatically,
                    ';': l10n.delimiterSemicolon,
                    ',': l10n.delimiterComma,
                    '\t': l10n.delimiterTab,
                    '|': l10n.delimiterPipe,
                  },
                  onChanged: (delimiter) =>
                      onChanged(profile.copyWith(delimiter: delimiter)),
                ),
              ),
              gapMd,
              Expanded(
                child: SelectField<TextEncoding>(
                  label: l10n.encoding,
                  value: profile.encoding,
                  items: {
                    TextEncoding.auto: l10n.detectAutomatically,
                    TextEncoding.utf8: 'UTF-8',
                    TextEncoding.latin1: 'Windows-1252',
                  },
                  onChanged: (encoding) =>
                      onChanged(profile.copyWith(encoding: encoding)),
                ),
              ),
            ],
          ),
          gapMd,
          TextFormField(
            key: const ValueKey('profile-header-row'),
            initialValue: profile.headerRow < 0
                ? ''
                : '${profile.headerRow + 1}',
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.headerRow,
              helperText: l10n.headerRowHint,
            ),
            onChanged: (value) {
              final line = int.tryParse(value.trim());
              onChanged(
                profile.copyWith(
                  headerRow: line == null || line < 1
                      ? ImportProfile.autoHeaderRow
                      : line - 1,
                ),
              );
            },
          ),
        ] else
          TextFormField(
            key: const ValueKey('profile-json-root'),
            initialValue: profile.jsonRootPath,
            decoration: InputDecoration(
              labelText: l10n.jsonRootPath,
              helperText: l10n.jsonRootPathHint,
            ),
            onChanged: (path) =>
                onChanged(profile.copyWith(jsonRootPath: path.trim())),
          ),
        gapMd,
        Row(
          children: [
            Expanded(
              child: SelectField<String>(
                label: l10n.dateFormat,
                value: profile.dateFormat,
                items: {
                  for (final format in supportedDateFormats) format: format,
                },
                onChanged: (format) =>
                    onChanged(profile.copyWith(dateFormat: format)),
              ),
            ),
            gapMd,
            Expanded(
              child: SelectField<String>(
                label: l10n.decimalSeparator,
                value: profile.decimalSeparator,
                items: {',': l10n.decimalComma, '.': l10n.decimalPoint},
                onChanged: (separator) =>
                    onChanged(profile.copyWith(decimalSeparator: separator)),
              ),
            ),
          ],
        ),
        gapMd,
        SelectField<AmountMode>(
          label: l10n.amountLayout,
          value: profile.amountMode,
          items: {
            for (final mode in AmountMode.values)
              mode: amountModeLabel(l10n, mode),
          },
          onChanged: (mode) => onChanged(profile.copyWith(amountMode: mode)),
        ),
        if (profile.amountMode == AmountMode.indicator) ...[
          gapMd,
          TextFormField(
            key: const ValueKey('profile-debit-indicators'),
            initialValue: profile.debitIndicators,
            decoration: InputDecoration(
              labelText: l10n.debitIndicators,
              helperText: l10n.debitIndicatorsHint,
            ),
            onChanged: (value) =>
                onChanged(profile.copyWith(debitIndicators: value)),
          ),
        ],
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.invertSign),
          subtitle: Text(l10n.invertSignHint),
          value: profile.invertSign,
          onChanged: (value) => onChanged(profile.copyWith(invertSign: value)),
        ),
        gapMd,
        FieldLabel(l10n.columnMapping),
        for (final field in profile.availableFields) ...[
          mappingField(field),
          gapMd,
        ],
      ],
    );
  }
}
