import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/app/app.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/database/connection.dart';
import 'package:pandabudget/database/database_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase(
    openAppDatabaseConnection(schemaVersion: AppDatabase.currentSchemaVersion),
    // Default categories are created in the language of the device.
    seedLanguageCode: PlatformDispatcher.instance.locale.languageCode,
  );

  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
      child: const PandaBudgetApp(),
    ),
  );
}
