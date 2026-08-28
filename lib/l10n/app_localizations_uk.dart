// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get navHome => 'Головна';

  @override
  String get navHistory => 'Історія';

  @override
  String get navBudgets => 'Бюджети';

  @override
  String get navGoals => 'Цілі';

  @override
  String get navStatistics => 'Статистика';

  @override
  String get dateToday => 'Сьогодні';

  @override
  String get dateYesterday => 'Вчора';

  @override
  String get commonCancel => 'Скасувати';

  @override
  String get commonDelete => 'Видалити';

  @override
  String get commonSave => 'Зберегти';

  @override
  String get commonCreate => 'Створити';

  @override
  String get commonAdd => 'Додати';

  @override
  String get commonOk => 'ОК';

  @override
  String get commonExpense => 'Витрата';

  @override
  String get commonIncome => 'Дохід';

  @override
  String get commonCategory => 'Категорія';

  @override
  String get commonColor => 'Колір';

  @override
  String get categoryGroceries => 'Продукти';

  @override
  String get categoryTransport => 'Транспорт';

  @override
  String get categoryHome => 'Житло';

  @override
  String get categoryRestaurant => 'Кафе та ресторани';

  @override
  String get categoryEntertainment => 'Розваги';

  @override
  String get categoryHealth => 'Здоров\'я';

  @override
  String get categoryClothes => 'Одяг';

  @override
  String get categoryBills => 'Рахунки';

  @override
  String get categoryOtherExpense => 'Інше';

  @override
  String get categorySalary => 'Зарплата';

  @override
  String get categoryFreelance => 'Підробіток';

  @override
  String get categoryGifts => 'Подарунки';

  @override
  String get categoryInvestments => 'Інвестиції';

  @override
  String get categoryOtherIncome => 'Інше';

  @override
  String get categoryDeleteHasTransactionsError =>
      'Не можна видалити категорію, яка має транзакції';

  @override
  String get currencyRub => 'Російський рубль';

  @override
  String get currencyUsd => 'Долар США';

  @override
  String get currencyEur => 'Євро';

  @override
  String get currencyUah => 'Українська гривня';

  @override
  String get currencyPln => 'Польський злотий';

  @override
  String get currencyByn => 'Білоруський рубль';

  @override
  String get currencyKzt => 'Казахстанський тенге';

  @override
  String get currencyGbp => 'Фунт стерлінгів';

  @override
  String get currencyCny => 'Китайський юань';

  @override
  String get currencyTry => 'Турецька ліра';

  @override
  String get appTitle => 'TexFi m0ney';

  @override
  String homeCurrencyTooltip(String name) {
    return 'Валюта: $name';
  }

  @override
  String get homeCategoriesTooltip => 'Категорії';

  @override
  String get homeSettingsTooltip => 'Налаштування';

  @override
  String get homeIncomeThisMonth => 'Дохід за місяць';

  @override
  String get homeExpenseThisMonth => 'Витрати за місяць';

  @override
  String get homeRecentTransactions => 'Останні транзакції';

  @override
  String get homeEmptyTransactions =>
      'Поки що немає транзакцій — додайте першу кнопкою «+»';

  @override
  String get homeLoadTransactionsError => 'Не вдалося завантажити транзакції';

  @override
  String get homeBalance => 'Баланс';

  @override
  String get addTxTitle => 'Нова транзакція';

  @override
  String get addTxLoadCategoriesError => 'Не вдалося завантажити категорії';

  @override
  String get addTxNoteHint => 'Нотатка (необов\'язково)';

  @override
  String get addTxAddCategory => 'Своя категорія';

  @override
  String get addTxAccountLabel => 'Рахунок';

  @override
  String get addTxNoAccount => 'Без рахунку';

  @override
  String get budgetsTitle => 'Бюджети';

  @override
  String get budgetsEmpty =>
      'Поки що немає бюджетів — встановіть місячний ліміт для категорії кнопкою «+»';

  @override
  String get budgetsLoadError => 'Не вдалося завантажити бюджети';

  @override
  String budgetsOverBy(String amount) {
    return 'Перевищено на $amount';
  }

  @override
  String get budgetsNearLimit => 'Наближається до ліміту';

  @override
  String get setBudgetTitleEdit => 'Змінити бюджет';

  @override
  String get setBudgetTitleNew => 'Новий бюджет';

  @override
  String get setBudgetLimitLabel => 'Ліміт на місяць';

  @override
  String get setBudgetNoCategoriesLeft =>
      'Для всіх категорій витрат уже задано бюджети';

  @override
  String get setBudgetLoadCategoriesError => 'Не вдалося завантажити категорії';

  @override
  String get categoriesDeleteTitle => 'Видалити категорію?';

  @override
  String categoriesDeleteConfirm(String name) {
    return 'Категорія «$name» буде видалена без можливості відновлення.';
  }

  @override
  String get categoriesTitle => 'Категорії';

  @override
  String get categoriesExpenseSection => 'Витрати';

  @override
  String get categoriesIncomeSection => 'Доходи';

  @override
  String get categoriesLoadError => 'Не вдалося завантажити категорії';

  @override
  String get categoryFormTitleNew => 'Нова категорія';

  @override
  String get categoryFormTitleEdit => 'Редагувати категорію';

  @override
  String get categoryFormNameHint => 'Назва категорії';

  @override
  String get categoryFormIconLabel => 'Іконка';

  @override
  String get goalFormNoDeadline => 'Без дедлайну';

  @override
  String get goalFormTitleEdit => 'Змінити ціль';

  @override
  String get goalFormTitleNew => 'Нова ціль';

  @override
  String get goalFormNameHint => 'Назва цілі, наприклад «ПК»';

  @override
  String get goalFormTargetLabel => 'Цільова сума';

  @override
  String get goalFormDeadlineLabel => 'Дедлайн';

  @override
  String goalsAddFundsTitle(String title) {
    return 'Поповнити «$title»';
  }

  @override
  String get goalsDeleteTitle => 'Видалити ціль?';

  @override
  String goalsDeleteConfirm(String title) {
    return 'Ціль «$title» буде видалена разом із накопиченим прогресом.';
  }

  @override
  String get goalsTitle => 'Цілі накопичень';

  @override
  String get goalsEmpty => 'Поки що немає цілей — створіть першу кнопкою «+»';

  @override
  String get goalsLoadError => 'Не вдалося завантажити цілі';

  @override
  String goalsProgressOf(String current, String target) {
    return '$current з $target';
  }

  @override
  String get goalsAchieved => 'Ціль досягнута!';

  @override
  String get goalsDeadlinePassed => 'Дедлайн минув';

  @override
  String goalsDaysLeft(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Залишилося $days дня',
      many: 'Залишилося $days днів',
      few: 'Залишилося $days дні',
      one: 'Залишився $days день',
    );
    return '$_temp0';
  }

  @override
  String get accountsTitle => 'Рахунки';

  @override
  String get accountsEmpty =>
      'Поки що немає рахунків — додайте перший кнопкою «+»';

  @override
  String get accountsLoadError => 'Не вдалося завантажити рахунки';

  @override
  String get accountsDeleteTitle => 'Видалити рахунок?';

  @override
  String accountsDeleteConfirm(String name) {
    return 'Рахунок «$name» буде видалено. Його транзакції залишаться, просто без прив\'язки.';
  }

  @override
  String get accountFormTitleNew => 'Новий рахунок';

  @override
  String get accountFormTitleEdit => 'Редагувати рахунок';

  @override
  String get accountFormNameHint => 'Назва рахунку, наприклад «Картка банку А»';

  @override
  String get profilesTitle => 'Профілі';

  @override
  String get profilesEmpty =>
      'Поки що немає профілів — обліковуйте чужі гроші кнопкою «+»';

  @override
  String get profilesLoadError => 'Не вдалося завантажити профілі';

  @override
  String get profilesDeleteTitle => 'Видалити профіль?';

  @override
  String profilesDeleteConfirm(String name) {
    return 'Профіль «$name» та його баланс будуть видалені.';
  }

  @override
  String get profileFormTitleNew => 'Новий профіль';

  @override
  String get profileFormTitleEdit => 'Редагувати профіль';

  @override
  String get profileFormNameHint => 'Ім\'я людини';

  @override
  String profilesRecordTitle(String name) {
    return 'Запис для «$name»';
  }

  @override
  String get profilesTheyBorrowed => 'Позичив(ла)';

  @override
  String get profilesTheyRepaid => 'Повернув(ла)';

  @override
  String profilesOwesYou(String amount) {
    return 'Винен(на) вам $amount';
  }

  @override
  String profilesYouOwe(String amount) {
    return 'Ви винні $amount';
  }

  @override
  String get profilesSettled => 'У розрахунку';

  @override
  String get historyAllTypes => 'Всі типи';

  @override
  String get historyAllCategories => 'Всі категорії';

  @override
  String get historyTitle => 'Історія';

  @override
  String get historyTypeFilterLabel => 'Тип';

  @override
  String get historyCategoryFilterLabel => 'Категорія';

  @override
  String get historyPeriodFilterLabel => 'Період';

  @override
  String get historyReset => 'Скинути';

  @override
  String get historyEmpty => 'Нічого не знайдено';

  @override
  String get historyLoadError => 'Не вдалося завантажити історію';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsThemeSection => 'Тема';

  @override
  String get settingsFontSection => 'Шрифт';

  @override
  String get settingsCurrencySection => 'Валюта';

  @override
  String get settingsLanguageSection => 'Мова';

  @override
  String get settingsManageSection => 'Керування';

  @override
  String get settingsBackupSection => 'Резервна копія';

  @override
  String get backupExport => 'Експортувати дані';

  @override
  String get backupImport => 'Імпортувати дані';

  @override
  String get backupImportConfirmTitle => 'Замінити всі дані?';

  @override
  String get backupImportConfirmBody =>
      'Імпорт резервної копії замінить усе, що зараз є на пристрої — транзакції, категорії, рахунки, профілі, бюджети та цілі. Це не можна скасувати.';

  @override
  String get backupImportConfirmAction => 'Замінити';

  @override
  String get backupImportSuccess => 'Дані відновлено з резервної копії';

  @override
  String get backupImportError =>
      'Цей файл не є коректною резервною копією TexFi m0ney';

  @override
  String get settingsDangerSection => 'Небезпечна зона';

  @override
  String get resetApp => 'Скинути застосунок';

  @override
  String get resetAppConfirmTitle => 'Скинути застосунок?';

  @override
  String get resetAppConfirmBody =>
      'Усе буде видалено без можливості відновлення: транзакції, категорії, рахунки, профілі, бюджети, цілі та всі налаштування. Застосунок перезапуститься як після першого встановлення. Це не можна скасувати.';

  @override
  String get resetAppConfirmAction => 'Скинути';

  @override
  String get themeDark => 'Темна';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeOled => 'Чорна (OLED)';

  @override
  String get fontSystem => 'Системний';

  @override
  String get languageSystem => 'Системна';

  @override
  String get currencyPickerTitle => 'Валюта';

  @override
  String get languagePickerTitle => 'Мова';

  @override
  String get statisticsTitle => 'Статистика';

  @override
  String get statisticsMonthlyChartTitle => 'Доходи та витрати за місяцями';

  @override
  String get statisticsLoadError => 'Не вдалося завантажити дані';

  @override
  String get statisticsCategoryChartTitle =>
      'Витрати за категоріями цього місяця';

  @override
  String get statisticsNoExpenses => 'Немає витрат цього місяця';

  @override
  String get quickEntryLabel => 'швидке додавання';

  @override
  String get quickEntryHint => '-350 продукти обід';

  @override
  String get quickEntryHelp =>
      'Знак, сума, категорія, нотатка — наприклад «-350 продукти обід» або «+5000 зарплата»';

  @override
  String get quickEntryParseError =>
      'Не розпізнано. Почніть з + або -, потім сума.';

  @override
  String get onboardingSlide1Title => 'Все під контролем';

  @override
  String get onboardingSlide1Body =>
      'Баланс, доходи та витрати за місяць — на одному екрані.';

  @override
  String get onboardingSlide2Title => 'Бюджети та цілі';

  @override
  String get onboardingSlide2Body =>
      'Встановлюйте місячні ліміти для категорій і накопичуйте на важливе — з наочним прогрес-баром.';

  @override
  String get onboardingSlide3Title => '❯ Швидке додавання';

  @override
  String get onboardingSlide3Body =>
      'Один рядок — «-350 продукти обід» — і транзакція готова. Швидше, ніж через меню.';

  @override
  String get onboardingSlide4Title => 'Приватно й офлайн';

  @override
  String get onboardingSlide4Body =>
      'Усі дані залишаються на пристрої. Без акаунта, хмари й реклами.';

  @override
  String get onboardingCurrencyStepTitle => 'Виберіть валюту';

  @override
  String get onboardingThemeStepTitle => 'Виберіть оформлення';

  @override
  String get onboardingNext => 'Далі';

  @override
  String get onboardingStart => 'Почати';

  @override
  String get onboardingSkip => 'Пропустити';
}
