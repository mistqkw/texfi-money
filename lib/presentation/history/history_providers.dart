import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/data_providers.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';

final filteredTransactionsProvider =
    StreamProvider.autoDispose.family<List<TransactionEntity>, TransactionFilter>(
  (ref, filter) => ref.watch(transactionRepositoryProvider).watchAll(filter),
);
