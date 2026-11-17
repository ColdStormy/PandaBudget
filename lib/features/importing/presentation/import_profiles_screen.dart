import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/page_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';
import 'package:pandabudget/features/importing/presentation/import_profile_form.dart';

class ImportProfilesScreen extends ConsumerWidget {
  const ImportProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    void add() => context.push(Routes.importProfileEdit());

    return Scaffold(
      appBar: SubpageBar(title: l10n.importProfiles),
      body: AsyncView(
        value: ref.watch(importProfilesProvider),
        builder: (profiles) {
          if (profiles.isEmpty) {
            return EmptyState(
              icon: Icons.table_chart_outlined,
              title: l10n.noImportProfilesTitle,
              message: l10n.noImportProfilesMessage,
              action: FilledButton(
                onPressed: add,
                child: Text(l10n.addImportProfile),
              ),
            );
          }
          return PageBody(
            children: [
              for (final profile in profiles)
                PandaListRow(
                  leading: const Icon(Icons.table_chart_outlined),
                  title: profile.name,
                  subtitle: [
                    if (profile.fileType == ImportFileType.csv)
                      'CSV'
                    else
                      'JSON',
                    profile.dateFormat,
                    l10n.mappedColumns(profile.mapping.length),
                  ].join(' · '),
                  onTap: () =>
                      context.push(Routes.importProfileEdit(profile.id)),
                ),
              gapSm,
              AddLink(label: l10n.addImportProfile, onPressed: add),
            ],
          );
        },
      ),
    );
  }
}
