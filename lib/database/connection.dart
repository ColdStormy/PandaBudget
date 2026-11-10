import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String _databaseName = 'pandabudget';

/// Opens the on-device database file, on a background isolate.
///
/// The file lives in the application support directory, which is private to
/// the app on Android and under the user's profile on Windows and Linux.
QueryExecutor openAppDatabaseConnection({required int schemaVersion}) {
  return driftDatabase(
    name: _databaseName,
    native: DriftNativeOptions(
      databasePath: () async {
        final directory = await getApplicationSupportDirectory();
        final file = File(p.join(directory.path, '$_databaseName.sqlite'));
        await backupBeforeUpgrade(file, targetVersion: schemaVersion);
        return file.path;
      },
    ),
  );
}

/// Copies [database] next to itself before a schema upgrade touches it.
///
/// A migration rewrites the user's only copy of their finances; if a bug
/// ever slips into one, the previous file is still there as
/// `<name>.v<old version>.bak`. Returns the backup, or null if none was
/// needed.
Future<File?> backupBeforeUpgrade(
  File database, {
  required int targetVersion,
}) async {
  final storedVersion = await readSchemaVersion(database);
  if (storedVersion == null ||
      storedVersion == 0 ||
      storedVersion >= targetVersion) {
    return null;
  }
  final backup = File('${database.path}.v$storedVersion.bak');
  return await database.copy(backup.path);
}

/// Reads SQLite's `user_version` straight from the file header, without
/// opening the database. Null if the file does not exist or is not SQLite.
Future<int?> readSchemaVersion(File database) async {
  if (!database.existsSync()) return null;
  final handle = await database.open();
  try {
    final header = await handle.read(100);
    if (header.length < 100) return null;
    const magic = 'SQLite format 3';
    if (String.fromCharCodes(header.sublist(0, magic.length)) != magic) {
      return null;
    }
    // The user version is a big-endian 32-bit integer at offset 60.
    return ByteData.sublistView(header).getInt32(60);
  } finally {
    await handle.close();
  }
}
