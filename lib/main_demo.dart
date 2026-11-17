import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/app/app.dart';
import 'package:pandabudget/database/app_database.dart';
import 'package:pandabudget/database/database_provider.dart';
import 'package:pandabudget/database/demo_data.dart';

/// Debug entry point: runs the app on a throwaway in-memory database filled
/// with the demo household, leaving the real on-device database untouched.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase(NativeDatabase.memory());
  await seedDemoData(database);

  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
      child: const PandaBudgetApp(),
    ),
  );
}
