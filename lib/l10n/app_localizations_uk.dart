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
  String get homeRecentShort => 'Останні';

  @override
  String get homeFactIncome => 'Дохід';

  @override
  String get homeFactExpense => 'Витрати';

  @override
  String get homeFactSaved => 'Заощаджено';

  @override
  String get homeEmptyTransactions =>
      'Тут поки порожньо. Перший запис займе секунд десять.';

  @override
  String get homeLoadTransactionsError => 'Не вдалося завантажити транзакції';

  @override
  String get homeBalance => 'Баланс';

  @override
  String get addTxAmountLabel => 'Сума';

  @override
  String get addTxTitle => 'Нова транзакція';

  @override
  String get addTxTitleEdit => 'Змінити транзакцію';

  @override
  String get txActionRepeat => 'Повторити сьогодні';

  @override
  String get txActionEdit => 'Змінити';

  @override
  String nudgeUnusualAmount(String times, String category) {
    return 'Це у $times× більше за звичне в «$category». Сума правильна?';
  }

  @override
  String nudgeBudgetClose(String category, String percent) {
    return 'Бюджет «$category» витрачено на $percent%';
  }

  @override
  String nudgeBudgetOver(String category, String amount) {
    return '«$category» перевищує бюджет на $amount';
  }

  @override
  String nudgeQuietDays(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Немає записів уже $days дня — внести?',
      many: 'Немає записів уже $days днів — внести?',
      few: 'Немає записів уже $days дні — внести?',
      one: 'Немає записів уже $days день — внести?',
    );
    return '$_temp0';
  }

  @override
  String nudgeGoalClose(String title, String percent) {
    return '«$title» зібрано на $percent% — майже ціль';
  }

  @override
  String get nudgeDismiss => 'Сховати';

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
      'Бюджетів поки немає. Задайте місячний ліміт на категорію — і стане видно, коли ви до нього підходите.';

  @override
  String get budgetsLoadError => 'Не вдалося завантажити бюджети';

  @override
  String budgetsLeft(String amount) {
    return 'Залишилось $amount';
  }

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
  String get goalsEmpty =>
      'Цілей поки немає. Відкладати простіше, коли в суми є ім’я.';

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
      'Рахунків поки немає. Заведіть ті, де насправді лежать гроші, — картку, готівку, скарбничку.';

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
  String get accountFormBankLabel => 'Банк';

  @override
  String get accountFormNoBank => 'Без банку';

  @override
  String get profilesTitle => 'Профілі';

  @override
  String get profilesEmpty =>
      'Профілів поки немає. Сюди йдуть чужі гроші: борги, спільний рахунок, чийсь бюджет у ваших руках.';

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
  String get settingsHapticsSection => 'Вібрація';

  @override
  String get hapticsEnabled => 'Тактильний відгук';

  @override
  String get settingsCurrencySection => 'Валюта';

  @override
  String get settingsLanguageSection => 'Мова';

  @override
  String get settingsManageSection => 'Керування';

  @override
  String get settingsBackupSection => 'Резервна копія';

  @override
  String get settingsSecuritySection => 'Безпека';

  @override
  String get securityAppLock => 'Блокувати застосунок';

  @override
  String get securityAppLockDesc =>
      'Запитує замок пристрою — відбиток, обличчя або код — під час відкриття і після того, як застосунок побув у фоні.';

  @override
  String get securityAppLockUnavailable =>
      'На пристрої не налаштовано замок. Спершу створіть його в системних налаштуваннях.';

  @override
  String get securityHideInSwitcher => 'Ховати в перемикачі задач';

  @override
  String get securityHideInSwitcherDesc =>
      'Замінює прев\'ю у списку недавніх застосунків порожнім екраном, щоб баланс не було видно. Заразом забороняє знімки екрана.';

  @override
  String get securityUnlockReason =>
      'Підтвердьте, що це ви, щоб відкрити TexFi m0ney';

  @override
  String get securityLockedTitle => 'Заблоковано';

  @override
  String get securityLockedBody =>
      'Гроші залишаються на цьому пристрої. Підтвердьте, що це ви.';

  @override
  String get securityUnlock => 'Розблокувати';

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
  String get onboardingBankStepTitle => 'Додайте свій банк (необов\'язково)';

  @override
  String get onboardingNext => 'Далі';

  @override
  String get onboardingStart => 'Почати';

  @override
  String get onboardingSkip => 'Пропустити';

  @override
  String get navWealth => 'Капітал';

  @override
  String get wealthTitle => 'Капітал';

  @override
  String get wealthTotal => 'Капітал';

  @override
  String get wealthAssets => 'Активи';

  @override
  String get wealthLiabilities => 'Пасиви';

  @override
  String get wealthEmptyTitle => 'Поки порожньо';

  @override
  String get wealthEmptyBody =>
      'Додайте те, чим володієте, і те, що винні. Вартість ставите ви самі і самі її оновлюєте — нічого нікуди не підтягується.';

  @override
  String get wealthAddAsset => 'Додати актив';

  @override
  String get wealthYearChange => 'За останній рік';

  @override
  String get wealthYearChangeNoBase =>
      'Даних річної давнини поки немає — порівнювати нема з чим.';

  @override
  String get wealthByCategory => 'У чому лежить';

  @override
  String get wealthByCashFlow => 'Що робить';

  @override
  String get wealthByRisk => 'Наскільки ризиковано';

  @override
  String get wealthAssetsList => 'Активи';

  @override
  String get wealthOffline =>
      'Усі цифри тут — ті, що ввели ви. Застосунок нікуди не ходить за курсами й котируваннями.';

  @override
  String get flowIncome => 'Приносить гроші';

  @override
  String get flowLiability => 'Забирає гроші';

  @override
  String get flowNeutral => 'Ні те ні інше';

  @override
  String get assetName => 'Назва';

  @override
  String get assetValue => 'Поточна вартість';

  @override
  String get assetCategory => 'Категорія';

  @override
  String get assetRisk => 'Рівень ризику';

  @override
  String get assetFlow => 'Грошовий потік';

  @override
  String get assetNote => 'Нотатка';

  @override
  String get assetValuedAt => 'Вартість на дату';

  @override
  String get assetNew => 'Новий актив';

  @override
  String get assetEdit => 'Редагування активу';

  @override
  String get assetRevalue => 'Оновити вартість';

  @override
  String get assetRevalueTitle => 'Нова вартість';

  @override
  String get assetHistory => 'Історія вартості';

  @override
  String get assetHistoryHint =>
      'Кожне оновлення додає точку, а не замінює попередню — з них і рахується зміна за рік.';

  @override
  String get assetDelete => 'Видалити актив';

  @override
  String get assetDeleteBody =>
      'Актив і вся історія його вартості зникнуть. Скасувати це не можна.';

  @override
  String get riskSection => 'Ризик-менеджмент';

  @override
  String riskLimitLabel(String level) {
    return 'Ліміт для «$level»';
  }

  @override
  String get riskNoLimit => 'без ліміту';

  @override
  String get riskLimitHint =>
      'Частка капіталу, яку ви згодні тримати на цьому рівні ризику. Вирішуєте ви: у застосунку немає думки про те, що безпечно.';

  @override
  String get riskBreachTitle => 'Вище вашого ліміту';

  @override
  String riskBreachBody(String level, String actual, String limit) {
    return '«$level»: $actual% капіталу за заданого ліміту $limit%.';
  }

  @override
  String get riskAddLevel => 'Додати рівень';

  @override
  String get riskLevelName => 'Назва рівня';

  @override
  String get riskLevelInUse =>
      'На цьому рівні є активи — спершу перенесіть їх.';

  @override
  String get riskLastLevel => 'Останній рівень видалити не можна.';

  @override
  String get usefulnessLabel => 'Було того варте?';

  @override
  String get usefulnessUseful => 'Варте';

  @override
  String get usefulnessUseless => 'Не варте';

  @override
  String get usefulnessNeutral => 'Ні те ні інше';

  @override
  String get usefulnessNotRated => 'Без оцінки';

  @override
  String get usefulnessSection => 'Варте чи ні';

  @override
  String get usefulnessHint =>
      'Тільки те, що ви позначили самі. Застосунок не вгадує: одна й та сама доставка буває і порятунком вечора, і слабкістю, і знаєте про це тільки ви.';

  @override
  String get subscriptionsTitle => 'Підписки';

  @override
  String get subscriptionsMonthly => 'На місяць';

  @override
  String get subscriptionsMonthlyHint =>
      'Річні показані місячною часткою, щоб сума означала те саме в будь-якому місяці.';

  @override
  String get subscriptionsEmpty =>
      'Підписок поки немає. Додайте ті, що продовжуються самі.';

  @override
  String get subscriptionsAdd => 'Додати підписку';

  @override
  String get subscriptionNew => 'Нова підписка';

  @override
  String get subscriptionEdit => 'Редагування підписки';

  @override
  String get subscriptionName => 'Назва';

  @override
  String get subscriptionAmount => 'Сума';

  @override
  String get subscriptionPeriod => 'Продовжується';

  @override
  String get subscriptionNextCharge => 'Наступне списання';

  @override
  String get subscriptionCustomDays => 'Раз на N днів';

  @override
  String get subscriptionActive => 'Активна';

  @override
  String get subscriptionCancelled => 'Скасована';

  @override
  String get periodMonthly => 'Щомісяця';

  @override
  String get periodYearly => 'Щороку';

  @override
  String get periodCustom => 'Свій період';

  @override
  String get chargeToday => 'сьогодні';

  @override
  String get chargeTomorrow => 'завтра';

  @override
  String chargeInDays(int days) {
    return 'через $days дн.';
  }

  @override
  String get chargeOverdue => 'термін минув';

  @override
  String get savingsRateTitle => 'Відсоток заощаджень';

  @override
  String get savingsRateHint =>
      'Стільки лишилося від усього, що прийшло за місяць. Що більша частка, то більше доходу лишилося вашим.';

  @override
  String get savingsRateNoIncome =>
      'Цього місяця доходу не було — частку рахувати нема від чого.';

  @override
  String get savingsRateHistory => 'За місяцями';

  @override
  String get cashFlowTitle => 'Рух грошей';

  @override
  String get cashFlowReceived => 'Надійшло';

  @override
  String get cashFlowSpent => 'Пішло';

  @override
  String get cashFlowSaved => 'Лишилося';

  @override
  String get reportsTitle => 'Звіти';

  @override
  String get reportsCategory => 'Категорія';

  @override
  String get reportsAllCategories => 'Усі категорії';

  @override
  String get reportsPeriod => 'Період';

  @override
  String get reportsGroupByMonth => 'За місяцями';

  @override
  String get reportsGroupByYear => 'За роками';

  @override
  String get reportsEmpty => 'Під ці умови нічого не потрапило.';

  @override
  String get reportsTotal => 'Разом';

  @override
  String get adviceSection => 'На що подивитися';

  @override
  String adviceRisk(String level, String percent, String limit) {
    return 'На рівні «$level» — $percent% капіталу за вашого ліміту $limit%. Можливо, варто переглянути розподіл.';
  }

  @override
  String adviceUseless(String percent) {
    return 'Витрати, які ви позначили як «не варте», зросли на $percent% проти минулого місяця.';
  }

  @override
  String adviceSubscriptions(String percent) {
    return 'Підписки коштують на $percent% більше, ніж місяць тому — варто перевірити, чи всі ще потрібні.';
  }

  @override
  String adviceSavings(String percent, String limit) {
    return 'Цього місяця лишилося $percent% проти звичних $limit%.';
  }

  @override
  String get adviceEmpty =>
      'На тлі ваших же чисел зараз нічого не вирізняється.';

  @override
  String get adviceDisclaimer =>
      'Усе це — порівняння ваших чисел з вашими ж лімітами та історією. Жодних ринкових даних і жодної оцінки того, чим ви володієте.';

  @override
  String get analysisRangeTitle => 'Діапазон аналізу';

  @override
  String get analysisRangeHint =>
      'Наскільки далеко назад дивляться всі графіки історії — капітал, рух грошей, відсоток заощаджень.';

  @override
  String analysisRangeYears(int years) {
    return 'Останні $years років';
  }

  @override
  String get analysisRangeCustom => 'Задати дати';

  @override
  String get assetCategoriesTitle => 'Категорії активів';

  @override
  String get aboutTitle => 'Про застосунок';

  @override
  String get aboutSectionApp => 'Застосунок';

  @override
  String get aboutSectionOpen => 'Відкритий код';

  @override
  String get aboutSectionSupport => 'Підтримати';

  @override
  String get aboutVersionLabel => 'Версія';

  @override
  String get aboutBuildLabel => 'Збірка';

  @override
  String get aboutTagline => 'Особисті фінанси, які нікуди не йдуть';

  @override
  String get aboutBlurb =>
      'Усе лежить у базі на цьому пристрої. Ні аналітики, ні рекламних ідентифікаторів, ні фонових «подій» — перевіряється за вихідним кодом.';

  @override
  String get aboutFactOffline => 'ОФЛАЙН';

  @override
  String get aboutFactTelemetry => 'ТЕЛЕМЕТРІЇ';

  @override
  String get aboutFactLicense => 'ЛІЦЕНЗІЯ';

  @override
  String get aboutSourceTitle => 'Вихідний код на GitHub';

  @override
  String get aboutLicenseTitle => 'Ліцензія GNU AGPL v3';

  @override
  String get aboutLicenseText =>
      'Хто випустить змінену версію — мусить відкрити свої правки.';

  @override
  String get aboutEcosystemTitle => 'Уся екосистема TexFi';

  @override
  String get aboutDonateTitle => 'Закинути на каву';

  @override
  String get aboutDonateText =>
      'TexFi робить одна людина, і всі застосунки безкоштовні. Платних функцій немає і не буде.';

  @override
  String get aboutLinkFailed => 'Немає чим відкрити це посилання';

  @override
  String get navPlan => 'План';

  @override
  String get navSummary => 'Підсумки';
}
