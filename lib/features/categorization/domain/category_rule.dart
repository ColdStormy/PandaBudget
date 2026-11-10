import 'package:meta/meta.dart';
import 'package:pandabudget/core/entity.dart';
import 'package:pandabudget/core/money/money_format.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

/// The part of a transaction a rule condition looks at.
enum RuleField {
  counterparty,
  purpose,

  /// Counterparty, purpose and note together.
  anyText,
  iban,

  /// The signed amount: negative for payments, positive for income.
  amount;

  bool get isNumeric => this == amount;
}

enum RuleOperator {
  contains,
  equals,
  startsWith,
  endsWith,
  regex,
  greaterThan,
  lessThan;

  bool get isNumeric => this == greaterThan || this == lessThan;

  static List<RuleOperator> forField(RuleField field) => field.isNumeric
      ? const [greaterThan, lessThan, equals]
      : const [contains, equals, startsWith, endsWith, regex];
}

@immutable
class RuleCondition {
  const RuleCondition({
    required this.field,
    required this.operator,
    required this.value,
  });

  factory RuleCondition.fromJson(Map<String, dynamic> json) => RuleCondition(
    field: RuleField.values.asNameMap()[json['field']] ?? RuleField.anyText,
    operator:
        RuleOperator.values.asNameMap()[json['operator']] ??
        RuleOperator.contains,
    value: json['value'] as String? ?? '',
  );

  final RuleField field;
  final RuleOperator operator;

  /// Text to compare with, or a decimal number (with `.`) for amounts.
  final String value;

  Map<String, dynamic> toJson() => {
    'field': field.name,
    'operator': operator.name,
    'value': value,
  };

  bool matches(LedgerTransaction transaction) {
    if (value.trim().isEmpty) return false;
    if (field.isNumeric) {
      final threshold = parseAmount(value, decimalSeparator: '.');
      if (threshold == null) return false;
      final amount = transaction.amountMinor;
      return switch (operator) {
        RuleOperator.greaterThan => amount > threshold,
        RuleOperator.lessThan => amount < threshold,
        RuleOperator.equals => amount == threshold,
        _ => false,
      };
    }

    final subject = switch (field) {
      RuleField.counterparty => transaction.counterparty,
      RuleField.purpose => transaction.purpose,
      RuleField.iban => transaction.counterpartyIban ?? '',
      RuleField.anyText =>
        '${transaction.counterparty} ${transaction.purpose} '
            '${transaction.note}',
      RuleField.amount => '',
    }.toLowerCase();
    final needle = value.trim().toLowerCase();
    switch (operator) {
      case RuleOperator.contains:
        return subject.contains(needle);
      case RuleOperator.equals:
        return subject.trim() == needle;
      case RuleOperator.startsWith:
        return subject.trimLeft().startsWith(needle);
      case RuleOperator.endsWith:
        return subject.trimRight().endsWith(needle);
      case RuleOperator.regex:
        try {
          return RegExp(value.trim(), caseSensitive: false).hasMatch(subject);
        } on FormatException {
          return false;
        }
      case RuleOperator.greaterThan:
      case RuleOperator.lessThan:
        return false;
    }
  }
}

/// "If a transaction looks like this, put it in that category."
@immutable
class CategoryRule {
  const CategoryRule({
    required this.name,
    required this.categoryId,
    required this.conditions,
    this.id = kNewId,
    this.priority = 0,
    this.matchAll = true,
    this.isEnabled = true,
  });

  final int id;
  final String name;
  final int categoryId;

  /// Rules are tried in ascending priority; the first match wins.
  final int priority;

  /// Whether all [conditions] must hold (true) or any one of them (false).
  final bool matchAll;
  final List<RuleCondition> conditions;
  final bool isEnabled;

  bool get isNew => id == kNewId;

  bool matches(LedgerTransaction transaction) {
    if (!isEnabled || conditions.isEmpty) return false;
    return matchAll
        ? conditions.every((c) => c.matches(transaction))
        : conditions.any((c) => c.matches(transaction));
  }

  CategoryRule copyWith({
    int? id,
    String? name,
    int? categoryId,
    int? priority,
    bool? matchAll,
    List<RuleCondition>? conditions,
    bool? isEnabled,
  }) => CategoryRule(
    id: id ?? this.id,
    name: name ?? this.name,
    categoryId: categoryId ?? this.categoryId,
    priority: priority ?? this.priority,
    matchAll: matchAll ?? this.matchAll,
    conditions: conditions ?? this.conditions,
    isEnabled: isEnabled ?? this.isEnabled,
  );
}

abstract interface class CategoryRuleRepository {
  /// Ordered by priority.
  Stream<List<CategoryRule>> watchAll();

  Future<List<CategoryRule>> getAll();

  Future<int> save(CategoryRule rule);

  Future<void> delete(int id);

  /// Stores the order of [orderedIds] as the rules' priorities.
  Future<void> reorder(List<int> orderedIds);
}
