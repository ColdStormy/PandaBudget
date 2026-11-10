import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pandabudget/core/time/year_month.dart';
import 'package:pandabudget/features/transactions/data/drift_transaction_repository.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';

/// The search and filter criteria of the transactions screen.
class TransactionFilterController extends Notifier<TransactionFilter> {
  @override
  TransactionFilter build() => const TransactionFilter();

  // Named `set` rather than a setter because Notifier.state is protected.
  // ignore: use_setters_to_change_properties
  void set(TransactionFilter filter) => state = filter;

  void clear() => state = TransactionFilter(query: state.query);
}

final transactionFilterProvider =
    NotifierProvider<TransactionFilterController, TransactionFilter>(
      TransactionFilterController.new,
    );

final filteredTransactionsProvider = StreamProvider<List<LedgerTransaction>>(
  (ref) => ref
      .watch(transactionRepositoryProvider)
      .watch(ref.watch(transactionFilterProvider)),
);

/// All transactions booked from the first month to the last, inclusive.
final transactionsInMonthsProvider =
    StreamProvider.family<
      List<LedgerTransaction>,
      ({YearMonth from, YearMonth to})
    >(
      (ref, range) => ref
          .watch(transactionRepositoryProvider)
          .watchRange(range.from.firstDay, range.to.lastDay),
    );
