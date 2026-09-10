import 'package:drift/drift.dart';

/// Категории активов — для распределения капитала.
///
/// Отдельная таблица, а не переиспользование [Categories], намеренно.
/// Категории транзакций отвечают на вопрос «на что ушли деньги», категории
/// активов — «в чём лежит капитал», и пересечение у них случайное:
/// «Транспорт» как статья расходов и «Транспорт» как машина в собственности
/// — разные вещи, которые в одном списке сложились бы в одну строку и
/// испортили обе картины.
class AssetCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  /// Ключ пиксельной иконки. Тот же каталог, что у категорий транзакций:
  /// набор иконок в приложении один.
  TextColumn get iconKey => text()();

  IntColumn get colorValue => integer()();

  /// Заведена пользователем, а не поставляется по умолчанию. Встроенные
  /// удалять нельзя — на них может ссылаться уже созданный актив.
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
