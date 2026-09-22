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

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

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
  /// **'Nothing here yet. The first entry takes about ten seconds.'**
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

  /// No description provided for @addTxTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get addTxTitleEdit;

  /// No description provided for @txActionRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat today'**
  String get txActionRepeat;

  /// No description provided for @txActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get txActionEdit;

  /// No description provided for @nudgeUnusualAmount.
  ///
  /// In en, this message translates to:
  /// **'That\'s {times}× your usual {category}. Amount right?'**
  String nudgeUnusualAmount(String times, String category);

  /// No description provided for @nudgeBudgetClose.
  ///
  /// In en, this message translates to:
  /// **'{category} budget is {percent}% spent'**
  String nudgeBudgetClose(String category, String percent);

  /// No description provided for @nudgeBudgetOver.
  ///
  /// In en, this message translates to:
  /// **'{category} is over budget by {amount}'**
  String nudgeBudgetOver(String category, String amount);

  /// No description provided for @nudgeQuietDays.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged in {days} days — catch up?'**
  String nudgeQuietDays(num days);

  /// No description provided for @nudgeGoalClose.
  ///
  /// In en, this message translates to:
  /// **'“{title}” is {percent}% funded — nearly there'**
  String nudgeGoalClose(String title, String percent);

  /// No description provided for @nudgeDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get nudgeDismiss;

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

  /// No description provided for @addTxAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get addTxAccountLabel;

  /// No description provided for @addTxNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account'**
  String get addTxNoAccount;

  /// No description provided for @budgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgetsTitle;

  /// No description provided for @budgetsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No budgets yet. Set a monthly cap on a category and you will see yourself approaching it.'**
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
  /// **'No goals yet. Saving is easier when the amount has a name.'**
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

  /// No description provided for @accountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accountsTitle;

  /// No description provided for @accountsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet. Add the ones where the money actually sits — a card, cash, a jar.'**
  String get accountsEmpty;

  /// No description provided for @accountsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load accounts'**
  String get accountsLoadError;

  /// No description provided for @accountsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get accountsDeleteTitle;

  /// No description provided for @accountsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Account “{name}” will be deleted. Its transactions stay, just unassigned.'**
  String accountsDeleteConfirm(String name);

  /// No description provided for @accountFormTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get accountFormTitleNew;

  /// No description provided for @accountFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get accountFormTitleEdit;

  /// No description provided for @accountFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'Account name, e.g. “Bank A card”'**
  String get accountFormNameHint;

  /// No description provided for @accountFormBankLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get accountFormBankLabel;

  /// No description provided for @accountFormNoBank.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get accountFormNoBank;

  /// No description provided for @profilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profilesTitle;

  /// No description provided for @profilesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No profiles yet. This is for other people’s money: debts, a shared account, someone’s budget in your hands.'**
  String get profilesEmpty;

  /// No description provided for @profilesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load profiles'**
  String get profilesLoadError;

  /// No description provided for @profilesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete profile?'**
  String get profilesDeleteTitle;

  /// No description provided for @profilesDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Profile “{name}” and its balance will be deleted.'**
  String profilesDeleteConfirm(String name);

  /// No description provided for @profileFormTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New profile'**
  String get profileFormTitleNew;

  /// No description provided for @profileFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileFormTitleEdit;

  /// No description provided for @profileFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'Person\'s name'**
  String get profileFormNameHint;

  /// No description provided for @profilesRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Record for “{name}”'**
  String profilesRecordTitle(String name);

  /// No description provided for @profilesTheyBorrowed.
  ///
  /// In en, this message translates to:
  /// **'They borrowed'**
  String get profilesTheyBorrowed;

  /// No description provided for @profilesTheyRepaid.
  ///
  /// In en, this message translates to:
  /// **'They repaid'**
  String get profilesTheyRepaid;

  /// No description provided for @profilesOwesYou.
  ///
  /// In en, this message translates to:
  /// **'Owes you {amount}'**
  String profilesOwesYou(String amount);

  /// No description provided for @profilesYouOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe {amount}'**
  String profilesYouOwe(String amount);

  /// No description provided for @profilesSettled.
  ///
  /// In en, this message translates to:
  /// **'Settled up'**
  String get profilesSettled;

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

  /// No description provided for @settingsHapticsSection.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get settingsHapticsSection;

  /// No description provided for @hapticsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Vibration feedback'**
  String get hapticsEnabled;

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

  /// No description provided for @settingsManageSection.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get settingsManageSection;

  /// No description provided for @settingsBackupSection.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsBackupSection;

  /// Settings section: app lock and hiding content from the system
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecuritySection;

  /// No description provided for @securityAppLock.
  ///
  /// In en, this message translates to:
  /// **'Lock the app'**
  String get securityAppLock;

  /// No description provided for @securityAppLockDesc.
  ///
  /// In en, this message translates to:
  /// **'Asks for your device lock — fingerprint, face or PIN — when you open the app and after it has been in the background for a while.'**
  String get securityAppLockDesc;

  /// No description provided for @securityAppLockUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Your device has no lock set up. Add one in system settings first.'**
  String get securityAppLockUnavailable;

  /// No description provided for @securityHideInSwitcher.
  ///
  /// In en, this message translates to:
  /// **'Hide in the app switcher'**
  String get securityHideInSwitcher;

  /// No description provided for @securityHideInSwitcherDesc.
  ///
  /// In en, this message translates to:
  /// **'Replaces the preview in the recent apps list with a blank screen, so your balance isn\'t visible there. Also blocks screenshots.'**
  String get securityHideInSwitcherDesc;

  /// No description provided for @securityUnlockReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm it\'s you to open TexFi m0ney'**
  String get securityUnlockReason;

  /// No description provided for @securityLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get securityLockedTitle;

  /// No description provided for @securityLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Your money stays on this device. Confirm it\'s you to open it.'**
  String get securityLockedBody;

  /// No description provided for @securityUnlock.
  ///
  /// In en, this message translates to:
  /// **'UNLOCK'**
  String get securityUnlock;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get backupExport;

  /// No description provided for @backupImport.
  ///
  /// In en, this message translates to:
  /// **'Import data'**
  String get backupImport;

  /// No description provided for @backupImportConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace all data?'**
  String get backupImportConfirmTitle;

  /// No description provided for @backupImportConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Importing a backup replaces everything currently on this device — transactions, categories, accounts, profiles, budgets and goals. This can\'t be undone.'**
  String get backupImportConfirmBody;

  /// No description provided for @backupImportConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get backupImportConfirmAction;

  /// No description provided for @backupImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data restored from backup'**
  String get backupImportSuccess;

  /// No description provided for @backupImportError.
  ///
  /// In en, this message translates to:
  /// **'This file isn\'t a valid TexFi m0ney backup'**
  String get backupImportError;

  /// No description provided for @settingsDangerSection.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get settingsDangerSection;

  /// No description provided for @resetApp.
  ///
  /// In en, this message translates to:
  /// **'Reset app'**
  String get resetApp;

  /// No description provided for @resetAppConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset the app?'**
  String get resetAppConfirmTitle;

  /// No description provided for @resetAppConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Everything will be permanently deleted: transactions, categories, accounts, profiles, budgets, goals and all settings. The app will restart as if freshly installed. This can\'t be undone.'**
  String get resetAppConfirmBody;

  /// No description provided for @resetAppConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetAppConfirmAction;

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

  /// No description provided for @quickEntryLabel.
  ///
  /// In en, this message translates to:
  /// **'quick add'**
  String get quickEntryLabel;

  /// No description provided for @quickEntryHint.
  ///
  /// In en, this message translates to:
  /// **'-15 coffee lunch'**
  String get quickEntryHint;

  /// No description provided for @quickEntryHelp.
  ///
  /// In en, this message translates to:
  /// **'Sign, amount, category, note — e.g. “-15 coffee lunch” or “+2000 salary”'**
  String get quickEntryHelp;

  /// No description provided for @quickEntryParseError.
  ///
  /// In en, this message translates to:
  /// **'Not recognized. Start with + or -, then the amount.'**
  String get quickEntryParseError;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Everything in view'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Body.
  ///
  /// In en, this message translates to:
  /// **'Balance, income and expenses for the month — all on one screen.'**
  String get onboardingSlide1Body;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Budgets & goals'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Body.
  ///
  /// In en, this message translates to:
  /// **'Set monthly limits per category and save toward what matters, with a live progress bar.'**
  String get onboardingSlide2Body;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'❯ Quick add'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'One line — “-15 coffee lunch” — and the transaction is done. Faster than tapping through menus.'**
  String get onboardingSlide3Body;

  /// No description provided for @onboardingSlide4Title.
  ///
  /// In en, this message translates to:
  /// **'Private & offline'**
  String get onboardingSlide4Title;

  /// No description provided for @onboardingSlide4Body.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on your device. No account, no cloud, no ads.'**
  String get onboardingSlide4Body;

  /// No description provided for @onboardingCurrencyStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your currency'**
  String get onboardingCurrencyStepTitle;

  /// No description provided for @onboardingThemeStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your look'**
  String get onboardingThemeStepTitle;

  /// No description provided for @onboardingBankStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your bank (optional)'**
  String get onboardingBankStepTitle;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @navWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get navWealth;

  /// No description provided for @wealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get wealthTitle;

  /// No description provided for @wealthTotal.
  ///
  /// In en, this message translates to:
  /// **'Net worth'**
  String get wealthTotal;

  /// No description provided for @wealthAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get wealthAssets;

  /// No description provided for @wealthLiabilities.
  ///
  /// In en, this message translates to:
  /// **'Liabilities'**
  String get wealthLiabilities;

  /// No description provided for @wealthEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get wealthEmptyTitle;

  /// No description provided for @wealthEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add what you own and what you owe. Values are yours to set and yours to update — nothing is fetched from anywhere.'**
  String get wealthEmptyBody;

  /// No description provided for @wealthAddAsset.
  ///
  /// In en, this message translates to:
  /// **'ADD ASSET'**
  String get wealthAddAsset;

  /// No description provided for @wealthYearChange.
  ///
  /// In en, this message translates to:
  /// **'Over the last year'**
  String get wealthYearChange;

  /// No description provided for @wealthYearChangeNoBase.
  ///
  /// In en, this message translates to:
  /// **'No data from a year ago to compare with yet.'**
  String get wealthYearChangeNoBase;

  /// No description provided for @wealthByCategory.
  ///
  /// In en, this message translates to:
  /// **'Where it sits'**
  String get wealthByCategory;

  /// No description provided for @wealthByCashFlow.
  ///
  /// In en, this message translates to:
  /// **'What it does'**
  String get wealthByCashFlow;

  /// No description provided for @wealthByRisk.
  ///
  /// In en, this message translates to:
  /// **'How risky'**
  String get wealthByRisk;

  /// No description provided for @wealthAssetsList.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get wealthAssetsList;

  /// No description provided for @wealthOffline.
  ///
  /// In en, this message translates to:
  /// **'Every figure here is one you entered. The app does not look up prices or rates anywhere.'**
  String get wealthOffline;

  /// No description provided for @flowIncome.
  ///
  /// In en, this message translates to:
  /// **'Brings money in'**
  String get flowIncome;

  /// No description provided for @flowLiability.
  ///
  /// In en, this message translates to:
  /// **'Takes money out'**
  String get flowLiability;

  /// No description provided for @flowNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neither'**
  String get flowNeutral;

  /// No description provided for @assetName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get assetName;

  /// No description provided for @assetValue.
  ///
  /// In en, this message translates to:
  /// **'Current value'**
  String get assetValue;

  /// No description provided for @assetCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get assetCategory;

  /// No description provided for @assetRisk.
  ///
  /// In en, this message translates to:
  /// **'Risk level'**
  String get assetRisk;

  /// No description provided for @assetFlow.
  ///
  /// In en, this message translates to:
  /// **'Cash flow'**
  String get assetFlow;

  /// No description provided for @assetNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get assetNote;

  /// No description provided for @assetValuedAt.
  ///
  /// In en, this message translates to:
  /// **'Value as of'**
  String get assetValuedAt;

  /// No description provided for @assetNew.
  ///
  /// In en, this message translates to:
  /// **'New asset'**
  String get assetNew;

  /// No description provided for @assetEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit asset'**
  String get assetEdit;

  /// No description provided for @assetRevalue.
  ///
  /// In en, this message translates to:
  /// **'UPDATE VALUE'**
  String get assetRevalue;

  /// No description provided for @assetRevalueTitle.
  ///
  /// In en, this message translates to:
  /// **'New value'**
  String get assetRevalueTitle;

  /// No description provided for @assetHistory.
  ///
  /// In en, this message translates to:
  /// **'Value history'**
  String get assetHistory;

  /// No description provided for @assetHistoryHint.
  ///
  /// In en, this message translates to:
  /// **'Each update adds a point instead of replacing the last one — that is what the year-over-year figure is built from.'**
  String get assetHistoryHint;

  /// No description provided for @assetDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete asset'**
  String get assetDelete;

  /// No description provided for @assetDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'The asset and its whole value history go away. This cannot be undone.'**
  String get assetDeleteBody;

  /// No description provided for @riskSection.
  ///
  /// In en, this message translates to:
  /// **'Risk management'**
  String get riskSection;

  /// No description provided for @riskLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Limit for {level}'**
  String riskLimitLabel(String level);

  /// No description provided for @riskNoLimit.
  ///
  /// In en, this message translates to:
  /// **'no limit'**
  String get riskNoLimit;

  /// No description provided for @riskLimitHint.
  ///
  /// In en, this message translates to:
  /// **'The share of your wealth you are fine keeping at this risk level. Yours to decide — the app has no opinion about what is safe.'**
  String get riskLimitHint;

  /// No description provided for @riskBreachTitle.
  ///
  /// In en, this message translates to:
  /// **'Over your own limit'**
  String get riskBreachTitle;

  /// No description provided for @riskBreachBody.
  ///
  /// In en, this message translates to:
  /// **'{level}: {actual}% of your wealth, and you set the limit at {limit}%.'**
  String riskBreachBody(String level, String actual, String limit);

  /// No description provided for @riskAddLevel.
  ///
  /// In en, this message translates to:
  /// **'ADD LEVEL'**
  String get riskAddLevel;

  /// No description provided for @riskLevelName.
  ///
  /// In en, this message translates to:
  /// **'Level name'**
  String get riskLevelName;

  /// No description provided for @riskLevelInUse.
  ///
  /// In en, this message translates to:
  /// **'Assets are using this level — move them first.'**
  String get riskLevelInUse;

  /// No description provided for @riskLastLevel.
  ///
  /// In en, this message translates to:
  /// **'The last level cannot be removed.'**
  String get riskLastLevel;

  /// No description provided for @usefulnessLabel.
  ///
  /// In en, this message translates to:
  /// **'Was it worth it?'**
  String get usefulnessLabel;

  /// No description provided for @usefulnessUseful.
  ///
  /// In en, this message translates to:
  /// **'Worth it'**
  String get usefulnessUseful;

  /// No description provided for @usefulnessUseless.
  ///
  /// In en, this message translates to:
  /// **'Not worth it'**
  String get usefulnessUseless;

  /// No description provided for @usefulnessNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neither'**
  String get usefulnessNeutral;

  /// No description provided for @usefulnessNotRated.
  ///
  /// In en, this message translates to:
  /// **'Not rated'**
  String get usefulnessNotRated;

  /// No description provided for @usefulnessSection.
  ///
  /// In en, this message translates to:
  /// **'Worth it or not'**
  String get usefulnessSection;

  /// No description provided for @usefulnessHint.
  ///
  /// In en, this message translates to:
  /// **'Only what you marked yourself. The app does not guess: the same delivery can be a rescue or a slip, and only you know which.'**
  String get usefulnessHint;

  /// No description provided for @subscriptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptionsTitle;

  /// No description provided for @subscriptionsMonthly.
  ///
  /// In en, this message translates to:
  /// **'Per month'**
  String get subscriptionsMonthly;

  /// No description provided for @subscriptionsMonthlyHint.
  ///
  /// In en, this message translates to:
  /// **'Yearly ones are shown as their monthly share, so the total means the same thing every month.'**
  String get subscriptionsMonthlyHint;

  /// No description provided for @subscriptionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No subscriptions yet. Add the ones that renew on their own.'**
  String get subscriptionsEmpty;

  /// No description provided for @subscriptionsAdd.
  ///
  /// In en, this message translates to:
  /// **'ADD SUBSCRIPTION'**
  String get subscriptionsAdd;

  /// No description provided for @subscriptionNew.
  ///
  /// In en, this message translates to:
  /// **'New subscription'**
  String get subscriptionNew;

  /// No description provided for @subscriptionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit subscription'**
  String get subscriptionEdit;

  /// No description provided for @subscriptionName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get subscriptionName;

  /// No description provided for @subscriptionAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get subscriptionAmount;

  /// No description provided for @subscriptionPeriod.
  ///
  /// In en, this message translates to:
  /// **'Renews'**
  String get subscriptionPeriod;

  /// No description provided for @subscriptionNextCharge.
  ///
  /// In en, this message translates to:
  /// **'Next charge'**
  String get subscriptionNextCharge;

  /// No description provided for @subscriptionCustomDays.
  ///
  /// In en, this message translates to:
  /// **'Every N days'**
  String get subscriptionCustomDays;

  /// No description provided for @subscriptionActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get subscriptionActive;

  /// No description provided for @subscriptionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get subscriptionCancelled;

  /// No description provided for @periodMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get periodMonthly;

  /// No description provided for @periodYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get periodYearly;

  /// No description provided for @periodCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get periodCustom;

  /// No description provided for @chargeToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get chargeToday;

  /// No description provided for @chargeTomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get chargeTomorrow;

  /// No description provided for @chargeInDays.
  ///
  /// In en, this message translates to:
  /// **'in {days} d'**
  String chargeInDays(int days);

  /// No description provided for @chargeOverdue.
  ///
  /// In en, this message translates to:
  /// **'overdue'**
  String get chargeOverdue;

  /// No description provided for @savingsRateTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings rate'**
  String get savingsRateTitle;

  /// No description provided for @savingsRateHint.
  ///
  /// In en, this message translates to:
  /// **'Of everything that came in this month, this much stayed. A higher share means more of your income is still yours.'**
  String get savingsRateHint;

  /// No description provided for @savingsRateNoIncome.
  ///
  /// In en, this message translates to:
  /// **'No income this month — there is nothing to take a share of.'**
  String get savingsRateNoIncome;

  /// No description provided for @savingsRateHistory.
  ///
  /// In en, this message translates to:
  /// **'By month'**
  String get savingsRateHistory;

  /// No description provided for @cashFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash flow'**
  String get cashFlowTitle;

  /// No description provided for @cashFlowReceived.
  ///
  /// In en, this message translates to:
  /// **'Came in'**
  String get cashFlowReceived;

  /// No description provided for @cashFlowSpent.
  ///
  /// In en, this message translates to:
  /// **'Went out'**
  String get cashFlowSpent;

  /// No description provided for @cashFlowSaved.
  ///
  /// In en, this message translates to:
  /// **'Kept'**
  String get cashFlowSaved;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get reportsCategory;

  /// No description provided for @reportsAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get reportsAllCategories;

  /// No description provided for @reportsPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get reportsPeriod;

  /// No description provided for @reportsGroupByMonth.
  ///
  /// In en, this message translates to:
  /// **'By month'**
  String get reportsGroupByMonth;

  /// No description provided for @reportsGroupByYear.
  ///
  /// In en, this message translates to:
  /// **'By year'**
  String get reportsGroupByYear;

  /// No description provided for @reportsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches these filters.'**
  String get reportsEmpty;

  /// No description provided for @reportsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get reportsTotal;

  /// No description provided for @adviceSection.
  ///
  /// In en, this message translates to:
  /// **'Worth a look'**
  String get adviceSection;

  /// No description provided for @adviceRisk.
  ///
  /// In en, this message translates to:
  /// **'{level} holds {percent}% of your wealth, above the {limit}% you set. Might be worth rebalancing.'**
  String adviceRisk(String level, String percent, String limit);

  /// No description provided for @adviceUseless.
  ///
  /// In en, this message translates to:
  /// **'Spending you marked as not worth it is up {percent}% from last month.'**
  String adviceUseless(String percent);

  /// No description provided for @adviceSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions cost {percent}% more than last month — worth checking whether you still need them all.'**
  String adviceSubscriptions(String percent);

  /// No description provided for @adviceSavings.
  ///
  /// In en, this message translates to:
  /// **'You kept {percent}% this month against your usual {limit}%.'**
  String adviceSavings(String percent, String limit);

  /// No description provided for @adviceEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing stands out against your own numbers right now.'**
  String get adviceEmpty;

  /// No description provided for @adviceDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'These come from comparing your numbers with your own limits and history. No market data, no analysis of what you hold.'**
  String get adviceDisclaimer;

  /// No description provided for @analysisRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Analysis range'**
  String get analysisRangeTitle;

  /// No description provided for @analysisRangeHint.
  ///
  /// In en, this message translates to:
  /// **'How far back every history chart looks — wealth, cash flow, savings rate.'**
  String get analysisRangeHint;

  /// No description provided for @analysisRangeYears.
  ///
  /// In en, this message translates to:
  /// **'Last {years} years'**
  String analysisRangeYears(int years);

  /// No description provided for @analysisRangeCustom.
  ///
  /// In en, this message translates to:
  /// **'Set dates'**
  String get analysisRangeCustom;

  /// No description provided for @assetCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Asset categories'**
  String get assetCategoriesTitle;

  /// Title of the About screen
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// About screen: section with version and tagline
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get aboutSectionApp;

  /// About screen: open-source section
  ///
  /// In en, this message translates to:
  /// **'Open source'**
  String get aboutSectionOpen;

  /// About screen: donation section
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get aboutSectionSupport;

  /// Label before the release version number
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersionLabel;

  /// Label before the build number
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get aboutBuildLabel;

  /// One-line description of the app
  ///
  /// In en, this message translates to:
  /// **'Personal finance that stays put'**
  String get aboutTagline;

  /// Short privacy statement on the About screen
  ///
  /// In en, this message translates to:
  /// **'Everything lives in a database on this device. No analytics, no ad identifiers, no background \"events\" — check it against the source.'**
  String get aboutBlurb;

  /// Fact chip: the app works offline
  ///
  /// In en, this message translates to:
  /// **'OFFLINE'**
  String get aboutFactOffline;

  /// Fact chip label paired with the number zero
  ///
  /// In en, this message translates to:
  /// **'TELEMETRY'**
  String get aboutFactTelemetry;

  /// Fact chip: license name label
  ///
  /// In en, this message translates to:
  /// **'LICENSE'**
  String get aboutFactLicense;

  /// Link to the source repository
  ///
  /// In en, this message translates to:
  /// **'Source on GitHub'**
  String get aboutSourceTitle;

  /// License row title
  ///
  /// In en, this message translates to:
  /// **'GNU AGPL v3'**
  String get aboutLicenseTitle;

  /// One-line summary of the AGPL copyleft rule
  ///
  /// In en, this message translates to:
  /// **'Ship a modified version and you have to open your changes too.'**
  String get aboutLicenseText;

  /// Link to the TexFi hub website
  ///
  /// In en, this message translates to:
  /// **'The whole TexFi ecosystem'**
  String get aboutEcosystemTitle;

  /// Donation link title
  ///
  /// In en, this message translates to:
  /// **'Buy a coffee'**
  String get aboutDonateTitle;

  /// Explains that the app is free and donations change nothing
  ///
  /// In en, this message translates to:
  /// **'TexFi is made by one person and every app is free. There are no paid features and there will not be.'**
  String get aboutDonateText;

  /// Snackbar when no app can handle the URL
  ///
  /// In en, this message translates to:
  /// **'Nothing here can open that link'**
  String get aboutLinkFailed;
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
