// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get navHome => 'Главная';

  @override
  String get navHistory => 'История';

  @override
  String get navBudgets => 'Бюджеты';

  @override
  String get navGoals => 'Цели';

  @override
  String get navStatistics => 'Статистика';

  @override
  String get dateToday => 'Сегодня';

  @override
  String get dateYesterday => 'Вчера';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonDelete => 'Удалить';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonCreate => 'Создать';

  @override
  String get commonAdd => 'Добавить';

  @override
  String get commonExpense => 'Расход';

  @override
  String get commonIncome => 'Доход';

  @override
  String get commonCategory => 'Категория';

  @override
  String get commonColor => 'Цвет';

  @override
  String get categoryGroceries => 'Продукты';

  @override
  String get categoryTransport => 'Транспорт';

  @override
  String get categoryHome => 'Жильё';

  @override
  String get categoryRestaurant => 'Кафе и рестораны';

  @override
  String get categoryEntertainment => 'Развлечения';

  @override
  String get categoryHealth => 'Здоровье';

  @override
  String get categoryClothes => 'Одежда';

  @override
  String get categoryBills => 'Счета';

  @override
  String get categoryOtherExpense => 'Прочее';

  @override
  String get categorySalary => 'Зарплата';

  @override
  String get categoryFreelance => 'Подработка';

  @override
  String get categoryGifts => 'Подарки';

  @override
  String get categoryInvestments => 'Инвестиции';

  @override
  String get categoryOtherIncome => 'Прочее';

  @override
  String get categoryDeleteHasTransactionsError =>
      'Нельзя удалить категорию, у которой есть транзакции';

  @override
  String get currencyRub => 'Российский рубль';

  @override
  String get currencyUsd => 'Доллар США';

  @override
  String get currencyEur => 'Евро';

  @override
  String get currencyUah => 'Украинская гривна';

  @override
  String get currencyPln => 'Польский злотый';

  @override
  String get currencyByn => 'Белорусский рубль';

  @override
  String get currencyKzt => 'Казахстанский тенге';

  @override
  String get currencyGbp => 'Фунт стерлингов';

  @override
  String get currencyCny => 'Китайский юань';

  @override
  String get currencyTry => 'Турецкая лира';

  @override
  String get appTitle => 'TexFi m0ney';

  @override
  String homeCurrencyTooltip(String name) {
    return 'Валюта: $name';
  }

  @override
  String get homeCategoriesTooltip => 'Категории';

  @override
  String get homeSettingsTooltip => 'Настройки';

  @override
  String get homeIncomeThisMonth => 'Доход за месяц';

  @override
  String get homeExpenseThisMonth => 'Расход за месяц';

  @override
  String get homeRecentTransactions => 'Последние транзакции';

  @override
  String get homeEmptyTransactions =>
      'Пока нет транзакций — добавьте первую кнопкой «+»';

  @override
  String get homeLoadTransactionsError => 'Не удалось загрузить транзакции';

  @override
  String get homeBalance => 'Баланс';

  @override
  String get addTxTitle => 'Новая транзакция';

  @override
  String get addTxLoadCategoriesError => 'Не удалось загрузить категории';

  @override
  String get addTxNoteHint => 'Заметка (необязательно)';

  @override
  String get addTxAddCategory => 'Своя категория';

  @override
  String get budgetsTitle => 'Бюджеты';

  @override
  String get budgetsEmpty =>
      'Пока нет бюджетов — задайте месячный лимит по категории кнопкой «+»';

  @override
  String get budgetsLoadError => 'Не удалось загрузить бюджеты';

  @override
  String budgetsOverBy(String amount) {
    return 'Превышен на $amount';
  }

  @override
  String get budgetsNearLimit => 'Приближается к лимиту';

  @override
  String get setBudgetTitleEdit => 'Изменить бюджет';

  @override
  String get setBudgetTitleNew => 'Новый бюджет';

  @override
  String get setBudgetLimitLabel => 'Лимит в месяц';

  @override
  String get setBudgetNoCategoriesLeft =>
      'Для всех категорий расходов уже заданы бюджеты';

  @override
  String get setBudgetLoadCategoriesError => 'Не удалось загрузить категории';

  @override
  String get categoriesDeleteTitle => 'Удалить категорию?';

  @override
  String categoriesDeleteConfirm(String name) {
    return 'Категория «$name» будет удалена без возможности восстановления.';
  }

  @override
  String get categoriesTitle => 'Категории';

  @override
  String get categoriesExpenseSection => 'Расходы';

  @override
  String get categoriesIncomeSection => 'Доходы';

  @override
  String get categoriesLoadError => 'Не удалось загрузить категории';

  @override
  String get categoryFormTitleNew => 'Новая категория';

  @override
  String get categoryFormTitleEdit => 'Редактировать категорию';

  @override
  String get categoryFormNameHint => 'Название категории';

  @override
  String get categoryFormIconLabel => 'Иконка';

  @override
  String get goalFormNoDeadline => 'Без дедлайна';

  @override
  String get goalFormTitleEdit => 'Изменить цель';

  @override
  String get goalFormTitleNew => 'Новая цель';

  @override
  String get goalFormNameHint => 'Название цели, например «ПК»';

  @override
  String get goalFormTargetLabel => 'Целевая сумма';

  @override
  String get goalFormDeadlineLabel => 'Дедлайн';

  @override
  String goalsAddFundsTitle(String title) {
    return 'Пополнить «$title»';
  }

  @override
  String get goalsDeleteTitle => 'Удалить цель?';

  @override
  String goalsDeleteConfirm(String title) {
    return 'Цель «$title» будет удалена вместе с накопленным прогрессом.';
  }

  @override
  String get goalsTitle => 'Цели накоплений';

  @override
  String get goalsEmpty => 'Пока нет целей — создайте первую кнопкой «+»';

  @override
  String get goalsLoadError => 'Не удалось загрузить цели';

  @override
  String goalsProgressOf(String current, String target) {
    return '$current из $target';
  }

  @override
  String get goalsAchieved => 'Цель достигнута!';

  @override
  String get goalsDeadlinePassed => 'Дедлайн прошёл';

  @override
  String goalsDaysLeft(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Осталось $days дня',
      many: 'Осталось $days дней',
      few: 'Осталось $days дня',
      one: 'Осталось $days день',
    );
    return '$_temp0';
  }

  @override
  String get historyAllTypes => 'Все типы';

  @override
  String get historyAllCategories => 'Все категории';

  @override
  String get historyTitle => 'История';

  @override
  String get historyTypeFilterLabel => 'Тип';

  @override
  String get historyCategoryFilterLabel => 'Категория';

  @override
  String get historyPeriodFilterLabel => 'Период';

  @override
  String get historyReset => 'Сбросить';

  @override
  String get historyEmpty => 'Ничего не найдено';

  @override
  String get historyLoadError => 'Не удалось загрузить историю';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsThemeSection => 'Тема';

  @override
  String get settingsFontSection => 'Шрифт';

  @override
  String get settingsCurrencySection => 'Валюта';

  @override
  String get settingsLanguageSection => 'Язык';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeOled => 'Чёрная (OLED)';

  @override
  String get fontSystem => 'Системный';

  @override
  String get languageSystem => 'Системный';

  @override
  String get currencyPickerTitle => 'Валюта';

  @override
  String get languagePickerTitle => 'Язык';

  @override
  String get statisticsTitle => 'Статистика';

  @override
  String get statisticsMonthlyChartTitle => 'Доходы и расходы по месяцам';

  @override
  String get statisticsLoadError => 'Не удалось загрузить данные';

  @override
  String get statisticsCategoryChartTitle =>
      'Расходы по категориям в этом месяце';

  @override
  String get statisticsNoExpenses => 'Нет расходов в этом месяце';
}
