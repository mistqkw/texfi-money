import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/data_providers.dart';
import '../../domain/entities/budget_entity.dart';

final currentMonthBudgetsProvider = StreamProvider<List<BudgetEntity>>((ref) {
  return ref.watch(budgetRepositoryProvider).watchAll(DateTime.now());
});
