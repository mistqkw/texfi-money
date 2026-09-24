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
  String get homeRecentShort => 'Recent';

  @override
  String get homeFactIncome => 'Income';

  @override
  String get homeFactExpense => 'Spent';

  @override
  String get homeFactSaved => 'Saved';

  @override
  String get homeEmptyTransactions =>
      'Nothing here yet. The first entry takes about ten seconds.';

  @override
  String get homeLoadTransactionsError => 'Couldn\'t load transactions';

  @override
  String get homeBalance => 'Balance';

  @override
  String get addTxAmountLabel => 'Amount';

  @override
  String get addTxTitle => 'New transaction';

  @override
  String get addTxTitleEdit => 'Edit transaction';

  @override
  String get txActionRepeat => 'Repeat today';

  @override
  String get txActionEdit => 'Edit';

  @override
  String nudgeUnusualAmount(String times, String category) {
    return 'That\'s $times× your usual $category. Amount right?';
  }

  @override
  String nudgeBudgetClose(String category, String percent) {
    return '$category budget is $percent% spent';
  }

  @override
  String nudgeBudgetOver(String category, String amount) {
    return '$category is over budget by $amount';
  }

  @override
  String nudgeQuietDays(num days) {
    return 'Nothing logged in $days days — catch up?';
  }

  @override
  String nudgeGoalClose(String title, String percent) {
    return '“$title” is $percent% funded — nearly there';
  }

  @override
  String get nudgeDismiss => 'Dismiss';

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
      'No budgets yet. Set a monthly cap on a category and you will see yourself approaching it.';

  @override
  String get budgetsLoadError => 'Couldn\'t load budgets';

  @override
  String budgetsLeft(String amount) {
    return '$amount left';
  }

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
      'No goals yet. Saving is easier when the amount has a name.';

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
      'No accounts yet. Add the ones where the money actually sits — a card, cash, a jar.';

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
      'No profiles yet. This is for other people’s money: debts, a shared account, someone’s budget in your hands.';

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
  String get settingsSecuritySection => 'Security';

  @override
  String get securityAppLock => 'Lock the app';

  @override
  String get securityAppLockDesc =>
      'Asks for your device lock — fingerprint, face or PIN — when you open the app and after it has been in the background for a while.';

  @override
  String get securityAppLockUnavailable =>
      'Your device has no lock set up. Add one in system settings first.';

  @override
  String get securityHideInSwitcher => 'Hide in the app switcher';

  @override
  String get securityHideInSwitcherDesc =>
      'Replaces the preview in the recent apps list with a blank screen, so your balance isn\'t visible there. Also blocks screenshots.';

  @override
  String get securityUnlockReason => 'Confirm it\'s you to open TexFi m0ney';

  @override
  String get securityLockedTitle => 'Locked';

  @override
  String get securityLockedBody =>
      'Your money stays on this device. Confirm it\'s you to open it.';

  @override
  String get securityUnlock => 'Unlock';

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

  @override
  String get navWealth => 'Wealth';

  @override
  String get wealthTitle => 'Wealth';

  @override
  String get wealthTotal => 'Net worth';

  @override
  String get wealthAssets => 'Assets';

  @override
  String get wealthLiabilities => 'Liabilities';

  @override
  String get wealthEmptyTitle => 'Nothing here yet';

  @override
  String get wealthEmptyBody =>
      'Add what you own and what you owe. Values are yours to set and yours to update — nothing is fetched from anywhere.';

  @override
  String get wealthAddAsset => 'Add asset';

  @override
  String get wealthYearChange => 'Over the last year';

  @override
  String get wealthYearChangeNoBase =>
      'No data from a year ago to compare with yet.';

  @override
  String get wealthByCategory => 'Where it sits';

  @override
  String get wealthByCashFlow => 'What it does';

  @override
  String get wealthByRisk => 'How risky';

  @override
  String get wealthAssetsList => 'Assets';

  @override
  String get wealthOffline =>
      'Every figure here is one you entered. The app does not look up prices or rates anywhere.';

  @override
  String get flowIncome => 'Brings money in';

  @override
  String get flowLiability => 'Takes money out';

  @override
  String get flowNeutral => 'Neither';

  @override
  String get assetName => 'Name';

  @override
  String get assetValue => 'Current value';

  @override
  String get assetCategory => 'Category';

  @override
  String get assetRisk => 'Risk level';

  @override
  String get assetFlow => 'Cash flow';

  @override
  String get assetNote => 'Note';

  @override
  String get assetValuedAt => 'Value as of';

  @override
  String get assetNew => 'New asset';

  @override
  String get assetEdit => 'Edit asset';

  @override
  String get assetRevalue => 'Update value';

  @override
  String get assetRevalueTitle => 'New value';

  @override
  String get assetHistory => 'Value history';

  @override
  String get assetHistoryHint =>
      'Each update adds a point instead of replacing the last one — that is what the year-over-year figure is built from.';

  @override
  String get assetDelete => 'Delete asset';

  @override
  String get assetDeleteBody =>
      'The asset and its whole value history go away. This cannot be undone.';

  @override
  String get riskSection => 'Risk management';

  @override
  String riskLimitLabel(String level) {
    return 'Limit for $level';
  }

  @override
  String get riskNoLimit => 'no limit';

  @override
  String get riskLimitHint =>
      'The share of your wealth you are fine keeping at this risk level. Yours to decide — the app has no opinion about what is safe.';

  @override
  String get riskBreachTitle => 'Over your own limit';

  @override
  String riskBreachBody(String level, String actual, String limit) {
    return '$level: $actual% of your wealth, and you set the limit at $limit%.';
  }

  @override
  String get riskAddLevel => 'Add level';

  @override
  String get riskLevelName => 'Level name';

  @override
  String get riskLevelInUse => 'Assets are using this level — move them first.';

  @override
  String get riskLastLevel => 'The last level cannot be removed.';

  @override
  String get usefulnessLabel => 'Was it worth it?';

  @override
  String get usefulnessUseful => 'Worth it';

  @override
  String get usefulnessUseless => 'Not worth it';

  @override
  String get usefulnessNeutral => 'Neither';

  @override
  String get usefulnessNotRated => 'Not rated';

  @override
  String get usefulnessSection => 'Worth it or not';

  @override
  String get usefulnessHint =>
      'Only what you marked yourself. The app does not guess: the same delivery can be a rescue or a slip, and only you know which.';

  @override
  String get subscriptionsTitle => 'Subscriptions';

  @override
  String get subscriptionsMonthly => 'Per month';

  @override
  String get subscriptionsMonthlyHint =>
      'Yearly ones are shown as their monthly share, so the total means the same thing every month.';

  @override
  String get subscriptionsEmpty =>
      'No subscriptions yet. Add the ones that renew on their own.';

  @override
  String get subscriptionsAdd => 'Add subscription';

  @override
  String get subscriptionNew => 'New subscription';

  @override
  String get subscriptionEdit => 'Edit subscription';

  @override
  String get subscriptionName => 'Name';

  @override
  String get subscriptionAmount => 'Amount';

  @override
  String get subscriptionPeriod => 'Renews';

  @override
  String get subscriptionNextCharge => 'Next charge';

  @override
  String get subscriptionCustomDays => 'Every N days';

  @override
  String get subscriptionActive => 'Active';

  @override
  String get subscriptionCancelled => 'Cancelled';

  @override
  String get periodMonthly => 'Monthly';

  @override
  String get periodYearly => 'Yearly';

  @override
  String get periodCustom => 'Custom';

  @override
  String get chargeToday => 'today';

  @override
  String get chargeTomorrow => 'tomorrow';

  @override
  String chargeInDays(int days) {
    return 'in $days d';
  }

  @override
  String get chargeOverdue => 'overdue';

  @override
  String get savingsRateTitle => 'Savings rate';

  @override
  String get savingsRateHint =>
      'Of everything that came in this month, this much stayed. A higher share means more of your income is still yours.';

  @override
  String get savingsRateNoIncome =>
      'No income this month — there is nothing to take a share of.';

  @override
  String get savingsRateHistory => 'By month';

  @override
  String get cashFlowTitle => 'Cash flow';

  @override
  String get cashFlowReceived => 'Came in';

  @override
  String get cashFlowSpent => 'Went out';

  @override
  String get cashFlowSaved => 'Kept';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsCategory => 'Category';

  @override
  String get reportsAllCategories => 'All categories';

  @override
  String get reportsPeriod => 'Period';

  @override
  String get reportsGroupByMonth => 'By month';

  @override
  String get reportsGroupByYear => 'By year';

  @override
  String get reportsEmpty => 'Nothing matches these filters.';

  @override
  String get reportsTotal => 'Total';

  @override
  String get adviceSection => 'Worth a look';

  @override
  String adviceRisk(String level, String percent, String limit) {
    return '$level holds $percent% of your wealth, above the $limit% you set. Might be worth rebalancing.';
  }

  @override
  String adviceUseless(String percent) {
    return 'Spending you marked as not worth it is up $percent% from last month.';
  }

  @override
  String adviceSubscriptions(String percent) {
    return 'Subscriptions cost $percent% more than last month — worth checking whether you still need them all.';
  }

  @override
  String adviceSavings(String percent, String limit) {
    return 'You kept $percent% this month against your usual $limit%.';
  }

  @override
  String get adviceEmpty =>
      'Nothing stands out against your own numbers right now.';

  @override
  String get adviceDisclaimer =>
      'These come from comparing your numbers with your own limits and history. No market data, no analysis of what you hold.';

  @override
  String get analysisRangeTitle => 'Analysis range';

  @override
  String get analysisRangeHint =>
      'How far back every history chart looks — wealth, cash flow, savings rate.';

  @override
  String analysisRangeYears(int years) {
    return 'Last $years years';
  }

  @override
  String get analysisRangeCustom => 'Set dates';

  @override
  String get assetCategoriesTitle => 'Asset categories';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutSectionApp => 'App';

  @override
  String get aboutSectionOpen => 'Open source';

  @override
  String get aboutSectionSupport => 'Support';

  @override
  String get aboutVersionLabel => 'Version';

  @override
  String get aboutBuildLabel => 'Build';

  @override
  String get aboutTagline => 'Personal finance that stays put';

  @override
  String get aboutBlurb =>
      'Everything lives in a database on this device. No analytics, no ad identifiers, no background \"events\" — check it against the source.';

  @override
  String get aboutFactOffline => 'OFFLINE';

  @override
  String get aboutFactTelemetry => 'TELEMETRY';

  @override
  String get aboutFactLicense => 'LICENSE';

  @override
  String get aboutSourceTitle => 'Source on GitHub';

  @override
  String get aboutLicenseTitle => 'GNU AGPL v3';

  @override
  String get aboutLicenseText =>
      'Ship a modified version and you have to open your changes too.';

  @override
  String get aboutEcosystemTitle => 'The whole TexFi ecosystem';

  @override
  String get aboutDonateTitle => 'Buy a coffee';

  @override
  String get aboutDonateText =>
      'TexFi is made by one person and every app is free. There are no paid features and there will not be.';

  @override
  String get aboutLinkFailed => 'Nothing here can open that link';

  @override
  String get navPlan => 'Plan';

  @override
  String get navSummary => 'Totals';

  @override
  String aboutDevTapsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more taps to open the developer menu',
      one: 'One more tap to open the developer menu',
    );
    return '$_temp0';
  }

  @override
  String get aboutDevUnlocked => 'Developer menu unlocked';

  @override
  String get aboutDevMenu => 'Developer menu';

  @override
  String get aboutDevMenuHint => 'Diagnostics and experiments';

  @override
  String get devTitle => 'Developer';

  @override
  String get devSectionBuild => 'Build & device';

  @override
  String get devSectionRendering => 'Rendering';

  @override
  String get devSectionMotion => 'Motion';

  @override
  String get devSectionInterface => 'Interface';

  @override
  String get devSectionHaptics => 'Haptics';

  @override
  String get devSectionData => 'Data';

  @override
  String get devSectionExperimental => 'Experimental';

  @override
  String get devInfoVersion => 'Version';

  @override
  String get devInfoPackage => 'Package';

  @override
  String get devInfoMode => 'Build mode';

  @override
  String get devInfoPlatform => 'Platform';

  @override
  String get devInfoScreen => 'Screen';

  @override
  String get devInfoPixelRatio => 'Pixel ratio';

  @override
  String get devInfoTextScale => 'Text scale';

  @override
  String get devInfoLocale => 'Locale';

  @override
  String get devInfoStyle => 'Style';

  @override
  String get devCopyInfo => 'Copy for a bug report';

  @override
  String get devCopied => 'Copied';

  @override
  String get devPerfOverlay => 'Frame timing overlay';

  @override
  String get devPerfOverlayDesc => 'GPU and UI thread time on top of the app';

  @override
  String get devRasterCheckerboard => 'Highlight cached images';

  @override
  String get devRasterCheckerboardDesc =>
      'Checkerboard over raster-cached images';

  @override
  String get devLayerCheckerboard => 'Highlight offscreen layers';

  @override
  String get devLayerCheckerboardDesc =>
      'Checkerboard over layers drawn with saveLayer';

  @override
  String get devSemanticsDebugger => 'Accessibility tree';

  @override
  String get devSemanticsDebuggerDesc =>
      'Shows what a screen reader sees. Turn off here to get the app back';

  @override
  String get devAnimationSpeed => 'Animation speed';

  @override
  String get devAnimationSpeedDesc =>
      'Slow every animation down to inspect it frame by frame';

  @override
  String get devSkipSplash => 'Skip splash screen';

  @override
  String get devSkipSplashDesc => 'Open straight to the app on launch';

  @override
  String get devBackgroundNoise => 'Background texture';

  @override
  String get devBackgroundNoiseDesc => 'Pixel speckle under the whole app';

  @override
  String get devBanner => 'Corner ribbon';

  @override
  String get devBannerDesc =>
      'Marks screenshots taken with developer settings on';

  @override
  String get devHapticsTest => 'Tap to feel each rhythm';

  @override
  String get devHapticSelect => 'Tick';

  @override
  String get devHapticSuccess => 'Done';

  @override
  String get devHapticIncome => 'Income';

  @override
  String get devHapticExpense => 'Expense';

  @override
  String get devHapticError => 'Error';

  @override
  String get devHapticCelebrate => 'Goal';

  @override
  String get devReplayOnboarding => 'Replay onboarding';

  @override
  String get devReplayOnboardingDesc => 'Your data stays; the app restarts';

  @override
  String get devShowPrefs => 'Stored preferences';

  @override
  String get devShowPrefsDesc => 'Every key the app keeps in SharedPreferences';

  @override
  String get devRestart => 'Restart app';

  @override
  String get devRestartDesc =>
      'Rebuilds everything from scratch without closing';

  @override
  String get devReset => 'Reset developer settings';

  @override
  String get devResetDone => 'Developer settings reset';

  @override
  String get devHideMenu => 'Hide developer menu';

  @override
  String get devHideMenuDesc => 'Tap the version five times to bring it back';

  @override
  String get devBetaStyle => 'Beta style';

  @override
  String get devBetaStyleDesc =>
      'Source Serif 4, avatar colours, a big mark behind the screens';

  @override
  String get devBetaOn => 'On';

  @override
  String get devBetaOff => 'Off';

  @override
  String get devBetaEnableTitle => 'Turn on beta style?';

  @override
  String get devBetaEnableBody =>
      'The app will change its typeface, colours and shapes. It\'s a beta: some screens may look unfinished. You can turn it off right here.';

  @override
  String get devBetaEnableAction => 'Turn on';

  @override
  String get devBetaDisableTitle => 'Turn off beta style?';

  @override
  String get devBetaDisableBody => 'The familiar pixel style comes back.';

  @override
  String get devBetaDisableAction => 'Turn off';

  @override
  String get devSectionBeta => 'Beta style';

  @override
  String get devBetaOnlyHint => 'Takes effect while the beta style is on';

  @override
  String get devBetaGlyph => 'Background mark';

  @override
  String get devBetaGlyphDesc => 'The big letter behind the screens';

  @override
  String get devBetaGlyphNone => 'None';

  @override
  String get devBetaGlyphStrength => 'Mark strength';

  @override
  String get devStrengthQuiet => 'Quiet';

  @override
  String get devStrengthNormal => 'Normal';

  @override
  String get devStrengthBold => 'Bold';

  @override
  String get devStrengthFull => 'Original';

  @override
  String get devBetaGlyphSize => 'Mark size';

  @override
  String get devSizeSmall => 'Smaller';

  @override
  String get devSizeNormal => 'Normal';

  @override
  String get devSizeLarge => 'Larger';

  @override
  String get devBetaTransition => 'Screen transition';

  @override
  String get devTransitionPageTurn => 'Turn';

  @override
  String get devTransitionFade => 'Fade';

  @override
  String get devTransitionInstant => 'Instant';

  @override
  String get devBetaGrain => 'Paper grain';

  @override
  String get devBetaGrainDesc =>
      'Faint speckle that makes the background read as a sheet';

  @override
  String get devBetaSerifBody => 'Serif body text';

  @override
  String get devBetaSerifBodyDesc =>
      'Off — body text in Inter, serif only in headings and amounts';

  @override
  String get devBetaReplay => 'Replay the switch animation';

  @override
  String get devTextScale => 'Text scale';

  @override
  String get devTextScaleDesc =>
      'Overrides the system setting — check that screens don\'t break';

  @override
  String get devTextScaleSystem => 'System';

  @override
  String get devLayoutGrid => '8dp grid';

  @override
  String get devLayoutGridDesc =>
      'Grid and screen margins on top of the interface';

  @override
  String get devTouches => 'Show touches';

  @override
  String get devTouchesDesc =>
      'Circles under your finger — for screen recordings';

  @override
  String get devBetaKind => 'Beta variant';

  @override
  String get devBetaKindDesc => 'Paper and ink, or the TexFi Style collage';

  @override
  String get devKindPaper => 'Paper';

  @override
  String get devKindCollage => 'Collage';

  @override
  String get devCollageBlobs => 'Blue cut-outs';

  @override
  String get devCollageBlobsDesc =>
      'Solid like the original, softened so text reads easier, or none';

  @override
  String get devBlobsBold => 'Solid';

  @override
  String get devBlobsSoft => 'Soft';

  @override
  String get devCollageRemix => 'Mix typefaces';

  @override
  String get devCollageRemixDesc =>
      'Headings built from several typefaces inside one word';

  @override
  String get devCollageShuffle => 'Typeface shuffle';

  @override
  String get devCollageShuffleDesc =>
      'A screen title tries on typefaces before settling';

  @override
  String get devTransitionCut => 'Cut';
}
