import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/features/settings/data/drift_settings_repository.dart';
import 'package:pandabudget/features/settings/domain/app_settings.dart';

final settingsProvider = StreamProvider<AppSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

/// The current settings, falling back to defaults while they load.
final currentSettingsProvider = Provider<AppSettings>(
  (ref) => ref.watch(settingsProvider).value ?? const AppSettings(),
);

final currencyCodeProvider = Provider<String>(
  (ref) => ref.watch(currentSettingsProvider.select((s) => s.currencyCode)),
);
