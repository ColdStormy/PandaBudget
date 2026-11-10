/// Words that say nothing about what a payment was for.
const Set<String> _stopWords = {
  'and', 'the', 'for', 'von', 'vom', 'und', 'der', 'die', 'das', 'den', //
  'dem', 'ihr', 'mit', 'bei', 'fuer', 'aus', 'your', 'you', 'our',
  'gmbh', 'mbh', 'inc', 'ltd', 'llc', 'kg', 'ag', 'ohg', 'ug', 'co',
  'sagt', 'danke', 'vielen', 'dank', 'thank', 'thanks',
  'sepa', 'lastschrift', 'ueberweisung', 'gutschrift', 'kartenzahlung',
  'dauerauftrag', 'basislastschrift', 'payment', 'transfer', 'debit',
  'card', 'ref', 'reference', 'referenz', 'mandat', 'mandate', 'end',
  'iban', 'bic', 'nr', 'no', 'eur', 'euro', 'kundennummer', 'rechnung',
  'invoice', 'datum', 'date', 'uhr', 'folgenr', 'verfalld',
};

/// Turns the text of a transaction into the features the classifier learns
/// from.
///
/// Produces, in this order of importance:
/// * `c:<word>` for each meaningful word of the counterparty,
/// * `p:<word>` for each meaningful word of the purpose,
/// * `t:<abc>` for character trigrams of the counterparty words, so that
///   "REWE Markt 0815" and "REWE-Center" still share features.
///
/// Words containing digits (dates, references, mandate numbers) are dropped
/// because they are unique per transaction and would only add noise.
List<String> tokenize({required String counterparty, required String purpose}) {
  final features = <String>{};
  final counterpartyWords = _words(counterparty);
  for (final word in counterpartyWords) {
    features.add('c:$word');
    if (word.length >= 4) {
      for (var i = 0; i + 3 <= word.length; i++) {
        features.add('t:${word.substring(i, i + 3)}');
      }
    }
  }
  for (final word in _words(purpose)) {
    features.add('p:$word');
  }
  return features.toList();
}

Iterable<String> _words(String text) => text
    .toLowerCase()
    .replaceAll('ä', 'ae')
    .replaceAll('ö', 'oe')
    .replaceAll('ü', 'ue')
    .replaceAll('ß', 'ss')
    .split(RegExp('[^a-z0-9]+'))
    .where(
      (word) =>
          word.length >= 3 &&
          !word.contains(RegExp('[0-9]')) &&
          !_stopWords.contains(word),
    );
