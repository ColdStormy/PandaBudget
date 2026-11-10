import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/spacing.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';
import 'package:pandabudget/features/importing/presentation/import_profile_form.dart';

class ImportProfilesScreen extends ConsumerWidget {
  const ImportProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.importProfiles)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.importProfileEdit()),
        icon: const Icon(Icons.add),
        label: Text(l10n.addImportProfile),
      ),
      body: AsyncView(
        value: ref.watch(importProfilesProvider),
        builder: (profiles) {
          if (profiles.isEmpty) {
            return EmptyState(
              icon: Icons.table_chart_outlined,
              title: l10n.noImportProfilesTitle,
              message: l10n.noImportProfilesMessage,
            );
          }
          return PageBody(
            children: [
              Card(
                child: Column(
                  children: [
                    for (final (index, profile) in profiles.indexed) ...[
                      if (index > 0) const Divider(indent: Insets.md),
                      ListTile(
                        leading: const Icon(Icons.table_chart_outlined),
                        title: Text(profile.name),
                        subtitle: Text(
                          [
                            if (profile.fileType == ImportFileType.csv)
                              'CSV'
                            else
                              'JSON',
                            profile.dateFormat,
                            l10n.mappedColumns(profile.mapping.length),
                          ].join(' · '),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            context.push(Routes.importProfileEdit(profile.id)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
