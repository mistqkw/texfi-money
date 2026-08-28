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
  String get homeEmptyTransactions =>
      'Brak transakcji — dodaj pierwszą przyciskiem „+”';

  @override
  String get homeLoadTransactionsError => 'Nie udało się wczytać transakcji';

  @override
  String get homeBalance => 'Saldo';

  @override
  String get addTxTitle => 'Nowa transakcja';

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
      'Brak budżetów — ustaw miesięczny limit dla kategorii przyciskiem „+”';

  @override
  String get budgetsLoadError => 'Nie udało się wczytać budżetów';

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
  String get goalsEmpty => 'Brak celów — utwórz pierwszy przyciskiem „+”';

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
  String get accountsEmpty => 'Brak kont — dodaj pierwsze przyciskiem „+”';

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
  String get profilesTitle => 'Profile';

  @override
  String get profilesEmpty =>
      'Brak profili — śledź cudze pieniądze przyciskiem „+”';

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
  String get settingsCurrencySection => 'Waluta';

  @override
  String get settingsLanguageSection => 'Język';

  @override
  String get settingsManageSection => 'Zarządzanie';

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
  String get onboardingNext => 'Dalej';

  @override
  String get onboardingStart => 'Zaczynajmy';

  @override
  String get onboardingSkip => 'Pomiń';
}
