import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/database/app_database.dart';

/// The single database instance of the running app.
///
/// Overridden in `main` with the on-device database and in tests with an
/// in-memory one.
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('appDatabaseProvider must be overridden'),
);
