import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/data_providers.dart';
import '../../domain/entities/account_entity.dart';

final allAccountsProvider = StreamProvider<List<AccountEntity>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAll();
});

final accountBalanceProvider = StreamProvider.family<double, String>((ref, accountId) {
  return ref.watch(accountRepositoryProvider).watchBalance(accountId);
});
