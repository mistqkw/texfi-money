import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/data_providers.dart';
import '../../domain/entities/transaction_entity.dart';

final totalBalanceProvider = StreamProvider<double>((ref) {
  return ref.watch(transactionRepositoryProvider).watchTotalBalance();
});

final monthlySummaryProvider =
    StreamProvider<({double income, double expense})>((ref) {
  return ref.watch(transactionRepositoryProvider).watchMonthlySummary(DateTime.now());
});

final recentTransactionsProvider = StreamProvider<List<TransactionEntity>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchRecent(limit: 5);
});
