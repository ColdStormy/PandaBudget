/// Date patterns offered in the import profile editor, in the order they are
/// tried during detection (day-first before month-first).
const List<String> supportedDateFormats = [
  'dd.MM.yyyy',
  'dd.MM.yy',
  'yyyy-MM-dd',
  'dd/MM/yyyy',
  'MM/dd/yyyy',
  'dd-MM-yyyy',
  'yyyy/MM/dd',
  'yyyyMMdd',
  'dd/MM/yy',
  'MM/dd/yy',
];

/// Parses [input] with a pattern made of `dd`, `MM`, `yyyy` and `yy`.
///
/// A time of day after the date (as in ISO timestamps) is ignored. Returns
/// null if the text does not match or is not a real calendar date.
DateTime? parseDate(String input, String format) {
  final text = input.trim();
  if (text.isEmpty) return null;

  final order = <String>[];
  final pattern = StringBuffer('^');
  var i = 0;
  while (i < format.length) {
    if (format.startsWith('yyyy', i)) {
      order.add('y');
      pattern.write(r'(\d{4})');
      i += 4;
    } else if (format.startsWith('yy', i)) {
      order.add('yy');
      pattern.write(r'(\d{2})');
      i += 2;
    } else if (format.startsWith('MM', i)) {
      order.add('M');
      pattern.write(format == 'yyyyMMdd' ? r'(\d{2})' : r'(\d{1,2})');
      i += 2;
    } else if (format.startsWith('dd', i)) {
      order.add('d');
      pattern.write(format == 'yyyyMMdd' ? r'(\d{2})' : r'(\d{1,2})');
      i += 2;
    } else {
      pattern.write(RegExp.escape(format[i]));
      i += 1;
    }
  }
  // Allow a trailing time part, nothing else.
  pattern.write(r'(?:[T ].*)?$');

  final match = RegExp(pattern.toString()).firstMatch(text);
  if (match == null) return null;

  var year = 0;
  var month = 0;
  var day = 0;
  for (final (index, part) in order.indexed) {
    final value = int.parse(match.group(index + 1)!);
    switch (part) {
      case 'y':
        year = value;
      case 'yy':
        // Two-digit years: 00-69 are 2000s, 70-99 are 1900s.
        year = value < 70 ? 2000 + value : 1900 + value;
      case 'M':
        month = value;
      case 'd':
        day = value;
    }
  }
  if (month < 1 || month > 12 || day < 1) return null;
  final date = DateTime(year, month, day);
  // DateTime rolls invalid days over (31 Feb -> 3 Mar); reject those.
  return date.month == month && date.day == day ? date : null;
}

/// Picks the format from [supportedDateFormats] that parses the most
/// [samples], or null if none parses any.
String? detectDateFormat(Iterable<String> samples) {
  final values = samples.where((s) => s.trim().isNotEmpty).toList();
  if (values.isEmpty) return null;
  String? best;
  var bestCount = 0;
  for (final format in supportedDateFormats) {
    final count = values.where((s) => parseDate(s, format) != null).length;
    if (count > bestCount) {
      bestCount = count;
      best = format;
    }
  }
  return best;
}

/// Guesses whether amounts use a decimal comma or a decimal point by looking
/// at which separator comes last in the [samples].
String detectDecimalSeparator(Iterable<String> samples) {
  var commas = 0;
  var points = 0;
  for (final raw in samples) {
    final sample = raw.replaceAll(RegExp('[^0-9.,]'), '');
    final lastComma = sample.lastIndexOf(',');
    final lastPoint = sample.lastIndexOf('.');
    if (lastComma < 0 && lastPoint < 0) continue;
    if (lastComma > lastPoint) {
      // "1,234" with exactly three digits after is more likely thousands.
      final digitsAfter = sample.length - lastComma - 1;
      if (lastPoint < 0 && digitsAfter == 3) continue;
      commas++;
    } else {
      final digitsAfter = sample.length - lastPoint - 1;
      if (lastComma < 0 && digitsAfter == 3) continue;
      points++;
    }
  }
  return points > commas ? '.' : ',';
}
