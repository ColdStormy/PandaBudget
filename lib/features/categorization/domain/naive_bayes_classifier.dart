import 'dart:math' as math;

import 'package:meta/meta.dart';

/// The counts a multinomial Naive Bayes model consists of.
class ClassifierState {
  ClassifierState({
    Map<int, int>? documentCounts,
    Map<int, int>? tokenTotals,
    Map<String, Map<int, int>>? tokenCounts,
  }) : documentCounts = documentCounts ?? {},
       tokenTotals = tokenTotals ?? {},
       tokenCounts = tokenCounts ?? {};

  /// Training examples seen per category.
  final Map<int, int> documentCounts;

  /// Sum of all token counts per category.
  final Map<int, int> tokenTotals;

  /// token -> category -> how often the token was seen in that category.
  final Map<String, Map<int, int>> tokenCounts;

  bool get isEmpty => documentCounts.isEmpty;
}

@immutable
class Prediction {
  const Prediction({required this.categoryId, required this.confidence});

  final int categoryId;

  /// Posterior probability of [categoryId], between 0 and 1.
  final double confidence;
}

/// An incrementally trained text classifier.
///
/// Every confirmed categorisation is added with [partialFit]; there is never
/// a full retraining pass, so learning is instant and works offline on the
/// device. [predict] only answers when it is reasonably sure, because a wrong
/// category is worse than none: uncategorised transactions get reviewed,
/// wrongly categorised ones silently distort the analysis.
class NaiveBayesClassifier {
  NaiveBayesClassifier({
    ClassifierState? state,
    this.minConfidence = 0.7,
    this.minEvidence = 0.25,
  }) : state = state ?? ClassifierState();

  final ClassifierState state;

  /// Minimum posterior probability for a prediction to be returned.
  final double minConfidence;

  /// Minimum share of a transaction's tokens that must have been seen in the
  /// predicted category before. Guards against confident guesses that rest
  /// on a single coincidental token.
  final double minEvidence;

  /// Adds one training example.
  void partialFit(Iterable<String> tokens, int categoryId) =>
      _update(tokens, categoryId, 1);

  /// Removes a training example previously added with [partialFit], used
  /// when the user corrects a category.
  void unlearn(Iterable<String> tokens, int categoryId) =>
      _update(tokens, categoryId, -1);

  void _update(Iterable<String> tokens, int categoryId, int delta) {
    final unique = tokens.toSet();
    if (unique.isEmpty) return;
    _add(state.documentCounts, categoryId, delta);
    _add(state.tokenTotals, categoryId, delta * unique.length);
    for (final token in unique) {
      final perCategory = state.tokenCounts.putIfAbsent(token, () => {});
      _add(perCategory, categoryId, delta);
      if (perCategory.isEmpty) state.tokenCounts.remove(token);
    }
  }

  static void _add(Map<int, int> counts, int key, int delta) {
    final value = (counts[key] ?? 0) + delta;
    if (value <= 0) {
      counts.remove(key);
    } else {
      counts[key] = value;
    }
  }

  /// Drops everything learned about [categoryId].
  void forgetCategory(int categoryId) {
    state.documentCounts.remove(categoryId);
    state.tokenTotals.remove(categoryId);
    state.tokenCounts.removeWhere((_, perCategory) {
      perCategory.remove(categoryId);
      return perCategory.isEmpty;
    });
  }

  /// The most likely category for [tokens], or null if the model has not
  /// seen enough to be confident.
  Prediction? predict(Iterable<String> tokens) {
    if (state.isEmpty) return null;
    final unique = tokens.toSet();
    final known = unique.where(state.tokenCounts.containsKey).toList();
    if (known.isEmpty) return null;

    final totalDocuments = state.documentCounts.values.fold(0, (a, b) => a + b);
    final vocabulary = state.tokenCounts.length;
    final scores = <int, double>{};
    for (final MapEntry(key: category, value: documents)
        in state.documentCounts.entries) {
      var score = math.log(documents / totalDocuments);
      final total = state.tokenTotals[category] ?? 0;
      for (final token in known) {
        final count = state.tokenCounts[token]![category] ?? 0;
        // Laplace smoothing keeps unseen tokens from zeroing a category.
        score += math.log((count + 1) / (total + vocabulary));
      }
      scores[category] = score;
    }

    final best = scores.entries.reduce((a, b) => a.value >= b.value ? a : b);
    // Softmax over log scores, computed relative to the best for stability.
    final normalizer = scores.values
        .map((score) => math.exp(score - best.value))
        .fold<double>(0, (a, b) => a + b);
    final confidence = 1 / normalizer;

    final supporting = known
        .where((token) => (state.tokenCounts[token]![best.key] ?? 0) > 0)
        .length;
    final evidence = supporting / unique.length;

    if (confidence < minConfidence || evidence < minEvidence) return null;
    return Prediction(categoryId: best.key, confidence: confidence);
  }
}

/// Persists the classifier's counts.
abstract interface class ClassifierStore {
  Future<ClassifierState> load();

  /// Applies count changes: [documentDeltas] per category and [tokenDeltas]
  /// per category and token. Counts that reach zero are removed.
  Future<void> applyDeltas({
    required Map<int, int> documentDeltas,
    required Map<int, Map<String, int>> tokenDeltas,
  });

  Future<void> clear();
}
