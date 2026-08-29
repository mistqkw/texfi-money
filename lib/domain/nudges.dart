import 'entities/budget_entity.dart';
import 'entities/savings_goal_entity.dart';
import 'entities/transaction_entity.dart';
import 'entities/transaction_type.dart';

/// Тип подсказки — определяет и текст, и визуальный акцент карточки.
enum NudgeKind {
  /// Последняя трата заметно выбивается из привычной для своей категории.
  unusualAmount,

  /// Бюджет категории на грани исчерпания.
  budgetClose,

  /// Бюджет категории уже превышен.
  budgetOver,

  /// Цель почти собрана — небольшой толчок к финишу.
  goalClose,

  /// Давно ничего не записывали — данные устаревают.
  quietDays,
}

/// Ненавязчивая подсказка на главном экране. Не уведомление и не модалка:
/// приложение офлайн и без пушей, поэтому подсказка живёт прямо в интерфейсе
/// и её всегда можно скрыть.
class Nudge {
  const Nudge({
    required this.kind,
    required this.id,
    this.categoryId,
    this.categoryName,
    this.goalTitle,
    this.ratio,
    this.percent,
    this.overAmount,
    this.days,
    this.transaction,
  });

  final NudgeKind kind;

  /// Стабильный идентификатор: пока ситуация не изменилась, подсказка
  /// остаётся «той же самой» и не всплывает заново после скрытия.
  final String id;

  final String? categoryId;
  final String? categoryName;
  final String? goalTitle;

  /// Во сколько раз сумма больше привычной (для [NudgeKind.unusualAmount]).
  final double? ratio;

  /// Процент исполнения бюджета или цели.
  final double? percent;

  /// На сколько превышен бюджет.
  final double? overAmount;

  /// Сколько дней без записей.
  final int? days;

  /// Транзакция, которой касается подсказка — по тапу открываем её на правку.
  final TransactionEntity? transaction;
}

/// Во сколько раз трата должна превысить привычную, чтобы о ней спросить.
const double _unusualRatio = 2.5;

/// Минимум транзакций в категории, чтобы «привычная сумма» вообще что-то
/// значила — иначе первая же покупка выглядела бы аномалией.
const int _minSamplesForAverage = 3;

/// Сколько дней тишины считаем поводом напомнить.
const int _quietDaysThreshold = 3;

/// Порог «цель почти собрана».
const double _goalCloseProgress = 0.8;

/// Собирает подсказки по текущему состоянию данных, в порядке важности:
/// превышенный бюджет → бюджет на грани → нетипичная сумма → почти
/// собранная цель → давно нет записей.
///
/// Функция намеренно чистая: никаких запросов и времени «изнутри» — всё
/// приходит аргументами, поэтому поведение полностью покрывается тестами.
List<Nudge> buildNudges({
  required List<TransactionEntity> transactions,
  required List<BudgetEntity> budgets,
  required List<SavingsGoalEntity> goals,
  required DateTime now,
}) {
  final nudges = <Nudge>[];

  for (final budget in budgets) {
    if (budget.isOverLimit) {
      final over = budget.spent - budget.monthlyLimit;
      nudges.add(Nudge(
        kind: NudgeKind.budgetOver,
        id: 'budget_over:${budget.category.id}:${over.round()}',
        categoryId: budget.category.id,
        categoryName: budget.category.name,
        overAmount: over,
      ));
    } else if (budget.isNearLimit) {
      nudges.add(Nudge(
        kind: NudgeKind.budgetClose,
        id: 'budget_close:${budget.category.id}',
        categoryId: budget.category.id,
        categoryName: budget.category.name,
        percent: budget.progress * 100,
      ));
    }
  }

  final unusual = _findUnusualExpense(transactions);
  if (unusual != null) nudges.add(unusual);

  for (final goal in goals) {
    if (!goal.isCompleted && goal.progress >= _goalCloseProgress) {
      nudges.add(Nudge(
        kind: NudgeKind.goalClose,
        id: 'goal_close:${goal.id}',
        goalTitle: goal.title,
        percent: goal.progress * 100,
      ));
    }
  }

  final quiet = _findQuietStreak(transactions, now);
  if (quiet != null) nudges.add(quiet);

  return nudges;
}

/// Ищет самую свежую трату, заметно превышающую среднюю по своей категории.
/// Средняя считается по остальным тратам категории — иначе крупная сумма
/// сама бы подтягивала ориентир и маскировала себя.
Nudge? _findUnusualExpense(List<TransactionEntity> transactions) {
  final expenses = transactions.where((t) => t.type == TransactionType.expense).toList()
    ..sort((a, b) => b.date.compareTo(a.date));
  if (expenses.isEmpty) return null;

  final latest = expenses.first;
  final peers = expenses
      .where((t) => t.id != latest.id && t.category.id == latest.category.id)
      .toList();
  if (peers.length < _minSamplesForAverage) return null;

  final average = peers.fold<double>(0, (sum, t) => sum + t.amount) / peers.length;
  if (average <= 0) return null;

  final ratio = latest.amount / average;
  if (ratio < _unusualRatio) return null;

  return Nudge(
    kind: NudgeKind.unusualAmount,
    id: 'unusual:${latest.id}',
    categoryId: latest.category.id,
    categoryName: latest.category.name,
    ratio: ratio,
    transaction: latest,
  );
}

/// Сколько дней прошло с последней записи.
Nudge? _findQuietStreak(List<TransactionEntity> transactions, DateTime now) {
  if (transactions.isEmpty) return null;

  var latest = transactions.first.date;
  for (final t in transactions) {
    if (t.date.isAfter(latest)) latest = t.date;
  }

  final today = DateTime(now.year, now.month, now.day);
  final lastDay = DateTime(latest.year, latest.month, latest.day);
  final days = today.difference(lastDay).inDays;
  if (days < _quietDaysThreshold) return null;

  return Nudge(
    kind: NudgeKind.quietDays,
    id: 'quiet:${lastDay.toIso8601String()}',
    days: days,
  );
}
