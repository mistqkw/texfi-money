import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/account_repository.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/debt_profile_repository.dart';
import '../../domain/repositories/savings_goal_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../local/database.dart';
import '../repositories/account_repository_impl.dart';
import '../repositories/budget_repository_impl.dart';
import '../repositories/category_repository_impl.dart';
import '../repositories/debt_profile_repository_impl.dart';
import '../repositories/savings_goal_repository_impl.dart';
import '../repositories/transaction_repository_impl.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final _categoryMapperProvider = Provider<CategoryRepositoryImpl>((ref) {
  return CategoryRepositoryImpl(ref.watch(databaseProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return ref.watch(_categoryMapperProvider);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(_categoryMapperProvider),
  );
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(_categoryMapperProvider),
  );
});

final savingsGoalRepositoryProvider = Provider<SavingsGoalRepository>((ref) {
  return SavingsGoalRepositoryImpl(ref.watch(databaseProvider));
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepositoryImpl(ref.watch(databaseProvider));
});

final debtProfileRepositoryProvider = Provider<DebtProfileRepository>((ref) {
  return DebtProfileRepositoryImpl(ref.watch(databaseProvider));
});
