/// Валюты, доступные для отображения сумм в приложении.
/// Это единица отображения, а не мультивалютный учёт с конвертацией —
/// все суммы в БД хранятся как числа без привязки к валюте.
enum AppCurrency {
  rub('RUB', '₽'),
  usd('USD', '\$'),
  eur('EUR', '€'),
  uah('UAH', '₴'),
  pln('PLN', 'zł'),
  byn('BYN', 'Br'),
  kzt('KZT', '₸'),
  gbp('GBP', '£'),
  cny('CNY', '¥'),
  tryLira('TRY', '₺');

  const AppCurrency(this.code, this.symbol);

  final String code;
  final String symbol;

  /// Локализованное название — см. `currencyDisplayName()` в
  /// `presentation/shared/l10n_helpers.dart` (нужен BuildContext).

  static AppCurrency fromCode(String? code) {
    return AppCurrency.values.firstWhere(
      (c) => c.code == code,
      orElse: () => AppCurrency.rub,
    );
  }
}
