import 'package:flutter_test/flutter_test.dart';
import 'package:pandabudget/features/categorization/domain/categorizer.dart';
import 'package:pandabudget/features/categorization/domain/category_rule.dart';
import 'package:pandabudget/features/categorization/domain/naive_bayes_classifier.dart';
import 'package:pandabudget/features/categorization/domain/tokenizer.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

LedgerTransaction tx({
  String counterparty = '',
  String purpose = '',
  int amountMinor = -1000,
  String? iban,
}) => LedgerTransaction(
  accountId: 1,
  bookingDate: DateTime(2026, 10),
  amountMinor: amountMinor,
  counterparty: counterparty,
  purpose: purpose,
  counterpartyIban: iban,
);

RuleCondition condition(RuleField field, RuleOperator operator, String value) =>
    RuleCondition(field: field, operator: operator, value: value);

void main() {
  group('RuleCondition', () {
    final rewe = tx(counterparty: 'REWE Markt GmbH', purpose: 'Sagt Danke');

    test('text operators ignore case', () {
      expect(
        condition(
          RuleField.counterparty,
          RuleOperator.contains,
          'rewe',
        ).matches(rewe),
        isTrue,
      );
      expect(
        condition(
          RuleField.counterparty,
          RuleOperator.startsWith,
          'REWE M',
        ).matches(rewe),
        isTrue,
      );
      expect(
        condition(
          RuleField.counterparty,
          RuleOperator.endsWith,
          'gmbh',
        ).matches(rewe),
        isTrue,
      );
      expect(
        condition(
          RuleField.counterparty,
          RuleOperator.equals,
          'rewe',
        ).matches(rewe),
        isFalse,
      );
      expect(
        condition(
          RuleField.purpose,
          RuleOperator.contains,
          'rewe',
        ).matches(rewe),
        isFalse,
      );
      expect(
        condition(
          RuleField.anyText,
          RuleOperator.contains,
          'danke',
        ).matches(rewe),
        isTrue,
      );
    });

    test('regular expressions match, broken ones never do', () {
      expect(
        condition(
          RuleField.counterparty,
          RuleOperator.regex,
          r'^rewe\s',
        ).matches(rewe),
        isTrue,
      );
      expect(
        condition(
          RuleField.counterparty,
          RuleOperator.regex,
          '(',
        ).matches(rewe),
        isFalse,
      );
    });

    test('amount comparisons use the signed amount', () {
      final salary = tx(amountMinor: 325000);
      expect(
        condition(
          RuleField.amount,
          RuleOperator.greaterThan,
          '1000',
        ).matches(salary),
        isTrue,
      );
      expect(
        condition(RuleField.amount, RuleOperator.lessThan, '0').matches(salary),
        isFalse,
      );
      expect(
        condition(
          RuleField.amount,
          RuleOperator.equals,
          '3250.00',
        ).matches(salary),
        isTrue,
      );
    });

    test('an empty value matches nothing', () {
      expect(
        condition(RuleField.anyText, RuleOperator.contains, ' ').matches(rewe),
        isFalse,
      );
    });

    test('survives a JSON round trip', () {
      final original = condition(RuleField.iban, RuleOperator.equals, 'DE00');
      final copy = RuleCondition.fromJson(original.toJson());
      expect(copy.field, RuleField.iban);
      expect(copy.operator, RuleOperator.equals);
      expect(copy.value, 'DE00');
    });
  });

  group('CategoryRule', () {
    final conditions = [
      condition(RuleField.counterparty, RuleOperator.contains, 'stadtwerke'),
      condition(RuleField.amount, RuleOperator.lessThan, '0'),
    ];
    final payment = tx(counterparty: 'Stadtwerke Musterstadt');
    final refund = tx(counterparty: 'Stadtwerke Musterstadt', amountMinor: 500);

    test('requires all conditions by default', () {
      final rule = CategoryRule(
        name: 'r',
        categoryId: 1,
        conditions: conditions,
      );
      expect(rule.matches(payment), isTrue);
      expect(rule.matches(refund), isFalse);
    });

    test('can match on any condition', () {
      final rule = CategoryRule(
        name: 'r',
        categoryId: 1,
        conditions: conditions,
        matchAll: false,
      );
      expect(rule.matches(refund), isTrue);
    });

    test('never matches when disabled or empty', () {
      expect(
        CategoryRule(
          name: 'r',
          categoryId: 1,
          conditions: conditions,
          isEnabled: false,
        ).matches(payment),
        isFalse,
      );
      expect(
        const CategoryRule(
          name: 'r',
          categoryId: 1,
          conditions: [],
        ).matches(payment),
        isFalse,
      );
    });
  });

  group('tokenize', () {
    test('keeps meaningful words and drops noise', () {
      final tokens = tokenize(
        counterparty: 'REWE Markt GmbH',
        purpose: 'REWE SAGT DANKE 4711 // Ref 2026-10-30',
      );
      expect(tokens, containsAll(['c:rewe', 'c:markt', 'p:rewe']));
      expect(tokens, isNot(contains('c:gmbh')));
      expect(tokens, isNot(contains('p:danke')));
      expect(tokens.where((t) => t.contains(RegExp('[0-9]'))), isEmpty);
    });

    test('adds counterparty trigrams so similar names overlap', () {
      final a = tokenize(counterparty: 'Stadtwerke Musterstadt', purpose: '');
      final b = tokenize(counterparty: 'Stadtwerk Nord', purpose: '');
      expect(a.toSet().intersection(b.toSet()), isNotEmpty);
    });

    test('transliterates umlauts', () {
      expect(
        tokenize(counterparty: 'Bäckerei Schön', purpose: ''),
        containsAll(['c:baeckerei', 'c:schoen']),
      );
    });
  });

  group('NaiveBayesClassifier', () {
    const groceries = 1;
    const energy = 2;
    const rent = 3;

    NaiveBayesClassifier trained() {
      final classifier = NaiveBayesClassifier();
      void fit(String counterparty, String purpose, int category) =>
          classifier.partialFit(
            tokenize(counterparty: counterparty, purpose: purpose),
            category,
          );
      fit('REWE Markt GmbH', 'REWE sagt Danke', groceries);
      fit('REWE Center', 'Einkauf', groceries);
      fit('EDEKA Schmidt', 'Einkauf Lebensmittel', groceries);
      fit('Stadtwerke Musterstadt', 'Abschlag Strom', energy);
      fit('Stadtwerke Musterstadt', 'Abschlag Gas', energy);
      fit('Hausverwaltung Müller', 'Miete Oktober', rent);
      return classifier;
    }

    test('recognises a known counterparty in a new transaction', () {
      final prediction = trained().predict(
        tokenize(counterparty: 'REWE Markt 0815', purpose: 'Kartenzahlung'),
      );
      expect(prediction?.categoryId, groceries);
      expect(prediction!.confidence, greaterThan(0.7));
    });

    test('generalises from the purpose text', () {
      final prediction = trained().predict(
        tokenize(counterparty: 'Stadtwerke Nord', purpose: 'Abschlag Strom'),
      );
      expect(prediction?.categoryId, energy);
    });

    test('stays silent on something it has never seen', () {
      final classifier = trained();
      expect(
        classifier.predict(
          tokenize(counterparty: 'Zahnarzt Dr. Weiss', purpose: 'Behandlung'),
        ),
        isNull,
      );
      expect(classifier.predict(const []), isNull);
      expect(NaiveBayesClassifier().predict(['c:rewe']), isNull);
    });

    test('stays silent when the evidence points both ways', () {
      final classifier = NaiveBayesClassifier()
        ..partialFit(['c:amazon'], groceries)
        ..partialFit(['c:amazon'], energy);
      expect(classifier.predict(['c:amazon']), isNull);
    });

    test('needs more than one coincidental token', () {
      final classifier = trained();
      // Shares only "einkauf" with groceries; five other tokens are unknown.
      final tokens = [
        'p:einkauf',
        'c:moebelhaus',
        'c:wohnwelt',
        'p:sofa',
        'p:lieferung',
        'p:anzahlung',
      ];
      expect(classifier.predict(tokens), isNull);
    });

    test('unlearn exactly reverses partialFit', () {
      final classifier = trained();
      final tokens = tokenize(
        counterparty: 'Tankstelle Aral',
        purpose: 'Diesel',
      );
      classifier.partialFit(tokens, 9);
      expect(classifier.predict(tokens)?.categoryId, 9);

      classifier.unlearn(tokens, 9);
      expect(classifier.predict(tokens), isNull);
      expect(classifier.state.documentCounts.containsKey(9), isFalse);
      expect(classifier.state.tokenCounts.containsKey('c:aral'), isFalse);
    });

    test('a correction moves the prediction to the new category', () {
      final classifier = NaiveBayesClassifier();
      final tokens = tokenize(counterparty: 'Drogerie Markt', purpose: '');
      classifier.partialFit(tokens, groceries);
      expect(classifier.predict(tokens)?.categoryId, groceries);
      classifier
        ..unlearn(tokens, groceries)
        ..partialFit(tokens, energy);
      expect(classifier.predict(tokens)?.categoryId, energy);
    });

    test('forgetCategory removes everything learned about it', () {
      final classifier = trained()..forgetCategory(groceries);
      expect(classifier.state.documentCounts.containsKey(groceries), isFalse);
      expect(
        classifier.predict(tokenize(counterparty: 'REWE Markt', purpose: '')),
        isNull,
      );
      expect(
        classifier
            .predict(
              tokenize(counterparty: 'Stadtwerke Musterstadt', purpose: ''),
            )
            ?.categoryId,
        energy,
      );
    });
  });

  group('Categorizer', () {
    final classifier = NaiveBayesClassifier()
      ..partialFit(tokenize(counterparty: 'REWE Markt', purpose: ''), 1);
    final rules = [
      CategoryRule(
        id: 20,
        name: 'late',
        categoryId: 5,
        priority: 2,
        conditions: [
          condition(RuleField.counterparty, RuleOperator.contains, 'rewe'),
        ],
      ),
      CategoryRule(
        id: 10,
        name: 'early',
        categoryId: 4,
        priority: 1,
        conditions: [
          condition(
            RuleField.counterparty,
            RuleOperator.contains,
            'rewe to go',
          ),
        ],
      ),
    ];

    test('the first matching rule by priority wins', () {
      final categorizer = Categorizer(rules: rules, classifier: classifier);
      final assignment = categorizer.assign(tx(counterparty: 'REWE To Go'));
      expect(assignment.source, CategorySource.rule);
      expect(assignment.categoryId, 4);
      expect(assignment.ruleId, 10);
    });

    test('rules win over the classifier', () {
      final categorizer = Categorizer(rules: rules, classifier: classifier);
      final assignment = categorizer.assign(tx(counterparty: 'REWE Markt'));
      expect(assignment.source, CategorySource.rule);
      expect(assignment.categoryId, 5);
    });

    test('falls back to the classifier, then to nothing', () {
      final categorizer = Categorizer(rules: const [], classifier: classifier);
      final learned = categorizer.assign(tx(counterparty: 'REWE Markt'));
      expect(learned.source, CategorySource.learned);
      expect(learned.categoryId, 1);
      expect(learned.confidence, isNotNull);

      final unknown = categorizer.assign(tx(counterparty: 'Unbekannt'));
      expect(unknown.source, CategorySource.none);
      expect(unknown.categoryId, isNull);
    });
  });
}
