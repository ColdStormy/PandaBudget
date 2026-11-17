import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/core/l10n/l10n.dart';
import 'package:pandabudget/core/theme/app_theme.dart';
import 'package:pandabudget/features/settings/presentation/settings_providers.dart';

/// A single widget in the app's theme and localisation, without database or
/// router. Amounts are formatted as euros.
Future<void> pumpWidgetInApp(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.light,
  Size size = const Size(412, 915),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [currencyCodeProvider.overrideWithValue('EUR')],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: const [Locale('en'), Locale('de')],
        locale: const Locale('en'),
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
