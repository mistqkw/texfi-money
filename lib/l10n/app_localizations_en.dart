// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navBudgets => 'Budgets';

  @override
  String get navGoals => 'Goals';

  @override
  String get navStatistics => 'Statistics';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonOk => 'OK';

  @override
  String get commonExpense => 'Expense';

  @override
  String get commonIncome => 'Income';

  @override
  String get commonCategory => 'Category';

  @override
  String get commonColor => 'Color';

  @override
  String get categoryGroceries => 'Groceries';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryHome => 'Housing';

  @override
  String get categoryRestaurant => 'Cafes & restaurants';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryClothes => 'Clothes';

  @override
  String get categoryBills => 'Bills';

  @override
  String get categoryOtherExpense => 'Other';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categoryFreelance => 'Freelance';

  @override
  String get categoryGifts => 'Gifts';

  @override
  String get categoryInvestments => 'Investments';

  @override
  String get categoryOtherIncome => 'Other';

  @override
  String get categoryDeleteHasTransactionsError =>
      'Can\'t delete a category that has transactions';

  @override
  String get currencyRub => 'Russian ruble';

  @override
  String get currencyUsd => 'US dollar';

  @override
  String get currencyEur => 'Euro';

  @override
  String get currencyUah => 'Ukrainian hryvnia';

  @override
  String get currencyPln => 'Polish zloty';

  @override
  String get currencyByn => 'Belarusian ruble';

  @override
  String get currencyKzt => 'Kazakhstani tenge';

  @override
  String get currencyGbp => 'British pound';

  @override
  String get currencyCny => 'Chinese yuan';

  @override
  String get currencyTry => 'Turkish lira';

  @override
  String get appTitle => 'TexFi m0ney';

  @override
  String homeCurrencyTooltip(String name) {
    return 'Currency: $name';
  }

  @override
  String get homeCategoriesTooltip => 'Categories';

  @override
  String get homeSettingsTooltip => 'Settings';

  @override
  String get homeIncomeThisMonth => 'Income this month';

  @override
  String get homeExpenseThisMonth => 'Expense this month';

  @override
  String get homeRecentTransactions => 'Recent transactions';

  @override
  String get homeEmptyTransactions =>
      'No transactions yet — add your first with the “+” button';

  @override
  String get homeLoadTransactionsError => 'Couldn\'t load transactions';

  @override
  String get homeBalance => 'Balance';

  @override
  String get addTxTitle => 'New transaction';

  @override
  String get addTxLoadCategoriesError => 'Couldn\'t load categories';

  @override
  String get addTxNoteHint => 'Note (optional)';

  @override
  String get addTxAddCategory => 'Custom category';

  @override
  String get addTxAccountLabel => 'Account';

  @override
  String get addTxNoAccount => 'No account';

  @override
  String get budgetsTitle => 'Budgets';

  @override
  String get budgetsEmpty =>
      'No budgets yet — set a monthly limit for a category with the “+” button';

  @override
  String get budgetsLoadError => 'Couldn\'t load budgets';

  @override
  String budgetsOverBy(String amount) {
    return 'Over by $amount';
  }

  @override
  String get budgetsNearLimit => 'Approaching the limit';

  @override
  String get setBudgetTitleEdit => 'Edit budget';

  @override
  String get setBudgetTitleNew => 'New budget';

  @override
  String get setBudgetLimitLabel => 'Monthly limit';

  @override
  String get setBudgetNoCategoriesLeft =>
      'All expense categories already have a budget';

  @override
  String get setBudgetLoadCategoriesError => 'Couldn\'t load categories';

  @override
  String get categoriesDeleteTitle => 'Delete category?';

  @override
  String categoriesDeleteConfirm(String name) {
    return 'Category “$name” will be deleted permanently.';
  }

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get categoriesExpenseSection => 'Expenses';

  @override
  String get categoriesIncomeSection => 'Income';

  @override
  String get categoriesLoadError => 'Couldn\'t load categories';

  @override
  String get categoryFormTitleNew => 'New category';

  @override
  String get categoryFormTitleEdit => 'Edit category';

  @override
  String get categoryFormNameHint => 'Category name';

  @override
  String get categoryFormIconLabel => 'Icon';

  @override
  String get goalFormNoDeadline => 'No deadline';

  @override
  String get goalFormTitleEdit => 'Edit goal';

  @override
  String get goalFormTitleNew => 'New goal';

  @override
  String get goalFormNameHint => 'Goal name, e.g. “New PC”';

  @override
  String get goalFormTargetLabel => 'Target amount';

  @override
  String get goalFormDeadlineLabel => 'Deadline';

  @override
  String goalsAddFundsTitle(String title) {
    return 'Add to “$title”';
  }

  @override
  String get goalsDeleteTitle => 'Delete goal?';

  @override
  String goalsDeleteConfirm(String title) {
    return 'Goal “$title” and its saved progress will be deleted.';
  }

  @override
  String get goalsTitle => 'Savings goals';

  @override
  String get goalsEmpty =>
      'No goals yet — create your first with the “+” button';

  @override
  String get goalsLoadError => 'Couldn\'t load goals';

  @override
  String goalsProgressOf(String current, String target) {
    return '$current of $target';
  }

  @override
  String get goalsAchieved => 'Goal achieved!';

  @override
  String get goalsDeadlinePassed => 'Deadline passed';

  @override
  String goalsDaysLeft(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '$days day left',
    );
    return '$_temp0';
  }

  @override
  String get accountsTitle => 'Accounts';

  @override
  String get accountsEmpty =>
      'No accounts yet — add your first with the “+” button';

  @override
  String get accountsLoadError => 'Couldn\'t load accounts';

  @override
  String get accountsDeleteTitle => 'Delete account?';

  @override
  String accountsDeleteConfirm(String name) {
    return 'Account “$name” will be deleted. Its transactions stay, just unassigned.';
  }

  @override
  String get accountFormTitleNew => 'New account';

  @override
  String get accountFormTitleEdit => 'Edit account';

  @override
  String get accountFormNameHint => 'Account name, e.g. “Bank A card”';

  @override
  String get accountFormBankLabel => 'Bank';

  @override
  String get accountFormNoBank => 'None';

  @override
  String get profilesTitle => 'Profiles';

  @override
  String get profilesEmpty =>
      'No profiles yet — track money someone owes you (or you owe them) with the “+” button';

  @override
  String get profilesLoadError => 'Couldn\'t load profiles';

  @override
  String get profilesDeleteTitle => 'Delete profile?';

  @override
  String profilesDeleteConfirm(String name) {
    return 'Profile “$name” and its balance will be deleted.';
  }

  @override
  String get profileFormTitleNew => 'New profile';

  @override
  String get profileFormTitleEdit => 'Edit profile';

  @override
  String get profileFormNameHint => 'Person\'s name';

  @override
  String profilesRecordTitle(String name) {
    return 'Record for “$name”';
  }

  @override
  String get profilesTheyBorrowed => 'They borrowed';

  @override
  String get profilesTheyRepaid => 'They repaid';

  @override
  String profilesOwesYou(String amount) {
    return 'Owes you $amount';
  }

  @override
  String profilesYouOwe(String amount) {
    return 'You owe $amount';
  }

  @override
  String get profilesSettled => 'Settled up';

  @override
  String get historyAllTypes => 'All types';

  @override
  String get historyAllCategories => 'All categories';

  @override
  String get historyTitle => 'History';

  @override
  String get historyTypeFilterLabel => 'Type';

  @override
  String get historyCategoryFilterLabel => 'Category';

  @override
  String get historyPeriodFilterLabel => 'Period';

  @override
  String get historyReset => 'Reset';

  @override
  String get historyEmpty => 'Nothing found';

  @override
  String get historyLoadError => 'Couldn\'t load history';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsThemeSection => 'Theme';

  @override
  String get settingsFontSection => 'Font';

  @override
  String get settingsHapticsSection => 'Vibration';

  @override
  String get hapticsEnabled => 'Vibration feedback';

  @override
  String get settingsCurrencySection => 'Currency';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsManageSection => 'Manage';

  @override
  String get settingsBackupSection => 'Backup';

  @override
  String get backupExport => 'Export data';

  @override
  String get backupImport => 'Import data';

  @override
  String get backupImportConfirmTitle => 'Replace all data?';

  @override
  String get backupImportConfirmBody =>
      'Importing a backup replaces everything currently on this device — transactions, categories, accounts, profiles, budgets and goals. This can\'t be undone.';

  @override
  String get backupImportConfirmAction => 'Replace';

  @override
  String get backupImportSuccess => 'Data restored from backup';

  @override
  String get backupImportError => 'This file isn\'t a valid TexFi m0ney backup';

  @override
  String get settingsDangerSection => 'Danger zone';

  @override
  String get resetApp => 'Reset app';

  @override
  String get resetAppConfirmTitle => 'Reset the app?';

  @override
  String get resetAppConfirmBody =>
      'Everything will be permanently deleted: transactions, categories, accounts, profiles, budgets, goals and all settings. The app will restart as if freshly installed. This can\'t be undone.';

  @override
  String get resetAppConfirmAction => 'Reset';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeOled => 'Black (OLED)';

  @override
  String get fontSystem => 'System';

  @override
  String get languageSystem => 'System';

  @override
  String get currencyPickerTitle => 'Currency';

  @override
  String get languagePickerTitle => 'Language';

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get statisticsMonthlyChartTitle => 'Income and expense by month';

  @override
  String get statisticsLoadError => 'Couldn\'t load data';

  @override
  String get statisticsCategoryChartTitle => 'Expenses by category this month';

  @override
  String get statisticsNoExpenses => 'No expenses this month';

  @override
  String get quickEntryLabel => 'quick add';

  @override
  String get quickEntryHint => '-15 coffee lunch';

  @override
  String get quickEntryHelp =>
      'Sign, amount, category, note — e.g. “-15 coffee lunch” or “+2000 salary”';

  @override
  String get quickEntryParseError =>
      'Not recognized. Start with + or -, then the amount.';

  @override
  String get onboardingSlide1Title => 'Everything in view';

  @override
  String get onboardingSlide1Body =>
      'Balance, income and expenses for the month — all on one screen.';

  @override
  String get onboardingSlide2Title => 'Budgets & goals';

  @override
  String get onboardingSlide2Body =>
      'Set monthly limits per category and save toward what matters, with a live progress bar.';

  @override
  String get onboardingSlide3Title => '❯ Quick add';

  @override
  String get onboardingSlide3Body =>
      'One line — “-15 coffee lunch” — and the transaction is done. Faster than tapping through menus.';

  @override
  String get onboardingSlide4Title => 'Private & offline';

  @override
  String get onboardingSlide4Body =>
      'Everything stays on your device. No account, no cloud, no ads.';

  @override
  String get onboardingCurrencyStepTitle => 'Pick your currency';

  @override
  String get onboardingThemeStepTitle => 'Pick your look';

  @override
  String get onboardingBankStepTitle => 'Add your bank (optional)';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingSkip => 'Skip';
}
