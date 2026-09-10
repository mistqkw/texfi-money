import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/data_providers.dart';
import '../../domain/entities/asset_entity.dart';
import '../../domain/entities/cash_flow_type.dart';
import '../../domain/entities/net_worth.dart';
import '../../domain/entities/spend_usefulness.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/entities/wealth_rules.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../settings/analysis_range_provider.dart';

final assetsProvider = StreamProvider<List<AssetEntity>>((ref) {
  return ref.watch(assetRepositoryProvider).watchAll();
});

final assetCategoriesProvider =
    StreamProvider<List<AssetCategoryEntity>>((ref) {
  return ref.watch(assetRepositoryProvider).watchCategories();
});

final riskLevelsProvider = StreamProvider<List<RiskLevelEntity>>((ref) {
  return ref.watch(assetRepositoryProvider).watchRiskLevels();
});

final assetHistoryProvider =
    StreamProvider.family<List<AssetValuePoint>, String>((ref, assetId) {
  return ref.watch(assetRepositoryProvider).watchHistory(assetId);
});

final activeSubscriptionsProvider =
    StreamProvider<List<SubscriptionEntity>>((ref) {
  return ref.watch(subscriptionRepositoryProvider).watchActive();
});

final allSubscriptionsProvider =
    StreamProvider<List<SubscriptionEntity>>((ref) {
  return ref.watch(subscriptionRepositoryProvider).watchAll();
});

/// Капитал на сегодня.
final netWorthProvider = Provider<NetWorthSnapshot>((ref) {
  final assets = ref.watch(assetsProvider).valueOrNull ?? const [];
  return NetWorth.snapshot(assets);
});

/// Распределение по категориям, типу потока и риску.
///
/// Три провайдера, а не один с параметром: экран показывает все три
/// сразу, и разделение делает каждый пересчёт независимым.
final categorySharesProvider =
    Provider<List<WealthShare<AssetCategoryEntity>>>((ref) {
  final assets = ref.watch(assetsProvider).valueOrNull ?? const [];
  return NetWorth.shares(assets, (asset) => asset.category);
});

final cashFlowSharesProvider = Provider<List<WealthShare<CashFlowType>>>((ref) {
  final assets = ref.watch(assetsProvider).valueOrNull ?? const [];
  return NetWorth.shares(assets, (asset) => asset.cashFlowType);
});

final riskSharesProvider = Provider<List<WealthShare<RiskLevelEntity>>>((ref) {
  final assets = ref.watch(assetsProvider).valueOrNull ?? const [];
  return NetWorth.shares(assets, (asset) => asset.riskLevel);
});

final riskBreachesProvider = Provider<List<RiskBreach>>((ref) {
  final assets = ref.watch(assetsProvider).valueOrNull ?? const [];
  return WealthRules.riskBreaches(assets);
});

/// Изменение капитала за последний год.
///
/// Считается по истории оценок, а не по сегодняшним стоимостям: актив,
/// купленный в июне, не должен выглядеть как прошлогодний рост. Активы,
/// которых год назад ещё не было, в начальную точку не входят вовсе.
final netWorthYearChangeProvider = FutureProvider<NetWorthChange?>((ref) async {
  final assets = ref.watch(assetsProvider).valueOrNull ?? const [];
  if (assets.isEmpty) return null;

  final history = await ref.watch(assetRepositoryProvider).historyByAsset();
  final now = DateTime.now();
  final yearAgo = DateTime(now.year - 1, now.month, now.day);

  var then = 0.0;
  for (final asset in assets) {
    final value = NetWorth.valueAt(history[asset.id] ?? const [], yearAgo);
    if (value == null) continue;
    then += asset.cashFlowType == CashFlowType.liability ? -value : value;
  }

  return NetWorthChange(from: then, to: ref.watch(netWorthProvider).total);
});

/// Сумма подписок в месяц. Годовые нормализованы к месяцу.
final monthlySubscriptionCostProvider = Provider<double>((ref) {
  final subs = ref.watch(activeSubscriptionsProvider).valueOrNull ?? const [];
  return subs.fold<double>(0, (sum, sub) => sum + sub.monthlyCost);
});

