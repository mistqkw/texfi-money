import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/data_providers.dart';
import '../../domain/entities/category_total.dart';
import '../../domain/entities/monthly_total.dart';
import '../../domain/entities/transaction_type.dart';

const monthlyChartRange = 6;

final monthlyTotalsProvider = StreamProvider<List<MonthlyTotal>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchMonthlyTotals(monthlyChartRange);
});

final expenseCategoryTotalsProvider = StreamProvider<List<CategoryTotal>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchCategoryTotals(
        month: DateTime.now(),
        type: TransactionType.expense,
      );
});
