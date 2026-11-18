import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/core/widgets/page_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/accounts/presentation/account_providers.dart';
import 'package:pandabudget/features/categories/presentation/category_widgets.dart';
import 'package:pandabudget/features/importing/application/import_service.dart';
import 'package:pandabudget/features/importing/domain/import_parser.dart';
import 'package:pandabudget/features/importing/presentation/import_profile_form.dart';
import 'package:pandabudget/features/importing/presentation/import_wizard_controller.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

class ImportWizardScreen extends ConsumerWidget {
  const ImportWizardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(importWizardProvider);
    final controller = ref.read(importWizardProvider.notifier);

    Future<void> finish() async {
      final count = await controller.commit();
      if (!context.mounted) return;
      showMessage(context, l10n.importedCount(count));
      context.pop();
    }

    final (String nextLabel, VoidCallback? onNext) = switch (state.step) {
      ImportStep.file => (
        l10n.next,
        state.canContinueFromFile
            ? () => state.usesSavedProfile
                  ? controller.buildPreview()
                  : controller.goTo(ImportStep.columns)
            : null,
      ),
      ImportStep.columns => (
        l10n.next,
        state.canContinueFromColumns ? controller.buildPreview : null,
      ),
      ImportStep.review => (
        l10n.importAction(state.preview?.readyCount ?? 0),
        (state.preview?.readyCount ?? 0) > 0 ? finish : null,
      ),
    };

