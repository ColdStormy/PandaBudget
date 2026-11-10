import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:meta/meta.dart';

/// A bank file reduced to a header row and rows of text cells.
@immutable
class TableData {
  const TableData({required this.headers, required this.rows});

  final List<String> headers;

  /// Every row has exactly `headers.length` cells.
  final List<List<String>> rows;

  int columnOf(String header) => headers.indexOf(header);

  /// Up to [count] non-empty example values of the column named [header].
  List<String> samples(String header, {int count = 20}) {
    final column = columnOf(header);
    if (column < 0) return const [];
    return rows
        .map((row) => row[column])
        .where((cell) => cell.isNotEmpty)
        .take(count)
        .toList();
  }
}

class TableFormatException implements Exception {
  const TableFormatException(this.message);

  final String message;

  @override
  String toString() => 'TableFormatException: $message';
}

const List<String> _delimiterCandidates = [';', ',', '\t', '|'];

/// Guesses the field separator from the first lines of [text].
///
/// Picks the candidate that most consistently splits lines into the same
/// number of columns (and into more than one).
String detectDelimiter(String text) {
  final lines = const LineSplitter()
      .convert(text)
      .where((line) => line.trim().isNotEmpty)
      .take(40)
      .toList();
  var best = ',';
  var bestScore = 0;
  for (final candidate in _delimiterCandidates) {
    final counts = <int, int>{};
    for (final line in lines) {
      final columns = _splitOutsideQuotes(line, candidate);
      if (columns > 1) counts[columns] = (counts[columns] ?? 0) + 1;
    }
    if (counts.isEmpty) continue;
    final modal = counts.entries.reduce((a, b) => a.value >= b.value ? a : b);
    final score = modal.value * modal.key;
    if (score > bestScore) {
      bestScore = score;
      best = candidate;
    }
  }
  return best;
}

int _splitOutsideQuotes(String line, String delimiter) {
  var columns = 1;
  var inQuotes = false;
  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      inQuotes = !inQuotes;
    } else if (!inQuotes && char == delimiter) {
      columns++;
    }
  }
  return columns;
}

/// Reads CSV [text] into a table.
///
/// An empty [delimiter] is detected. With [headerRow] < 0 the header is taken
/// to be the first row that has as many columns as most rows do, which skips
/// the account summary lines many banks put on top. Rows with a different
/// shape after the header (totals, footers) are dropped.
TableData readCsv(String text, {String delimiter = '', int headerRow = -1}) {
  final separator = delimiter.isEmpty ? detectDelimiter(text) : delimiter;
  final decoded = Csv(
    fieldDelimiter: separator,
    autoDetect: false,
  ).decode(text.replaceFirst(RegExp(r'^sep=.\r?\n'), ''));
  final raw = [
    for (final row in decoded)
      [for (final cell in row) cell?.toString().trim() ?? ''],
  ];
  if (raw.isEmpty) {
    throw const TableFormatException('The file contains no rows.');
  }

  var headerIndex = headerRow;
  if (headerIndex < 0) {
    final widths = <int, int>{};
    for (final row in raw) {
      if (row.length > 1) widths[row.length] = (widths[row.length] ?? 0) + 1;
    }
    if (widths.isEmpty) {
      throw const TableFormatException('No columns could be detected.');
    }
    final modalWidth = widths.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
    headerIndex = raw.indexWhere((row) => row.length == modalWidth);
  }
  if (headerIndex < 0 || headerIndex >= raw.length) {
    throw const TableFormatException('The header row could not be found.');
  }

  final headers = _uniqueHeaders(raw[headerIndex]);
  final rows = <List<String>>[];
  for (final row in raw.skip(headerIndex + 1)) {
    if (row.every((cell) => cell.isEmpty)) continue;
    // Tolerate a trailing delimiter, drop rows of a clearly different shape.
    if (row.length == headers.length) {
      rows.add(row);
    } else if (row.length == headers.length + 1 && row.last.isEmpty) {
      rows.add(row.sublist(0, headers.length));
    } else if (row.length == headers.length - 1 && headers.last.isEmpty) {
      rows.add([...row, '']);
    }
  }
  return TableData(headers: headers, rows: rows);
}

List<String> _uniqueHeaders(List<String> cells) {
  final seen = <String, int>{};
  return [
    for (final (index, cell) in cells.indexed)
      () {
        final base = cell.isEmpty ? 'Column ${index + 1}' : cell;
        final count = seen[base] = (seen[base] ?? 0) + 1;
        return count == 1 ? base : '$base ($count)';
      }(),
  ];
}

/// Reads JSON [text] into a table.
///
/// The transactions are expected as an array of objects, either at the top
/// level, at the dotted [rootPath], or as the first such array found in the
/// document. Nested objects become columns with dotted names.
TableData readJson(String text, {String rootPath = ''}) {
  final Object? document;
  try {
    document = jsonDecode(text);
  } on FormatException catch (error) {
    throw TableFormatException('Invalid JSON: ${error.message}');
  }

  var node = document;
  if (rootPath.isNotEmpty) {
    for (final key in rootPath.split('.')) {
      node = node is Map<String, dynamic> ? node[key] : null;
    }
  } else if (node is! List) {
    node = _findObjectArray(node, 4);
  }
  if (node is! List) {
    throw const TableFormatException(
      'No array of transactions was found in the JSON file.',
    );
  }

  final headers = <String>[];
  final flattened = <Map<String, String>>[];
  for (final item in node) {
    if (item is! Map<String, dynamic>) continue;
    final flat = <String, String>{};
    _flatten(item, '', flat);
    for (final key in flat.keys) {
      if (!headers.contains(key)) headers.add(key);
    }
    flattened.add(flat);
  }
  if (flattened.isEmpty) {
    throw const TableFormatException('The JSON array contains no objects.');
  }
  return TableData(
    headers: headers,
    rows: [
      for (final flat in flattened)
        [for (final key in headers) flat[key] ?? ''],
    ],
  );
}

List<dynamic>? _findObjectArray(Object? node, int depth) {
  if (depth == 0 || node is! Map<String, dynamic>) return null;
  for (final value in node.values) {
    if (value is List && value.firstOrNull is Map) return value;
  }
  for (final value in node.values) {
    final found = _findObjectArray(value, depth - 1);
    if (found != null) return found;
  }
  return null;
}

void _flatten(
  Map<String, dynamic> source,
  String prefix,
  Map<String, String> out,
) {
  for (final MapEntry(:key, :value) in source.entries) {
    final path = prefix.isEmpty ? key : '$prefix.$key';
    switch (value) {
      case null:
        out[path] = '';
      case final Map<String, dynamic> nested:
        _flatten(nested, path, out);
      case final List<dynamic> list:
        out[path] = list.join(' ');
      default:
        out[path] = value.toString().trim();
    }
  }
}
