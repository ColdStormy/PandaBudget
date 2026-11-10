import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/features/categorization/data/drift_categorization_repositories.dart';
import 'package:pandabudget/features/categorization/domain/categorizer.dart';
import 'package:pandabudget/features/categorization/domain/category_rule.dart';
import 'package:pandabudget/features/categorization/domain/naive_bayes_classifier.dart';
import 'package:pandabudget/features/transactions/data/drift_transaction_repository.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

final categorizationServiceProvider = Provider<CategorizationService>(
  (ref) => CategorizationService(
    rules: ref.watch(categoryRuleRepositoryProvider),
    classifierStore: ref.watch(classifierStoreProvider),
    transactions: ref.watch(transactionRepositoryProvider),
  ),
);

/// Assigns categories to transactions and keeps the learning classifier in
/// step with what the user decides.
///
/// Order of precedence: user rules, then the classifier, then nothing.
/// Categories set by a rule or by hand are ground truth and train the
/// classifier; categories the classifier suggested itself never do, so it
/// cannot reinforce its own mistakes.
class CategorizationService {
  CategorizationService({
    required this._rules,
    required ClassifierStore classifierStore,
    required this._transactions,
  }) : _store = classifierStore;

  final CategoryRuleRepository _rules;
  final ClassifierStore _store;
  final TransactionRepository _transactions;

  NaiveBayesClassifier? _classifier;

  Future<NaiveBayesClassifier> _loadClassifier() async =>
      _classifier ??= NaiveBayesClassifier(state: await _store.load());

  /// Forgets the in-memory model so it is reloaded from the database, for
  /// example after a category (and with it its training data) was deleted.
  void invalidate() => _classifier = null;

  /// Returns [transactions] with categories filled in where a rule or the
  /// classifier has an answer. Nothing is stored and nothing is learned.
  ///
  /// Transactions that already carry a manual category are left alone.
  Future<List<LedgerTransaction>> categorize(
    List<LedgerTransaction> transactions,
  ) async {
    final categorizer = Categorizer(
      rules: await _rules.getAll(),
      classifier: await _loadClassifier(),
    );
    return [
      for (final transaction in transactions)
        if (transaction.categorySource == CategorySource.manual)
          transaction
        else
          _apply(transaction, categorizer.assign(transaction)),
    ];
  }

  static LedgerTransaction _apply(
    LedgerTransaction transaction,
    CategoryAssignment assignment,
  ) => transaction.copyWith(
    categoryId: () => assignment.categoryId,
    categorySource: assignment.source,
    ruleId: () => assignment.ruleId,
  );

  /// Stores [transactions] and teaches the classifier those categorised by a
  /// rule or by hand.
  Future<void> saveAll(List<LedgerTransaction> transactions) async {
    final trained = await _train(transactions);
    await _transactions.saveAll(trained);
  }

  /// Stores a single transaction, see [saveAll]. Returns its id.
  Future<int> save(LedgerTransaction transaction) async {
    final trained = await _train([transaction]);
    return await _transactions.save(trained.single);
  }

  /// Sets the category the user picked (or clears it with null).
  Future<void> setCategoryManually(
    LedgerTransaction transaction,
    int? categoryId,
  ) => save(
    transaction.copyWith(
      categoryId: () => categoryId,
      categorySource: categoryId == null
          ? CategorySource.none
          : CategorySource.manual,
      ruleId: () => null,
    ),
  );

  /// Runs rules and classifier again over stored transactions and returns
  /// how many changed.
  ///
  /// Manual categories are never touched. With [onlyUncategorized] the
  /// existing rule and classifier results are kept as well.
  Future<int> recategorize({bool onlyUncategorized = false}) async {
    final stored = await _transactions.getAll(
      uncategorizedOnly: onlyUncategorized,
    );
    final updated = await categorize(stored);
    final changed = [
      for (final (index, transaction) in updated.indexed)
        if (transaction.categoryId != stored[index].categoryId ||
            transaction.categorySource != stored[index].categorySource ||
            transaction.ruleId != stored[index].ruleId)
          transaction,
    ];
    if (changed.isNotEmpty) await saveAll(changed);
    return changed.length;
  }

  /// Throws away the learned model and rebuilds it from all transactions
  /// that were categorised by a rule or by hand.
  Future<void> rebuildClassifier() async {
    await _store.clear();
    invalidate();
    final stored = await _transactions.getAll();
    await saveAll([
      for (final transaction in stored)
        transaction.copyWith(trainedCategoryId: () => null),
    ]);
  }

  /// Brings the classifier in line with the categories of [transactions]
  /// and returns them with `trainedCategoryId` updated.
  Future<List<LedgerTransaction>> _train(
    List<LedgerTransaction> transactions,
  ) async {
    final classifier = await _loadClassifier();
    final documentDeltas = <int, int>{};
    final tokenDeltas = <int, Map<String, int>>{};

    void record(List<String> tokens, int categoryId, int delta) {
      if (tokens.isEmpty) return;
      if (delta > 0) {
        classifier.partialFit(tokens, categoryId);
      } else {
        classifier.unlearn(tokens, categoryId);
      }
      documentDeltas[categoryId] = (documentDeltas[categoryId] ?? 0) + delta;
      final perToken = tokenDeltas.putIfAbsent(categoryId, () => {});
      for (final token in tokens.toSet()) {
        perToken[token] = (perToken[token] ?? 0) + delta;
      }
    }

    final result = <LedgerTransaction>[];
    for (final transaction in transactions) {
      final isGroundTruth =
          transaction.categorySource == CategorySource.rule ||
          transaction.categorySource == CategorySource.manual;
      final target = isGroundTruth ? transaction.categoryId : null;
      final trained = transaction.trainedCategoryId;
      if (target == trained) {
        result.add(transaction);
        continue;
      }
      final tokens = Categorizer.tokensOf(transaction);
      if (trained != null) record(tokens, trained, -1);
      if (target != null) record(tokens, target, 1);
      result.add(
        transaction.copyWith(
          trainedCategoryId: () => tokens.isEmpty ? null : target,
        ),
      );
    }

    if (documentDeltas.isNotEmpty) {
      await _store.applyDeltas(
        documentDeltas: documentDeltas,
        tokenDeltas: tokenDeltas,
      );
    }
    return result;
  }
}