    return Scaffold(
      appBar: SubpageBar(title: l10n.importTitle),
      body: Column(
        children: [
          _StepHeader(step: state.step),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: switch (state.step) {
                  ImportStep.file => _FileStep(state: state),
                  ImportStep.columns => _ColumnsStep(state: state),
                  ImportStep.review => _ReviewStep(preview: state.preview!),
                },
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(Insets.md),
              child: Row(
                children: [
                  if (state.step != ImportStep.file)
                    TextButton(
                      onPressed: state.isBusy
                          ? null
                          : () => controller.goTo(
                              state.step == ImportStep.review &&
                                      !state.usesSavedProfile
                                  ? ImportStep.columns
                                  : ImportStep.file,
                            ),
                      child: Text(l10n.back),
                    ),
                  gapSm,
                  // Wraps onto a second line on narrow phones or with long
                  // translations instead of overflowing.
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: Insets.sm,
                      runSpacing: Insets.sm,
                      children: [
                        if (state.step == ImportStep.file &&
                            state.usesSavedProfile)
                          TextButton(
                            onPressed: state.canContinueFromFile
                                ? () => controller.goTo(ImportStep.columns)
                                : null,
                            child: Text(l10n.adjustColumns),
                          ),
                        FilledButton(
                          onPressed: state.isBusy ? null : onNext,
                          child: Text(nextLabel),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "1 File · 2 Columns · 3 Review": the current step in accent colour.
class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step});

  final ImportStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final labels = [
      l10n.importStepFile,
      l10n.importStepColumns,
      l10n.importStepReview,
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.md, 0, Insets.md, Insets.sm),
      child: Row(
        children: [
          for (final (index, label) in labels.indexed)
            Expanded(
              child: Text(
                '${index + 1}  $label',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: index == step.index
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: index == step.index
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FileStep extends ConsumerWidget {
  const _FileStep({required this.state});

  final ImportWizardState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final controller = ref.read(importWizardProvider.notifier);
    final accounts = ref.watch(accountsProvider).value ?? const [];
    final profiles = ref.watch(importProfilesProvider).value ?? const [];
    final file = state.file;

    return ListView(
      padding: const EdgeInsets.all(Insets.md),
      children: [
        PandaListRow(
          onTap: controller.pickFile,
          leading: ColorAvatar(
            color: theme.colorScheme.primary,
            icon: file == null
                ? Icons.upload_file_outlined
                : Icons.description_outlined,
            size: 48,
          ),
          title: file?.name ?? l10n.chooseFile,
          subtitle: file == null
              ? l10n.chooseFileHint
              : state.table == null
              ? l10n.fileNotReadable
              : l10n.rowsFound(state.table!.rows.length),
          subtitleMaxLines: 2,
          trailing: file == null
              ? null
              : TextButton(
                  onPressed: controller.pickFile,
                  child: Text(l10n.change),
                ),
        ),
        if (state.tableError != null) ...[
          gapMd,
          Callout(
            icon: Icons.error_outline,
            color: theme.colorScheme.error,
            child: Text(state.tableError!),
          ),
        ],
        gapLg,
        if (accounts.isEmpty)
          Callout(
            icon: Icons.info_outline,
            color: theme.colorScheme.primary,
            action: TextButton(
              onPressed: () => context.push(Routes.accountEdit()),
              child: Text(l10n.addAccount),
            ),
            child: Text(l10n.importNeedsAccount),
          )
        else
          SelectField<int>(
            label: l10n.importIntoAccount,
            value: state.accountId,
            items: {for (final account in accounts) account.id: account.name},
            onChanged: controller.selectAccount,
          ),
        if (file != null && state.table != null) ...[
          gapMd,
          SelectField<int>(
            label: l10n.bankFormat,
            value: state.usesSavedProfile ? state.profile?.id : 0,
            items: {
              0: l10n.newBankFormat,
              for (final profile in profiles.where(
                (p) => p.fileType == state.profile?.fileType,
              ))
                profile.id: profile.name,
            },
            onChanged: (id) => controller.useSavedProfile(
              id == null || id == 0
                  ? null
                  : profiles.firstWhere((p) => p.id == id),
            ),
          ),
          gapMd,
          Callout(
            icon: state.usesSavedProfile
                ? Icons.check_circle_outline
                : Icons.auto_awesome_outlined,
            color: theme.colorScheme.primary,
            child: Text(
              state.usesSavedProfile
                  ? l10n.formatRecognised(state.profile!.name)
                  : l10n.formatNew,
            ),
          ),
        ],
      ],
    );
  }
}

class _ColumnsStep extends ConsumerWidget {
  const _ColumnsStep({required this.state});

  final ImportWizardState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final controller = ref.read(importWizardProvider.notifier);
    final samples = state.sampleRows();

    return ListView(
      padding: const EdgeInsets.all(Insets.md),
      children: [
        if (state.tableError != null) ...[
          Callout(
            icon: Icons.error_outline,
            color: theme.colorScheme.error,
            child: Text(state.tableError!),
          ),
          gapMd,
        ],
        ImportProfileForm(
          profile: state.profile!,
          headers: state.table?.headers ?? const [],
          onChanged: controller.updateProfile,
        ),
        FieldLabel(l10n.importPreview),
        if (samples.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.sm),
            child: Text(l10n.importPreviewEmpty),
          )
        else
          for (final row in samples) _SampleTile(row: row),
        gapMd,
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.rememberFormat),
          subtitle: Text(l10n.rememberFormatHint),
          value: state.rememberProfile,
          onChanged: (value) => controller.setRememberProfile(remember: value),
        ),
      ],
    );
  }
}

String importIssueLabel(AppLocalizations l10n, ImportRowIssue issue) =>
    switch (issue) {
      ImportRowIssue.missingDate => l10n.issueMissingDate,
      ImportRowIssue.invalidDate => l10n.issueInvalidDate,
      ImportRowIssue.missingAmount => l10n.issueMissingAmount,
      ImportRowIssue.invalidAmount => l10n.issueInvalidAmount,
    };

class _SampleTile extends StatelessWidget {
  const _SampleTile({required this.row});

  final ParsedImportRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final transaction = row.transaction;
    if (transaction == null) {
      return PandaListRow(
        leading: Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
        ),
        title: l10n.rowNumber(row.rowNumber),
        subtitle: row.issues
            .map((issue) => importIssueLabel(l10n, issue))
            .join(', '),
        subtitleMaxLines: 2,
      );
    }
    return PandaListRow(
      title: transaction.title.isEmpty ? l10n.noDescription : transaction.title,
      subtitle: joinDetails([
        context.formatDate(transaction.bookingDate),
        if (transaction.counterparty.isNotEmpty) transaction.purpose,
      ]),
      amountMinor: transaction.amountMinor,
      tone: AmountTone.incomeOnly,
      showPlus: true,
    );
  }
}

class _ReviewStep extends ConsumerWidget {
  const _ReviewStep({required this.preview});

  final ImportPreview preview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final finance = context.financeColors;
    final tree = ref.watch(categoryTreeProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(Insets.md),
      itemCount: preview.rows.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Insets.md),
            child: Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              children: [
                StatusPill(
                  label: l10n.reviewNew(preview.readyCount),
                  color: theme.colorScheme.primary,
                  icon: Icons.add_circle_outline,
                ),
                StatusPill(
                  label: l10n.reviewCategorised(preview.categorizedCount),
                  color: theme.colorScheme.primary,
                  icon: Icons.label_outline,
                ),
                if (preview.duplicateCount > 0)
                  StatusPill(
                    label: l10n.reviewDuplicates(preview.duplicateCount),
                    color: theme.colorScheme.onSurfaceVariant,
                    icon: Icons.content_copy_outlined,
                  ),
                if (preview.invalidCount > 0)
                  StatusPill(
                    label: l10n.reviewInvalid(preview.invalidCount),
                    color: finance.expense,
                    icon: Icons.error_outline,
                  ),
              ],
            ),
          );
        }

        final row = preview.rows[index - 1];
        final transaction = row.transaction;
        if (transaction == null) {
          return _SampleTile(row: row.parsed);
        }
        final isDuplicate = row.status == ImportRowStatus.duplicate;
        final category = tree[transaction.categoryId];
        return PandaListRow(
          enabled: !isDuplicate,
          leading: CategoryAvatar(category, size: 36),
          title: transaction.title.isEmpty
              ? l10n.noDescription
              : transaction.title,
          subtitle: joinDetails([
            context.formatDate(transaction.bookingDate),
            if (isDuplicate)
              l10n.alreadyImported
            else if (category == null)
              l10n.uncategorized
            else
              tree.pathOf(category.id),
            if (!isDuplicate &&
                category != null &&
                transaction.categorySource == CategorySource.learned)
              l10n.suggested,
          ]),
          subtitleMaxLines: 2,
          amountMinor: transaction.amountMinor,
          tone: AmountTone.incomeOnly,
          showPlus: true,
        );
      },
    );
  }
}
