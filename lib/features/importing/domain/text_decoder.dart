import 'dart:convert';
import 'dart:typed_data';

import 'package:pandabudget/features/importing/domain/import_profile.dart';

/// Turns the bytes of a bank file into text.
///
/// German banks in particular still export Windows-1252 ("ANSI") files, so
/// with [TextEncoding.auto] the bytes are read as UTF-8 if they are valid
/// UTF-8 and as Windows-1252 otherwise.
String decodeText(
  Uint8List bytes, {
  TextEncoding encoding = TextEncoding.auto,
}) {
  var data = bytes;
  final hasUtf8Bom =
      data.length >= 3 && data[0] == 0xEF && data[1] == 0xBB && data[2] == 0xBF;
  if (hasUtf8Bom) data = Uint8List.sublistView(data, 3);

  switch (encoding) {
    case TextEncoding.utf8:
      return utf8.decode(data, allowMalformed: true);
    case TextEncoding.latin1:
      return _decodeWindows1252(data);
    case TextEncoding.auto:
      if (hasUtf8Bom) return utf8.decode(data, allowMalformed: true);
      try {
        return utf8.decode(data);
      } on FormatException {
        return _decodeWindows1252(data);
      }
  }
}

String _decodeWindows1252(Uint8List data) {
  final buffer = StringBuffer();
  for (final byte in data) {
    buffer.writeCharCode(
      byte >= 0x80 && byte <= 0x9F ? _windows1252High[byte - 0x80] : byte,
    );
  }
  return buffer.toString();
}

/// Code points for bytes 0x80..0x9F, where Windows-1252 differs from Latin-1.
const List<int> _windows1252High = [
  0x20AC, 0x0081, 0x201A, 0x0192, 0x201E, 0x2026, 0x2020, 0x2021, //
  0x02C6, 0x2030, 0x0160, 0x2039, 0x0152, 0x008D, 0x017D, 0x008F,
  0x0090, 0x2018, 0x2019, 0x201C, 0x201D, 0x2022, 0x2013, 0x2014,
  0x02DC, 0x2122, 0x0161, 0x203A, 0x0153, 0x009D, 0x017E, 0x0178,
];
