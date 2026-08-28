import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/data_providers.dart';
import '../../domain/entities/savings_goal_entity.dart';

final savingsGoalsProvider = StreamProvider<List<SavingsGoalEntity>>((ref) {
  return ref.watch(savingsGoalRepositoryProvider).watchAll();
});
