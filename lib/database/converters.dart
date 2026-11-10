import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:pandabudget/core/time/dates.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/features/categorization/domain/category_rule.dart';
import 'package:pandabudget/features/importing/domain/import_profile.dart';

/// Stores a calendar date as the integer `yyyymmdd`.
class DateOnlyConverter extends TypeConverter<DateTime, int> {
  const DateOnlyConverter();

  @override
  DateTime fromSql(int fromDb) => dateFromDayNumber(fromDb);

  @override
  int toSql(DateTime value) => dayNumber(value);
}

/// Stores a month as `year * 12 + month - 1`.
class YearMonthConverter extends TypeConverter<YearMonth, int> {
  const YearMonthConverter();

  @override
  YearMonth fromSql(int fromDb) => YearMonth.fromIndex(fromDb);

  @override
  int toSql(YearMonth value) => value.index;
}

/// Stores an import profile's column mapping as a JSON object.
class FieldMappingConverter
    extends TypeConverter<Map<ImportField, String>, String> {
  const FieldMappingConverter();

  @override
  Map<ImportField, String> fromSql(String fromDb) {
    final fields = ImportField.values.asNameMap();
    final json = jsonDecode(fromDb) as Map<String, dynamic>;
    return {
      for (final MapEntry(:key, :value) in json.entries)
        // Unknown keys come from newer app versions; skip them.
        ?fields[key]: value as String,
    };
  }

  @override
  String toSql(Map<ImportField, String> value) => jsonEncode({
    for (final MapEntry(:key, :value) in value.entries) key.name: value,
  });
}

/// Stores a rule's conditions as a JSON array.
class RuleConditionsConverter
    extends TypeConverter<List<RuleCondition>, String> {
  const RuleConditionsConverter();

  @override
  List<RuleCondition> fromSql(String fromDb) => [
    for (final item in jsonDecode(fromDb) as List<dynamic>)
      RuleCondition.fromJson(item as Map<String, dynamic>),
  ];

  @override
  String toSql(List<RuleCondition> value) =>
      jsonEncode([for (final condition in value) condition.toJson()]);
}
