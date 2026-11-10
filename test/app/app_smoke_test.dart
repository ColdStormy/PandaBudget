import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  appTest('starts on the overview and reaches every section', (tester) async {
    await pumpApp(tester);
    expect(find.text('Welcome to PandaBudget'), findsOneWidget);

    for (final (label, expected) in [
      ('Planning', 'Nothing planned yet'),
      ('Transactions', 'No transactions yet'),
      ('Analysis', 'By category'),
      ('Settings', 'Your data'),
      ('Overview', 'Welcome to PandaBudget'),
    ]) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(label),
        ),
      );
      await settle(tester);
      expect(find.text(expected), findsOneWidget, reason: label);
    }
  });

  appTest('uses a navigation rail on wide windows', (tester) async {
    await pumpApp(tester, size: desktopSize);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  appTest('speaks German on a German device', (tester) async {
    await pumpApp(tester, languageCode: 'de');
    expect(find.text('Willkommen bei PandaBudget'), findsOneWidget);
    expect(find.text('Übersicht'), findsOneWidget);
  });

  appTest('falls back to English for other system languages', (tester) async {
    await pumpApp(tester, languageCode: 'fr');
    expect(find.text('Welcome to PandaBudget'), findsOneWidget);
  });
}
