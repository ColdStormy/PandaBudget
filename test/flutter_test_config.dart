import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pump_app.dart';

/// Runs once before the tests of every file.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Each test opens its own in-memory database; that is intended.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  // Lay text out with the real font. The default test font is much wider,
  // which hides real overflows and reports ones that do not exist.
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadAppFonts();

  await testMain();
}
