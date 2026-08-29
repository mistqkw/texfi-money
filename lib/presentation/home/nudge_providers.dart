import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/providers/data_providers.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/nudges.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../budgets/budgets_providers.dart';
import '../goals/goals_providers.dart';
import '../settings/currency_provider.dart';

const _dismissedKey = 'dismissed_nudges';

/// Скрытые пользователем подсказки. Хранится множество стабильных id:
/// пока ситуация не изменилась, скрытая подсказка не возвращается.
class DismissedNudgesNotifier extends StateNotifier<Set<String>> {
  DismissedNudgesNotifier(this._prefs)
      : super((_prefs.getStringList(_dismissedKey) ?? const []).toSet());

  final SharedPreferences _prefs;

  Future<void> dismiss(String id) async {
    state = {...state, id};
    await _prefs.setStringList(_dismissedKey, state.toList());
  }
}

final dismissedNudgesProvider =
    StateNotifierProvider<DismissedNudgesNotifier, Set<String>>((ref) {
  return DismissedNudgesNotifier(ref.watch(sharedPreferencesProvider));
});

/// Транзакции за последние ~3 месяца — достаточная база, чтобы судить
/// о «привычной» сумме, но без выкачивания всей истории.
final _nudgeTransactionsProvider = StreamProvider<List<TransactionEntity>>((ref) {
  final now = DateTime.now();
  return ref.watch(transactionRepositoryProvider).watchAll(
        TransactionFilter(from: DateTime(now.year, now.month - 3, now.day)),
      );
});

/// Актуальные подсказки без уже скрытых.
final nudgesProvider = Provider<List<Nudge>>((ref) {
  final transactions = ref.watch(_nudgeTransactionsProvider).valueOrNull;
  final budgets = ref.watch(currentMonthBudgetsProvider).valueOrNull;
  final goals = ref.watch(savingsGoalsProvider).valueOrNull;
  if (transactions == null) return const [];

  final dismissed = ref.watch(dismissedNudgesProvider);

  return buildNudges(
    transactions: transactions,
    budgets: budgets ?? const [],
    goals: goals ?? const [],
    now: DateTime.now(),
  ).where((n) => !dismissed.contains(n.id)).toList();
});
