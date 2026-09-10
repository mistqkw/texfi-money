import 'package:drift/drift.dart';

/// Подписка — регулярный платёж, о котором известно заранее.
///
/// Не транзакция: транзакция говорит, что деньги уже ушли, подписка — что
/// они будут уходить и дальше. Именно поэтому её видно отдельно: сумма
/// подписок в месяц — это обязательство, а не история.
class Subscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();

  /// Как часто списывают. Строкой — по той же причине, что и тип
  /// денежного потока у актива.
  TextColumn get period => text()();

  /// Длина периода в днях для [SubscriptionPeriod.custom]. Для остальных
  /// периодов не используется.
  IntColumn get customDays => integer().nullable()();

  /// Дата следующего списания. Двигается вперёд, когда проходит.
  DateTimeColumn get nextChargeAt => dateTime()();

  /// Категория расходов, к которой относится подписка. Необязательна:
  /// подписку заводят, чтобы видеть сумму, а не чтобы разложить по полкам.
  TextColumn get categoryId => text().nullable()();

  /// Отменённая подписка не удаляется, а перестаёт быть активной: в
  /// отчёте за прошлый год она должна остаться.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
