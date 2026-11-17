import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/database/demo_data.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

void main() {
  appTest('a purpose equal to the category is not shown twice', (tester) async {
    final db = createTestDatabase();
    // The demo data has "Shell Station", purpose "Fuel", category "Fuel".
    await tester.runAsync(() => seedDemoData(db));
    await pumpApp(tester, database: db);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Transactions'),
      ),
    );
    await settle(tester);

    expect(find.text('Shell Station'), findsOneWidget);
    expect(find.textContaining('Fuel · Fuel'), findsNothing);
    expect(find.text('Fuel · Main account'), findsOneWidget);
  });
}
