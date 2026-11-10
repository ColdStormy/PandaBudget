import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/money/money_format.dart';
import 'package:pandabudget/features/settings/presentation/settings_providers.dart';

/// Formatters are cached per currency and locale.
final moneyFormatterProvider =
    Provider.family<MoneyFormatter, ({String currency, String locale})>(
      (ref, key) =>
          MoneyFormatter(currencyCode: key.currency, locale: key.locale),
    );

extension MoneyRef on WidgetRef {
  /// The formatter for the household currency in the UI language.
  MoneyFormatter money(BuildContext context) => watch(
    moneyFormatterProvider((
      currency: watch(currencyCodeProvider),
      locale: Localizations.localeOf(context).toLanguageTag(),
    )),
  );
}
