import 'package:drift/drift.dart';

/// Транзакции дохода/расхода. Сумма всегда положительная — знак задаёт [type].
class Transactions extends Table {
  TextColumn get id => text()();
  RealColumn get amount => real()();

  /// 'income' | 'expense'.
  TextColumn get type => text()();

  /// Ссылается на `Categories.id` (без декларативного FK — см. репозитории).
  TextColumn get categoryId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
