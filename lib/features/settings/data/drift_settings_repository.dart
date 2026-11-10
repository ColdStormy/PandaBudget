import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/database/database_provider.dart';
import 'package:pandabudget/features/settings/domain/app_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => DriftSettingsRepository(ref.watch(appDatabaseProvider)),
);

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db);

  static const _currency = 'currency';
  static const _language = 'language';
  static const _theme = 'theme';

  final AppDatabase _db;

  @override
  Stream<AppSettings> watch() =>
      _db.select(_db.appSettingEntries).watch().map(_fromRows);

  @override
  Future<AppSettings> load() async =>
      _fromRows(await _db.select(_db.appSettingEntries).get());

  @override
  Future<void> save(AppSettings settings) => _db.transaction(() async {
    await _db.delete(_db.appSettingEntries).go();
    await _db.batch(
      (batch) => batch.insertAll(_db.appSettingEntries, [
        AppSettingEntriesCompanion.insert(
          key: _currency,
          value: settings.currencyCode,
        ),
        AppSettingEntriesCompanion.insert(
          key: _theme,
          value: settings.themeMode.name,
        ),
        if (settings.languageCode case final language?)
          AppSettingEntriesCompanion.insert(key: _language, value: language),
      ]),
    );
  });

  static AppSettings _fromRows(List<AppSettingRow> rows) {
    final values = {for (final row in rows) row.key: row.value};
    return AppSettings(
      currencyCode: values[_currency] ?? 'EUR',
      languageCode: values[_language],
      themeMode:
          AppThemeMode.values.asNameMap()[values[_theme]] ??
          AppThemeMode.system,
    );
  }
}
