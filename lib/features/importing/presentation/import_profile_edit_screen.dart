import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/widgets/form_widgets.dart';
import 'package:pandabudget/core/widgets/panda_widgets.dart';
import 'package:pandabudget/features/importing/data/drift_import_repositories.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';
import 'package:pandabudget/features/importing/presentation/import_profile_form.dart';

class ImportProfileEditScreen extends ConsumerWidget {
  const ImportProfileEditScreen({this.id, super.key});

  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncView(
      value: ref.watch(importProfilesProvider),
      builder: (profiles) => _ProfileEditor(
        initial: profiles.firstWhereOrNull((profile) => profile.id == id),
      ),
    );
  }
}

class _ProfileEditor extends ConsumerStatefulWidget {
  const _ProfileEditor({this.initial});

  final ImportProfile? initial;

  @override
  ConsumerState<_ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends ConsumerState<_ProfileEditor> {
  final _formKey = GlobalKey<FormState>();
  late ImportProfile _profile = widget.initial ?? const ImportProfile(name: '');

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_profile.isComplete) {
      showMessage(context, context.l10n.mappingIncomplete);
      return;
    }
    await ref
        .read(importProfileRepositoryProvider)
        .save(_profile.copyWith(name: _profile.name.trim()));
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await confirmDelete(
      context,
      title: context.l10n.deleteImportProfileTitle,
    );
    if (!confirmed) return;
    await ref.read(importProfileRepositoryProvider).delete(_profile.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isNew = widget.initial == null;
    return FormPage(
      formKey: _formKey,
      title: isNew ? l10n.addImportProfile : l10n.editImportProfile,
      onSave: _save,
      onDelete: isNew ? null : _delete,
      children: [
        ImportProfileForm(
          profile: _profile,
          onChanged: (profile) => setState(() => _profile = profile),
        ),
      ],
    );
  }
}
