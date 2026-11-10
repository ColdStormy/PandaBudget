@Tags(['golden'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/features/settings/data/drift_settings_repository.dart';
import 'package:pandabudget/features/settings/domain/app_settings.dart';

import '../helpers/demo_data.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

/// Renders the main screens with demo data and compares them with the
/// reference images in `test/goldens/images/`.
///
/// After an intended visual change, refresh the images with
/// `flutter test --update-goldens --tags golden`.
///
/// Text rendering differs slightly between operating systems, so the
/// comparison only runs on Linux (which is also what CI uses).
void main() {
  final sections = [
    'Overview',
    'Planning',
    'Transactions',
    'Analysis',
    'Settings',
  ];

  for (final (name, size, theme) in [
    ('phone_light', phoneSize, AppThemeMode.light),
    ('phone_dark', phoneSize, AppThemeMode.dark),
    ('desktop_light', desktopSize, AppThemeMode.light),
  ]) {
    appTest('main screens: $name', (tester) async {
      final db = createTestDatabase();
      await tester.runAsync(() async {
        await seedDemoData(db);
        await DriftSettingsRepository(db).save(AppSettings(themeMode: theme));
      });
      await pumpApp(tester, database: db, size: size);

      for (final section in sections) {
        final navigation = size == phoneSize ? NavigationBar : NavigationRail;
        await tester.tap(
          find.descendant(
            of: find.byType(navigation),
            matching: find.text(section),
          ),
        );
        await settle(tester);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('images/${name}_${section.toLowerCase()}.png'),
        );
      }
    }, skip: !Platform.isLinux);
  }
}
