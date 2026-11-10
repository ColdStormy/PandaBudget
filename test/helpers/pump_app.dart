import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:pandabudget/app/app.dart';
import 'package:pandabudget/core/time/clock.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/database/database_provider.dart';
import 'package:pandabudget/features/importing/presentation/import_wizard_controller.dart';

import 'test_database.dart';

/// "Today" in widget tests, so screens that show the current month are
/// reproducible.
final DateTime testToday = DateTime(2026, 11, 10);

const Size phoneSize = Size(412, 915);
const Size desktopSize = Size(1280, 800);

/// Starts the whole app on an in-memory database.
///
/// Returns the database so tests can prepare and inspect data. [picker]
/// replaces the native file dialog of the import wizard.
Future<AppDatabase> pumpApp(
  WidgetTester tester, {
  AppDatabase? database,
  Size size = phoneSize,
  String languageCode = 'en',
  ImportFilePicker? picker,
}) async {
  final db = database ?? createTestDatabase(languageCode: languageCode);
  // The database has to be closed in real time; in the fake-async zone of
  // a widget test closing would never finish.
  addTearDown(() => tester.runAsync(db.close));

  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.localeTestValue = Locale(languageCode);
  tester.platformDispatcher.localesTestValue = [Locale(languageCode)];
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearLocaleTestValue);
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);

  await tester.pumpWidget(
    ProviderScope(
      // Fail fast instead of retrying a broken provider with a delay.
      retry: (_, _) => null,
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => testToday),
        if (picker != null) importFilePickerProvider.overrideWithValue(picker),
      ],
      child: const PandaBudgetApp(),
    ),
  );
  await settle(tester);
  return db;
}

/// Lets database streams deliver and animations finish.
///
/// Drift answers on real timers, which the fake clock of widget tests does
/// not advance, so real time has to pass in between pumps.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 350));
  }
}

/// A widget test that runs the whole app.
///
/// Like [testWidgets], but always unmounts the app afterwards, also when an
/// expectation failed. Without that, timers of open database streams stay
/// pending and a failing test hangs instead of reporting its failure.
@isTest
void appTest(
  String description,
  Future<void> Function(WidgetTester tester) body, {
  bool? skip,
}) {
  testWidgets(description, (tester) async {
    try {
      await body(tester);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(seconds: 1));
    }
  }, skip: skip);
}

/// Loads the real Roboto and Material icon fonts, so rendered screenshots
/// show text instead of the test font's rectangles.
Future<void> loadAppFonts() async {
  final fonts = Directory(
    '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts',
  );
  Future<ByteData> read(String name) async =>
      ByteData.sublistView(await File('${fonts.path}/$name').readAsBytes());

  final roboto = FontLoader('Roboto')
    ..addFont(read('Roboto-Regular.ttf'))
    ..addFont(read('Roboto-Medium.ttf'))
    ..addFont(read('Roboto-Bold.ttf'));
  final icons = FontLoader('MaterialIcons')
    ..addFont(read('MaterialIcons-Regular.otf'));
  await roboto.load();
  await icons.load();
}
