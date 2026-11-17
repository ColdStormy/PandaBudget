import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/widgets/page_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/accounts/presentation/account_providers.dart';
import 'package:pandabudget/features/importing/application/import_service.dart';
import 'package:pandabudget/features/importing/presentation/import_profile_form.dart';

class ImportHistoryScreen extends ConsumerWidget {
  const ImportHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final accounts = ref.watch(allAccountsProvider).value ?? const [];

    return Scaffold(
      appBar: SubpageBar(title: l10n.importHistory),
      body: AsyncView(
        value: ref.watch(importBatchesProvider),
        builder: (batches) {
          if (batches.isEmpty) {
            return EmptyState(
              icon: Icons.history,
              title: l10n.noImportsTitle,
              message: l10n.noImportsMessage,
            );
          }
          return PageBody(
            children: [
              for (final batch in batches)
                PandaListRow(
                  leading: const Icon(Icons.upload_file_outlined),
                  title: batch.fileName,
                  subtitle: [
                    context.formatDate(batch.importedAt),
                    ?accounts
                        .firstWhereOrNull((a) => a.id == batch.accountId)
                        ?.name,
                    l10n.transactionCount(batch.importedCount),
                  ].join(' · '),
                  subtitleMaxLines: 2,
                  trailing: TextButton(
                    onPressed: () async {
                      final confirmed = await confirmDelete(
                        context,
                        title: l10n.undoImportTitle,
                        message: l10n.undoImportMessage(batch.importedCount),
                      );
                      if (!confirmed) return;
                      await ref.read(importServiceProvider).undo(batch.id);
                    },
                    child: Text(l10n.undo),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
