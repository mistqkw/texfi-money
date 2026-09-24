// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get navHome => 'Główna';

  @override
  String get navHistory => 'Historia';

  @override
  String get navBudgets => 'Budżety';

  @override
  String get navGoals => 'Cele';

  @override
  String get navStatistics => 'Statystyki';

  @override
  String get dateToday => 'Dzisiaj';

  @override
  String get dateYesterday => 'Wczoraj';

  @override
  String get commonCancel => 'Anuluj';

  @override
  String get commonDelete => 'Usuń';

  @override
  String get commonSave => 'Zapisz';

  @override
  String get commonCreate => 'Utwórz';

  @override
  String get commonAdd => 'Dodaj';

  @override
  String get commonOk => 'OK';

  @override
  String get commonExpense => 'Wydatek';

  @override
  String get commonIncome => 'Przychód';

  @override
  String get commonCategory => 'Kategoria';

  @override
  String get commonColor => 'Kolor';

  @override
  String get categoryGroceries => 'Zakupy spożywcze';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryHome => 'Mieszkanie';

  @override
  String get categoryRestaurant => 'Kawiarnie i restauracje';

  @override
  String get categoryEntertainment => 'Rozrywka';

  @override
  String get categoryHealth => 'Zdrowie';

  @override
  String get categoryClothes => 'Odzież';

  @override
  String get categoryBills => 'Rachunki';

  @override
  String get categoryOtherExpense => 'Inne';

  @override
  String get categorySalary => 'Wynagrodzenie';

  @override
  String get categoryFreelance => 'Freelance';

  @override
  String get categoryGifts => 'Prezenty';

  @override
  String get categoryInvestments => 'Inwestycje';

  @override
  String get categoryOtherIncome => 'Inne';

  @override
  String get categoryDeleteHasTransactionsError =>
      'Nie można usunąć kategorii, która ma transakcje';

  @override
  String get currencyRub => 'Rubel rosyjski';

  @override
  String get currencyUsd => 'Dolar amerykański';

  @override
  String get currencyEur => 'Euro';

  @override
  String get currencyUah => 'Hrywna ukraińska';

  @override
  String get currencyPln => 'Złoty polski';

  @override
  String get currencyByn => 'Rubel białoruski';

  @override
  String get currencyKzt => 'Tenge kazachstańskie';

  @override
  String get currencyGbp => 'Funt szterling';

  @override
  String get currencyCny => 'Juan chiński';

  @override
  String get currencyTry => 'Lira turecka';

  @override
  String get appTitle => 'TexFi m0ney';

  @override
  String homeCurrencyTooltip(String name) {
    return 'Waluta: $name';
  }

  @override
  String get homeCategoriesTooltip => 'Kategorie';

  @override
  String get homeSettingsTooltip => 'Ustawienia';

  @override
  String get homeIncomeThisMonth => 'Przychód w tym miesiącu';

  @override
  String get homeExpenseThisMonth => 'Wydatki w tym miesiącu';

  @override
  String get homeRecentTransactions => 'Ostatnie transakcje';

  @override
  String get homeRecentShort => 'Ostatnie';

  @override
  String get homeFactIncome => 'Przychód';

  @override
  String get homeFactExpense => 'Wydatki';

  @override
  String get homeFactSaved => 'Oszczędności';

  @override
  String get homeEmptyTransactions =>
      'Na razie pusto. Pierwszy wpis zajmie ze dziesięć sekund.';

  @override
  String get homeLoadTransactionsError => 'Nie udało się wczytać transakcji';

  @override
  String get homeBalance => 'Saldo';

  @override
  String get addTxAmountLabel => 'Kwota';

  @override
  String get addTxTitle => 'Nowa transakcja';

  @override
  String get addTxTitleEdit => 'Edytuj transakcję';

  @override
  String get txActionRepeat => 'Powtórz dzisiaj';

  @override
  String get txActionEdit => 'Edytuj';

  @override
  String nudgeUnusualAmount(String times, String category) {
    return 'To $times× więcej niż zwykle w „$category”. Kwota się zgadza?';
  }

  @override
  String nudgeBudgetClose(String category, String percent) {
    return 'Budżet „$category” wykorzystany w $percent%';
  }

  @override
  String nudgeBudgetOver(String category, String amount) {
    return '„$category” przekracza budżet o $amount';
  }

  @override
  String nudgeQuietDays(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Brak wpisów od $days dnia — uzupełnić?',
      many: 'Brak wpisów od $days dni — uzupełnić?',
      few: 'Brak wpisów od $days dni — uzupełnić?',
      one: 'Brak wpisów od $days dnia — uzupełnić?',
    );
    return '$_temp0';
  }

  @override
  String nudgeGoalClose(String title, String percent) {
    return '„$title” zebrane w $percent% — już blisko';
  }

  @override
  String get nudgeDismiss => 'Ukryj';

  @override
  String get addTxLoadCategoriesError => 'Nie udało się wczytać kategorii';

  @override
  String get addTxNoteHint => 'Notatka (opcjonalnie)';

  @override
  String get addTxAddCategory => 'Własna kategoria';

  @override
  String get addTxAccountLabel => 'Konto';

  @override
  String get addTxNoAccount => 'Bez konta';

  @override
  String get budgetsTitle => 'Budżety';

  @override
  String get budgetsEmpty =>
      'Nie ma jeszcze budżetów. Ustaw miesięczny limit na kategorię, a zobaczysz, kiedy się do niego zbliżasz.';

  @override
  String get budgetsLoadError => 'Nie udało się wczytać budżetów';

  @override
  String budgetsLeft(String amount) {
    return 'Zostało $amount';
  }

  @override
  String budgetsOverBy(String amount) {
    return 'Przekroczono o $amount';
  }

  @override
  String get budgetsNearLimit => 'Zbliża się do limitu';

  @override
  String get setBudgetTitleEdit => 'Edytuj budżet';

  @override
  String get setBudgetTitleNew => 'Nowy budżet';

  @override
  String get setBudgetLimitLabel => 'Miesięczny limit';

  @override
  String get setBudgetNoCategoriesLeft =>
      'Wszystkie kategorie wydatków mają już budżet';

  @override
  String get setBudgetLoadCategoriesError => 'Nie udało się wczytać kategorii';

  @override
  String get categoriesDeleteTitle => 'Usunąć kategorię?';

  @override
  String categoriesDeleteConfirm(String name) {
    return 'Kategoria „$name” zostanie usunięta bezpowrotnie.';
  }

  @override
  String get categoriesTitle => 'Kategorie';

  @override
  String get categoriesExpenseSection => 'Wydatki';

  @override
  String get categoriesIncomeSection => 'Przychody';

  @override
  String get categoriesLoadError => 'Nie udało się wczytać kategorii';

  @override
  String get categoryFormTitleNew => 'Nowa kategoria';

  @override
  String get categoryFormTitleEdit => 'Edytuj kategorię';

  @override
  String get categoryFormNameHint => 'Nazwa kategorii';

  @override
  String get categoryFormIconLabel => 'Ikona';

  @override
  String get goalFormNoDeadline => 'Bez terminu';

  @override
  String get goalFormTitleEdit => 'Edytuj cel';

  @override
  String get goalFormTitleNew => 'Nowy cel';

  @override
  String get goalFormNameHint => 'Nazwa celu, np. „Nowy komputer”';

  @override
  String get goalFormTargetLabel => 'Kwota docelowa';

  @override
  String get goalFormDeadlineLabel => 'Termin';

  @override
  String goalsAddFundsTitle(String title) {
    return 'Doładuj „$title”';
  }

  @override
  String get goalsDeleteTitle => 'Usunąć cel?';

  @override
  String goalsDeleteConfirm(String title) {
    return 'Cel „$title” zostanie usunięty razem z zebranym postępem.';
  }

  @override
  String get goalsTitle => 'Cele oszczędnościowe';

  @override
  String get goalsEmpty =>
      'Nie ma jeszcze celów. Łatwiej odkładać, gdy kwota ma imię.';

  @override
  String get goalsLoadError => 'Nie udało się wczytać celów';

  @override
  String goalsProgressOf(String current, String target) {
    return '$current z $target';
  }

  @override
  String get goalsAchieved => 'Cel osiągnięty!';

  @override
  String get goalsDeadlinePassed => 'Termin minął';

  @override
  String goalsDaysLeft(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Zostało $days dnia',
      many: 'Zostało $days dni',
      few: 'Zostały $days dni',
      one: 'Został $days dzień',
    );
    return '$_temp0';
  }

  @override
  String get accountsTitle => 'Konta';

  @override
  String get accountsEmpty =>
      'Nie ma jeszcze kont. Dodaj te, na których naprawdę leżą pieniądze — kartę, gotówkę, skarbonkę.';

  @override
  String get accountsLoadError => 'Nie udało się załadować kont';

  @override
  String get accountsDeleteTitle => 'Usunąć konto?';

  @override
  String accountsDeleteConfirm(String name) {
    return 'Konto „$name” zostanie usunięte. Jego transakcje pozostaną, tylko bez przypisania.';
  }

  @override
  String get accountFormTitleNew => 'Nowe konto';

  @override
  String get accountFormTitleEdit => 'Edytuj konto';

  @override
  String get accountFormNameHint => 'Nazwa konta, np. „Karta banku A”';

  @override
  String get accountFormBankLabel => 'Bank';

  @override
  String get accountFormNoBank => 'Brak';

  @override
  String get profilesTitle => 'Profile';

  @override
  String get profilesEmpty =>
      'Nie ma jeszcze profili. Tu trafiają cudze pieniądze: długi, wspólne konto, czyjś budżet w twoich rękach.';

  @override
  String get profilesLoadError => 'Nie udało się załadować profili';

  @override
  String get profilesDeleteTitle => 'Usunąć profil?';

  @override
  String profilesDeleteConfirm(String name) {
    return 'Profil „$name” i jego saldo zostaną usunięte.';
  }

  @override
  String get profileFormTitleNew => 'Nowy profil';

  @override
  String get profileFormTitleEdit => 'Edytuj profil';

  @override
  String get profileFormNameHint => 'Imię osoby';

  @override
  String profilesRecordTitle(String name) {
    return 'Zapis dla „$name”';
  }

  @override
  String get profilesTheyBorrowed => 'Pożyczył(a)';

  @override
  String get profilesTheyRepaid => 'Oddał(a)';

  @override
  String profilesOwesYou(String amount) {
    return 'Jest winien(na) $amount';
  }

  @override
  String profilesYouOwe(String amount) {
    return 'Jesteś winien(na) $amount';
  }

  @override
  String get profilesSettled => 'Rozliczone';

  @override
  String get historyAllTypes => 'Wszystkie typy';

  @override
  String get historyAllCategories => 'Wszystkie kategorie';

  @override
  String get historyTitle => 'Historia';

  @override
  String get historyTypeFilterLabel => 'Typ';

  @override
  String get historyCategoryFilterLabel => 'Kategoria';

  @override
  String get historyPeriodFilterLabel => 'Okres';

  @override
  String get historyReset => 'Resetuj';

  @override
  String get historyEmpty => 'Nic nie znaleziono';

  @override
  String get historyLoadError => 'Nie udało się wczytać historii';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get settingsThemeSection => 'Motyw';

  @override
  String get settingsFontSection => 'Czcionka';

  @override
  String get settingsHapticsSection => 'Wibracje';

  @override
  String get hapticsEnabled => 'Wibracje przy interakcji';

  @override
  String get settingsCurrencySection => 'Waluta';

  @override
  String get settingsLanguageSection => 'Język';

  @override
  String get settingsManageSection => 'Zarządzanie';

  @override
  String get settingsBackupSection => 'Kopia zapasowa';

  @override
  String get settingsSecuritySection => 'Bezpieczeństwo';

  @override
  String get securityAppLock => 'Blokuj aplikację';

  @override
  String get securityAppLockDesc =>
      'Pyta o blokadę urządzenia — odcisk, twarz lub PIN — przy otwarciu i po tym, jak aplikacja pobyła w tle.';

  @override
  String get securityAppLockUnavailable =>
      'Urządzenie nie ma ustawionej blokady. Najpierw dodaj ją w ustawieniach systemu.';

  @override
  String get securityHideInSwitcher => 'Ukryj w przełączniku aplikacji';

  @override
  String get securityHideInSwitcherDesc =>
      'Zastępuje podgląd na liście ostatnich aplikacji pustym ekranem, żeby saldo nie było tam widoczne. Blokuje też zrzuty ekranu.';

  @override
  String get securityUnlockReason =>
      'Potwierdź, że to Ty, aby otworzyć TexFi m0ney';

  @override
  String get securityLockedTitle => 'Zablokowane';

  @override
  String get securityLockedBody =>
      'Twoje pieniądze zostają na tym urządzeniu. Potwierdź, że to Ty.';

  @override
  String get securityUnlock => 'Odblokuj';

  @override
  String get backupExport => 'Eksportuj dane';

  @override
  String get backupImport => 'Importuj dane';

  @override
  String get backupImportConfirmTitle => 'Zastąpić wszystkie dane?';

  @override
  String get backupImportConfirmBody =>
      'Import kopii zapasowej zastąpi wszystko, co jest obecnie na urządzeniu — transakcje, kategorie, konta, profile, budżety i cele. Tego nie można cofnąć.';

  @override
  String get backupImportConfirmAction => 'Zastąp';

  @override
  String get backupImportSuccess => 'Dane przywrócone z kopii zapasowej';

  @override
  String get backupImportError =>
      'Ten plik nie jest prawidłową kopią zapasową TexFi m0ney';

  @override
  String get settingsDangerSection => 'Strefa niebezpieczna';

  @override
  String get resetApp => 'Zresetuj aplikację';

  @override
  String get resetAppConfirmTitle => 'Zresetować aplikację?';

  @override
  String get resetAppConfirmBody =>
      'Wszystko zostanie trwale usunięte: transakcje, kategorie, konta, profile, budżety, cele i wszystkie ustawienia. Aplikacja uruchomi się ponownie tak, jakby była świeżo zainstalowana. Tego nie można cofnąć.';

  @override
  String get resetAppConfirmAction => 'Zresetuj';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeOled => 'Czarny (OLED)';

  @override
  String get fontSystem => 'Systemowa';

  @override
  String get languageSystem => 'Systemowy';

  @override
  String get currencyPickerTitle => 'Waluta';

  @override
  String get languagePickerTitle => 'Język';

  @override
  String get statisticsTitle => 'Statystyki';

  @override
  String get statisticsMonthlyChartTitle => 'Przychody i wydatki wg miesięcy';

  @override
  String get statisticsLoadError => 'Nie udało się wczytać danych';

  @override
  String get statisticsCategoryChartTitle =>
      'Wydatki wg kategorii w tym miesiącu';

  @override
  String get statisticsNoExpenses => 'Brak wydatków w tym miesiącu';

  @override
  String get quickEntryLabel => 'szybkie dodawanie';

  @override
  String get quickEntryHint => '-50 zakupy obiad';

  @override
  String get quickEntryHelp =>
      'Znak, kwota, kategoria, notatka — np. „-50 zakupy obiad” lub „+3000 wynagrodzenie”';

  @override
  String get quickEntryParseError =>
      'Nie rozpoznano. Zacznij od + lub -, potem kwota.';

  @override
  String get onboardingSlide1Title => 'Wszystko pod kontrolą';

  @override
  String get onboardingSlide1Body =>
      'Saldo, przychody i wydatki w tym miesiącu — na jednym ekranie.';

  @override
  String get onboardingSlide2Title => 'Budżety i cele';

  @override
  String get onboardingSlide2Body =>
      'Ustawiaj miesięczne limity dla kategorii i oszczędzaj na to, co ważne — z paskiem postępu.';

  @override
  String get onboardingSlide3Title => '❯ Szybkie dodawanie';

  @override
  String get onboardingSlide3Body =>
      'Jedna linia — „-50 zakupy obiad” — i transakcja gotowa. Szybciej niż przez menu.';

  @override
  String get onboardingSlide4Title => 'Prywatnie i offline';

  @override
  String get onboardingSlide4Body =>
      'Wszystko zostaje na urządzeniu. Bez konta, chmury i reklam.';

  @override
  String get onboardingCurrencyStepTitle => 'Wybierz walutę';

  @override
  String get onboardingThemeStepTitle => 'Wybierz wygląd';

  @override
  String get onboardingBankStepTitle => 'Dodaj swój bank (opcjonalnie)';

  @override
  String get onboardingNext => 'Dalej';

  @override
  String get onboardingStart => 'Zaczynajmy';

  @override
  String get onboardingSkip => 'Pomiń';

  @override
  String get navWealth => 'Majątek';

  @override
  String get wealthTitle => 'Majątek';

  @override
  String get wealthTotal => 'Majątek netto';

  @override
  String get wealthAssets => 'Aktywa';

  @override
  String get wealthLiabilities => 'Zobowiązania';

  @override
  String get wealthEmptyTitle => 'Na razie pusto';

  @override
  String get wealthEmptyBody =>
      'Dodaj to, co masz, i to, co jesteś winien. Wartości ustawiasz i aktualizujesz sam — nic nie jest nigdzie pobierane.';

  @override
  String get wealthAddAsset => 'Dodaj aktywo';

  @override
  String get wealthYearChange => 'Przez ostatni rok';

  @override
  String get wealthYearChangeNoBase =>
      'Nie ma jeszcze danych sprzed roku, żeby porównać.';

  @override
  String get wealthByCategory => 'Gdzie leży';

  @override
  String get wealthByCashFlow => 'Co robi';

  @override
  String get wealthByRisk => 'Jak ryzykowne';

  @override
  String get wealthAssetsList => 'Aktywa';

  @override
  String get wealthOffline =>
      'Wszystkie liczby tutaj wpisałeś ty. Aplikacja nigdzie nie sprawdza kursów ani notowań.';

  @override
  String get flowIncome => 'Przynosi pieniądze';

  @override
  String get flowLiability => 'Zabiera pieniądze';

  @override
  String get flowNeutral => 'Ani jedno, ani drugie';

  @override
  String get assetName => 'Nazwa';

  @override
  String get assetValue => 'Obecna wartość';

  @override
  String get assetCategory => 'Kategoria';

  @override
  String get assetRisk => 'Poziom ryzyka';

  @override
  String get assetFlow => 'Przepływ pieniędzy';

  @override
  String get assetNote => 'Notatka';

  @override
  String get assetValuedAt => 'Wartość na dzień';

  @override
  String get assetNew => 'Nowe aktywo';

  @override
  String get assetEdit => 'Edycja aktywa';

  @override
  String get assetRevalue => 'Zaktualizuj wartość';

  @override
  String get assetRevalueTitle => 'Nowa wartość';

  @override
  String get assetHistory => 'Historia wartości';

  @override
  String get assetHistoryHint =>
      'Każda aktualizacja dodaje punkt zamiast zastępować poprzedni — z nich liczy się zmiana roczna.';

  @override
  String get assetDelete => 'Usuń aktywo';

  @override
  String get assetDeleteBody =>
      'Aktywo i cała historia jego wartości znikną. Tego nie da się cofnąć.';

  @override
  String get riskSection => 'Zarządzanie ryzykiem';

  @override
  String riskLimitLabel(String level) {
    return 'Limit dla „$level”';
  }

  @override
  String get riskNoLimit => 'bez limitu';

  @override
  String get riskLimitHint =>
      'Część majątku, jaką godzisz się trzymać na tym poziomie ryzyka. Decydujesz ty: aplikacja nie ma zdania, co jest bezpieczne.';

  @override
  String get riskBreachTitle => 'Powyżej twojego limitu';

  @override
  String riskBreachBody(String level, String actual, String limit) {
    return '„$level”: $actual% majątku przy ustawionym limicie $limit%.';
  }

  @override
  String get riskAddLevel => 'Dodaj poziom';

  @override
  String get riskLevelName => 'Nazwa poziomu';

  @override
  String get riskLevelInUse =>
      'Na tym poziomie są aktywa — najpierw je przenieś.';

  @override
  String get riskLastLevel => 'Ostatniego poziomu nie można usunąć.';

  @override
  String get usefulnessLabel => 'Było warto?';

  @override
  String get usefulnessUseful => 'Warto';

  @override
  String get usefulnessUseless => 'Nie warto';

  @override
  String get usefulnessNeutral => 'Ani tak, ani nie';

  @override
  String get usefulnessNotRated => 'Bez oceny';

  @override
  String get usefulnessSection => 'Warto czy nie';

  @override
  String get usefulnessHint =>
      'Tylko to, co sam oznaczyłeś. Aplikacja nie zgaduje: ta sama dostawa bywa ratunkiem wieczoru i słabością, a wiesz o tym tylko ty.';

  @override
  String get subscriptionsTitle => 'Subskrypcje';

  @override
  String get subscriptionsMonthly => 'Miesięcznie';

  @override
  String get subscriptionsMonthlyHint =>
      'Roczne pokazane jako część miesięczna, żeby suma znaczyła to samo w każdym miesiącu.';

  @override
  String get subscriptionsEmpty =>
      'Na razie brak subskrypcji. Dodaj te, które odnawiają się same.';

  @override
  String get subscriptionsAdd => 'Dodaj subskrypcję';

  @override
  String get subscriptionNew => 'Nowa subskrypcja';

  @override
  String get subscriptionEdit => 'Edycja subskrypcji';

  @override
  String get subscriptionName => 'Nazwa';

  @override
  String get subscriptionAmount => 'Kwota';

  @override
  String get subscriptionPeriod => 'Odnawia się';

  @override
  String get subscriptionNextCharge => 'Następne obciążenie';

  @override
  String get subscriptionCustomDays => 'Co N dni';

  @override
  String get subscriptionActive => 'Aktywna';

  @override
  String get subscriptionCancelled => 'Anulowana';

  @override
  String get periodMonthly => 'Co miesiąc';

  @override
  String get periodYearly => 'Co rok';

  @override
  String get periodCustom => 'Własny okres';

  @override
  String get chargeToday => 'dziś';

  @override
  String get chargeTomorrow => 'jutro';

  @override
  String chargeInDays(int days) {
    return 'za $days dn.';
  }

  @override
  String get chargeOverdue => 'termin minął';

  @override
  String get savingsRateTitle => 'Stopa oszczędności';

  @override
  String get savingsRateHint =>
      'Tyle zostało z wszystkiego, co wpłynęło w tym miesiącu. Im większa część, tym więcej dochodu zostało twoje.';

  @override
  String get savingsRateNoIncome =>
      'W tym miesiącu nie było dochodu — nie ma od czego liczyć części.';

  @override
  String get savingsRateHistory => 'Wg miesięcy';

  @override
  String get cashFlowTitle => 'Przepływ pieniędzy';

  @override
  String get cashFlowReceived => 'Wpłynęło';

  @override
  String get cashFlowSpent => 'Wypłynęło';

  @override
  String get cashFlowSaved => 'Zostało';

  @override
  String get reportsTitle => 'Raporty';

  @override
  String get reportsCategory => 'Kategoria';

  @override
  String get reportsAllCategories => 'Wszystkie kategorie';

  @override
  String get reportsPeriod => 'Okres';

  @override
  String get reportsGroupByMonth => 'Wg miesięcy';

  @override
  String get reportsGroupByYear => 'Wg lat';

  @override
  String get reportsEmpty => 'Nic nie pasuje do tych warunków.';

  @override
  String get reportsTotal => 'Razem';

  @override
  String get adviceSection => 'Warto zerknąć';

  @override
  String adviceRisk(String level, String percent, String limit) {
    return 'Na poziomie „$level” jest $percent% majątku przy twoim limicie $limit%. Może warto przemyśleć podział.';
  }

  @override
  String adviceUseless(String percent) {
    return 'Wydatki oznaczone jako „nie warto” wzrosły o $percent% wobec zeszłego miesiąca.';
  }

  @override
  String adviceSubscriptions(String percent) {
    return 'Subskrypcje kosztują o $percent% więcej niż miesiąc temu — warto sprawdzić, czy wszystkie są jeszcze potrzebne.';
  }

  @override
  String adviceSavings(String percent, String limit) {
    return 'W tym miesiącu zostało $percent% wobec zwykłych $limit%.';
  }

  @override
  String get adviceEmpty =>
      'Na tle twoich własnych liczb nic się teraz nie wyróżnia.';

  @override
  String get adviceDisclaimer =>
      'To wszystko to porównanie twoich liczb z twoimi limitami i historią. Żadnych danych rynkowych ani oceny tego, co posiadasz.';

  @override
  String get analysisRangeTitle => 'Zakres analizy';

  @override
  String get analysisRangeHint =>
      'Jak daleko wstecz sięgają wszystkie wykresy historii — majątek, przepływ, stopa oszczędności.';

  @override
  String analysisRangeYears(int years) {
    return 'Ostatnie $years lat';
  }

  @override
  String get analysisRangeCustom => 'Ustaw daty';

  @override
  String get assetCategoriesTitle => 'Kategorie aktywów';

  @override
  String get aboutTitle => 'O aplikacji';

  @override
  String get aboutSectionApp => 'Aplikacja';

  @override
  String get aboutSectionOpen => 'Otwarty kod';

  @override
  String get aboutSectionSupport => 'Wsparcie';

  @override
  String get aboutVersionLabel => 'Wersja';

  @override
  String get aboutBuildLabel => 'Kompilacja';

  @override
  String get aboutTagline => 'Finanse osobiste, które nigdzie nie wyciekają';

  @override
  String get aboutBlurb =>
      'Wszystko leży w bazie na tym urządzeniu. Bez analityki, bez identyfikatorów reklamowych, bez wysyłania „zdarzeń” w tle — sprawdzisz to w źródłach.';

  @override
  String get aboutFactOffline => 'OFFLINE';

  @override
  String get aboutFactTelemetry => 'TELEMETRII';

  @override
  String get aboutFactLicense => 'LICENCJA';

  @override
  String get aboutSourceTitle => 'Źródła na GitHubie';

  @override
  String get aboutLicenseTitle => 'Licencja GNU AGPL v3';

  @override
  String get aboutLicenseText =>
      'Kto wyda zmienioną wersję, musi otworzyć swoje poprawki.';

  @override
  String get aboutEcosystemTitle => 'Cały ekosystem TexFi';

  @override
  String get aboutDonateTitle => 'Postaw kawę';

  @override
  String get aboutDonateText =>
      'TexFi robi jedna osoba, a wszystkie aplikacje są darmowe. Płatnych funkcji nie ma i nie będzie.';

  @override
  String get aboutLinkFailed => 'Nie ma czym otworzyć tego odnośnika';

  @override
  String get navPlan => 'Plan';

  @override
  String get navSummary => 'Podsumowanie';

  @override
  String aboutDevTapsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jeszcze $count dotknięć do menu dewelopera',
      many: 'Jeszcze $count dotknięć do menu dewelopera',
      few: 'Jeszcze $count dotknięcia do menu dewelopera',
      one: 'Jeszcze $count dotknięcie do menu dewelopera',
    );
    return '$_temp0';
  }

  @override
  String get aboutDevUnlocked => 'Menu dewelopera odblokowane';

  @override
  String get aboutDevMenu => 'Menu dewelopera';

  @override
  String get aboutDevMenuHint => 'Diagnostyka i eksperymenty';

  @override
  String get devTitle => 'Dla dewelopera';

  @override
  String get devSectionBuild => 'Kompilacja i urządzenie';

  @override
  String get devSectionRendering => 'Renderowanie';

  @override
  String get devSectionMotion => 'Animacja';

  @override
  String get devSectionInterface => 'Interfejs';

  @override
  String get devSectionHaptics => 'Wibracje';

  @override
  String get devSectionData => 'Dane';

  @override
  String get devSectionExperimental => 'Eksperymenty';

  @override
  String get devInfoVersion => 'Wersja';

  @override
  String get devInfoPackage => 'Pakiet';

  @override
  String get devInfoMode => 'Tryb kompilacji';

  @override
  String get devInfoPlatform => 'Platforma';

  @override
  String get devInfoScreen => 'Ekran';

  @override
  String get devInfoPixelRatio => 'Gęstość';

  @override
  String get devInfoTextScale => 'Skala tekstu';

  @override
  String get devInfoLocale => 'Język';

  @override
  String get devInfoStyle => 'Styl';

  @override
  String get devCopyInfo => 'Kopiuj do zgłoszenia błędu';

  @override
  String get devCopied => 'Skopiowano';

  @override
  String get devPerfOverlay => 'Wykres klatek';

  @override
  String get devPerfOverlayDesc => 'Czas wątków UI i GPU na wierzchu aplikacji';

  @override
  String get devRasterCheckerboard => 'Podświetl buforowane obrazy';

  @override
  String get devRasterCheckerboardDesc =>
      'Szachownica na obrazach z bufora rastrowego';

  @override
  String get devLayerCheckerboard => 'Podświetl warstwy poza ekranem';

  @override
  String get devLayerCheckerboardDesc =>
      'Szachownica na warstwach rysowanych przez saveLayer';

  @override
  String get devSemanticsDebugger => 'Drzewo dostępności';

  @override
  String get devSemanticsDebuggerDesc =>
      'Pokazuje to, co widzi czytnik ekranu. Wyłącza się tutaj';

  @override
  String get devAnimationSpeed => 'Szybkość animacji';

  @override
  String get devAnimationSpeedDesc =>
      'Spowalnia wszystkie animacje, by obejrzeć je klatka po klatce';

  @override
  String get devSkipSplash => 'Pomiń ekran startowy';

  @override
  String get devSkipSplashDesc => 'Od razu otwieraj aplikację przy starcie';

  @override
  String get devBackgroundNoise => 'Tekstura tła';

  @override
  String get devBackgroundNoiseDesc => 'Pikselowy szum pod całą aplikacją';

  @override
  String get devBanner => 'Wstęga w rogu';

  @override
  String get devBannerDesc => 'Oznacza zrzuty ekranu z ustawieniami dewelopera';

  @override
  String get devHapticsTest => 'Dotknij, by poczuć rytm';

  @override
  String get devHapticSelect => 'Tyk';

  @override
  String get devHapticSuccess => 'Gotowe';

  @override
  String get devHapticIncome => 'Przychód';

  @override
  String get devHapticExpense => 'Wydatek';

  @override
  String get devHapticError => 'Błąd';

  @override
  String get devHapticCelebrate => 'Cel';

  @override
  String get devReplayOnboarding => 'Pokaż wprowadzenie ponownie';

  @override
  String get devReplayOnboardingDesc =>
      'Dane zostaną, aplikacja uruchomi się ponownie';

  @override
  String get devShowPrefs => 'Zapisane ustawienia';

  @override
  String get devShowPrefsDesc =>
      'Wszystkie klucze, które aplikacja trzyma w SharedPreferences';

  @override
  String get devRestart => 'Uruchom ponownie';

  @override
  String get devRestartDesc => 'Przebudowuje wszystko od zera bez zamykania';

  @override
  String get devReset => 'Resetuj ustawienia dewelopera';

  @override
  String get devResetDone => 'Ustawienia dewelopera zresetowane';

  @override
  String get devHideMenu => 'Ukryj menu dewelopera';

  @override
  String get devHideMenuDesc => 'Aby przywrócić — znów pięć dotknięć wersji';

  @override
  String get devBetaStyle => 'Styl beta';

  @override
  String get devBetaStyleDesc =>
      'Source Serif 4, ciepła beżowa paleta, miękkie kształty';

  @override
  String get devBetaOn => 'Włączony';

  @override
  String get devBetaOff => 'Wyłączony';

  @override
  String get devBetaEnableTitle => 'Włączyć styl beta?';

  @override
  String get devBetaEnableBody =>
      'Aplikacja zmieni krój pisma, kolory i kształty. To beta: niektóre ekrany mogą wyglądać na niedokończone. Wyłączysz ją tutaj.';

  @override
  String get devBetaEnableAction => 'Włącz';

  @override
  String get devBetaDisableTitle => 'Wyłączyć styl beta?';

  @override
  String get devBetaDisableBody => 'Wróci znany styl pikselowy.';

  @override
  String get devBetaDisableAction => 'Wyłącz';
}
