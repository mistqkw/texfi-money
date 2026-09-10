import 'package:drift/drift.dart';

/// Транзакции дохода/расхода. Сумма всегда положительная — знак задаёт [type].
class Transactions extends Table {
  TextColumn get id => text()();
  RealColumn get amount => real()();

  /// 'income' | 'expense'.
  TextColumn get type => text()();

  /// Ссылается на `Categories.id` (без декларативного FK — см. репозитории).
  TextColumn get categoryId => text()();

  /// Ссылается на `Accounts.id` (без декларативного FK). Необязательное —
  /// старые транзакции и транзакции без выбранного счёта имеют null.
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Оценка полезности траты — «полезно», «бесполезно» или «нейтрально».
  ///
  /// Необязательное поле, и это принципиально: у большинства операций
  /// оценки нет и не будет, а пустое значение — это не «нейтрально», а
  /// «человек не оценивал». Смешать их значило бы посчитать нейтральными
  /// все старые траты разом.
  ///
  /// Проставляется только руками. Угадывать полезность по категории
  /// приложение не берётся: одна и та же доставка еды бывает и спасением
  /// вечера, и слабостью, и знает об этом только сам человек.
  TextColumn get usefulness => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