/// Процент сбережений по месяцам внутри выбранного диапазона анализа.
///
/// Самый свежий месяц идёт последним — так его читает график.
final savingsRateHistoryProvider =
    FutureProvider<List<({DateTime month, double? rate})>>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final range = ref.watch(analysisRangeProvider).resolve(DateTime.now());

  final months = <DateTime>[];
  var cursor = DateTime(range.from.year, range.from.month);
  final last = DateTime(range.to.year, range.to.month);
  // Потолок — страховка от вырожденного диапазона, а не ожидаемый режим:
  // сто лет помесячно никто не смотрит.
  while (!cursor.isAfter(last) && months.length < 1200) {
    months.add(cursor);
    cursor = DateTime(cursor.year, cursor.month + 1);
  }

  return Future.wait(
    months.map((month) async {
      final summary = await repository.watchMonthlySummary(month).first;
      return (
        month: month,
        rate: SavingsRate.forPeriod(
          income: summary.income,
          expense: summary.expense,
        ),
      );
    }),
  );
});

/// Процент сбережений за текущий месяц.
final currentSavingsRateProvider = FutureProvider<double?>((ref) async {
  final now = DateTime.now();
  final summary = await ref
      .watch(transactionRepositoryProvider)
      .watchMonthlySummary(DateTime(now.year, now.month))
      .first;
  return SavingsRate.forPeriod(
    income: summary.income,
    expense: summary.expense,
  );
});

/// Движение денег за произвольный период.
final cashFlowProvider = FutureProvider.family<
    ({double income, double expense, double saved}),
    ({DateTime from, DateTime to})>((ref, period) async {
  final transactions = await ref
      .watch(transactionRepositoryProvider)
      .watchAll(TransactionFilter(from: period.from, to: period.to))
      .first;

  var income = 0.0;
  var expense = 0.0;
  for (final tx in transactions) {
    if (tx.type == TransactionType.income) {
      income += tx.amount;
    } else {
      expense += tx.amount;
    }
  }
  return (income: income, expense: expense, saved: income - expense);
});

/// Расходы по оценке полезности за текущий месяц.
final usefulnessTotalsProvider =
    FutureProvider.family<Map<SpendUsefulness?, double>, ({DateTime from, DateTime to})>(
        (ref, period) async {
  return ref
      .watch(transactionRepositoryProvider)
      .usefulnessTotals(from: period.from, to: period.to);
});

/// Поводы что-то сказать — по всем правилам сразу.
///
/// Собирается в одном месте, потому что советы стоят на одном экране и
/// должны появляться и исчезать вместе, а не по одному от каждого раздела.
final adviceProvider = FutureProvider<List<Advice>>((ref) async {
  final now = DateTime.now();
  final thisMonth = DateTime(now.year, now.month);
  final prevMonth = DateTime(now.year, now.month - 1);
  final repository = ref.watch(transactionRepositoryProvider);

  Future<double> uselessIn(DateTime month) async {
    final totals = await repository.usefulnessTotals(
      from: month,
      to: DateTime(month.year, month.month + 1).subtract(const Duration(days: 1)),
    );
    return totals[SpendUsefulness.useless] ?? 0;
  }

  final rates = await ref.watch(savingsRateHistoryProvider.future);
  // Среднее считается без текущего месяца: сравнивать его с самим собой
  // бессмысленно, а в начале месяца он ещё и заведомо неполный.
  final history = rates.length > 1
      ? rates.sublist(0, rates.length - 1).map((e) => e.rate)
      : const <double?>[];

  return WealthRules.advise(
    breaches: ref.watch(riskBreachesProvider),
    uselessBefore: await uselessIn(prevMonth),
    uselessAfter: await uselessIn(thisMonth),
    savingsRate: await ref.watch(currentSavingsRateProvider.future),
    savingsRateAverage: SavingsRate.average(history),
  );
});
