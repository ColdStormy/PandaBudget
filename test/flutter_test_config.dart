import 'dart:async';

import 'package:drift/drift.dart';

/// Runs once before the tests of every file.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Each test opens its own in-memory database; that is intended.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  await testMain();
}
