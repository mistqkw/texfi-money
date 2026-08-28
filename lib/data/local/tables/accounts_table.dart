import 'package:drift/drift.dart';

/// Счёт/карта пользователя (наличные, карта банка А, карта банка Б...).
/// Баланс не хранится напрямую — считается как сумма привязанных транзакций.
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get colorValue => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
