import 'package:meta/meta.dart';

enum AppThemeMode { system, light, dark }

@immutable
class AppSettings {
  const AppSettings({
    this.currencyCode = 'EUR',
    this.languageCode,
    this.themeMode = AppThemeMode.system,
  });

  static const List<String> supportedCurrencies = [
    'EUR',
    'USD',
    'GBP',
    'CHF',
    'SEK',
    'NOK',
    'DKK',
    'PLN',
    'CZK',
  ];

  /// ISO 4217 code of the household's currency.
  final String currencyCode;

  /// `en` or `de`; null follows the system language.
  final String? languageCode;
  final AppThemeMode themeMode;

  AppSettings copyWith({
    String? currencyCode,
    String? Function()? languageCode,
    AppThemeMode? themeMode,
  }) => AppSettings(
    currencyCode: currencyCode ?? this.currencyCode,
    languageCode: languageCode != null ? languageCode() : this.languageCode,
    themeMode: themeMode ?? this.themeMode,
  );
}

abstract interface class SettingsRepository {
  Stream<AppSettings> watch();

  Future<AppSettings> load();

  Future<void> save(AppSettings settings);
}
