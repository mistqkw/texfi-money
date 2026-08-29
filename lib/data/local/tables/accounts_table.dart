import 'package:drift/drift.dart';

/// Счёт/карта пользователя (наличные, карта банка А, карта банка Б...).
/// Баланс не хранится напрямую — считается как сумма привязанных транзакций.
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get colorValue => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Ссылается на id из `BankCatalog` (core/constants/banks.dart) —
  /// необязательное, для отображения фирменного бейджа банка.
  TextColumn get bankId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
