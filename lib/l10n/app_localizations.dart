import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
    Locale('ru'),
    Locale('uk'),
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navBudgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get navBudgets;

  /// No description provided for @navGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get navGoals;

  /// No description provided for @navStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get navStatistics;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get commonCreate;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get commonExpense;

  /// No description provided for @commonIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get commonIncome;

  /// No description provided for @commonCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get commonCategory;

  /// No description provided for @commonColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get commonColor;

  /// No description provided for @categoryGroceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get categoryGroceries;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryHome.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get categoryHome;

  /// No description provided for @categoryRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Cafes & restaurants'**
  String get categoryRestaurant;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryClothes.
  ///
  /// In en, this message translates to:
  /// **'Clothes'**
  String get categoryClothes;

  /// No description provided for @categoryBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get categoryBills;

  /// No description provided for @categoryOtherExpense.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOtherExpense;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categoryFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get categoryFreelance;

  /// No description provided for @categoryGifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get categoryGifts;

  /// No description provided for @categoryInvestments.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get categoryInvestments;

  /// No description provided for @categoryOtherIncome.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOtherIncome;

  /// No description provided for @categoryDeleteHasTransactionsError.
  ///
  /// In en, this message translates to:
  /// **'Can\'t delete a category that has transactions'**
  String get categoryDeleteHasTransactionsError;

  /// No description provided for @currencyRub.
  ///
  /// In en, this message translates to:
  /// **'Russian ruble'**
  String get currencyRub;

  /// No description provided for @currencyUsd.
  ///
  /// In en, this message translates to:
  /// **'US dollar'**
  String get currencyUsd;

  /// No description provided for @currencyEur.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get currencyEur;

  /// No description provided for @currencyUah.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian hryvnia'**
  String get currencyUah;

  /// No description provided for @currencyPln.
  ///
  /// In en, this message translates to:
  /// **'Polish zloty'**
  String get currencyPln;

  /// No description provided for @currencyByn.
  ///
  /// In en, this message translates to:
  /// **'Belarusian ruble'**
  String get currencyByn;

  /// No description provided for @currencyKzt.
  ///
  /// In en, this message translates to:
  /// **'Kazakhstani tenge'**
  String get currencyKzt;

  /// No description provided for @currencyGbp.
  ///
  /// In en, this message translates to:
  /// **'British pound'**
  String get currencyGbp;

  /// No description provided for @currencyCny.
  ///
  /// In en, this message translates to:
  /// **'Chinese yuan'**
  String get currencyCny;

  /// No description provided for @currencyTry.
  ///
  /// In en, this message translates to:
  /// **'Turkish lira'**
  String get currencyTry;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TexFi m0ney'**
  String get appTitle;

  /// No description provided for @homeCurrencyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Currency: {name}'**
  String homeCurrencyTooltip(String name);

  /// No description provided for @homeCategoriesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get homeCategoriesTooltip;

  /// No description provided for @homeSettingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettingsTooltip;

  /// No description provided for @homeIncomeThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Income this month'**
  String get homeIncomeThisMonth;

  /// No description provided for @homeExpenseThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Expense this month'**
  String get homeExpenseThisMonth;

  /// No description provided for @homeRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get homeRecentTransactions;

  /// No description provided for @homeEmptyTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet — add your first with the “+” button'**
  String get homeEmptyTransactions;

  /// No description provided for @homeLoadTransactionsError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load transactions'**
  String get homeLoadTransactionsError;

  /// No description provided for @homeBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get homeBalance;

  /// No description provided for @addTxTitle.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get addTxTitle;

  /// No description provided for @addTxLoadCategoriesError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load categories'**
  String get addTxLoadCategoriesError;

  /// No description provided for @addTxNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get addTxNoteHint;

  /// No description provided for @addTxAddCategory.
  ///
  /// In en, this message translates to:
  /// **'Custom category'**
  String get addTxAddCategory;

  /// No description provided for @budgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgetsTitle;

  /// No description provided for @budgetsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No budgets yet — set a monthly limit for a category with the “+” button'**
  String get budgetsEmpty;

  /// No description provided for @budgetsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load budgets'**
  String get budgetsLoadError;

  /// No description provided for @budgetsOverBy.
  ///
  /// In en, this message translates to:
  /// **'Over by {amount}'**
  String budgetsOverBy(String amount);

  /// No description provided for @budgetsNearLimit.
  ///
  /// In en, this message translates to:
  /// **'Approaching the limit'**
  String get budgetsNearLimit;

  /// No description provided for @setBudgetTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get setBudgetTitleEdit;

  /// No description provided for @setBudgetTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New budget'**
  String get setBudgetTitleNew;

  /// No description provided for @setBudgetLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly limit'**
  String get setBudgetLimitLabel;

  /// No description provided for @setBudgetNoCategoriesLeft.
  ///
  /// In en, this message translates to:
  /// **'All expense categories already have a budget'**
  String get setBudgetNoCategoriesLeft;

  /// No description provided for @setBudgetLoadCategoriesError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load categories'**
  String get setBudgetLoadCategoriesError;

  /// No description provided for @categoriesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete category?'**
  String get categoriesDeleteTitle;

  /// No description provided for @categoriesDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Category “{name}” will be deleted permanently.'**
  String categoriesDeleteConfirm(String name);

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @categoriesExpenseSection.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get categoriesExpenseSection;

  /// No description provided for @categoriesIncomeSection.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get categoriesIncomeSection;

  /// No description provided for @categoriesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load categories'**
  String get categoriesLoadError;

  /// No description provided for @categoryFormTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get categoryFormTitleNew;

  /// No description provided for @categoryFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get categoryFormTitleEdit;

  /// No description provided for @categoryFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryFormNameHint;

  /// No description provided for @categoryFormIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get categoryFormIconLabel;

  /// No description provided for @goalFormNoDeadline.
  ///
  /// In en, this message translates to:
  /// **'No deadline'**
  String get goalFormNoDeadline;

  /// No description provided for @goalFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit goal'**
  String get goalFormTitleEdit;

  /// No description provided for @goalFormTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get goalFormTitleNew;

  /// No description provided for @goalFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'Goal name, e.g. “New PC”'**
  String get goalFormNameHint;

  /// No description provided for @goalFormTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get goalFormTargetLabel;

  /// No description provided for @goalFormDeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get goalFormDeadlineLabel;

  /// No description provided for @goalsAddFundsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to “{title}”'**
  String goalsAddFundsTitle(String title);

  /// No description provided for @goalsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete goal?'**
  String get goalsDeleteTitle;

  /// No description provided for @goalsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Goal “{title}” and its saved progress will be deleted.'**
  String goalsDeleteConfirm(String title);

  /// No description provided for @goalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings goals'**
  String get goalsTitle;

  /// No description provided for @goalsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No goals yet — create your first with the “+” button'**
  String get goalsEmpty;

  /// No description provided for @goalsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load goals'**
  String get goalsLoadError;

  /// No description provided for @goalsProgressOf.
  ///
  /// In en, this message translates to:
  /// **'{current} of {target}'**
  String goalsProgressOf(String current, String target);

  /// No description provided for @goalsAchieved.
  ///
  /// In en, this message translates to:
  /// **'Goal achieved!'**
  String get goalsAchieved;

  /// No description provided for @goalsDeadlinePassed.
  ///
  /// In en, this message translates to:
  /// **'Deadline passed'**
  String get goalsDeadlinePassed;

  /// No description provided for @goalsDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one {{days} day left} other {{days} days left}}'**
  String goalsDaysLeft(num days);

  /// No description provided for @historyAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get historyAllTypes;

  /// No description provided for @historyAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get historyAllCategories;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyTypeFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get historyTypeFilterLabel;

  /// No description provided for @historyCategoryFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get historyCategoryFilterLabel;

  /// No description provided for @historyPeriodFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get historyPeriodFilterLabel;

  /// No description provided for @historyReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get historyReset;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get historyEmpty;

  /// No description provided for @historyLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load history'**
  String get historyLoadError;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsThemeSection.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeSection;

  /// No description provided for @settingsFontSection.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get settingsFontSection;

  /// No description provided for @settingsCurrencySection.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrencySection;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeOled.
  ///
  /// In en, this message translates to:
  /// **'Black (OLED)'**
  String get themeOled;

  /// No description provided for @fontSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get fontSystem;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @currencyPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyPickerTitle;

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languagePickerTitle;

  /// No description provided for @statisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTitle;

  /// No description provided for @statisticsMonthlyChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Income and expense by month'**
  String get statisticsMonthlyChartTitle;

  /// No description provided for @statisticsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load data'**
  String get statisticsLoadError;

  /// No description provided for @statisticsCategoryChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses by category this month'**
  String get statisticsCategoryChartTitle;

  /// No description provided for @statisticsNoExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses this month'**
  String get statisticsNoExpenses;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
