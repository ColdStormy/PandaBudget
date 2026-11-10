import 'package:meta/meta.dart';
import 'package:pandabudget/features/categorization/domain/category_rule.dart';
import 'package:pandabudget/features/categorization/domain/naive_bayes_classifier.dart';
import 'package:pandabudget/features/categorization/domain/tokenizer.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

@immutable
class CategoryAssignment {
  const CategoryAssignment({
    required this.categoryId,
    required this.source,
    this.ruleId,
    this.confidence,
  });

  static const none = CategoryAssignment(
    categoryId: null,
    source: CategorySource.none,
  );

  final int? categoryId;
  final CategorySource source;
  final int? ruleId;

  /// Set for [CategorySource.learned] assignments.
  final double? confidence;
}

/// Decides the category of a transaction: user rules first, in priority
/// order; if none matches, the learning classifier; otherwise none.
class Categorizer {
  Categorizer({required List<CategoryRule> rules, required this.classifier})
    : rules = [...rules]..sort((a, b) => a.priority.compareTo(b.priority));

  final List<CategoryRule> rules;
  final NaiveBayesClassifier classifier;

  CategoryAssignment assign(LedgerTransaction transaction) {
    for (final rule in rules) {
      if (rule.matches(transaction)) {
        return CategoryAssignment(
          categoryId: rule.categoryId,
          source: CategorySource.rule,
          ruleId: rule.id,
        );
      }
    }
    final prediction = classifier.predict(tokensOf(transaction));
    if (prediction != null) {
      return CategoryAssignment(
        categoryId: prediction.categoryId,
        source: CategorySource.learned,
        confidence: prediction.confidence,
      );
    }
    return CategoryAssignment.none;
  }

  static List<String> tokensOf(LedgerTransaction transaction) => tokenize(
    counterparty: transaction.counterparty,
    purpose: transaction.purpose,
  );
}
