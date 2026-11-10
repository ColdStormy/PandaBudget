import 'package:drift/native.dart';
import 'package:pandabudget/database/app_database.dart';

/// A fresh in-memory database with the default categories seeded.
AppDatabase createTestDatabase({String languageCode = 'en'}) =>
    AppDatabase(NativeDatabase.memory(), seedLanguageCode: languageCode);
